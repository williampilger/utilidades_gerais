import dns.resolver
from tqdm import tqdm  # Para barra de progresso (opcional)

def verificar_email(email):
    dominio = email.split('@')[-1].split(',')[0]
    
     # 1. Verifica resolução DNS do domínio
    try:
        # Verifica se o domínio existe (registro A)
        dns.resolver.resolve(dominio, 'A')
        
        # Verifica se tem MX (servidor de email)
        mx_records = dns.resolver.resolve(dominio, 'MX')
        mx_record = str(mx_records[0].exchange)
    except Exception as e:
        return False, dominio, f"Erro DNS: {str(e)}"
    
    return True, dominio, f"DNS Válido"

# Carrega os e-mails do arquivo
with open('emails.txt', 'r') as f:
    emails = f.readlines()

validos = []
invalidos = []

print("Verificando e-mails...")
for email in tqdm(emails):
    if '@' not in email:
        continue
        
    valido, dominio, msg = verificar_email(email)
    # print(f"Verificado { '✅' if valido else '❌'} {dominio}... {msg}")
    if valido:
        validos.append(email.strip())
    else:
        invalidos.append(f"{email.strip()} (Domínio: {dominio} {msg})")

# Salva os resultados
with open('dominios_validos.txt', 'w') as f:
    f.write('\n'.join(validos))

with open('dominios_invalidos.txt', 'w') as f:
    f.write('\n'.join(invalidos))

print(f"""
Processo concluído!
E-mails válidos salvos em: dominios_validos.txt ({len(validos)})
E-mails inválidos salvos em: dominios_invalidos.txt ({len(invalidos)})
""")