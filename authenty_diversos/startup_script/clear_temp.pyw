from tkinter import messagebox
import os
import shutil

def search_directories():
    # Diretórios para buscar
    directories = [os.path.join(os.path.expanduser('~'), 'Downloads'), os.path.join(os.path.expanduser('~'), 'Desktop')]
    
    # Lista para armazenar os arquivos e pastas encontrados
    found_items = []

    # Lista de extensões e nomes de pastas permitidos (!!! LOWERCASE !!!)
    allowed_items = ['.ini', '.lnk', '.tmp.driveupload']

    # Procurar por arquivos e pastas
    for directory in directories:
        for root, dirs, files in os.walk(directory):
            for name in files:
                filename = os.path.splitext(name)[1].lower()
                if filename in allowed_items:
                    print(f'O arquivo {filename} foi ignorado (whitelist)')
                    continue  # Ignorar arquivos com extensões permitidas
                print(f'O arquivo {filename} precisa ser removido')
                found_items.append(os.path.join(root, name))
            for name in dirs:
                if name.lower() in allowed_items:
                    print(f'A pasta {name} foi ignorada (whitelist)')
                    continue  # Ignorar pastas com nomes permitidos
                print(f'A pasta {name} precisa ser removida')
                found_items.append(os.path.join(root, name))
    
    return found_items

def search_and_warn():
    found_items = search_directories()
    while found_items != []:
        # Criar mensagem com os primeiros 4 itens
        message = "Foram encontrados arquivos e pastas nas pastas Downloads e Desktop:\n\n"
        
        # Mostrar apenas os primeiros 4 itens
        items_to_show = found_items[:4]
        for item in items_to_show:
            # Mostrar apenas o nome do arquivo/pasta, não o caminho completo
            item_name = os.path.basename(item)
            message += f"• {item_name}\n"
        
        # Adicionar reticências se houver mais itens
        if len(found_items) > 4:
            remaining_count = len(found_items) - 4
            message += f"... e mais {remaining_count} item(s)\n"
        
        message += "\nPor favor, exclua-os manualmente."
        
        messagebox.showinfo("Aviso", message)
        
        # Atualizar a lista para verificar se ainda há itens
        found_items = search_directories()


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
