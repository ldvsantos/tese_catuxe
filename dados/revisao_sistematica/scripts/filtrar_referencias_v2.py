#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script melhorado para filtrar referências bibliográficas por relevância temática
Tema: Saberes agroecológicos tradicionais e machine learning
Versão 2.0 - Critérios aprimorados e mais flexíveis
"""

import re
from typing import List, Dict, Tuple

def ler_arquivo_bib(caminho_arquivo: str) -> List[Dict[str, str]]:
    """
    Lê arquivo BibTeX e extrai as referências como dicionários
    """
    with open(caminho_arquivo, 'r', encoding='utf-8', errors='ignore') as arquivo:
        conteudo = arquivo.read()
    
    # Regex para extrair entradas BibTeX completas
    padrao_entrada = r'(@\w+\{[^@]*?)\n(?=@|\Z)'
    entradas_completas = re.findall(padrao_entrada, conteudo, re.DOTALL)
    
    referencias = []
    for entrada_completa in entradas_completas:
        # Extrair tipo e chave
        match_cabecalho = re.match(r'@(\w+)\{([^,]+),', entrada_completa)
        if not match_cabecalho:
            continue
            
        tipo, chave = match_cabecalho.groups()
        
        ref = {
            'tipo': tipo,
            'chave': chave,
            'entrada_completa': entrada_completa,
            'texto_completo': entrada_completa.lower()
        }
        
        # Extrair campos específicos
        for campo in ['title', 'abstract', 'keywords', 'journal', 'booktitle', 'author', 'year']:
            padrao_campo = rf'{campo}\s*=\s*\{{([^}}]*(?:\}}[^}}]*)*)\}}'
            match = re.search(padrao_campo, entrada_completa, re.IGNORECASE | re.DOTALL)
            if match:
                ref[campo] = match.group(1).strip()
        
        referencias.append(ref)
    
    return referencias

def calcular_relevancia(referencia: Dict[str, str]) -> Tuple[float, List[str]]:
    """
    Calcula score de relevância baseado em palavras-chave temáticas com critérios aprimorados
    """
    
    # Termos PRIORITÁRIOS (peso 5) - Essenciais para o tema
    termos_prioritarios = [
        'traditional knowledge', 'indigenous knowledge', 'traditional ecological knowledge',
        'ethnobotany', 'ethnobotanical', 'traditional practice', 'traditional agriculture',
        'agroecology', 'agroecological', 'traditional farming', 'traditional medicine',
        'traditional crop', 'traditional variety', 'landrace', 'heritage seed',
        'machine learning', 'artificial intelligence', 'natural language processing',
        'knowledge preservation', 'traditional community', 'indigenous community',
        'traditional system', 'ancestral knowledge', 'local knowledge',
        'folk knowledge', 'traditional cultivation', 'cultural heritage',
        'traditional wisdom', 'traditional technique', 'rural knowledge',
        'ethnomedicine', 'ethnopharmacology', 'traditional healing'
    ]
    
    # Termos ALTAMENTE relevantes (peso 3)
    termos_alta_relevancia = [
        'sustainable agriculture', 'organic farming', 'traditional management',
        'agricultural heritage', 'crop diversity', 'biodiversity conservation',
        'seed saving', 'participatory', 'community-based', 'smallholder',
        'family farming', 'rural development', 'food security', 'agrodiversity',
        'ecosystem services', 'climate adaptation', 'resilience',
        'cultural landscape', 'traditional territory', 'semiarid', 'dryland',
        'farmer knowledge', 'agricultural innovation', 'sustainable practice',
        'conservation agriculture', 'traditional use', 'medicinal plant',
        'native variety', 'local variety', 'water management', 'soil management',
        'crop management', 'pest management', 'natural resource management',
        'ethnography', 'anthropology', 'traditional resource', 'indigenous practice'
    ]
    
    # Termos MODERADAMENTE relevantes (peso 2)
    termos_media_relevancia = [
        'agriculture', 'farming', 'rural', 'farmer', 'agricultural',
        'sustainability', 'environmental', 'ecological', 'conservation',
        'plant', 'crop', 'cultivation', 'management', 'practice',
        'system', 'knowledge', 'community', 'cultural', 'social',
        'innovation', 'technology', 'heritage', 'diversity',
        'natural resource', 'ecosystem', 'landscape', 'territory',
        'agronomy', 'horticulture', 'forestry', 'agroforestry'
    ]
    
    # Termos de CONTEXTO (peso 1) - Podem ser relevantes dependendo do contexto
    termos_contexto = [
        'development', 'method', 'approach', 'strategy', 'technique',
        'model', 'analysis', 'study', 'research', 'survey',
        'assessment', 'evaluation', 'application', 'implementation',
        'documentation', 'preservation', 'collection', 'database'
    ]
    
    # Termos para EXCLUSÃO FORTE (peso -5) - Claramente irrelevantes
    termos_exclusao_forte = [
        'cancer', 'tumor', 'disease', 'pathology', 'clinical trial',
        'therapy', 'treatment', 'pharmaceutical', 'drug discovery',
        'molecular biology', 'genomics', 'proteomics',
        'biochemistry', 'cell culture', 'tissue culture', 'in vitro',
        'laboratory synthesis', 'synthetic biology', 'artificial synthesis', 
        'chemical synthesis', 'industrial process', 'manufacturing', 
        'urban planning', 'metropolitan', 'factory', 'nuclear',
        'nanotechnology', 'quantum', 'aerospace'
    ]
    
    # Termos para EXCLUSÃO MODERADA (peso -2)
    termos_exclusao_moderada = [
        'biotechnology', 'genetically modified', 'gmo', 'genetic engineering',
        'chemical fertilizer', 'synthetic pesticide', 'herbicide', 'insecticide',
        'medical device', 'clinical application', 'hospital', 'patient', 
        'diagnosis', 'industrial agriculture', 'monoculture'
    ]
    
    score = 0
    termos_encontrados = []
    
    # Combinar todos os campos de texto para análise
    texto_completo = ' '.join([
        referencia.get('title', ''),
        referencia.get('abstract', ''),
        referencia.get('keywords', ''),
        referencia.get('journal', ''),
        referencia.get('booktitle', ''),
        referencia.get('author', ''),
        referencia.get('texto_completo', '')
    ]).lower()
    
    # Verificar termos prioritários
    for termo in termos_prioritarios:
        if termo in texto_completo:
            score += 5
            termos_encontrados.append(f"Prioritário: {termo}")
    
    # Verificar termos de alta relevância
    for termo in termos_alta_relevancia:
        if termo in texto_completo:
            score += 3
            termos_encontrados.append(f"Alta: {termo}")
    
    # Verificar termos de média relevância
    for termo in termos_media_relevancia:
        if termo in texto_completo:
            score += 2
            termos_encontrados.append(f"Média: {termo}")
    
    # Verificar termos de contexto
    for termo in termos_contexto:
        if termo in texto_completo:
            score += 1
            termos_encontrados.append(f"Contexto: {termo}")
    
    # Penalizar termos de exclusão forte
    for termo in termos_exclusao_forte:
        if termo in texto_completo:
            score -= 5
            termos_encontrados.append(f"Exclusão Forte: {termo}")
    
    # Penalizar termos de exclusão moderada
    for termo in termos_exclusao_moderada:
        if termo in texto_completo:
            score -= 2
            termos_encontrados.append(f"Exclusão Moderada: {termo}")
    
    return score, termos_encontrados

def filtrar_referencias(referencias: List[Dict[str, str]], threshold: float = 5.0) -> Tuple[List[Dict], List[Dict]]:
    """
    Filtra referências baseado no score de relevância
    """
    relevantes = []
    irrelevantes = []
    
    for ref in referencias:
        score, termos = calcular_relevancia(ref)
        ref['score'] = score
        ref['termos_encontrados'] = termos
        
        if score >= threshold:
            relevantes.append(ref)
        else:
            irrelevantes.append(ref)
    
    # Ordenar por score decrescente
    relevantes.sort(key=lambda x: x['score'], reverse=True)
    irrelevantes.sort(key=lambda x: x['score'], reverse=True)
    
    return relevantes, irrelevantes

def gerar_relatorio(relevantes: List[Dict], irrelevantes: List[Dict], arquivo_original: str):
    """
    Gera relatório de filtragem
    """
    total = len(relevantes) + len(irrelevantes)
    
    with open('relatorio_filtragem_referencias_v2.txt', 'w', encoding='utf-8') as f:
        f.write("RELATÓRIO DE FILTRAGEM DE REFERÊNCIAS BIBLIOGRÁFICAS V2.0\n")
        f.write("=" * 65 + "\n\n")
        
        f.write("TEMA DA PESQUISA:\n")
        f.write("Saberes agroecológicos tradicionais e machine learning para preservação de conhecimentos\n\n")
        
        f.write("RESUMO DA FILTRAGEM:\n")
        f.write(f"• Total de referências analisadas: {total}\n")
        f.write(f"• Referências RELEVANTES: {len(relevantes)} ({len(relevantes)/total*100:.1f}%)\n")
        f.write(f"• Referências IRRELEVANTES: {len(irrelevantes)} ({len(irrelevantes)/total*100:.1f}%)\n")
        f.write(f"• Threshold utilizado: 5.0 pontos\n\n")
        
        if relevantes:
            f.write("REFERÊNCIAS RELEVANTES (TOP 50):\n")
            f.write("-" * 50 + "\n")
            for i, ref in enumerate(relevantes[:50], 1):
                f.write(f"{i:2d}. {ref['chave']} (Score: {ref['score']:.1f})\n")
                if 'title' in ref:
                    f.write(f"    Título: {ref['title'][:150]}...\n")
                if 'year' in ref:
                    f.write(f"    Ano: {ref['year']}\n")
                f.write(f"    Termos encontrados: {', '.join(ref['termos_encontrados'][:8])}\n\n")
        
        f.write("REFERÊNCIAS IRRELEVANTES (SCORE MAIS ALTO):\n")
        f.write("-" * 50 + "\n")
        for i, ref in enumerate(irrelevantes[:15], 1):
            f.write(f"{i:2d}. {ref['chave']} (Score: {ref['score']:.1f})\n")
            if 'title' in ref:
                f.write(f"    Título: {ref['title'][:100]}...\n")
            f.write(f"    Principais termos: {', '.join(ref['termos_encontrados'][:3])}\n\n")
        
        f.write("\nCRITÉRIOS DE PONTUAÇÃO:\n")
        f.write("• Termos Prioritários: +5 pontos\n")
        f.write("• Termos Alta Relevância: +3 pontos\n")
        f.write("• Termos Média Relevância: +2 pontos\n")
        f.write("• Termos de Contexto: +1 ponto\n")
        f.write("• Termos Exclusão Forte: -5 pontos\n")
        f.write("• Termos Exclusão Moderada: -2 pontos\n")

def salvar_referencias_filtradas(referencias: List[Dict], arquivo_saida: str):
    """
    Salva referências filtradas em arquivo BibTeX
    """
    with open(arquivo_saida, 'w', encoding='utf-8') as f:
        f.write("% Referências bibliográficas filtradas por relevância temática\n")
        f.write("% Tema: Saberes agroecológicos tradicionais e machine learning\n")
        f.write(f"% Total: {len(referencias)} referências relevantes\n")
        f.write("% Filtradas com score >= 5.0 pontos\n\n")
        
        for ref in referencias:
            f.write(f"% Score: {ref['score']:.1f} - {ref['chave']}\n")
            f.write(ref['entrada_completa'])
            f.write("\n\n")

def main():
    """
    Função principal
    """
    arquivo_entrada = 'referencias_encontradas_para_adicionar.bib'
    
    print("=== FILTRADOR DE REFERÊNCIAS V2.0 ===")
    print("Tema: Saberes agroecológicos tradicionais e machine learning\n")
    
    print("Lendo arquivo de referências...")
    referencias = ler_arquivo_bib(arquivo_entrada)
    print(f"Total de referências encontradas: {len(referencias)}")
    
    print("Calculando relevância temática com critérios aprimorados...")
    relevantes, irrelevantes = filtrar_referencias(referencias, threshold=5.0)
    
    print(f"\nResultados:")
    print(f"• Referências RELEVANTES: {len(relevantes)} ({len(relevantes)/len(referencias)*100:.1f}%)")
    print(f"• Referências IRRELEVANTES: {len(irrelevantes)} ({len(irrelevantes)/len(referencias)*100:.1f}%)")
    
    if relevantes:
        print(f"\nTOP 10 referências mais relevantes:")
        for i, ref in enumerate(relevantes[:10], 1):
            titulo = ref.get('title', 'Sem título')[:80] + "..." if len(ref.get('title', '')) > 80 else ref.get('title', 'Sem título')
            print(f"{i:2d}. {ref['chave']} (Score: {ref['score']:.1f}) - {titulo}")
    
    print("\nGerando relatório...")
    gerar_relatorio(relevantes, irrelevantes, arquivo_entrada)
    
    if relevantes:
        print("Salvando referências filtradas...")
        salvar_referencias_filtradas(relevantes, 'referencias_filtradas_tema_agroecologia_v2.bib')
        print(f"Arquivo salvo: referencias_filtradas_tema_agroecologia_v2.bib")
    
    print("\nProcesso concluído!")
    print(f"Relatório salvo em: relatorio_filtragem_referencias_v2.txt")

if __name__ == "__main__":
    main()