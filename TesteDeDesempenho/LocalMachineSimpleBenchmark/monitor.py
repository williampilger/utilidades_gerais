import psutil
import json
import time
from class_EnvLoader import EnvLoader
from win32gui import GetWindowText, GetForegroundWindow

ENV = EnvLoader('.env')

def coletar_dados( previousDump=None ):
    interval = ENV.get_var('DUMP_INTERVAL_SECONDS', 1, int)

    return {
        'cpu': {
            'usage_percent': psutil.cpu_percent(interval)
        },
        'memory': {
            'available_GB': psutil.virtual_memory().total,
            'inUse_GB': psutil.virtual_memory().used,
            'free_GB': psutil.virtual_memory().available
        },
        'disc': {
            'read_B': psutil.disk_io_counters().read_bytes,
            'write_B': psutil.disk_io_counters().write_bytes,
            'read_Bps': ((psutil.disk_io_counters().read_bytes - previousDump['disc']['read_B']) / interval ) if previousDump else 0,
            'write_Bps': ((psutil.disk_io_counters().write_bytes - previousDump['disc']['write_B']) / interval ) if previousDump else 0,
        },
        'network': {
            'send_B': psutil.net_io_counters().bytes_sent,
            'recv_B': psutil.net_io_counters().bytes_recv,
            'send_Bps': ((psutil.net_io_counters().bytes_sent - previousDump['network']['send_B']) / interval) if previousDump else 0,
            'recv_Bps': ((psutil.net_io_counters().bytes_recv - previousDump['network']['recv_B']) / interval) if previousDump else 0
        },
        'other': {
            'ForegroundWindowTitle': GetWindowText(GetForegroundWindow())
        }
    }

def save_json(dados):
    with open(ENV.get_var('OUTPUT_FILE','out.json',str), "w") as arquivo:
        json.dump(dados, arquivo, indent=4)

def monitor(interval_seconds=1, save_freq=1):
    data = []
    count = 0
    while True:
        data.append(coletar_dados(data[0] if len(data)>0 else None))
        count += 1
        if count > save_freq:
            count = 0
            save_json(data)
        print(f"Dados salvos: {data}")
        time.sleep(interval_seconds)

if __name__ == "__main__":
    monitor(
        ENV.get_var('DUMP_INTERVAL_SECONDS',1,int),
        ENV.get_var('SAVE_FREQUENCY',1,int)
    )
