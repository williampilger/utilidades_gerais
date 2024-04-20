import os
import psutil
import json
import time
import pygetwindow as gw

from class_EnvLoader import EnvLoader

ENV = EnvLoader('.env')

if __name__ == "__main__":
    print(f'''

        Analisador de resultados:
            - CPU
            - Memória Principal (RAM)
            - Disco (leitura/gravação)
            - Rede (download/upload)
    ''')
    
    
