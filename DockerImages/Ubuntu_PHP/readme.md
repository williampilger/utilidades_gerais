# Ubuntu PHP

Essa imagem é pronta para rodar um servidor PHP com as principais extensões que EU uso.


## Criando a Imagem

> docker build -t williampilger/ubuntu_php .

## Executando

*Auto-removida e com rede total*
```sh
docker run -it --rm --network host williampilger/ubuntu_php
```

*Auto-removida, com rede total e montagem de diretório atual para o html root - Linux*
```sh
docker run -it --rm --network host -v ".":/var/www/html williampilger/ubuntu_php
```