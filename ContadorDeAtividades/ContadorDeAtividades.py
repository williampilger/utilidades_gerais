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

def sair(code):
    limpar_terminal()
    if(code == 0):
        print("OOOps! Esta função ainda está em desenvolvimento.\n\nEstamos finalizando.")
    time.sleep(5)
    quit()

def obtem_nome_janela():
    if(eh_windows):
        try:
            return GetWindowText(GetForegroundWindow())
        except:
            return "NULL"
            

def limpar_terminal():
    if(eh_windows):
        os.system("cls")
    elif(eh_linux):
        os.system("clear")
    return

def registra_log_geral(texto):
    try:
        with open("log_geral.txt", "a") as arquivo:
            instante = datetime.now().strftime('%d/%m/%Y\t%H:%M:%S')
            arquivo.writelines(f"\n{instante}\t{texto}")
    return

def monitoracao():
    limpar_terminal()
    print("Estamos monitorando sua atividade.\nPara finalizar o serviço, feche esta janela.")
    while True:
        registra_log_geral(obtem_nome_janela())
        time.sleep(1)

def ler_projetos():
    projetos = []
    chaves = []
    try:
        with open("projetos.txt", "r") as arquivo:
            
            for linha in arquivo:
                parcial = linha.split('\t')
                projetos.append(parcial[0])
                chaves.append(parcial[1])
        print(f'Leitura dos projetos concluída.')
    except:
        print(f'Não existem projetos atualmente')
    return projetos, chaves

def salvar_projetos(projetos, chaves):
    with open("projetos.txt", "w") as arquivo:
        for i in range(len(projetos)):
            arquivo.write(f"{projetos[i]}\t{chaves[i]}\n")
    return

def add_projeto():
    projetos, chaves = ler_projetos()
    limpar_terminal()
    print("\n\n\n")
    while True:
        projeto = input("\nDigite o nome do projeto que seja adicionar: ")
        if(not projeto in projetos):
            break
        else:
            limpar_terminal()
            print("\n\n OOps!, Este projeto já existe!")
    limpar_terminal()
    print("\n\n\n")
    while True:
        chave = input("\nDigite a chave do projeto (texto que será localizano nas janelas): ")
        if(not chave in chaves):
            break
        else:
            limpar_terminal()
            print("\n\n OOps!, Esta chave já existe!")
    projetos.append(projeto)
    chaves.append(chave)
    salvar_projetos(projetos, chaves)

def configurar_projetos():
    limpar_terminal()
    print("\n\n")
    while True:
        print("Configuração dos projetos.")
        print("\n\n    (1) - Adicionar Projeto\n    (2) - Excluir Projeto(s)\n    (3) - Ver meus projetos\n    (0) - Voltar")
        opcao = int(input("Para começarmos, digite sua opção:"))
        if (opcao == 1):
            add_projeto()
            limpar_terminal()
            print("\n Projeto Adicionado.")
        elif (opcao == 2):
            sair(0)
        elif (opcao == 3):
            sair(0)
        elif (opcao == 0):
            return
        else:
            limpar_terminal()
            print("\nOPÇÃO INVÁLIDA\n")

def menu_principal():
    limpar_terminal()
    print("\n\n")
    while True:
        print("Iniciando aplicação!\n\n     By: William Pilger\n\n\n Contador de horas!")
        print("\n\n    (1) - Configurar projetos\n    (2) - Iniciar monitoração\n    (3) - Ver minha atividade")
        opcao = int(input("Para começarmos, digite sua opção:"))
        if (opcao == 1):
            configurar_projetos()
            limpar_terminal()
            print("\n")
        elif (opcao == 2):
            monitoracao()
            return #sair da aplicação
        elif (opcao == 3):
            return #sair da aplicação
        else:
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


def ler_projetos():
    with open("projetos.txt", "r") as arquivo:
        projetos = []
        chaves = []
        for linha in arquivo:
            parcial = linha.split('\t')
            projetos.append(parcial[0])
            chaves.append(parcial[1])
    print(f'Leitura dos projetos concluída.')
    return
