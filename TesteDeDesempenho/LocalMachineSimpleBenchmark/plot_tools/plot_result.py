import pandas as pd
import matplotlib.pyplot as plt
import json


with open('export.json', 'r') as file:
    # Carregar JSON em um DataFrame
    data = json.load(file)
    df = pd.json_normalize(data)

    # Converter timestamp para datetime
    df['datetime'] = pd.to_datetime(df['other.timestamp'], unit='s')

    # Configurar o gráfico
    fig, ax = plt.subplots()

    # Agrupar por título da janela para cores diferentes
    for title, group in df.groupby('other.ForegroundWindowTitle'):
        ax.plot(group['datetime'], group['cpu.usage_percent'], label=title, marker='o', linestyle='-')

    # Configurar os eixos e legenda
    ax.set_xlabel('Time')
    ax.set_ylabel('CPU Usage (%)')
    ax.legend()
    ax.set_title('CPU Usage Over Time by Window Title')

    # Mostrar o gráfico
    plt.show()
