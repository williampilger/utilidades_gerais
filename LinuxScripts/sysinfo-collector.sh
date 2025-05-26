#!/bin/bash

# Script: sysinfo-collector.sh
# Author: Deepseek R1 - 2025-05-26 15:59
# Descrição: Coleta informações abrangentes do sistema em formato JSON
# Uso: ./sysinfo-collector.sh [opção]
# Opções:
#   --all          Coleta todas as informações (modo normal + modo root se disponível)
#   --network      Coleta apenas informações de rede
#   --hardware     Coleta apenas informações de hardware
#   --software     Coleta apenas informações de software
#   --users        Coleta apenas informações de usuários
#   --security     Coleta apenas informações de segurança
#   --show         Mostra as informações coletadas no terminal
#   --help         Mostra esta ajuda

VERSION="1.0"
OUTPUT_FILE="system_info_$(date +%Y%m%d_%H%M%S).json"
TEMP_FILE=$(mktemp)
ROOT_REQUIRED=0

# Cores para saída
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Verifica se o comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Mostra ajuda
show_help() {
    echo -e "${GREEN}SysInfo Collector ${VERSION}${NC}"
    echo "Coleta informações do sistema e salva em formato JSON"
    echo
    echo "Uso: $0 [opção]"
    echo
    echo "Opções:"
    echo "  --all          Coleta todas as informações (modo normal + modo root se disponível)"
    echo "  --network      Coleta apenas informações de rede"
    echo "  --hardware     Coleta apenas informações de hardware"
    echo "  --software     Coleta apenas informações de software"
    echo "  --users        Coleta apenas informações de usuários"
    echo "  --security     Coleta apenas informações de segurança"
    echo "  --show         Mostra as informações coletadas no terminal"
    echo "  --help         Mostra esta ajuda"
    echo
    echo "O arquivo de saída é gerado no diretório atual com o nome: system_info_<data_hora>.json"
}

# Inicia o arquivo JSON
init_json() {
    echo "{" > "$TEMP_FILE"
}

# Finaliza o arquivo JSON
end_json() {
    # Remove a vírgula extra do último elemento
    sed -i '$ s/,$//' "$TEMP_FILE"
    echo "}" >> "$TEMP_FILE"
}

# Adiciona uma seção ao JSON
add_section() {
    local section_name="$1"
    local section_content="$2"
    
    echo -e "\"$section_name\": $section_content," >> "$TEMP_FILE"
}

# Coleta informações básicas do sistema
collect_system_info() {
    echo -e "${YELLOW}[*] Coletando informações básicas do sistema...${NC}"
    
    local system_info=$(cat <<EOF
{
    "hostname": "$(hostname)",
    "operating_system": "$(lsb_release -d | cut -f2-)",
    "kernel_version": "$(uname -r)",
    "architecture": "$(uname -m)",
    "uptime": "$(uptime -p | sed 's/up //')",
    "current_user": "$(whoami)",
    "shell": "$SHELL",
    "timezone": "$(timedatectl | grep "Time zone" | awk '{print $3}')",
    "language": "$(echo $LANG)"
}
EOF
)
    add_section "system_info" "$system_info"
}

# Coleta informações de hardware
collect_hardware_info() {
    echo -e "${YELLOW}[*] Coletando informações de hardware...${NC}"
    
    # Informações da CPU
    local cpu_info=$(lscpu | awk -F: '{gsub(/^[ \t]+/, "", $2); if ($2 != "") printf "\"%s\": \"%s\",\n", $1, $2}' | sed '$ s/,$//')
    
    # Informações da memória
    local mem_info=$(free -h | awk '/^Mem:/ {printf "\"total\": \"%s\", \"used\": \"%s\", \"free\": \"%s\"", $2, $3, $4}')
    
    # Informações do disco
    local disk_info=$(lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE,MODEL -J | jq -c '.blockdevices')
    
    # Informações da placa-mãe (se disponível)
    local mobo_info="{}"
    if [ -f /sys/devices/virtual/dmi/id/board_vendor ]; then
        mobo_info=$(cat <<EOF
{
    "vendor": "$(cat /sys/devices/virtual/dmi/id/board_vendor 2>/dev/null)",
    "model": "$(cat /sys/devices/virtual/dmi/id/board_name 2>/dev/null)",
    "serial": "$(cat /sys/devices/virtual/dmi/id/board_serial 2>/dev/null)"
}
EOF
)
    fi
    
    # Informações da GPU
    local gpu_info="[]"
    if command_exists lspci; then
        gpu_info=$(lspci | grep -i "vga\|3d\|2d" | awk -F: '{print $3}' | jq -R -s -c 'split("\n") | map(select(. != ""))')
    fi
    
    # Informações dos monitores
    local monitor_info="{}"
    if command_exists xrandr; then
        monitor_info=$(xrandr --query | awk -v count=0 '/ connected/ {count++} END {printf "\"count\": %d", count}')
        monitor_info="{$monitor_info}"
    fi
    
    # Combina todas as informações de hardware
    local hardware_info=$(cat <<EOF
{
    "cpu": { $cpu_info },
    "memory": { $mem_info },
    "disks": $disk_info,
    "motherboard": $mobo_info,
    "gpu": $gpu_info,
    "monitors": $monitor_info
}
EOF
)
    add_section "hardware_info" "$hardware_info"
}

# Coleta informações de rede
collect_network_info() {
    echo -e "${YELLOW}[*] Coletando informações de rede...${NC}"
    
    # IP público (requer conexão com internet)
    local public_ip="null"
    if command_exists curl; then
        public_ip=$(curl -s https://api.ipify.org?format=json || echo "null")
    fi
    
    # IPs privados
    local private_ips=$(ip -j address || ip -j addr || ifconfig -a)
    
    # Informações de roteamento
    local routing_info=$(ip -j route || route -n)
    
    # Portas abertas (somente conexões ativas)
    local open_ports=$(ss -tuln -H | awk '{print $5}' | awk -F: '{print $NF}' | sort -n | uniq | jq -R -s -c 'split("\n") | map(select(. != ""))')
    
    # Informações de DNS
    local dns_info=$(cat /etc/resolv.conf | grep -E "^nameserver" | awk '{print $2}' | jq -R -s -c 'split("\n") | map(select(. != ""))')
    
    # Informações de vizinhos ARP
    local arp_info=$(ip -j neighbor || arp -n)
    
    # Varredura básica de rede (apenas para a subrede local)
    local network_scan="{}"
    if command_exists nmap && [ "$ROOT_REQUIRED" -eq 1 ]; then
        echo -e "${BLUE}[!] Executando varredura básica de rede (requer root)${NC}"
        local default_iface=$(ip route | grep default | awk '{print $5}' | head -n1)
        local local_network=$(ip -o -f inet addr show | grep "$default_iface" | awk '{print $4}')
        network_scan=$(nmap -sn "$local_network" -oJ - 2>/dev/null || echo "{}")
    fi
    
    # Combina todas as informações de rede
    local network_info=$(cat <<EOF
{
    "public_ip": $public_ip,
    "private_ips": $private_ips,
    "routing": $routing_info,
    "open_ports": $open_ports,
    "dns_servers": $dns_info,
    "arp_table": $arp_info,
    "network_scan": $network_scan
}
EOF
)
    add_section "network_info" "$network_info"
}

# Coleta informações de software
collect_software_info() {
    echo -e "${YELLOW}[*] Coletando informações de software...${NC}"
    
    # Pacotes instalados (depende da distribuição)
    local packages="[]"
    if command_exists dpkg; then
        packages=$(dpkg-query -W -f='{"name":"${Package}","version":"${Version}","architecture":"${Architecture}"}\n' | jq -s .)
    elif command_exists rpm; then
        packages=$(rpm -qa --queryformat='{"name":"%{NAME}","version":"%{VERSION}","release":"%{RELEASE}","architecture":"%{ARCH}"}\n' | jq -s .)
    elif command_exists pacman; then
        packages=$(pacman -Q | awk '{print "{\"name\":\"" $1 "\",\"version\":\"" $2 "\"}"}' | jq -s .)
    fi
    
    # Serviços em execução
    local running_services="{}"
    if command_exists systemctl; then
        running_services=$(systemctl list-units --type=service --state=running --no-pager -o json)
    fi
    
    # Variáveis de ambiente
    local env_vars=$(printenv | jq -R -s 'split("\n") | map(select(. != "")) | map(split("=")) | map({(.[0]): .[1]}) | add')
    
    # Aplicativos de inicialização automática
    local startup_apps="[]"
    if [ -d /etc/xdg/autostart/ ]; then
        startup_apps=$(find /etc/xdg/autostart/ -type f -name "*.desktop" | jq -R -s 'split("\n") | map(select(. != ""))')
    fi
    
    # Combina todas as informações de software
    local software_info=$(cat <<EOF
{
    "installed_packages": $packages,
    "running_services": $running_services,
    "environment_variables": $env_vars,
    "startup_applications": $startup_apps
}
EOF
)
    add_section "software_info" "$software_info"
}

# Coleta informações de usuários
collect_user_info() {
    echo -e "${YELLOW}[*] Coletando informações de usuários...${NC}"
    
    # Usuários do sistema
    local system_users=$(getent passwd | awk -F: '{printf "{\"username\":\"%s\",\"uid\":\"%s\",\"gid\":\"%s\",\"home\":\"%s\",\"shell\":\"%s\"}\n", $1, $3, $4, $6, $7}' | jq -s .)
    
    # Grupos do sistema
    local system_groups=$(getent group | awk -F: '{printf "{\"groupname\":\"%s\",\"gid\":\"%s\",\"members\":\"%s\"}\n", $1, $3, $4}' | jq -s .)
    
    # Usuários logados
    local logged_users=$(who | awk '{printf "{\"user\":\"%s\",\"terminal\":\"%s\",\"login_time\":\"%s %s\"}\n", $1, $2, $3, $4}' | jq -s .)
    
    # Histórico de logins
    local login_history="[]"
    if [ -f /var/log/auth.log ]; then
        login_history=$(grep -a "session opened" /var/log/auth.log | tail -n 10 | jq -R -s 'split("\n") | map(select(. != ""))')
    elif [ -f /var/log/secure ]; then
        login_history=$(grep -a "session opened" /var/log/secure | tail -n 10 | jq -R -s 'split("\n") | map(select(. != ""))')
    fi
    
    # Combina todas as informações de usuários
    local user_info=$(cat <<EOF
{
    "system_users": $system_users,
    "system_groups": $system_groups,
    "logged_users": $logged_users,
    "login_history": $login_history
}
EOF
)
    add_section "user_info" "$user_info"
}

# Coleta informações de segurança
collect_security_info() {
    echo -e "${YELLOW}[*] Coletando informações de segurança...${NC}"
    
    # Regras de firewall
    local firewall_rules="{}"
    if command_exists iptables && [ "$ROOT_REQUIRED" -eq 1 ]; then
        echo -e "${BLUE}[!] Coletando regras de firewall (requer root)${NC}"
        firewall_rules=$(iptables -L -n -v | jq -R -s 'split("\n") | map(select(. != ""))')
    elif command_exists ufw; then
        firewall_rules=$(ufw status verbose | jq -R -s 'split("\n") | map(select(. != ""))')
    fi
    
    # Informações de sudo
    local sudo_info=$(cat /etc/sudoers /etc/sudoers.d/* 2>/dev/null | grep -v -E '^#|^$' | jq -R -s 'split("\n") | map(select(. != ""))')
    
    # Permissões de arquivos sensíveis
    local sensitive_files="[]"
    if [ "$ROOT_REQUIRED" -eq 1 ]; then
        sensitive_files=$(find /etc /var/log -type f \( -name "*shadow*" -o -name "*passwd*" -o -name "*sudoers*" \) -exec ls -la {} \; 2>/dev/null | jq -R -s 'split("\n") | map(select(. != ""))')
    fi
    
    # Combina todas as informações de segurança
    local security_info=$(cat <<EOF
{
    "firewall_rules": $firewall_rules,
    "sudo_configuration": $sudo_info,
    "sensitive_files": $sensitive_files
}
EOF
)
    add_section "security_info" "$security_info"
}

# Coleta informações que requerem root
collect_root_info() {
    if [ "$(id -u)" -eq 0 ]; then
        ROOT_REQUIRED=1
        echo -e "${GREEN}[*] Coletando informações que requerem privilégios de root...${NC}"
        
        # Chama as funções que podem coletar mais informações com root
        collect_network_info
        collect_security_info
        
        # Informações adicionais somente disponíveis para root
        local kernel_modules=$(lsmod | awk 'NR>1 {printf "{\"module\":\"%s\",\"size\":\"%s\",\"used_by\":\"%s\"}\n", $1, $2, $3}' | jq -s .)
        add_section "kernel_modules" "$kernel_modules"
        
        local disk_usage=$(df -h | awk 'NR>1 {printf "{\"filesystem\":\"%s\",\"size\":\"%s\",\"used\":\"%s\",\"available\":\"%s\",\"mount_point\":\"%s\"}\n", $1, $2, $3, $4, $6}' | jq -s .)
        add_section "disk_usage" "$disk_usage"
    else
        echo -e "${RED}[!] Algumas informações requerem privilégios de root e não foram coletadas.${NC}"
        echo -e "${YELLOW}[!] Execute o script como root para coletar todas as informações.${NC}"
    fi
}

# Mostra as informações coletadas de forma organizada
show_collected_info() {
    if [ ! -f "$OUTPUT_FILE" ]; then
        echo -e "${RED}[!] Nenhum arquivo de informações encontrado.${NC}"
        echo -e "${YELLOW}[!] Execute o script com --all ou outra opção primeiro.${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}=== Informações Coletadas ===${NC}"
    jq '.' "$OUTPUT_FILE" | less -R
}

# Processa os argumentos da linha de comando
process_args() {
    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi
    
    case "$1" in
        --all)
            init_json
            collect_system_info
            collect_hardware_info
            collect_network_info
            collect_software_info
            collect_user_info
            collect_security_info
            collect_root_info
            end_json
            mv "$TEMP_FILE" "$OUTPUT_FILE"
            echo -e "${GREEN}[+] Todas as informações foram coletadas e salvas em $OUTPUT_FILE${NC}"
            ;;
        --network)
            init_json
            collect_network_info
            collect_root_info
            end_json
            mv "$TEMP_FILE" "$OUTPUT_FILE"
            echo -e "${GREEN}[+] Informações de rede foram coletadas e salvas em $OUTPUT_FILE${NC}"
            ;;
        --hardware)
            init_json
            collect_hardware_info
            end_json
            mv "$TEMP_FILE" "$OUTPUT_FILE"
            echo -e "${GREEN}[+] Informações de hardware foram coletadas e salvas em $OUTPUT_FILE${NC}"
            ;;
        --software)
            init_json
            collect_software_info
            end_json
            mv "$TEMP_FILE" "$OUTPUT_FILE"
            echo -e "${GREEN}[+] Informações de software foram coletadas e salvas em $OUTPUT_FILE${NC}"
            ;;
        --users)
            init_json
            collect_user_info
            end_json
            mv "$TEMP_FILE" "$OUTPUT_FILE"
            echo -e "${GREEN}[+] Informações de usuários foram coletadas e salvas em $OUTPUT_FILE${NC}"
            ;;
        --security)
            init_json
            collect_security_info
            collect_root_info
            end_json
            mv "$TEMP_FILE" "$OUTPUT_FILE"
            echo -e "${GREEN}[+] Informações de segurança foram coletadas e salvas em $OUTPUT_FILE${NC}"
            ;;
        --show)
            show_collected_info
            ;;
        --help|-h)
            show_help
            ;;
        *)
            echo -e "${RED}[!] Opção inválida: $1${NC}"
            show_help
            exit 1
            ;;
    esac
}

# Ponto de entrada principal
main() {
    # Verifica se o jq está instalado
    if ! command_exists jq; then
        echo -e "${RED}[!] O comando 'jq' é necessário para executar este script.${NC}"
        echo -e "${YELLOW}[!] Por favor, instale-o usando seu gerenciador de pacotes.${NC}"
        echo -e "${YELLOW}[!] Exemplo: sudo apt install jq (Debian/Ubuntu)${NC}"
        exit 1
    fi
    
    process_args "$@"
}

main "$@"
