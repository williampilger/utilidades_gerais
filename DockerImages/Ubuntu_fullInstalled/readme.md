# Ubuntu

Essa imagem é pronta para rodar comandos do Ubuntu.

## Criando a Imagem

> docker build -t williampilger/ubuntu .

## Executando

*Auto-removida e com rede total*
```sh
docker run -it --rm --network host williampilger/kali
```

*Auto-removida, com rede total e montagem de diretório Downloads para host Windows*
```sh
docker run -it --rm --network host -v "%userprofile%\Downloads":/Downloads williampilger/ubuntu
```