# By: will.i.am | AuthentyAE | Bom Princípio - RS - Brasil
try:
    import os
    import multiplat as mp
    import backend as be
    import time
except:
    print("Biblioteca necessária não disponível.\n\nEstamos finalizando.")
    quit()

try:
    import pyautogui
except:
    mp.install_lib('pyautogui')
    mp.restart_program()

try:
    import readchar
except:
    mp.install_lib('readchar')
    mp.restart_program()

#retorna dicionário com chaves e dados salvos em arquivo
def carrega_chaves(fileName):
    dic = {}
    if not os.path.exists(fileName):
        return dic
    with open(fileName, "r") as arquivo:
        for linha in arquivo:
            linha = linha.replace('\n', '')#tirar fim de linha
            par = linha.split('\t')
            if(len(par) == 2):#precisa ser par de chave/dado
                dic[par[0]] = par[1]
    return dic

#Salva o dicionário em arquivo
def salva_chaves(dic, fileName):
    with open(fileName, "w") as arquivo:
        for item in dic:
            arquivo.write(f"{item}\t{dic[item]}\n")

def preenche(dado):
    delay = 0#mudar conforme necessidade (é comum funcionar sem delay, porém aplicações lentas podem exigir que a escrita seja mais lenta, 0.001 é um bom delay)
    pyautogui.hotkey('alt', 'tab')
    if(delay == 0):
        pyautogui.write(dado)
    else:
        for letra in dado:
            pyautogui.press(letra)
            time.sleep(delay)

# Pesquisar $text(string) nas CHAVES do $dic(dicionário)
# RETURN: array com strings encontradas
def pesquisa_dict(dic, text):
    resp = []
    for chave in dic:
        if(text == "" or text in chave):
            resp.append(chave)
    return resp

def inicio():
    pesquisa = ''
    dic = carrega_chaves('autotype.data')#dicionário com todas as chaves cadastradas.
    p = []#array com as opções condizentes com a pesquisa
    sel = -1#indice do ítem selecionado. -1 quando nenhum selecionado
    repesquisa = True
    while True:
        mp.limpar_terminal()
        print(f"\n Faça sua pesquisa: {pesquisa}\n")
        if(repesquisa):
            sel = -1
            p = pesquisa_dict(dic, pesquisa)
            repesquisa = False
        if(len(p) > 0):#reprinta a lista de itens coerentes
            index = 0
            for item in p:
                if(sel == index):
                    carac = '♦'
                else:
                    carac = ' '
                print(f" {carac} {item:20} - {dic[item]}")
                index += 1
        dig = readchar.readkey()
        if(dig == '\x1b'):#esc
            be.sair(1)
        elif(dig == '\t' or dig == '\r'):#tab ou enter
            if(sel != -1):#existe um ítem selecionado
                preenche(dic[p[sel]])
                be.sair(10)
            else:#Nenhum ítem selecionado
                if(pesquisa in dic):#se existe uma ocorrência Idêntica no dicionário
                    preenche(dic[p[sel]])
                    be.sair(10)
                else:#cadastrar nova chave
                    mp.limpar_terminal()
                    print(f"Cadastrando novo valor para a chave {pesquisa}\n")
                    dic[pesquisa] = input("Digite o conteúdo da chave: ")
                    preenche(dic[pesquisa])
                    salva_chaves(dic, 'autotype.data')
                    be.sair(10)
        elif(dig == '\x1b[A'):#seta pra CIMA
            if(sel > 0):
                sel -= 1
        elif(dig == '\x1b[B'):#seta pra BAIXO
            if(sel < len(p)):
                sel += 1
        elif(dig == '\x08'):#back space
            pesquisa = pesquisa[:-1]
            repesquisa = True
        else:
            pesquisa += dig
            repesquisa = True

        

if __name__ == '__main__':
    inicio()
