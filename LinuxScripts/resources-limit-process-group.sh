#!/bin/bash
# By: ChatGPT 4o - 2024.07.09 11:09 - Prompt: quero um script linux para chamar e informar um nome (ou filtro de string) para que os processos sejam adicionados ao grupo, limite de CPU, memória e núcleos. quero que estes parâmetros sejam opcionais

# Função para mostrar a ajuda
mostrar_ajuda() {
    echo "Uso: $0 -n <nome_do_processo> [-c <percentual_cpu>] [-m <memoria_em_MB>] [-p <nucleos>]"
    echo
    echo "  -n    Nome ou parte do nome do processo."
    echo "  -c    Limite de uso de CPU em percentual (opcional)."
    echo "  -m    Limite de uso de memória em MB (opcional)."
    echo "  -p    Núcleos de CPU permitidos, separados por vírgula (opcional)."
    exit 1
}

# Inicializar variáveis
NOME_PROCESSO=""
LIMIT_CPU=""
LIMIT_MEM=""
CPU_CORES=""

# Processar argumentos
while getopts "n:c:m:p:h" opt; do
    case ${opt} in
        n) NOME_PROCESSO=${OPTARG} ;;
        c) LIMIT_CPU=${OPTARG} ;;
        m) LIMIT_MEM=${OPTARG} ;;
        p) CPU_CORES=${OPTARG} ;;
        h) mostrar_ajuda ;;
        \?) mostrar_ajuda ;;
    esac
done

# Verificar se o nome do processo foi fornecido
if [ -z "${NOME_PROCESSO}" ]; then
    mostrar_ajuda
fi

# Verificar se cgroup-tools está instalado
if ! command -v cgcreate &> /dev/null; then
    echo "cgroup-tools não está instalado. Instalando..."
    sudo apt-get update
    sudo apt-get install -y cgroup-tools
fi

# Criar cgroup se não existir
CGROUP_NAME="custom_group"
sudo cgcreate -g cpu,memory:/custom_group

# Configurar limites de CPU
if [ ! -z "${LIMIT_CPU}" ]; then
    CPU_QUOTA=$(echo "${LIMIT_CPU} * 1000" | bc | awk '{printf "%d", $1}')
    sudo cgset -r cpu.cfs_quota_us=${CPU_QUOTA} ${CGROUP_NAME}
    sudo cgset -r cpu.cfs_period_us=100000 ${CGROUP_NAME}
fi

# Configurar limites de memória
if [ ! -z "${LIMIT_MEM}" ]; then
    MEM_LIMIT=$(echo "${LIMIT_MEM} * 1024 * 1024" | bc)
    sudo cgset -r memory.limit_in_bytes=${MEM_LIMIT} ${CGROUP_NAME}
fi

# Encontrar processos e adicionar ao cgroup
for pid in $(pgrep -f ${NOME_PROCESSO}); do
    sudo cgclassify -g cpu,memory:/custom_group ${pid}
    # Definir afinidade de CPU, se especificado
    if [ ! -z "${CPU_CORES}" ]; then
        sudo taskset -cp ${CPU_CORES} ${pid}
    fi
done

echo "Processos correspondentes a '${NOME_PROCESSO}' foram limitados conforme especificado."
