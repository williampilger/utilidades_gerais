# Monitor de Desempenho

Este aplicativo monitora o uso de CPU, memória, disco e rede.
Os dados são coletados enquanto o software está em execução, podendo ter abrangência aberta, ou coletar dados apenas enquanto determinada(s) aplicação(ões) está(ão) em execução.



## Usage

> python3 monitor.py

*ExportSample.json*
```json
[
    {
        "cpu": {
            "usage_percent": 12.2
        },
        "memory": {
            "available_GB": 8199692288,
            "inUse_GB": 5025587200,
            "free_GB": 2100690944
        },
        "disc": {
            "read_B": 3486021632,
            "write_B": 5747689472,
            "read_Bps": 0,
            "write_Bps": 0
        },
        "network": {
            "send_B": 47276849,
            "recv_B": 270226470,
            "send_Bps": 0,
            "recv_Bps": 0
        },
        "other":{
            "ForegroundWindowTitle":"Visual Studio Code",
            "timestamp": 1713548628.218036
        }
    },
    {
        "cpu": {
            "usage_percent": 3.6
        },
        "memory": {
            "available_GB": 8199692288,
            "inUse_GB": 5011881984,
            "free_GB": 2118852608
        },
        "disc": {
            "read_B": 3486021632,
            "write_B": 5747820544,
            "read_Bps": 0.0,
            "write_Bps": 131072.0
        },
        "network": {
            "send_B": 47278566,
            "recv_B": 270228055,
            "send_Bps": 1717.0,
            "recv_Bps": 1585.0
        },
        "other":{
            "ForegroundWindowTitle":"Visual Studio Code",
            "timestamp": 1713548648.218036
        }
    }
]
```


## Compilando versão Python (pyinstaller)

> pyinstaller monitor.spec