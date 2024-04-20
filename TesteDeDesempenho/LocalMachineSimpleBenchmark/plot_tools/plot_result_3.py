
import matplotlib
matplotlib.use('Agg')  # Usar backend Agg para renderização que não precisa de GUI
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from datetime import datetime
import json

# Carregar dados JSON de um arquivo
with open('export.json', 'r') as file:
    data = json.load(file)

# Preparar listas para os dados
timestamps = []
cpu_usages = []
memory_inUse = []
network_send_bps = []
network_recv_bps = []
titles = []

# Processar cada item nos dados
for item in data:
    timestamp = datetime.fromtimestamp(item['other']['timestamp'])
    timestamps.append(timestamp)
    cpu_usages.append(item['cpu']['usage_percent'])
    memory_inUse.append(item['memory']['inUse_GB'])
    network_send_bps.append(item['network']['send_Bps'])
    network_recv_bps.append(item['network']['recv_Bps'])
    titles.append(item['other']['ForegroundWindowTitle'])

# Criar os gráficos
fig, axs = plt.subplots(4, 1, figsize=(10, 15), sharex=True)
metrics = [
    (cpu_usages, 'CPU Usage (%)', 'blue'),
    (memory_inUse, 'Memory In Use (GB)', 'red'),
    (network_send_bps, 'Network Send (Bps)', 'green'),
    (network_recv_bps, 'Network Receive (Bps)', 'purple')
]

# Plotar cada métrica em seu próprio subplot
for ax, (data, label, color) in zip(axs, metrics):
    ax.plot(timestamps, data, label=label, linestyle='-', color=color)
    ax.set_title(label)
    ax.set_ylabel(label)
    ax.xaxis.set_major_locator(mdates.MinuteLocator())
    ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y-%m-%d %H:%M'))
    ax.grid(True)

    # Adicionar linhas de mudança de software
    last_title = None
    for i, title in enumerate(titles):
        if i > 0 and title != titles[i-1]:
            ax.axvline(x=timestamps[i], color='grey', linestyle='--', linewidth=0.5)

# Configurar layout e salvar o gráfico
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig('system_metrics.png')  # Salva o gráfico em um arquivo PNG
