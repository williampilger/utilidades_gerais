# Nome do arquivo: gerar_inserts.py

TAG_NOME = "Prefeituras RS"
ARQUIVO_LEADS = "dominios_validos.txt"

SENHA_CRIPTOGRAFIA_SQL = "password"

def gerar_sql(leads):
    sql = []

    # Criar a TAG
    sql.append(f"INSERT INTO leads_tags (title,description) VALUES (AES_ENCRYPT('{TAG_NOME}', '{SENHA_CRIPTOGRAFIA_SQL}'),AES_ENCRYPT('Todas as prefeituras do estado', '{SENHA_CRIPTOGRAFIA_SQL}'));")
    sql.append(f"SET @tag_id = LAST_INSERT_ID();")

    # Inserir as leads
    for lead in leads:
        lead_email = lead.replace(",", "").strip()
        lead_nome = lead_email.split("@")[1].split(".")[0]
        if lead_email:
            sql.append(f"INSERT INTO leads_profiles (name,email) VALUES (AES_ENCRYPT('Prefeitura - {lead_nome}', '{SENHA_CRIPTOGRAFIA_SQL}'), AES_ENCRYPT('{lead_email}', '{SENHA_CRIPTOGRAFIA_SQL}'));")
            sql.append(f"SET @lead_id = LAST_INSERT_ID();")
            sql.append(f"INSERT INTO leads_tag_profile (profileID, tagID) VALUES (@lead_id, @tag_id);")

    return "\n".join(sql)

def main():
    with open(ARQUIVO_LEADS, "r", encoding="utf-8") as file:
        leads = file.readlines()

    sql_script = gerar_sql(leads)

    with open("inserts.sql", "w", encoding="utf-8") as out_file:
        out_file.write(sql_script)

    print("Arquivo 'inserts.sql' criado com sucesso!")

if __name__ == "__main__":
    main()
