#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script para verificar citações dos arquivos de metodologia (Met_psicometrica.tex, Met_rs.tex e Met_machine_learning.tex) no arquivo de referências filtradas
"""

import re
from typing import List, Set, Dict

def extrair_citacoes_metodos() -> Set[str]:
    """
    Extrai todas as citações dos arquivos de metodologia
    """
    citacoes = set()
    arquivos_metodologia = [
        'CONTEUDOS/METODOLOGIA/Met_psicometrica.tex',
        'CONTEUDOS/METODOLOGIA/Met_rs.tex',
        'CONTEUDOS/METODOLOGIA/Met_machine_learning.tex'
    ]
    
    for arquivo_path in arquivos_metodologia:
        try:
            with open(arquivo_path, 'r', encoding='utf-8') as arquivo:
                conteudo = arquivo.read()
            
            # Regex para extrair citações \cite{...} e \citeonline{...}
            padrao_cite = r'\\cite(?:online)?\{([^}]+)\}'
            matches = re.findall(padrao_cite, conteudo)
            
            for match in matches:
                # Separar múltiplas citações (ex: \cite{ref1,ref2,ref3})
                refs = [ref.strip() for ref in match.split(',')]
                citacoes.update(refs)
            
            print(f"   Arquivo {arquivo_path}: {len(matches)} citações encontradas")
        
        except FileNotFoundError:
            print(f"   Arquivo {arquivo_path} não encontrado!")
            continue
    
    return citacoes

def extrair_chaves_referencias_filtradas() -> Set[str]:
    """
    Extrai chaves das referências filtradas como relevantes
    """
    try:
        with open('referencias_filtradas_tema_agroecologia_v2.bib', 'r', encoding='utf-8') as arquivo:
            conteudo = arquivo.read()
        
        # Regex para extrair chaves das entradas BibTeX
        padrao_chave = r'@\w+\{([^,]+),'
        chaves = re.findall(padrao_chave, conteudo)
        
        return set(chaves)
    
    except FileNotFoundError:
        print("Arquivo de referências filtradas não encontrado!")
        return set()

def extrair_referencias_completas(chaves_encontradas: Set[str]) -> Dict[str, str]:
    """
    Extrai as referências completas para as chaves encontradas
    """
    try:
        with open('referencias_encontradas_para_adicionar.bib', 'r', encoding='utf-8') as arquivo:
            conteudo = arquivo.read()
        
        referencias_completas = {}
        
        # Regex para extrair entradas BibTeX completas
        padrao_entrada = r'(@\w+\{[^@]*?)\n(?=@|\Z)'
        entradas = re.findall(padrao_entrada, conteudo, re.DOTALL)
        
        for entrada in entradas:
            # Extrair chave da entrada
            match_chave = re.match(r'@\w+\{([^,]+),', entrada)
            if match_chave:
                chave = match_chave.group(1)
                if chave in chaves_encontradas:
                    referencias_completas[chave] = entrada
        
        return referencias_completas
    
    except FileNotFoundError:
        print("Arquivo de referências original não encontrado!")
        return {}

def main():
    """
    Função principal
    """
    print("=== VERIFICAÇÃO DE CITAÇÕES DA METODOLOGIA ===\n")
    
    print("1. Extraindo citações dos arquivos de metodologia...")
    citacoes_metodos = extrair_citacoes_metodos()
    print(f"   Encontradas {len(citacoes_metodos)} citações únicas")
    
    print("2. Extraindo chaves das referências filtradas...")
    chaves_filtradas = extrair_chaves_referencias_filtradas()
    print(f"   Encontradas {len(chaves_filtradas)} referências filtradas")
    
    print("3. Verificando correspondências...")
    citacoes_encontradas = citacoes_metodos.intersection(chaves_filtradas)
    citacoes_nao_encontradas = citacoes_metodos - chaves_filtradas
    
    print(f"\n=== RESULTADOS ===")
    print(f"• Citações na metodologia: {len(citacoes_metodos)}")
    print(f"• Citações ENCONTRADAS nas referências filtradas: {len(citacoes_encontradas)}")
    print(f"• Citações NÃO ENCONTRADAS: {len(citacoes_nao_encontradas)}")
    
    if citacoes_encontradas:
        print(f"\n✅ CITAÇÕES ENCONTRADAS ({len(citacoes_encontradas)}):")
        for i, citacao in enumerate(sorted(citacoes_encontradas), 1):
            print(f"{i:2d}. {citacao}")
    
    if citacoes_nao_encontradas:
        print(f"\n❌ CITAÇÕES NÃO ENCONTRADAS ({len(citacoes_nao_encontradas)}):")
        for i, citacao in enumerate(sorted(citacoes_nao_encontradas), 1):
            print(f"{i:2d}. {citacao}")
    
    # Extrair referências completas para as encontradas
    if citacoes_encontradas:
        print("\n4. Extraindo referências completas para adicionar ao references.bib...")
        referencias_completas = extrair_referencias_completas(citacoes_encontradas)
        
        if referencias_completas:
            # Salvar em arquivo
            with open('referencias_metodos_para_adicionar.bib', 'w', encoding='utf-8') as arquivo:
                arquivo.write("% Referências citadas nos arquivos de metodologia encontradas nas referências filtradas\n")
                arquivo.write(f"% Total: {len(referencias_completas)} referências\n")
                arquivo.write("% Para adicionar ao arquivo references.bib principal\n\n")
                
                for chave, entrada in referencias_completas.items():
                    arquivo.write(f"% Citação: {chave}\n")
                    arquivo.write(entrada)
                    arquivo.write("\n\n")
            
            print(f"   ✅ Arquivo 'referencias_metodos_para_adicionar.bib' criado com {len(referencias_completas)} referências")
        else:
            print("   ❌ Nenhuma referência completa encontrada")
    
    # Relatório final
    with open('relatorio_citacoes_metodos.txt', 'w', encoding='utf-8') as arquivo:
        arquivo.write("RELATÓRIO DE VERIFICAÇÃO DE CITAÇÕES - METODOLOGIA\n")
        arquivo.write("=" * 55 + "\n\n")
        
        arquivo.write("RESUMO:\n")
        arquivo.write(f"• Total de citações na metodologia: {len(citacoes_metodos)}\n")
        arquivo.write(f"• Citações encontradas nas referências filtradas: {len(citacoes_encontradas)}\n")
        arquivo.write(f"• Taxa de correspondência: {len(citacoes_encontradas)/len(citacoes_metodos)*100:.1f}%\n\n")
        
        if citacoes_encontradas:
            arquivo.write("CITAÇÕES ENCONTRADAS:\n")
            for citacao in sorted(citacoes_encontradas):
                arquivo.write(f"- {citacao}\n")
        
        if citacoes_nao_encontradas:
            arquivo.write(f"\nCITAÇÕES NÃO ENCONTRADAS:\n")
            for citacao in sorted(citacoes_nao_encontradas):
                arquivo.write(f"- {citacao}\n")
        
        arquivo.write(f"\nACÕES RECOMENDADAS:\n")
        arquivo.write(f"1. Adicionar as {len(citacoes_encontradas)} referências encontradas ao references.bib\n")
        arquivo.write(f"2. Buscar as {len(citacoes_nao_encontradas)} referências não encontradas em outras fontes\n")
        arquivo.write(f"3. Verificar se as citações não encontradas são realmente necessárias\n")
    
    print(f"\n📊 Relatório salvo em: relatorio_citacoes_metodos.txt")
    print("\n🎯 PRÓXIMOS PASSOS:")
    print(f"1. Adicionar as {len(citacoes_encontradas)} referências do arquivo 'referencias_metodos_para_adicionar.bib' ao references.bib")
    print(f"2. Buscar as {len(citacoes_nao_encontradas)} referências não encontradas em outras fontes")

if __name__ == "__main__":
    main()