#!/bin/bash
# By CharGPT - Este script foi escrito, praticamente na íntegra, pelo chatGPT.

# Verifica a instalação do Python e instala se necessário
if ! command -v python3 &> /dev/null
then
    echo "Python 3 não está instalado. Instalando Python 3..."
    sudo apt update
    sudo apt install python3 -y
else
    echo "Python 3 já está instalado."
fi

# Cria o diretório local de aplicações, se não existir
mkdir -p ~/.local/share/applications

# Cria o lançador de scripts Python
echo "Criando o lançador para scripts Python..."
LAUNCHER_PATH="/usr/local/bin/run-python"
echo '#!/bin/bash' | sudo tee $LAUNCHER_PATH
echo 'python3 "$@"' | sudo tee -a $LAUNCHER_PATH
sudo chmod +x $LAUNCHER_PATH

# Cria o arquivo .desktop para o lançador
DESKTOP_ENTRY="$HOME/.local/share/applications/run-python.desktop"
echo "[Desktop Entry]" > $DESKTOP_ENTRY
echo "Name=Run Python Script" >> $DESKTOP_ENTRY
echo "Exec=/usr/local/bin/run-python %f" >> $DESKTOP_ENTRY
echo "Type=Application" >> $DESKTOP_ENTRY
echo "Terminal=false" >> $DESKTOP_ENTRY
echo "MimeType=text/x-python;" >> $DESKTOP_ENTRY

# Adiciona a associação de MIME type
MIMEAPPS="$HOME/.config/mimeapps.list"
mkdir -p $(dirname $MIMEAPPS)
touch $MIMEAPPS
echo "[Default Applications]" >> $MIMEAPPS
echo "text/x-python=run-python.desktop" >> $MIMEAPPS

# Atualiza o banco de dados de MIME types
update-desktop-database ~/.local/share/applications

echo "Configuração completa. Arquivos .py e .pyw agora podem ser executados com um duplo clique."
