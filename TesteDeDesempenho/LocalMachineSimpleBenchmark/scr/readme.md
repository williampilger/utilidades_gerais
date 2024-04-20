# Monitor e Analizador de Resultados

Esta solução inclui o monitor e uma ferramenta para gerar relatórios genéricos do desempenho da máquina. Existem outros relatórios mais específicos no diretório `../plot_tools/`, juntamente com alguns exemplos.

As ferramentas de monitoramento (`monitor.py`) e análise dos dados (`analyzer.py`) são completamente independentes.


## Preparando o ambiente

Para evitar a instalação das bibliotecas na sua máquina principal, podes optar por criar o ambiente virtual:

*Linux - Ubuntu-based*
```sh
# sudo apt install python3-venv
python3 -m venv virtual_environment
source virtual_environment/bin/activate
pip3 install -r requirements.txt
```

*Microsoft Windows*
```sh
# sudo apt install python3-venv
python -m venv virtual_environment
virtual_environment\Scripts\activate
pip install -r requirements.txt
```

Para usar o ambiente depois de ter preparado tudo, basta:

*Linux - Ubuntu-based*
```sh
source virtual_environment/bin/activate
```