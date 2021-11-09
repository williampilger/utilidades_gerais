try:
    import backend as be
    import multiplat as mp
    import os
    from os import path
    import json
except:
    print("Biblioteca necessária não disponível.\n\nEstamos finalizando.")
    quit()

def download_ncm(fileName):
    try:
        import requests
    except:
        mp.install_lib('requests')
        mp.restart_program()
    downurl = "https://portalunico.siscomex.gov.br/classif/api/publico/nomenclatura/download/json"
    try:
        dados = requests.get(downurl)
        with open(fileName, "wb") as arquivo:
            arquivo.write(dados.content)
        return True
    except:
        pass
    return False

def load_ncm(fileName):
    if(path.exists(fileName)):
        fluxo = open(fileName, encoding="utf8")
        data = json.load(fluxo)
        return data
    return None

# Pesquisar $text(string) no campo 'Descricao' do dict
# RETURN: array com strings encontradas
def pesquisa_dict(dic, text):
    resp = []
    text = text.split(sep=' ')

    if(len(text) > 1 or len(text[0]) > 5):# se tem mais de uma palavra ou mais de 5 letras
        for j in range(len(text)):
            if(j == 0):
                for i in range(len(dic)):
                    if(text[j].lower() in dic[i]['Descricao'].lower() or text[j] in dic[i]['Codigo']):
                        resp.append(i)
            else:
                for i in resp:
                    if not (text[j].lower() in dic[i]['Descricao'].lower() or text[j] in dic[i]['Codigo']):
                        resp.remove(i)
    return resp

# Escreve detalhes di item selecionado na tela
def detalha(dic):
    mp.limpar_terminal()
    print("\n DETALHES DO ITEM:")
    print(f"\n    Código: {dic['Codigo']}")
    print(f"    Data Início: {dic['Data_Inicio']}")
    print(f"    Data Fim: ", end='')
    if(dic['Data_Fim'] == '31/12/9999'):
        print("-- / -- / ----")
    else:
        print(f"{dic['Data_Fim']}")
    print(f"    Tipo (ato): {dic['Tipo_Ato']}")
    print(f"    Número (ato): {dic['Numero_Ato']}")
    print(f"    Ano (ato): {dic['Ano_Ato']}")
    print(f"    Descrição: {dic['Descricao']}\n\n")
    os.system("pause")

def main():
    try:
        import readchar
    except:
        mp.install_lib('readchar')
        mp.restart_program()

    fileName = 'ncm.data.json'
    ResultPrint = 20
    dic = load_ncm(fileName)
    if( not dic ):
        print("Iniciando download dos dados de NCM")
        if(download_ncm(fileName)):
            print("> OK <")
            mp.restart_program()
    else:
        pesquisa = ''
        repesquisa = False
        p = []#array com as opções condizentes com a pesquisa
        sel = -1#indice do ítem selecionado. -1 quando nenhum selecionado
        while True:
            mp.limpar_terminal()
            print("\n\n  By: William Pilger")
            print(f"\n Ultima atualização dos dados de NCM: {dic['Data_Ultima_Atualizacao_NCM']}\n")
            print(f"\n Faça sua pesquisa: {pesquisa}\n")
            if(repesquisa):
                sel = -1
                p = pesquisa_dict(dic['Nomenclaturas'], pesquisa)
                repesquisa = False
                maxResultPrint = ResultPrint
            if(len(p) > 0):#reprinta a lista de itens coerentes
                index = 0
                i = 0
                for item in p:
                    i += 1
                    if(i > maxResultPrint):
                        break
                    if(sel == index):
                        carac = '♦'
                    else:
                        carac = ' '
                    print(f" {carac} {dic['Nomenclaturas'][item]['Codigo']:10} - {dic['Nomenclaturas'][item]['Descricao'][:80]}")
                    index += 1
            dig = readchar.readkey()
            if(dig == '\x1b'):#esc
                be.sair(1)
            elif(dig == '\t' or dig == '\r'):#tab ou enter
                if(sel != -1):#existe um ítem selecionado
                    detalha(dic['Nomenclaturas'][p[sel]])
                else:
                    maxResultPrint += 10
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



if __name__ == "__main__":
    main()