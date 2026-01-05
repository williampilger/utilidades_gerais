#!/usr/bin/env python3
"""
Script para gerar relatório financeiro a partir de arquivo ZIP contendo dados financeiros.
Uso: python gerar_relatorio.py <arquivo_zip>
"""

import sys
import os
import zipfile
import tempfile
import shutil
from pathlib import Path
import pandas as pd
import xml.etree.ElementTree as ET
from datetime import datetime
from collections import defaultdict
import warnings

warnings.filterwarnings('ignore')

class AnalisadorFinanceiro:
    def __init__(self, caminho_zip):
        self.caminho_zip = caminho_zip
        self.dados_extratos = []
        self.dados_nfse = []
        self.dir_temp = None
        
    def extrair_zip(self):
        """Extrai o conteúdo do ZIP para um diretório temporário"""
        self.dir_temp = tempfile.mkdtemp()
        print(f"📂 Extraindo arquivo ZIP: {self.caminho_zip}")
        
        with zipfile.ZipFile(self.caminho_zip, 'r') as zip_ref:
            zip_ref.extractall(self.dir_temp)
        
        print(f"✅ Arquivos extraídos para: {self.dir_temp}\n")
        return self.dir_temp
    
    def processar_extratos_xlsx(self):
        """Processa arquivos XLSX de extratos bancários do Nibo"""
        arquivos_xlsx = list(Path(self.dir_temp).glob('extrato_nibo_*.xlsx'))
        
        print(f"📊 Processando {len(arquivos_xlsx)} arquivos de extrato (XLSX)...")
        
        for arquivo in arquivos_xlsx:
            try:
                df = pd.read_excel(arquivo)
                
                # Identifica o tipo de conta pelo nome do arquivo
                nome_arquivo = arquivo.name
                if 'Hotmart' in nome_arquivo:
                    conta = 'Hotmart'
                elif 'Stripe' in nome_arquivo:
                    conta = 'Stripe'
                elif 'Sicredi' in nome_arquivo:
                    conta = 'Sicredi'
                elif 'Nubank' in nome_arquivo:
                    conta = 'Nubank'
                elif 'Cartão' in nome_arquivo or 'Credito' in nome_arquivo:
                    conta = 'Cartão de Crédito'
                else:
                    conta = 'Outros'
                
                # Adiciona coluna de identificação da conta
                df['Conta'] = conta
                df['Arquivo'] = arquivo.name
                
                self.dados_extratos.append(df)
                print(f"  ✓ {arquivo.name}: {len(df)} transações")
                
            except Exception as e:
                print(f"  ✗ Erro ao processar {arquivo.name}: {e}")
        
        print()
    
    def processar_extratos_ofx(self):
        """Processa arquivos OFX de extratos bancários"""
        arquivos_ofx = list(Path(self.dir_temp).glob('extrato_banco_*.ofx'))
        
        if not arquivos_ofx:
            return
        
        print(f"💳 Processando {len(arquivos_ofx)} arquivos OFX...")
        
        try:
            import ofxparse
            
            for arquivo in arquivos_ofx:
                try:
                    with open(arquivo, 'rb') as f:
                        ofx = ofxparse.OfxParser.parse(f)
                    
                    # Identifica a conta
                    nome_arquivo = arquivo.name
                    if 'Hotmart' in nome_arquivo:
                        conta = 'Hotmart'
                    elif 'Stripe' in nome_arquivo:
                        conta = 'Stripe'
                    elif 'Sicredi' in nome_arquivo:
                        conta = 'Sicredi'
                    elif 'Nubank' in nome_arquivo:
                        conta = 'Nubank'
                    elif 'Cartão' in nome_arquivo or 'Credito' in nome_arquivo:
                        conta = 'Cartão de Crédito'
                    else:
                        conta = 'Outros'
                    
                    # Extrai transações
                    if hasattr(ofx, 'account') and hasattr(ofx.account, 'statement'):
                        transacoes = []
                        for transacao in ofx.account.statement.transactions:
                            transacoes.append({
                                'Data': transacao.date,
                                'Descrição': transacao.memo or transacao.payee,
                                'Valor': float(transacao.amount),
                                'Tipo': transacao.type,
                                'Conta': conta,
                                'Arquivo': arquivo.name
                            })
                        
                        if transacoes:
                            df = pd.DataFrame(transacoes)
                            self.dados_extratos.append(df)
                            print(f"  ✓ {arquivo.name}: {len(transacoes)} transações")
                    
                except Exception as e:
                    print(f"  ✗ Erro ao processar {arquivo.name}: {e}")
        
        except ImportError:
            print("  ⚠ Biblioteca 'ofxparse' não instalada, pulando arquivos OFX")
        
        print()
    
    def processar_nfse_xml(self):
        """Processa arquivos XML de Notas Fiscais de Serviço Eletrônicas"""
        arquivos_xml = list(Path(self.dir_temp).glob('NFSe_*_Autorizada.xml'))
        
        print(f"🧾 Processando {len(arquivos_xml)} notas fiscais (XML)...")
        
        for arquivo in arquivos_xml:
            try:
                tree = ET.parse(arquivo)
                root = tree.getroot()
                
                # Tenta diferentes estruturas de XML de NFSe
                nfse_data = self._extrair_dados_nfse(root)
                
                if nfse_data:
                    nfse_data['Arquivo'] = arquivo.name
                    self.dados_nfse.append(nfse_data)
                
            except Exception as e:
                print(f"  ✗ Erro ao processar {arquivo.name}: {e}")
        
        print(f"  ✓ {len(self.dados_nfse)} notas fiscais processadas\n")
    
    def _extrair_dados_nfse(self, root):
        """Extrai dados relevantes do XML da NFSe"""
        try:
            # Remove namespaces para facilitar a busca
            for elem in root.iter():
                if '}' in elem.tag:
                    elem.tag = elem.tag.split('}', 1)[1]
            
            # Busca campos comuns em NFSe
            numero = self._buscar_valor(root, ['Numero', 'NumeroNfse', 'IdentificacaoNfse'])
            data_emissao = self._buscar_valor(root, ['DataEmissao', 'DataEmissaoNfse'])
            valor = self._buscar_valor(root, ['ValorServicos', 'Valor', 'ValorTotal'])
            descricao = self._buscar_valor(root, ['Discriminacao', 'DescricaoServico', 'Servico'])
            
            # Dados do tomador (cliente)
            tomador_nome = self._buscar_valor(root, ['RazaoSocial', 'Nome'], contexto='Tomador')
            
            # Dados do prestador
            prestador_nome = self._buscar_valor(root, ['RazaoSocial', 'Nome'], contexto='Prestador')
            
            if valor:
                return {
                    'Numero': numero or 'N/A',
                    'Data': self._parsear_data(data_emissao),
                    'Valor': float(valor.replace(',', '.')) if isinstance(valor, str) else float(valor),
                    'Descricao': descricao or 'Serviço',
                    'Cliente': tomador_nome or 'N/A',
                    'Prestador': prestador_nome or 'N/A'
                }
        
        except Exception as e:
            return None
    
    def _buscar_valor(self, root, tags, contexto=None):
        """Busca um valor em uma lista de possíveis tags"""
        for tag in tags:
            # Se há contexto, busca dentro dele
            if contexto:
                elementos_contexto = root.findall(f'.//{contexto}')
                for elem_contexto in elementos_contexto:
                    elemento = elem_contexto.find(f'.//{tag}')
                    if elemento is not None and elemento.text:
                        return elemento.text.strip()
            
            # Busca global
            elemento = root.find(f'.//{tag}')
            if elemento is not None and elemento.text:
                return elemento.text.strip()
        
        return None
    
    def _parsear_data(self, data_str):
        """Converte string de data para objeto datetime"""
        if not data_str:
            return None
        
        formatos = ['%Y-%m-%d', '%d/%m/%Y', '%Y%m%d', '%d-%m-%Y']
        
        for formato in formatos:
            try:
                return datetime.strptime(data_str, formato)
            except:
                continue
        
        return None
    
    def gerar_relatorio(self):
        """Gera o relatório financeiro completo"""
        print("\n" + "="*80)
        print("📈 RELATÓRIO FINANCEIRO - NOVEMBRO 2025")
        print("="*80 + "\n")
        
        # Combina todos os extratos
        if self.dados_extratos:
            df_extratos = pd.concat(self.dados_extratos, ignore_index=True)
            self._relatorio_extratos(df_extratos)
        else:
            print("⚠ Nenhum dado de extrato bancário encontrado.\n")
        
        # # Analisa NFSe
        # if self.dados_nfse:
        #     df_nfse = pd.DataFrame(self.dados_nfse)
        #     self._relatorio_nfse(df_nfse)
        # else:
        #     print("⚠ Nenhuma nota fiscal encontrada.\n")
        
        # # Resumo geral
        # self._relatorio_resumo(df_extratos if self.dados_extratos else None, 
        #                       df_nfse if self.dados_nfse else None)
    
    def _identificar_transferencias(self, df):
        """Identifica transações de transferência entre contas"""
        # Palavras-chave que indicam transferência entre contas
        palavras_transferencia = [
            'transferencia', 'transferência', 'transf', 'transfer',
            'entre contas', 'conta corrente', 'ted', 'pix',
            'aplicacao', 'aplicação', 'resgate', 'investimento',
            'transferido', 'enviado para', 'recebido de'
        ]
        
        # Identifica coluna de descrição
        colunas_desc = [col for col in df.columns if any(x in col.lower() for x in ['descri', 'memo', 'historic', 'nome'])]
        
        if not colunas_desc:
            return pd.Series([False] * len(df), index=df.index)
        
        col_desc = colunas_desc[0]
        
        # Cria máscara para identificar transferências
        mask_transferencia = df[col_desc].astype(str).str.lower().apply(
            lambda x: any(palavra in x for palavra in palavras_transferencia)
        )
        
        return mask_transferencia
    
    def _relatorio_extratos(self, df):
        """Gera relatório dos extratos bancários"""
        print("💰 MOVIMENTAÇÃO BANCÁRIA\n")
        
        # Verifica se existe formato Entrada/Saida (padrão Nibo)
        if 'Entrada' in df.columns and 'Saida' in df.columns:
            # Converte para numérico, limpando NaN e convertendo strings
            df['Entrada'] = pd.to_numeric(df['Entrada'].astype(str).str.replace(',', '.'), errors='coerce').fillna(0)
            df['Saida'] = pd.to_numeric(df['Saida'].astype(str).str.replace(',', '.'), errors='coerce').fillna(0)
            
            # Cria coluna de valor consolidado
            # Entradas são positivas, Saídas já vêm negativas ou precisam ser negativas
            df['Valor'] = df['Entrada'] + df['Saida']  # Saida já é negativa
            col_valor = 'Valor'
        else:
            # Identifica colunas de valor
            colunas_valor = [col for col in df.columns if any(x in col.lower() for x in ['valor', 'amount', 'quantia'])]
            
            if not colunas_valor:
                print("  ⚠ Estrutura de dados não identificada nos extratos\n")
                print("  Colunas disponíveis:", df.columns.tolist())
                print(f"\n  Mostrando primeiras linhas:\n{df.head()}\n")
                return
            
            col_valor = colunas_valor[0]
        
        # Converte valores para numérico
        df[col_valor] = pd.to_numeric(df[col_valor], errors='coerce')
        
        # Agrupa por conta
        print("  Resumo por Conta:")
        por_conta = df.groupby('Conta')[col_valor].agg(['sum', 'count'])
        for conta, row in por_conta.iterrows():
            total = row['sum']
            qtd = row['count']
            print(f"    • {conta:30s}: R$ {total:>12,.2f} ({int(qtd):>3} transações)")
        
        print()
        
        # Separa receitas e despesas
        df['Tipo_Transacao'] = df[col_valor].apply(lambda x: 'Receita' if x > 0 else 'Despesa')
        
        total_receitas = df[df[col_valor] > 0][col_valor].sum()
        total_despesas = abs(df[df[col_valor] < 0][col_valor].sum())
        saldo = total_receitas - total_despesas
        
        # print(f"  Total de Receitas:  R$ {total_receitas:>12,.2f}")
        # print(f"  Total de Despesas:  R$ {total_despesas:>12,.2f}")
        print(f"  Saldo:              R$ {saldo:>12,.2f}")
        print()
        
        # Análise por categoria (se disponível)
        if 'Categoria' in df.columns:
            print("  📊 Despesas por Categoria:")
            despesas_cat = df[df[col_valor] < 0].copy()
            if len(despesas_cat) > 0:
                por_categoria = despesas_cat.groupby('Categoria')[col_valor].agg(['sum', 'count'])
                por_categoria['sum'] = abs(por_categoria['sum'])
                por_categoria = por_categoria.sort_values('sum', ascending=False)
                
                total_categorizado = por_categoria['sum'].sum()
                
                for categoria, row in por_categoria.head(15).iterrows():
                    valor = row['sum']
                    qtd = int(row['count'])
                    percentual = (valor / total_categorizado * 100) if total_categorizado > 0 else 0
                    print(f"    • {str(categoria)[:35]:35s}: R$ {valor:>10,.2f} ({qtd:>3} transações) - {percentual:>5.1f}%")
            print()
        
        # Maiores despesas (excluindo transferências)
        despesas = df[df[col_valor] < 0].copy()
        if len(despesas) > 0:
            # Filtra transferências apenas para exibição
            mask_transf = self._identificar_transferencias(despesas)
            despesas_sem_transf = despesas[~mask_transf].copy()
            
            transferencias_removidas_desp = len(despesas) - len(despesas_sem_transf)
            
            print("  🔴 Maiores Despesas:")
            if transferencias_removidas_desp > 0:
                print(f"      (excluindo {transferencias_removidas_desp} transferências entre contas)")
            
            # Identifica coluna de descrição
            colunas_desc = [col for col in df.columns if any(x in col.lower() for x in ['descri', 'memo', 'historic', 'nome'])]
            col_desc = colunas_desc[0] if colunas_desc else None
            
            if len(despesas_sem_transf) > 0:
                despesas_sem_transf['Valor_Abs'] = abs(despesas_sem_transf[col_valor])
                despesas_top = despesas_sem_transf.nlargest(10, 'Valor_Abs')
                
                for idx, row in despesas_top.iterrows():
                    desc = row[col_desc] if col_desc and pd.notna(row[col_desc]) else 'Sem descrição'
                    desc = str(desc)[:50]
                    valor = abs(row[col_valor])
                    print(f"    • R$ {valor:>10,.2f} - {desc}")
        
        print()
        
        # Maiores receitas (excluindo transferências)
        receitas = df[df[col_valor] > 0].copy()
        if len(receitas) > 0:
            # Filtra transferências apenas para exibição
            mask_transf = self._identificar_transferencias(receitas)
            receitas_sem_transf = receitas[~mask_transf].copy()
            
            transferencias_removidas_rec = len(receitas) - len(receitas_sem_transf)
            
            print("  🟢 Maiores Receitas:")
            if transferencias_removidas_rec > 0:
                print(f"      (excluindo {transferencias_removidas_rec} transferências entre contas)")
            
            colunas_desc = [col for col in df.columns if any(x in col.lower() for x in ['descri', 'memo', 'historic', 'nome'])]
            col_desc = colunas_desc[0] if colunas_desc else None
            
            if len(receitas_sem_transf) > 0:
                receitas_top = receitas_sem_transf.nlargest(10, col_valor)
                
                for idx, row in receitas_top.iterrows():
                    desc = row[col_desc] if col_desc and pd.notna(row[col_desc]) else 'Sem descrição'
                    desc = str(desc)[:50]
                    valor = row[col_valor]
                    print(f"    • R$ {valor:>10,.2f} - {desc}")
        
        print("\n")
    
    def _relatorio_nfse(self, df):
        """Gera relatório das notas fiscais"""
        print("🧾 NOTAS FISCAIS DE SERVIÇO\n")
        
        total_nfse = df['Valor'].sum()
        quantidade = len(df)
        
        print(f"  Total de Notas Emitidas: {quantidade}")
        print(f"  Valor Total:             R$ {total_nfse:,.2f}")
        print(f"  Ticket Médio:            R$ {total_nfse/quantidade:,.2f}")
        print()
        
        # Por cliente
        if 'Cliente' in df.columns:
            print("  Faturamento por Cliente:")
            por_cliente = df.groupby('Cliente')['Valor'].agg(['sum', 'count']).sort_values('sum', ascending=False)
            for cliente, row in por_cliente.head(10).iterrows():
                print(f"    • {cliente[:40]:40s}: R$ {row['sum']:>10,.2f} ({int(row['count'])} NF)")
        
        print("\n")
    
    def _relatorio_resumo(self, df_extratos, df_nfse):
        """Gera resumo executivo"""
        print("="*80)
        print("📊 RESUMO EXECUTIVO\n")
        
        # Calcula métricas principais
        if df_extratos is not None and len(df_extratos) > 0:
            colunas_valor = [col for col in df_extratos.columns if any(x in col.lower() for x in ['valor', 'amount'])]
            if colunas_valor:
                col_valor = colunas_valor[0]
                df_extratos[col_valor] = pd.to_numeric(df_extratos[col_valor], errors='coerce')
                
                receitas = df_extratos[df_extratos[col_valor] > 0][col_valor].sum()
                despesas = abs(df_extratos[df_extratos[col_valor] < 0][col_valor].sum())
                resultado = receitas - despesas
                
                print(f"  💵 Receitas Totais:     R$ {receitas:>12,.2f}")
                print(f"  💸 Despesas Totais:     R$ {despesas:>12,.2f}")
                print(f"  {'📈' if resultado >= 0 else '📉'} Resultado do Mês:   R$ {resultado:>12,.2f}")
                
                if resultado >= 0:
                    print(f"  ✅ LUCRO")
                else:
                    print(f"  ❌ PREJUÍZO")
        
        if df_nfse is not None and len(df_nfse) > 0:
            print(f"\n  📋 Notas Fiscais:       {len(df_nfse)} emitidas")
            print(f"  💰 Faturamento NF:      R$ {df_nfse['Valor'].sum():>12,.2f}")
        
        print("\n" + "="*80)
    
    def limpar(self):
        """Remove arquivos temporários"""
        if self.dir_temp and os.path.exists(self.dir_temp):
            shutil.rmtree(self.dir_temp)
            print(f"\n🧹 Arquivos temporários removidos")

def main():
    if len(sys.argv) < 2:
        print("Uso: python gerar_relatorio.py <arquivo_zip>")
        print("\nExemplo:")
        print("  python gerar_relatorio.py Arquivos_2025_11.zip")
        sys.exit(1)
    
    caminho_zip = sys.argv[1]
    
    if not os.path.exists(caminho_zip):
        print(f"❌ Erro: Arquivo não encontrado: {caminho_zip}")
        sys.exit(1)
    
    analisador = AnalisadorFinanceiro(caminho_zip)
    
    try:
        # Processa os dados
        analisador.extrair_zip()
        analisador.processar_extratos_xlsx()
        analisador.processar_extratos_ofx()
        analisador.processar_nfse_xml()
        
        # Gera relatório
        analisador.gerar_relatorio()
        
    except Exception as e:
        print(f"\n❌ Erro ao processar arquivo: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
    
    finally:
        # Limpa arquivos temporários
        analisador.limpar()

if __name__ == '__main__':
    main()
