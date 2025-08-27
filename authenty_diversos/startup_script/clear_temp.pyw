# By: William Pilger
# Documentado automaticamente pelo @Copilot (Cloude Sonnet 4)

from tkinter import messagebox
import os
import shutil

def search_directories():
    # Diretórios para buscar
    home_dir = os.path.expanduser('~')
    directories = [
        os.path.join(home_dir, 'Downloads'), 
        os.path.join(home_dir, 'Desktop')
    ]
    
    # Lista para armazenar os arquivos e pastas encontrados
    found_items = []

    # Lista de extensões e nomes permitidos (!!! LOWERCASE !!!)
    allowed_extensions = ['.ini', '.lnk', '.tmp.driveupload']
    allowed_folders = ['desktop.ini']  # Nomes de pastas permitidas

    # Procurar por arquivos e pastas apenas no nível raiz dos diretórios
    for directory in directories:
        if not os.path.exists(directory):
            print(f'O diretório {directory} não existe')
            continue
            
        try:
            # Listar apenas o conteúdo direto do diretório (não recursivo)
            for item in os.listdir(directory):
                item_path = os.path.join(directory, item)
                
                if os.path.isfile(item_path):
                    # Verificar extensão do arquivo
                    file_extension = os.path.splitext(item)[1].lower()
                    if file_extension in allowed_extensions:
                        print(f'O arquivo {item} foi ignorado (whitelist - extensão)')
                        continue
                    print(f'O arquivo {item} precisa ser removido')
                    found_items.append(item_path)
                    
                elif os.path.isdir(item_path):
                    # Verificar nome da pasta
                    if item.lower() in allowed_folders:
                        print(f'A pasta {item} foi ignorada (whitelist - nome)')
                        continue
                    print(f'A pasta {item} precisa ser removida')
                    found_items.append(item_path)
                    
        except PermissionError:
            print(f'Sem permissão para acessar {directory}')
        except Exception as e:
            print(f'Erro ao acessar {directory}: {e}')
    
    return found_items

def search_and_warn():
    found_items = search_directories()
    while found_items != []:  # Loop proposital até que todos os arquivos sejam removidos
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
        
        message += "\nPor favor, salve-os manualmente em local apropriado."
        
        messagebox.showwarning("Atenção - Arquivos encontrados", message)
        
        # Atualizar a lista para verificar se ainda há itens
        found_items = search_directories()


def limpa_diretorio(diretorio):
    if os.path.exists(diretorio):
        print(f'Limpando o diretório {diretorio}')
        try:
            for item in os.listdir(diretorio):
                item_path = os.path.join(diretorio, item)
                try:
                    if os.path.isdir(item_path):
                        shutil.rmtree(item_path)
                        print(f'Pasta removida: {item}')
                    else:
                        os.remove(item_path)
                        print(f'Arquivo removido: {item}')
                except PermissionError:
                    print(f'Sem permissão para remover: {item}')
                except Exception as e:
                    print(f'Erro ao remover {item}: {e}')
        except Exception as e:
            print(f'Erro ao acessar o diretório {diretorio}: {e}')
    else:
        print(f'O diretório {diretorio} não existe')


def main():
    print("Iniciando limpeza de arquivos temporários...")
    
    # Limpar diretórios específicos do Windows/ESA22.1
    limpa_diretorio(os.path.expandvars(r'%userprofile%\ESA22.1\Temp'))
    limpa_diretorio(os.path.expandvars(r'%userprofile%\Documents\ESA22.1\Autosave'))
    
    # Verificar Downloads e Desktop (com loop até que sejam removidos)
    print("Verificando Downloads e Desktop...")
    search_and_warn()
    
    print("Processo de limpeza concluído.")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"Erro durante execução: {e}")
        messagebox.showerror("Erro", f"Ocorreu um erro durante a execução:\n{e}")
