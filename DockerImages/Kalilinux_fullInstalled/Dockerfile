FROM kalilinux/kali-last-release

RUN apt update
# Coloquei um `|| true` pois sempre tem algum pacote que não está instalando... e eu não preciso necessariamente de todo o sistema, o básico já está ótimo.
#RUN apt install -y kali-linux-default || true

# Instalar manualmente -- OU -- Para forçar a instalação dos itens específicos
RUN apt install -y netcat-openbsd nmap wireshark tcpdump dnsutils iputils-ping
