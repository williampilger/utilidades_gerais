# TEMPORÁRIO - Tratamento de CORREÇÃO dos dados coletados

Em versões anteriores desde software, existia um erro na coleta dos dados, e o JSON tem os valores de memória em Bytes, e não em GigaBytes.
Para corrigir rode em python mesmo:

```python
import json

filename = 'export.json'

with open(filename, 'r') as file:
    data = json.load(file)

for item in data:
    item['memory']['available_GB'] = item['memory']['available_GB'] / 1000000000
    item['memory']['inUse_GB'] = item['memory']['inUse_GB'] / 1000000000
    item['memory']['free_GB'] = item['memory']['free_GB'] / 1000000000

with open(filename, "w") as arquivo:
    json.dump(data, arquivo, indent=4)
```

De mesmo modo, em versões mais antigas ainda, os valores de bytes enviados e recebidos por rede eram acumulados, e não zerados entre uma leitura e outra. Para tratar este problema, rode:

```python
import json

filename = '5_export.json'

with open(filename, 'r') as file:
    data = json.load(file)

anterior = data[0]
for item in data:
    item['network']['send_Bps'] = item['network']['send_B'] - anterior['network']['send_B']
    item['network']['recv_Bps'] = item['network']['recv_B'] - anterior['network']['recv_B']
    anterior = item

with open(filename, "w") as arquivo:
    json.dump(data, arquivo, indent=4)
```