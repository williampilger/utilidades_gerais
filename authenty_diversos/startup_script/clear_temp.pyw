import tkinter as tk
from tkinter import messagebox
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
    found_items = search_directories()

    # Se encontrou algum item, mostrar aviso
    if found_items:
        messagebox.showinfo("Aviso", "Foram encontrados arquivos e pastas nas pastas Downloads e Desktop. "
                                     "Por favor, exclua-os manualmente.")
        # Verificar novamente após o usuário clicar em OK
        found_items_after = search_directories()
        if found_items_after:
            # Se ainda houver itens, mostrar o aviso novamente
            search_and_warn()
        else:
            # Se todos os itens foram excluídos, encerrar o aplicativo
            root.destroy()
    else:
        # Se nenhum item foi encontrado, encerrar o aplicativo
        root.destroy()

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
    global root
    root = tk.Tk()
    root.withdraw()  # Esconde a janela principal

    limpa_diretorio(os.path.expandvars(r'%userprofile%\ESA22.1\Temp'))
    limpa_diretorio(os.path.expandvars(r'%userprofile%\Documents\ESA22.1\Autosave'))
    
    search_and_warn()

    root.mainloop()

if __name__ == "__main__":
    main()
