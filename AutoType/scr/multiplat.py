# By: William Pilger
# 2021.08.10 - Song: Heathens (Twenty One Pilots)

import os
import platform

eh_windows = platform.system() == "Windows"
eh_linux = platform.system() == "Linux"

def restart_program():
    if(eh_windows):
        os.system(f"python \"main.py\"")
    elif(eh_linux):
        os.system(f"python3 \"main.py\"")
    quit()
    
def install_lib(lib):
    print(f"\nINSTALANDO BIBLIOTECA NECESSÁRIA, AGUARDE!\n(CONEXÃO COM INTERNET NECESSÁRIA)\n{lib}")
    if(eh_windows):
        os.system(f"pip install {lib}")
    elif(eh_linux):
        os.system(f"pip3 install {lib}")

def limpar_terminal():
    if(eh_windows):
        os.system("cls")
    elif(eh_linux):
        os.system("clear")
    return