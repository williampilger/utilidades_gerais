import os
def restart_program():
    os.system(f"python \"{__file__}\"")
    quit()

from datetime import datetime
import time
import webbrowser #paga abrir página de ajuda
try:
    from win32gui import GetWindowText, GetForegroundWindow #para instalar use >>> pip install pywin32
except:
    print("\nINSTALANDO BIBLIOTECA NECESSÁRIA, AGUARDE!\n(CONEXÃO COM INTERNET NECESSÁRIA)")
    os.system("pip install pywin32")
    restart_program()
try:
    import pyautogui # para instalar use >>> pip install pyautogui
except:
    print("\nINSTALANDO BIBLIOTECA NECESSÁRIA, AGUARDE!\n(CONEXÃO COM INTERNET NECESSÁRIA)")
    os.system("pip install pyautogui")
    restart_program()

def busca_janela(chave_janela, tentativas):
    #Recebe a string chave, e o número de tentativas de alt+tab deve-se tentar
    #Retorna True se encontrou, e False se não
    for x in range(tentativas): #Teste as 6 proximas janelas
        pyautogui.keyDown('alt')
        for y in range(1,x):
            pyautogui.press('tab')
        pyautogui.keyUp('alt')
        if chave_janela in GetWindowText(GetForegroundWindow()):
            return True
    return False

def preenchimento_tab_simples(nome_janela_deve_conter):
    delay_entre_preenchimento = 0.3 #delay dado a cada preenchimento
    dela_entre_varredura_de_tela = 0.5#delay entre uma verificação e outra de tela quando aguarda o preenchimento do TXT
    nome_desta_janela = "py.exe"
    nome_arquivo = "tempdadospreenchimento.txt"
    os.system(f"echo PREENCHA SEUS DADOS AQUI (EXCLUA ESTE CONTEÚDO) > {nome_arquivo}&&echo SEPARE CADA CELULA com um TAB. >> {nome_arquivo}&&start {nome_arquivo}")
    time.sleep(1)
    while True:
        if (nome_desta_janela  in GetWindowText(GetForegroundWindow())):
            break
        time.sleep(dela_entre_varredura_de_tela)
    print(f'Buscando janela do {nome_janela_deve_conter}')
    if(busca_janela(nome_janela_deve_conter, 10)):
        print(f"Janela do {nome_janela_deve_conter} encontrada!")
    else:
        print("Janela não encontrada!")
        return
    with open(nome_arquivo, "r") as arquivo:
        '''for linha in arquivo:
            if not nome_janela_deve_conter in GetWindowText(GetForegroundWindow()):
                print(f'Você não está mais na janela do {nome_janela_deve_conter}')
                return
            print("{:.100s}".format(linha[:len(linha)-1]))
            celulas = linha.split('\t')
            for string in celulas:
                pyautogui.write(f"{string}\t")
                time.sleep(delay_entre_preenchimento)
            pyautogui.press('tab')'''
        for linha in arquivo:
            if not nome_janela_deve_conter in GetWindowText(GetForegroundWindow()):
                print(f'Você não está mais na janela do {nome_janela_deve_conter}')
                return
            print("{:.100s}".format(linha[:len(linha)-1]))
            for letra in linha:
                if(letra == '\t'):
                    pyautogui.press('tab')
                elif(letra == '\n'):
                    pyautogui.press('tab')
                    pyautogui.press('tab')
                else:
                    pyautogui.write(letra)
    os.system(f"del /q {nome_arquivo}")



def mensagem_sobre():
    webbrowser.open("")
    return

def ajuda():
    webbrowser.open("")
    return
  
def inicio():
    while True:
        print("Authenty AE\n\n\nBy: William Pilger")
        print("\n\n\nEscolha uma das opções abaixo:\n    (1) Preencher Entrada dados PCalc (TAB Simples)\n\n    (8) Sair\n    (9) Ajuda\n    (0) Sobre este script\n\n")
        opcao = int(input("Sua opção: "))
        if (opcao == 0):
            mensagem_sobre()
        elif (opcao == 1):
            preenchimento_tab_simples("Entrada de dados: Esforços")
            return #sair da aplicação
        elif (opcao == 9):
            ajuda()
        elif (opcao == 8):
            return #sair
        elif (opcao == 69):
            easteregg_1()
        else:
            print("Opção inválida!")
        os.system("cls") #limpar tela

if (__name__ == "__main__"):
    inicio()
    print("FIM DO PROGRAMA!")
    #input()
