# Relatório financeiro a partir de exportação de fechamento de mês no Nibo

Geração automática de relatório mensal (balanço mensal geral simplificado) com os dados exportados no campo **Fechamento de Mês** no *Nibo Empresas*.

---

## Como usar

### 1. Criar e ativar ambiente virtual (venv)

```bash
# No Linux/Mac
python3 -m venv venv
source venv/bin/activate

# ou
python -m venv venv
venv\Scripts\activate  # No Windows
```

### 2. Instalar dependências

```bash
pip install -r requirements.txt
```

### 3. Executar

```bash
python gerar_relatorio.py Arquivos_2025_11.zip
```

Substitua `Arquivos_2025_11.zip` pelo nome do seu arquivo ZIP.
