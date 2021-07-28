import os
import tempfile
import platform
import socket #usada para testar conexão, apenas
from os import path

eh_windows = platform.system() == "Windows"
eh_linux = platform.system() == "Linux"

def check_net(): #testar conexão com internet
    a=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    a.settimeout(.5)
    try:
        b=a.connect_ex(("www.google.com", 80))
        if b==0: #ok, conectado
            return True
    except:
        pass
    a.close()
    return False

def restart_program():
    if(eh_windows):
        os.system(f"python \"{__file__}\"")
    elif(eh_linux):
        os.system(f"python3 \"{__file__}\"")
    quit()

try:
    import requests
except:
    print("\nINSTALANDO BIBLIOTECA NECESSÁRIA, AGUARDE!\n(CONEXÃO COM INTERNET NECESSÁRIA)")
    if(eh_windows):
        os.system("pip install requests")
    elif(eh_linux):
        os.system("pip3 install requests")
    restart_program()

def baixa_arquivo(url, destino):
    if (check_net()):
        try:
            dados = requests.get(url)#faz download do arquivo
        except:
            print("Falha ao obter o arquivo fonte. Tentaremos instalar os certificados, e na sequência poderá tentar novamente.")
            if(eh_windows):
                os.system("pip install python-certifi-win32") #já que não sei se está instalada, instalo sempre que falhar
            if(eh_linux):
                os.system("pip3 install certifi")
            restart_program()

        with open(destino, "wb") as arquivo:
            arquivo.write(dados.content)
    else:
        print("Você está sem conexão com a internet!!!")

def main():

    destino = path.join(path.expanduser("~"), "cache")
    baixa_arquivo("https://raw.githubusercontent.com/williampilger/utilidades_gerais/master/ContadorDeAtividades/ContadorDeAtividades.py", destino)
    if(eh_windows):
        os.system(f"python {destino}")
    elif(eh_linux):
        os.system(f"python3 {destino}")
    quit()

if __name__ == "__main__":
    main()
