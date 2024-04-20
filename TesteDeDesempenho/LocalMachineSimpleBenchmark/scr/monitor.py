import subprocess
import sys
import os

from class_EnvLoader import EnvLoader

try:
    import psutil
    import json
    import time
    import pygetwindow as gw
except Exception as e:
    if not getattr(sys, 'frozen', False):
        subprocess.check_call([sys.executable, '-m', 'pip', 'install', '-r', 'requirements.txt'])
        os.system(f"python \"{__file__}\"")
    else:
        print(f'''
            {e}
***********************************************************************************************
            Esta versão do aplicativo não funciona no seu computador.
              
              - Você está usando uma versão compilada deste aplicativo;
              - Seus sistema operacional não encontrou uma ou mais bibliotecas necessárias;

            Execução interrompida.
***********************************************************************************************
            ''')
        input('Pressione enter para sair...')
    quit()


ENV = EnvLoader('.env')

def coletar_dados( previousDump=None, interval=1 ):

    return {
        'cpu': {
            'usage_percent': psutil.cpu_percent(1) #aqui eu usava "interval", mas para tentar deixar esta leitura mais parecida com a do gerenciador de tarefas, estou mudando pra 1, fixo
        },
        'memory': {
            'available_GB': psutil.virtual_memory().total/1000000000,
            'inUse_GB': psutil.virtual_memory().used/1000000000,
            'free_GB': psutil.virtual_memory().available/1000000000
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
            'ForegroundWindowTitle': gw.getActiveWindow().title, #GetWindowText(GetForegroundWindow()),
            'timestamp': time.time()
        }
    }

def save_json(dados, outfile):
    with open(outfile, "w") as arquivo:
        json.dump(dados, arquivo, indent=4)

def monitor(interval_seconds=1, save_freq=1, print_data=False):

    outfile = ENV.get_var('OUTPUT_FILE','out.json',str)
    fv = 0
    while os.path.exists(outfile):
        if '_' in outfile:
            parts = outfile.split('_',1)
            fv = int(parts[0])
            outfile = parts[1]
        fv += 1
        outfile = f'{fv}_{outfile}'

    data = []
    count = 0
    print(f'\n\nMONITORAMENTO EM ANDAMENTO')
    while True:
        data.append(coletar_dados(data[-1] if len(data)>0 else None, interval_seconds))
        count += 1
        if count > save_freq:
            count = 0
            save_json(data, outfile)
        if print_data:
            print(f"Dados coletados: {data}")
        time.sleep(interval_seconds)

if __name__ == "__main__":
    print(f'''

        Monitor de recursos:
            - CPU
            - Memória Principal (RAM)
            - Disco (leitura/gravação)
            - Rede (download/upload)
          * Também serão coletados os nomes das janelas em evidência

    INICIANDO O MONITORAMENTO...
          
          ''')
    monitor(
        ENV.get_var('DUMP_INTERVAL_SECONDS',5,int),
        ENV.get_var('SAVE_FREQUENCY',6,int),
        ENV.get_var('PRINT_DATA',False,bool)
    )
