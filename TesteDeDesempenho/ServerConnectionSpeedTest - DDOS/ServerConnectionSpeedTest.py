import requests
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
print("""

    TESTE DE DESEMPENHO SIMPLIFICADO
        - Mede a quantidade de requisições GET que uma URL
          consegue atender por segundo

""")
# URL do seu servidor
url = input('Digite a URL: ')

# Número de threads; pode precisar de ajustes baseado na capacidade do seu servidor
numero_de_threads = 100

def fazer_requisicao():
    try:
        resposta = requests.get(url, timeout=5)  # Ajuste o timeout conforme necessário
        return resposta.status_code == 200
    except requests.exceptions.RequestException:
        return False

while True:
    inicio = time.time()
    with ThreadPoolExecutor(max_workers=numero_de_threads) as executor:
        futures = [executor.submit(fazer_requisicao) for _ in range(numero_de_threads)]
        resultados = [f.result() for f in as_completed(futures)]

    # Calcula a duração e o número de sucessos
    duracao = time.time() - inicio
    sucessos = sum(resultados)

    print(f"Requisições atendidas por segundo: {sucessos / duracao:.2f}")
    
    # Pequena pausa para evitar sobrecarga no servidor, ajuste conforme necessário
    time.sleep(1)
