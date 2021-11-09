# By: William Pilger
# 2021.08.10 - Song: Same Old War (Our Last Night)

import time
from os import path
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
    elif(code == 3):
        print("Alguma biblioteca necessária não está disponível.")
        time.sleep(5)
    elif(code == 10):
        print('Finalizado normalmente.')
    quit()


class appConfig:
    def __init__(self, filename):
        self.file = filename
        self.params = self.carregaConfig(filename)

    def carregaConfig(self, filename):
        if not path.exists(filename):
            return {}
        data = {}
        with open(filename, "r") as arquivo:
            for linha in arquivo:
                linha = linha.replace('\n', '')#tirar fim de linha
                param = linha.split('\t')
                if(len(param) == 2):
                    data[param[0]] = param[1:]
        return data

    def salvaConfig(self):
        with open(filename, "w") as arquivo:
            for param in self.params:
                arquivo.writelines(f"{param}\t{params[param]}")

    def get(self, chave):
        return self.params[chave]

    def set(self, chave, valor):
        self.params[chave] = valor

#Carregar linhas do arquivo para um array de strings
def carregaStringArray(filename):
    with open(filename, 'r') as arquivo:
        arr = []
        for linha in arquivo:
            linha = linha.replace('\n', '')#tirar fim de linha
            arr.append(linha)
        return arr
    return None
