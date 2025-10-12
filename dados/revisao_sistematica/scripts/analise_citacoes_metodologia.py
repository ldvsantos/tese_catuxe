#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script para analisar citações presentes no arquivo de metodologia e verificar
correspondência com referências no arquivo bib principal e backup.
"""

import re
from pathlib import Path

def extrair_citacoes_do_texto(arquivo_tex):
    """Extrai citações do arquivo LaTeX - formato (Autor, Ano) e \cite{}"""
    with open(arquivo_tex, 'r', encoding='utf-8') as f:
        conteudo = f.read()
    
    citacoes_processadas = []
    
    # Padrão 1: Citações em formato (Autor, Ano) ou (Autor et al., Ano)
    padrao_citacoes_parenteses = r'\(([^)]*(?:19|20)\d{2}[^)]*)\)'
    citacoes_parenteses = re.findall(padrao_citacoes_parenteses, conteudo)
    
    for citacao in citacoes_parenteses:
        # Dividir por ; para citações múltiplas
        partes = citacao.split(';')
        for parte in partes:
            parte = parte.strip()
            # Extrair autor e ano
            match_autor_ano = re.search(r'([^,]+?)(?:,?\s*)(\d{4})', parte)
            if match_autor_ano:
                autor = match_autor_ano.group(1).strip()
                ano = match_autor_ano.group(2)
                
                # Limpar nome do autor
                autor = re.sub(r'\bet al\.?', '', autor)
                autor = autor.strip()
                
                citacoes_processadas.append({
                    'texto_original': parte,
                    'autor': autor,
                    'ano': ano,
                    'chave_possivel': f"{autor.replace(' ', '').replace('-', '')}{ano}",
                    'tipo': 'parenteses',
                    'linha_encontrada': f"({parte})"
                })
    
    # Padrão 2: Comandos \cite{} e variações
    padrao_cite = r'\\(?:cite|citeonline|citeyear)\{([^}]+)\}'
    cites = re.findall(padrao_cite, conteudo)
    
    for cite_content in cites:
        # Dividir por vírgula para citações múltiplas
        chaves = [chave.strip() for chave in cite_content.split(',')]
        for chave in chaves:
            if chave:
                citacoes_processadas.append({
                    'texto_original': chave,
                    'autor': '',
                    'ano': '',
                    'chave_possivel': chave,
                    'tipo': 'cite_command',
                    'linha_encontrada': f"\\cite{{{chave}}}"
                })
    
    return citacoes_processadas

def extrair_chaves_bib(arquivo_bib):
    """Extrai chaves de referência do arquivo .bib"""
    try:
        with open(arquivo_bib, 'r', encoding='utf-8') as f:
            conteudo = f.read()
        
        # Padrão para capturar chaves das entradas bib
        padrao_chaves = r'@[a-zA-Z]+\{([^,]+),'
        chaves = re.findall(padrao_chaves, conteudo)
        
        return chaves
    except FileNotFoundError:
        return []

def encontrar_correspondencias(citacoes, chaves_bib):
    """Encontra correspondências entre citações e chaves bib"""
    correspondencias = []
    nao_encontradas = []
    
    for citacao in citacoes:
        encontrou = False
        
        # Para comandos \cite{}, busca direta
        if citacao['tipo'] == 'cite_command':
            chave_procurada = citacao['chave_possivel']
            if chave_procurada in chaves_bib:
                correspondencias.append({
                    'citacao': citacao,
                    'chave_bib': chave_procurada,
                    'tipo_match': 'cite_direto'
                })
                encontrou = True
        
        # Para citações em parênteses, tentar várias estratégias
        else:
            # Tentar correspondência direta
            for chave in chaves_bib:
                if citacao['chave_possivel'].lower() in chave.lower():
                    correspondencias.append({
                        'citacao': citacao,
                        'chave_bib': chave,
                        'tipo_match': 'direto'
                    })
                    encontrou = True
                    break
            
            # Tentar correspondência por autor e ano separadamente
            if not encontrou and citacao['autor'] and citacao['ano']:
                for chave in chaves_bib:
                    autor_match = citacao['autor'].replace(' ', '').replace('-', '').lower()
                    if (autor_match in chave.lower() and 
                        citacao['ano'] in chave):
                        correspondencias.append({
                            'citacao': citacao,
                            'chave_bib': chave,
                            'tipo_match': 'autor_ano'
                        })
                        encontrou = True
                        break
        
        if not encontrou:
            nao_encontradas.append(citacao)
    
    return correspondencias, nao_encontradas

def main():
    # Caminhos dos arquivos
    arquivo_tex = Path(r"c:\Users\vidal\OneDrive\Documentos\1 - ACADEMICO\1- UFS\2 - POS\3- DOUTORADO\TESE_ATUAL\Conteudo\metodos.tex")
    arquivo_bib_principal = Path(r"c:\Users\vidal\OneDrive\Documentos\1 - ACADEMICO\1- UFS\2 - POS\3- DOUTORADO\TESE_ATUAL\references.bib")
    arquivo_bib_backup = Path(r"c:\Users\vidal\OneDrive\Documentos\1 - ACADEMICO\1- UFS\2 - POS\3- DOUTORADO\TESE_ATUAL\backup_arquivos_removidos\references_backup.bib")
    
    print("=== ANÁLISE DE CITAÇÕES - ARQUIVO METODOLOGIA ===\n")
    
    # Extrair citações do texto
    print("1. Extraindo citações do arquivo metodos.tex...")
    citacoes = extrair_citacoes_do_texto(arquivo_tex)
    print(f"   Encontradas {len(citacoes)} citações\n")
    
    # Extrair chaves do arquivo bib principal
    print("2. Extraindo chaves do arquivo references.bib principal...")
    chaves_bib_principal = extrair_chaves_bib(arquivo_bib_principal)
    print(f"   Encontradas {len(chaves_bib_principal)} referências\n")
    
    # Extrair chaves do arquivo bib backup
    print("3. Extraindo chaves do arquivo backup...")
    chaves_bib_backup = extrair_chaves_bib(arquivo_bib_backup)
    print(f"   Encontradas {len(chaves_bib_backup)} referências no backup\n")
    
    # Encontrar correspondências no arquivo principal
    print("4. Buscando correspondências no arquivo principal...")
    correspondencias_principal, nao_encontradas_principal = encontrar_correspondencias(citacoes, chaves_bib_principal)
    
    # Encontrar correspondências no backup para as não encontradas
    print("5. Buscando correspondências no backup para citações não encontradas...")
    correspondencias_backup, nao_encontradas_final = encontrar_correspondencias(nao_encontradas_principal, chaves_bib_backup)
    
    print(f"\n=== RESULTADOS ===")
    print(f"Total de citações analisadas: {len(citacoes)}")
    print(f"Encontradas no arquivo principal: {len(correspondencias_principal)}")
    print(f"Encontradas no arquivo backup: {len(correspondencias_backup)}")
    print(f"Não encontradas em nenhum lugar: {len(nao_encontradas_final)}")
    
    print(f"\n=== CITAÇÕES ENCONTRADAS NO ARQUIVO PRINCIPAL ===")
    for i, corr in enumerate(correspondencias_principal, 1):
        print(f"{i}. {corr['citacao']['linha_encontrada']}")
        print(f"   → Chave BibTeX: {corr['chave_bib']}")
        print(f"   → Tipo: {corr['tipo_match']}")
        print()
    
    print(f"\n=== CITAÇÕES ENCONTRADAS NO BACKUP (PRECISAM SER TRANSFERIDAS) ===")
    chaves_para_transferir = []
    for i, corr in enumerate(correspondencias_backup, 1):
        print(f"{i}. {corr['citacao']['linha_encontrada']}")
        print(f"   → Chave BibTeX: {corr['chave_bib']}")
        print(f"   → Tipo: {corr['tipo_match']}")
        chaves_para_transferir.append(corr['chave_bib'])
        print()
    
    print(f"\n=== CITAÇÕES NÃO ENCONTRADAS ===")
    for i, citacao in enumerate(nao_encontradas_final, 1):
        print(f"{i}. {citacao['linha_encontrada']}")
        if citacao['autor']:
            print(f"   Autor: {citacao['autor']}")
            print(f"   Ano: {citacao['ano']}")
        print()
    
    if chaves_para_transferir:
        print(f"\n=== CHAVES QUE PRECISAM SER TRANSFERIDAS DO BACKUP ===")
        for i, chave in enumerate(set(chaves_para_transferir), 1):
            print(f"{i}. {chave}")
        
        # Gerar script para extrair referências do backup
        print(f"\n=== SCRIPT PARA EXTRAIR REFERÊNCIAS DO BACKUP ===")
        print("Execute o seguinte comando para extrair as referências:")
        print("python extrair_referencias_backup.py")

if __name__ == "__main__":
    main()