#!/usr/bin/env python3
"""
Script para descobrir a senha de arquivos Excel (.xlsx) protegidos usando força bruta.

Uso no terminal:
    python quebrar_senha_excel.py --input <caminho_arquivo.xlsx> --length <tamanho_da_senha>

Parâmetros:
    --input     Caminho do arquivo Excel protegido.
    --length    Comprimento máximo da senha a ser testada (padrão: 4).

Requisitos:
    - Python 3.x
    - Biblioteca msoffcrypto-tool (instale com 'pip install msoffcrypto-tool')

Autor:
    - ChatGPT (GPT-4o)
    - William Pilger -> github.com/williampilger
"""

import msoffcrypto
import argparse
import itertools
import string
import os

def try_passwords(file_path, password_length=4):
    chars = string.digits  # Ajuste para letras e números: string.ascii_letters + string.digits
    temp_output = "temp_unlocked.xlsx"

    print(f"Tentando desbloquear '{file_path}' com senhas de até {password_length} caracteres...")

    # Gerador de combinações de senhas
    for password in itertools.product(chars, repeat=password_length):
        password = ''.join(password)
        try:
            with open(file_path, "rb") as input_file:
                file = msoffcrypto.OfficeFile(input_file)
                file.load_key(password=password)  # Testa a senha

                # Se a senha for correta, exporta o arquivo desbloqueado
                with open(temp_output, "wb") as output_file:
                    file.decrypt(output_file)
                
                print(f"\nSenha encontrada: {password}")
                print(f"Arquivo desbloqueado salvo em: {os.path.abspath(temp_output)}")
                return password
        except Exception:
            continue

    print("\nSenha não encontrada.")
    return None

def main():
    parser = argparse.ArgumentParser(
        description="Descobre a senha de arquivos Excel protegidos via força bruta."
    )
    parser.add_argument("--input", required=True, help="Caminho do arquivo Excel protegido")
    parser.add_argument("--length", type=int, default=4, help="Comprimento máximo da senha (padrão: 4)")

    args = parser.parse_args()

    senha = try_passwords(args.input, args.length)

    if senha:
        print("Arquivo desbloqueado com sucesso!")
    else:
        print("Falha ao desbloquear o arquivo.")

if __name__ == "__main__":
    main()
