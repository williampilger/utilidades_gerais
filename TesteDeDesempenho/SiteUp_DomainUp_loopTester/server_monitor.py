import requests
import time
import os
import json
import subprocess
from datetime import datetime, timedelta
from dotenv import load_dotenv

load_dotenv()

HOST = os.getenv("HOST")
PATH = os.getenv("SPATH")
URL = f"{HOST}{PATH}"
INTERVAL = int(os.getenv("INTERVAL"))
RETRY_INTERVAL = int(os.getenv("RETRY_INTERVAL"))
RETRY_COUNT = int(os.getenv("RETRY_COUNT"))
RETAIN_DAYS = int(os.getenv("RETAIN_DAYS"))
LOG_FILE = os.getenv("LOG_FILE")

def ping_host(host):
    return subprocess.run(["ping", "-c", "4", host], capture_output=True, text=True).stdout

def traceroute_host(host):
    return subprocess.run(["traceroute", host], capture_output=True, text=True).stdout

def telnet_host(host, port):
    return subprocess.run(["telnet", host, str(port)], capture_output=True, text=True).stdout

def cleanup_logs():
    if not os.path.exists(LOG_FILE):
        return
    with open(LOG_FILE, "r") as file:
        logs = json.load(file)
    cutoff_date = datetime.now() - timedelta(days=RETAIN_DAYS)
    logs = [log for log in logs if datetime.fromisoformat(log["timestamp"]) >= cutoff_date]
    with open(LOG_FILE, "w") as file:
        json.dump(logs, file, indent=4)

def log_result(result):
    if not os.path.exists(LOG_FILE):
        logs = []
    else:
        with open(LOG_FILE, "r") as file:
            logs = json.load(file)
    logs.append(result)
    with open(LOG_FILE, "w") as file:
        json.dump(logs, file, indent=4)

def test_server():
    retries = 0
    while retries < RETRY_COUNT:
        start_time = time.time()
        try:
            response = requests.get(URL)
            response_time = time.time() - start_time
            
            log_result({
                "timestamp": datetime.now().isoformat(),
                "status": "success" if 200 <= response.status_code < 300 else "failure",
                "url": URL,
                "response_code": response.status_code,
                "response_time": response_time,
                "response_content": response.text
            })

            if 200 <= response.status_code < 300:
                print(f"Test successful: {response.status_code} in {response_time:.2f}s")
                return
            else:
                print(f"Test failed (HTTP {response.status_code}): Server responded with an error")
                retries += 1
                time.sleep(RETRY_INTERVAL)

        except requests.RequestException as e:
            response_time = time.time() - start_time
            log_result({
                "timestamp": datetime.now().isoformat(),
                "status": "failure",
                "url": URL,
                "response_code": None,
                "response_time": response_time,
                "error": str(e),
                "response_content": None
            })
            print(f"Test failed (attempt {retries}/{RETRY_COUNT}): {e}")
            retries += 1
            if retries < RETRY_COUNT:
                time.sleep(RETRY_INTERVAL)
    
    # If we get here, it means all retries failed, collect additional data
    host_without_protocol = HOST.replace("https://", "").replace("http://", "")
    log_result({
        "timestamp": datetime.now().isoformat(),
        "status": "failure_details",
        "ping_google": ping_host("8.8.8.8"),
        "ping_server": ping_host(host_without_protocol),
        "traceroute_server": traceroute_host(host_without_protocol),
        "telnet_server": telnet_host(host_without_protocol, 80)
    })
    print(f"All retries failed. Additional diagnostic information collected.")

def main():
    cleanup_logs()
    while True:
        test_server()
        time.sleep(INTERVAL)

if __name__ == "__main__":
    main()
