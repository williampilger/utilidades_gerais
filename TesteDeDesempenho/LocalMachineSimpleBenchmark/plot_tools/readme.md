# Gerando relatórios e gráficos

Para estes scripts **não criei uma interface para gerar estes gráficos**, portanto, usarei scripts curtos para fazer as manipulações e gerar os gráficos de forma bastante simples.

Estou usando ambientes virtuais aqui, para não instalar bibliotecas desnecessárias na máquina hospedeira.

## Preparando o ambiente

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

## Executando a parada

Para usar o ambiente depois de ter preparado tudo, e executando um dos relatórios:

*Linux - Ubuntu-based*
```sh
source virtual_environment/bin/activate
python3 plot_result_3.py
```

