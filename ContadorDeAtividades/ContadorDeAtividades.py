import os
def restart_program():
    os.system(f"python \"{__file__}\"")
    quit()
from datetime import datetime
import time
try:
    from win32gui import GetWindowText, GetForegroundWindow #para instalar use >>> pip install pywin32
except:
    print("\nINSTALANDO BIBLIOTECA NECESSÁRIA, AGUARDE!\n(CONEXÃO COM INTERNET NECESSÁRIA)")
    os.system("pip install pywin32")
    restart_program()

def registra_log_geral(texto):
    with open("log_geral.txt", "a") as arquivo:
        instante = datetime.now().strftime('%d/%m/%Y\t%H:%M:%S')
        arquivo.writelines(f"\n{instante}\t{texto}")
    return

def inicio():
    while True:
        nome_janela = GetWindowText(GetForegroundWindow())
        registra_log_geral(nome_janela)
        time.sleep(1)

if (__name__ == "__main__"):
    inicio()
    print("FIM DO PROGRAMA!")
    #input()
    
'''def ler_projetos():
    with open("projetos.txt", "r") as arquivo:
        projetos = []
        chaves = []
        for linha in arquivo:
            parcial = linha.split('\t')
            projetos.append(parcial[0])
            chaves.append(parcial[1])
    print(f'Leitura dos projetos concluída.')
    return'''
