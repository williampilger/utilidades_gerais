#!/usr/bin/env python3
"""
Script para remover a proteção de trechos (células ou abas) em planilhas Excel protegidas.

Uso no terminal:
    python xlsx_remove_protection.py --input <caminho_arquivo.xlsx> --output <caminho_saída.xlsx>

Parâmetros:
    --input     Caminho do arquivo Excel protegido.
    --output    Caminho do arquivo Excel de saída (sem proteção).

Requisitos:
    - Python 3.x
    - Biblioteca openpyxl (instale com 'pip install openpyxl')

Autor:
    - ChatGPT (GPT-4o)
    - William Pilger -> github.com/williampilger
"""

import openpyxl
import argparse

def unprotect_excel_sheets(input_path, output_path):
    try:
        workbook = openpyxl.load_workbook(input_path)

        for sheet in workbook.worksheets:
            if sheet.protection.sheet:
                sheet.protection.sheet = False
                print(f"Proteção removida na aba: {sheet.title}")
            else:
                print(f"Aba '{sheet.title}' não estava protegida.")

        workbook.save(output_path)
        print(f"\nArquivo salvo em: {output_path}")
    except Exception as e:
        print(f"Ocorreu um erro: {e}")

def main():

    parser = argparse.ArgumentParser(
        description="Remove a proteção de trechos (abas ou células) em planilhas Excel protegidas."
    )
    parser.add_argument("--input", required=True, help="Caminho do arquivo Excel protegido")
    parser.add_argument("--output", required=True, help="Caminho do arquivo Excel sem proteção")
    
    args = parser.parse_args()

    unprotect_excel_sheets(args.input, args.output)

if __name__ == "__main__":
    main()
