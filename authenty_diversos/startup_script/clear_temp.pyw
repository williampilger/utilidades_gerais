import tkinter as tk
from tkinter import messagebox
import threading
import os
import shutil

def search_directories():
    # Diretórios para buscar
    directories = [os.path.join(os.path.expanduser('~'), 'Downloads'), os.path.join(os.path.expanduser('~'), 'Desktop')]
    
    # Lista para armazenar os arquivos e pastas encontrados
    found_items = []

    # Lista de extensões e nomes de pastas permitidos
    allowed_items = ['.ini', '.lnk', '.tmp.driveupload']

    # Procurar por arquivos e pastas
    for directory in directories:
        for root, dirs, files in os.walk(directory):
            for name in files:
                if os.path.splitext(name)[1].lower() in allowed_items:
                    continue  # Ignorar arquivos com extensões permitidas
                found_items.append(os.path.join(root, name))
            for name in dirs:
                if name.lower() in allowed_items:
                    continue  # Ignorar pastas com nomes permitidos
                found_items.append(os.path.join(root, name))
    
    return found_items

def search_and_warn():
    while search_directories()!=[]:
        messagebox.showinfo("Aviso", "Foram encontrados arquivos e pastas nas pastas Downloads e Desktop.\nPor favor, exclua-os manualmente.")


def limpa_diretorio(diretorio):
    if os.path.exists(diretorio):
        print(f'Limpando o diretório {diretorio}')
        for item in os.listdir(diretorio):
            item_path = os.path.join(diretorio, item)
            if os.path.isdir(item_path):
                shutil.rmtree(item_path)
            else:
                os.remove(item_path)
    else:
        print(f'O diretório {diretorio} não existe')


def main():

    limpa_diretorio(os.path.expandvars(r'%userprofile%\ESA22.1\Temp'))
    limpa_diretorio(os.path.expandvars(r'%userprofile%\Documents\ESA22.1\Autosave'))
    
    search_and_warn()


if __name__ == "__main__":
    main()
