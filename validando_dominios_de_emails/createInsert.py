# Nome do arquivo: gerar_inserts.py

TAG_NOME = "Prefeituras RS"
ARQUIVO_LEADS = "dominios_validos.txt"

def gerar_sql(leads):
    sql = []

    # Criar a TAG
    sql.append(f"INSERT INTO leads_tags (title) VALUES ('{TAG_NOME}');")
    sql.append(f"SET @tag_id = LAST_INSERT_ID();")

    # Inserir as leads
    for lead in leads:
        lead_nome = lead.replace(",", "").strip()
        if lead_nome:
            sql.append(f"INSERT INTO leads_profiles (name,email) VALUES ('{lead_nome}','{lead_nome}');")
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
