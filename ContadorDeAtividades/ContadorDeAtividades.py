import os
import platform
import time
from datetime import datetime

eh_windows = platform.system() == "Windows"
eh_linux = platform.system() == "Linux"

def restart_program():
    if(eh_windows):
        os.system(f"python \"{__file__}\"")
    elif(eh_linux):
        os.system(f"python3 \"{__file__}\"")
    quit()

if(eh_windows):#includes especiais do Windows
    try:
        from win32gui import GetWindowText, GetForegroundWindow #para instalar use >>> pip install pywin32
    except:
        print("\nINSTALANDO BIBLIOTECA NECESSÁRIA, AGUARDE!\n(CONEXÃO COM INTERNET NECESSÁRIA)")
        os.system("pip install pywin32")
        restart_program()

def obtem_nome_janela():
    if(eh_windows):
        return GetWindowText(GetForegroundWindow())

def limpar_terminal():
    if(eh_windows):
        os.system("cls")
    elif(eh_linux):
        os.system("clear")

def registra_log_geral(texto):
    with open("log_geral.txt", "a") as arquivo:
        instante = datetime.now().strftime('%d/%m/%Y\t%H:%M:%S')
        arquivo.writelines(f"\n{instante}\t{texto}")
    return

def monitoracao():
    while True:
        registra_log_geral(obtem_nome_janela())
        time.sleep(1)

def menu_principal():
    limpar_terminal()
    print("\n\n")
    while True:
        print("Iniciando aplicação!\n\n     By: William Pilger\n\n\n Contador de horas!")
        print("\n\n    (1) - Cadastrar projetos\n    (2) - Iniciar monitoração\n    (3) - Ver minha atividade")
        opcao = int(input("Para começarmos, digite sua opção:"))
        if (opcao == 1):
            return #sair da aplicação
        elif (opcao == 1):
            monitoracao()
            return #sair da aplicação
        elif (opcao == 2):
            return #sair da aplicação
        limpar_terminal()
        print("\nOPÇÃO INVÁLIDA\n")


def inicio():
    if(eh_windows):
        menu_principal()
    else:
        print("\n\nLamentamos, mas esta aplicação ainda não é compatível com o seu sistema operacional!\nA aplicação será finalizada!")
        time.sleep(5)
        quit()

if (__name__ == "__main__"):
    inicio()
    print("FIM DA EXECUÇÃO!")


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
