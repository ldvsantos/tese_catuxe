#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script para verificar se as citações da metodologia já estão no references.bib principal
"""

import re
from typing import List, Set, Dict

def extrair_citacoes_metodologia() -> Set[str]:
    """
    Extrai todas as citações dos arquivos de metodologia
    """
    citacoes = set()
    arquivos_metodologia = [
        'Conteudo/Metodos.tex',
        'Conteudo/metodologia_rs.tex'
    ]
    
    print("📖 Extraindo citações dos arquivos de metodologia...")
    for arquivo_path in arquivos_metodologia:
        try:
            with open(arquivo_path, 'r', encoding='utf-8') as arquivo:
                conteudo = arquivo.read()
            
            # Regex para extrair citações \cite{...} e \citeonline{...}
            padrao_cite = r'\\cite(?:online)?\{([^}]+)\}'
            matches = re.findall(padrao_cite, conteudo)
            
            citacoes_arquivo = set()
            for match in matches:
                # Separar múltiplas citações (ex: \cite{ref1,ref2,ref3})
                refs = [ref.strip() for ref in match.split(',')]
                citacoes_arquivo.update(refs)
            
            citacoes.update(citacoes_arquivo)
            print(f"   ✅ {arquivo_path}: {len(citacoes_arquivo)} citações encontradas")
        
        except FileNotFoundError:
            print(f"   ❌ {arquivo_path} não encontrado!")
            continue
    
    return citacoes

def extrair_chaves_references_principal() -> Set[str]:
    """
    Extrai chaves do arquivo references.bib principal
    """
    try:
        with open('references.bib', 'r', encoding='utf-8') as arquivo:
            conteudo = arquivo.read()
        
        # Regex para extrair chaves das entradas BibTeX
        padrao_chave = r'@\w+\{([^,]+),'
        chaves = re.findall(padrao_chave, conteudo)
        
        return set(chaves)
    
    except FileNotFoundError:
        print("❌ Arquivo references.bib não encontrado!")
        return set()

def extrair_chaves_arquivos_backup() -> Dict[str, Set[str]]:
    """
    Extrai chaves dos arquivos de backup
    """
    arquivos_backup = {
        'references_backup.bib': set(),
        'library_diego.bib': set(),
        'referencias_encontradas_para_adicionar.bib': set()
    }
    
    print("\n📚 Verificando arquivos de backup...")
    
    for arquivo in arquivos_backup.keys():
        try:
            with open(arquivo, 'r', encoding='utf-8') as f:
                conteudo = f.read()
            
            # Regex para extrair chaves das entradas BibTeX
            padrao_chave = r'@\w+\{([^,]+),'
            chaves = re.findall(padrao_chave, conteudo)
            arquivos_backup[arquivo] = set(chaves)
            
            print(f"   ✅ {arquivo}: {len(chaves)} referências")
        
        except FileNotFoundError:
            print(f"   ❌ {arquivo} não encontrado!")
            continue
    
    return arquivos_backup

def extrair_entrada_completa(chave: str, arquivo: str) -> str:
    """
    Extrai a entrada BibTeX completa para uma chave específica
    """
    try:
        with open(arquivo, 'r', encoding='utf-8') as f:
            conteudo = f.read()
        
        # Padrão para encontrar a entrada completa
        padrao = rf'(@\w+\{{{re.escape(chave)},.*?)\n(?=@|\Z)'
        match = re.search(padrao, conteudo, re.DOTALL)
        
        if match:
            return match.group(1)
        return ""
    
    except FileNotFoundError:
        return ""

def main():
    """
    Função principal
    """
    print("🔍 VERIFICAÇÃO COMPLETA DE CITAÇÕES DA METODOLOGIA")
    print("=" * 60)
    
    # 1. Extrair citações da metodologia
    citacoes_metodologia = extrair_citacoes_metodologia()
    print(f"\n📊 Total de citações na metodologia: {len(citacoes_metodologia)}")
    
    # 2. Verificar no references.bib principal
    print("\n🎯 Verificando no references.bib principal...")
    chaves_principal = extrair_chaves_references_principal()
    citacoes_ja_presentes = citacoes_metodologia.intersection(chaves_principal)
    citacoes_faltantes = citacoes_metodologia - chaves_principal
    
    print(f"   ✅ Já estão no references.bib: {len(citacoes_ja_presentes)}")
    print(f"   ❌ Faltam no references.bib: {len(citacoes_faltantes)}")
    
    # 3. Buscar as faltantes nos arquivos de backup
    if citacoes_faltantes:
        print(f"\n🔎 Buscando {len(citacoes_faltantes)} citações faltantes nos backups...")
        arquivos_backup = extrair_chaves_arquivos_backup()
        
        encontradas_backup = {}
        ainda_faltantes = set(citacoes_faltantes)
        
        for arquivo, chaves in arquivos_backup.items():
            encontradas_neste_arquivo = citacoes_faltantes.intersection(chaves)
            if encontradas_neste_arquivo:
                encontradas_backup[arquivo] = encontradas_neste_arquivo
                ainda_faltantes -= encontradas_neste_arquivo
                print(f"   ✅ {arquivo}: {len(encontradas_neste_arquivo)} encontradas")
        
        # 4. Criar arquivo com referências encontradas nos backups
        if encontradas_backup:
            print(f"\n📝 Criando arquivo com referências encontradas nos backups...")
            
            with open('referencias_metodologia_encontradas.bib', 'w', encoding='utf-8') as arquivo_saida:
                arquivo_saida.write("% Referências da metodologia encontradas nos arquivos de backup\n")
                arquivo_saida.write(f"% Para adicionar ao references.bib principal\n\n")
                
                total_adicionadas = 0
                
                for arquivo_origem, chaves_encontradas in encontradas_backup.items():
                    arquivo_saida.write(f"% === ENCONTRADAS EM: {arquivo_origem} ===\n\n")
                    
                    for chave in sorted(chaves_encontradas):
                        entrada = extrair_entrada_completa(chave, arquivo_origem)
                        if entrada:
                            arquivo_saida.write(f"% Citação: {chave}\n")
                            arquivo_saida.write(entrada)
                            arquivo_saida.write("\n\n")
                            total_adicionadas += 1
                
                print(f"   ✅ Arquivo 'referencias_metodologia_encontradas.bib' criado com {total_adicionadas} referências")
    
    # 5. Relatório final
    print(f"\n📋 RELATÓRIO FINAL")
    print("=" * 40)
    print(f"📖 Total de citações na metodologia: {len(citacoes_metodologia)}")
    print(f"✅ Já estão no references.bib: {len(citacoes_ja_presentes)}")
    if citacoes_faltantes:
        total_encontradas_backup = sum(len(chaves) for chaves in encontradas_backup.values())
        print(f"🔍 Encontradas nos backups: {total_encontradas_backup}")
        print(f"❌ Ainda faltantes: {len(ainda_faltantes)}")
    
    # Salvar relatório detalhado
    with open('relatorio_metodologia_completo.txt', 'w', encoding='utf-8') as arquivo:
        arquivo.write("RELATÓRIO COMPLETO - CITAÇÕES DA METODOLOGIA\n")
        arquivo.write("=" * 50 + "\n\n")
        
        arquivo.write("RESUMO GERAL:\n")
        arquivo.write(f"• Total de citações na metodologia: {len(citacoes_metodologia)}\n")
        arquivo.write(f"• Já estão no references.bib: {len(citacoes_ja_presentes)}\n")
        
        if citacoes_ja_presentes:
            arquivo.write(f"\nCITAÇÕES JÁ PRESENTES NO REFERENCES.BIB ({len(citacoes_ja_presentes)}):\n")
            for citacao in sorted(citacoes_ja_presentes):
                arquivo.write(f"✅ {citacao}\n")
        
        if citacoes_faltantes:
            total_encontradas_backup = sum(len(chaves) for chaves in encontradas_backup.values())
            arquivo.write(f"• Encontradas nos backups: {total_encontradas_backup}\n")
            arquivo.write(f"• Ainda faltantes: {len(ainda_faltantes)}\n")
            
            if encontradas_backup:
                arquivo.write(f"\nCITAÇÕES ENCONTRADAS NOS BACKUPS:\n")
                for arquivo_origem, chaves_encontradas in encontradas_backup.items():
                    arquivo.write(f"\n{arquivo_origem} ({len(chaves_encontradas)}):\n")
                    for chave in sorted(chaves_encontradas):
                        arquivo.write(f"✅ {chave}\n")
            
            if ainda_faltantes:
                arquivo.write(f"\nCITAÇÕES AINDA FALTANTES ({len(ainda_faltantes)}):\n")
                for citacao in sorted(ainda_faltantes):
                    arquivo.write(f"❌ {citacao}\n")
        
        arquivo.write(f"\nACÕES RECOMENDADAS:\n")
        if encontradas_backup:
            total_para_adicionar = sum(len(chaves) for chaves in encontradas_backup.values())
            arquivo.write(f"1. Adicionar as {total_para_adicionar} referências do arquivo 'referencias_metodologia_encontradas.bib' ao references.bib\n")
        if ainda_faltantes:
            arquivo.write(f"2. Buscar as {len(ainda_faltantes)} referências ainda faltantes em outras fontes\n")
    
    print(f"\n📊 Relatório detalhado salvo: relatorio_metodologia_completo.txt")
    
    if encontradas_backup:
        total_para_adicionar = sum(len(chaves) for chaves in encontradas_backup.values())
        print(f"\n🎯 PRÓXIMO PASSO: Adicionar {total_para_adicionar} referências encontradas ao references.bib")

if __name__ == "__main__":
    main()