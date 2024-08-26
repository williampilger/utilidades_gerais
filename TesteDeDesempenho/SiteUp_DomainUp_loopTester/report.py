import json
import os
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.dates import DateFormatter
from dotenv import load_dotenv

load_dotenv()

# Carregar os dados do arquivo JSON
LOG_FILE = os.getenv("LOG_FILE")

if not os.path.exists(LOG_FILE):
    print(f"Log file {LOG_FILE} does not exist.")
    exit(1)

with open(LOG_FILE, 'r') as file:
    data = json.load(file)

# Transformar os dados em um DataFrame do Pandas
df = pd.DataFrame(data)

# Converter a coluna de timestamp para o tipo datetime
df['timestamp'] = pd.to_datetime(df['timestamp'])

# Filtrar apenas as linhas onde temos um tempo de resposta
df_success = df[df['response_time'].notnull()]

# Gráfico 1: Tempo de resposta ao longo do tempo
plt.figure(figsize=(10, 6))
plt.plot(df_success['timestamp'], df_success['response_time'], marker='o', linestyle='-', color='blue', label='Response Time (s)')
plt.xlabel('Timestamp')
plt.ylabel('Response Time (seconds)')
plt.title('Server Response Time Over Time')
plt.grid(True)

# Adicionar formato ao eixo X
date_format = DateFormatter("%Y-%m-%d %H:%M:%S")
plt.gca().xaxis.set_major_formatter(date_format)
plt.gcf().autofmt_xdate()

# Gráfico 2: Códigos de status HTTP ao longo do tempo
plt.figure(figsize=(10, 6))
plt.plot(df_success['timestamp'], df_success['response_code'], marker='o', linestyle='-', color='green', label='HTTP Status Code')
plt.xlabel('Timestamp')
plt.ylabel('HTTP Status Code')
plt.title('HTTP Status Codes Over Time')
plt.grid(True)

# Marcar falhas no gráfico
df_failures = df[df['status'] == 'failure']
plt.scatter(df_failures['timestamp'], [500] * len(df_failures), color='red', label='Failures', zorder=5)

# Adicionar formato ao eixo X
plt.gca().xaxis.set_major_formatter(date_format)
plt.gcf().autofmt_xdate()

plt.legend()

# Exibir os gráficos
plt.show()
