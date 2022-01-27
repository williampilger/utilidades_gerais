# By: William Pilger
# 2021.08.10 - Song: Same Old War (Our Last Night)

import time
from datetime import datetime
import multiplat

def registra_log_geral(texto):
    try:
        with open("log_geral.txt", "a") as arquivo:
            instante = datetime.now().strftime('%d/%m/%Y\t%H:%M:%S')
            arquivo.writelines(f"\n{instante}\t{texto}")
    except:
        pass
    return

def sair(code):
    multiplat.limpar_terminal()
    if(code == 0):
        print("OOOps! Esta função ainda está em desenvolvimento.\n\nEstamos finalizando.")
        time.sleep(5)
    elif(code == 1):
        print("Você escolheu sair.")
        time.sleep(1)
    elif(code == 2):
        print("Não encontramos o arquivo de configuração necessário.")
        time.sleep(5)
    elif(code == 10):
        print('Finalizado normalmente.')
    quit()