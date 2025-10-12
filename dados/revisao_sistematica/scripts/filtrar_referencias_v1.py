#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script para filtrar referências bibliográficas por relevância temática
Tema da pesquisa: Modelo empírico para salvaguarda de saberes e fazeres agroecológicos tradicionais por meio de machine learning

Critérios de inclusão:
- Saberes e conhecimentos tradicionais
- Agroecologia e agricultura sustentável
- Povos e comunidades tradicionais
- Machine learning e inteligência artificial aplicada
- Processamento de linguagem natural (PLN/NLP)
- Patrimônio cultural e imaterial
- Agricultura familiar e tradicional
- Territórios tradicionais e semiárido
- Preservação de conhecimentos
- Sistemas agroflorestais tradicionais
- Etnobotânica e etnobiologia
- Biodiversidade e conservação relacionada a práticas tradicionais
"""

import re
import os
from typing import List, Dict, Tuple

# Palavras-chave para INCLUIR referências (relacionadas ao tema)
PALAVRAS_INCLUSAO = [
    # Saberes tradicionais
    'traditional knowledge', 'conhecimento tradicional', 'saberes tradicionais', 'indigenous knowledge',
    'local knowledge', 'vernacular knowledge', 'folk knowledge', 'traditional practices',
    'traditional farming', 'traditional agriculture', 'agricultura tradicional',
    
    # Agroecologia
    'agroecology', 'agroecologia', 'agroecological', 'agroecológic', 'sustainable agriculture',
    'agricultura sustentável', 'agricultura familiar', 'family farming', 'smallholder',
    'permaculture', 'permacultura', 'organic farming', 'agricultura orgânica',
    
    # Povos e comunidades tradicionais
    'indigenous', 'indígena', 'quilombola', 'ribeirinha', 'traditional communities',
    'comunidades tradicionais', 'povos tradicionais', 'aboriginal', 'native people',
    'traditional peoples', 'rural communities', 'comunidades rurais',
    
    # Machine Learning e IA
    'machine learning', 'artificial intelligence', 'inteligência artificial', 'deep learning',
    'neural network', 'data mining', 'pattern recognition', 'classification algorithm',
    'clustering', 'natural language processing', 'nlp', 'processamento linguagem natural',
    'text mining', 'mineração texto', 'sentiment analysis',
    
    # Patrimônio cultural
    'cultural heritage', 'patrimônio cultural', 'intangible heritage', 'patrimônio imaterial',
    'cultural preservation', 'preservação cultural', 'cultural diversity', 'diversidade cultural',
    'biocultural', 'etnoconhecimento', 'ethnobotany', 'etnobotânica', 'ethnobiology',
    
    # Territórios e semiárido
    'semiarid', 'semiárido', 'caatinga', 'northeast brazil', 'nordeste brasil',
    'territorial identity', 'identidade territorial', 'territory', 'território',
    'landscape', 'paisagem', 'land use', 'uso solo',
    
    # Sistemas agroflorestais
    'agroforestry', 'agroflorestal', 'silviculture', 'silvicultura', 'forest management',
    'manejo florestal', 'agroforest', 'home garden', 'quintal produtivo',
    
    # Conservação e biodiversidade relacionada
    'biodiversity conservation', 'conservação biodiversidade', 'genetic resources',
    'recursos genéticos', 'crop diversity', 'diversidade cultivar', 'seed conservation',
    'conservação sementes', 'variety', 'variedade', 'cultivar',
    
    # Metodologias participativas
    'participatory', 'participativa', 'community-based', 'baseado comunidade',
    'collaborative', 'colaborativ', 'stakeholder', 'bottom-up', 'empowerment',
    'empoderamento', 'social innovation', 'inovação social'
]

# Palavras-chave para EXCLUIR referências (não relacionadas ao tema)
PALAVRAS_EXCLUSAO = [
    # Engenharia não relacionada
    'concrete', 'concreto', 'steel', 'aço', 'construction', 'construção civil',
    'building', 'edificação', 'structural', 'estrutural', 'bridge', 'ponte',
    'highway', 'rodovia', 'pavement', 'pavimento',
    
    # Energia não renovável
    'nuclear power', 'energia nuclear', 'fossil fuel', 'combustível fóssil',
    'coal', 'carvão', 'petroleum', 'petróleo', 'oil refinery', 'refinaria',
    'power plant', 'usina energia', 'thermal power', 'energia térmica',
    
    # Medicina/saúde não relacionada
    'cancer', 'tumor', 'chemotherapy', 'quimioterapia', 'surgery', 'cirurgia',
    'pharmaceutical', 'farmacêutic', 'drug discovery', 'descoberta drogas',
    'clinical trial', 'ensaio clínico', 'medical', 'médico', 'hospital',
    
    # Tecnologia industrial não relacionada
    'manufacturing', 'manufatura', 'industrial process', 'processo industrial',
    'automation', 'automação', 'robotics', 'robótica', 'sensor network',
    'rede sensores', 'internet things', 'iot', 'blockchain',
    
    # Hidrologia puramente técnica
    'water treatment', 'tratamento água', 'wastewater', 'água residual',
    'sewage', 'esgoto', 'water quality', 'qualidade água', 'hydraulic',
    'hidráulico', 'dam', 'barragem', 'reservoir', 'reservatório',
    
    # Química não relacionada
    'chemical synthesis', 'síntese química', 'catalyst', 'catalisador',
    'polymer', 'polímero', 'nanoparticle', 'nanopartícula', 'crystallization',
    'cristalização', 'spectroscopy', 'espectroscopia',
    
    # Áreas muito específicas não relacionadas
    'quantum', 'quântico', 'cosmology', 'cosmologia', 'astronomy', 'astronomia',
    'particle physics', 'física partículas', 'nuclear physics', 'física nuclear',
    'telecommunications', 'telecomunicações', 'electronics', 'eletrônica'
]

def extrair_referencias_do_bib(arquivo_bib: str) -> List[Dict]:
    """Extrai todas as referências do arquivo .bib"""
    referencias = []
    
    with open(arquivo_bib, 'r', encoding='utf-8', errors='ignore') as f:
        conteudo = f.read()
    
    # Padrão para encontrar entradas bibliográficas
    padrao = r'@(\w+)\s*\{\s*([^,]+)\s*,([^@]*?)(?=\n@|\n\s*$|$)'
    matches = re.finditer(padrao, conteudo, re.DOTALL | re.MULTILINE)
    
    for match in matches:
        tipo = match.group(1).lower()
        chave = match.group(2).strip()
        campos = match.group(3)
        
        # Extrair título, abstract, keywords, etc.
        ref_completa = match.group(0)
        
        referencias.append({
            'tipo': tipo,
            'chave': chave,
            'campos': campos,
            'texto_completo': ref_completa.lower(),  # Para busca case-insensitive
            'ref_original': match.group(0)
        })
    
    return referencias

def avaliar_relevancia(referencia: Dict) -> Tuple[bool, float, List[str]]:
    """
    Avalia se uma referência é relevante ao tema da pesquisa
    
    Returns:
        (é_relevante, score_relevancia, palavras_encontradas)
    """
    texto = referencia['texto_completo']
    
    # Buscar palavras de exclusão primeiro
    palavras_exclusao_encontradas = []
    for palavra in PALAVRAS_EXCLUSAO:
        if palavra.lower() in texto:
            palavras_exclusao_encontradas.append(palavra)
    
    # Se encontrou muitas palavras de exclusão, provavelmente não é relevante
    if len(palavras_exclusao_encontradas) >= 2:
        return False, 0.0, palavras_exclusao_encontradas
    
    # Buscar palavras de inclusão
    palavras_inclusao_encontradas = []
    score = 0.0
    
    for palavra in PALAVRAS_INCLUSAO:
        if palavra.lower() in texto:
            palavras_inclusao_encontradas.append(palavra)
            # Dar pesos diferentes para diferentes tipos de palavras
            if any(termo in palavra.lower() for termo in ['traditional', 'tradicional', 'indigenous', 'indígena']):
                score += 3.0  # Peso alto para conhecimento tradicional
            elif any(termo in palavra.lower() for termo in ['agroecolog', 'machine learning', 'nlp']):
                score += 2.5  # Peso alto para agroecologia e ML
            elif any(termo in palavra.lower() for termo in ['cultural', 'patrimônio', 'heritage']):
                score += 2.0  # Peso médio-alto para patrimônio cultural
            else:
                score += 1.0  # Peso padrão
    
    # Considerar relevante se:
    # 1. Score >= 2.0 (pelo menos 2 palavras relevantes ou 1 palavra de alto peso)
    # 2. Não tem muitas palavras de exclusão
    eh_relevante = score >= 2.0 and len(palavras_exclusao_encontradas) <= 1
    
    return eh_relevante, score, palavras_inclusao_encontradas

def filtrar_referencias(arquivo_entrada: str, arquivo_saida: str) -> Dict:
    """Filtra as referências e salva apenas as relevantes"""
    
    print("🔍 Carregando referências do arquivo...")
    referencias = extrair_referencias_do_bib(arquivo_entrada)
    
    print(f"📊 Total de referências encontradas: {len(referencias)}")
    
    referencias_relevantes = []
    referencias_irrelevantes = []
    relatorio = {
        'total': len(referencias),
        'relevantes': 0,
        'irrelevantes': 0,
        'detalhes_relevantes': [],
        'detalhes_irrelevantes': []
    }
    
    print("\n Analisando relevância de cada referência...")
    
    for i, ref in enumerate(referencias):
        eh_relevante, score, palavras = avaliar_relevancia(ref)
        
        if eh_relevante:
            referencias_relevantes.append(ref)
            relatorio['detalhes_relevantes'].append({
                'chave': ref['chave'],
                'score': score,
                'palavras_encontradas': palavras
            })
        else:
            referencias_irrelevantes.append(ref)
            relatorio['detalhes_irrelevantes'].append({
                'chave': ref['chave'],
                'score': score,
                'palavras_encontradas': palavras
            })
        
        # Progress indicator
        if (i + 1) % 100 == 0:
            print(f"   Processadas: {i + 1}/{len(referencias)}")
    
    relatorio['relevantes'] = len(referencias_relevantes)
    relatorio['irrelevantes'] = len(referencias_irrelevantes)
    
    # Salvar apenas as referências relevantes
    print(f"\n💾 Salvando {len(referencias_relevantes)} referências relevantes...")
    
    with open(arquivo_saida, 'w', encoding='utf-8') as f:
        f.write("% Referências filtradas por relevância temática\n")
        f.write("% Tema: Modelo empírico para salvaguarda de saberes agroecológicos tradicionais por meio de machine learning\n")
        f.write(f"% Total de referências relevantes: {len(referencias_relevantes)}\n")
        f.write(f"% Filtrado de {len(referencias)} referências originais\n\n")
        
        for ref in referencias_relevantes:
            f.write(ref['ref_original'])
            f.write('\n\n')
    
    return relatorio

def gerar_relatorio_detalhado(relatorio: Dict, arquivo_relatorio: str):
    """Gera um relatório detalhado da filtragem"""
    
    with open(arquivo_relatorio, 'w', encoding='utf-8') as f:
        f.write("RELATÓRIO DE FILTRAGEM DE REFERÊNCIAS BIBLIOGRÁFICAS\n")
        f.write("=" * 60 + "\n\n")
        
        f.write("TEMA DA PESQUISA:\n")
        f.write("Modelo empírico para salvaguarda de saberes e fazeres agroecológicos tradicionais por meio de machine learning\n\n")
        
        f.write("RESUMO DA FILTRAGEM:\n")
        f.write(f"• Total de referências analisadas: {relatorio['total']}\n")
        f.write(f"• Referências RELEVANTES: {relatorio['relevantes']} ({relatorio['relevantes']/relatorio['total']*100:.1f}%)\n")
        f.write(f"• Referências IRRELEVANTES: {relatorio['irrelevantes']} ({relatorio['irrelevantes']/relatorio['total']*100:.1f}%)\n\n")
        
        f.write("TOP 20 REFERÊNCIAS MAIS RELEVANTES:\n")
        f.write("-" * 40 + "\n")
        relevantes_ordenadas = sorted(relatorio['detalhes_relevantes'], 
                                    key=lambda x: x['score'], reverse=True)
        
        for i, ref in enumerate(relevantes_ordenadas[:20], 1):
            f.write(f"{i:2d}. {ref['chave']} (Score: {ref['score']:.1f})\n")
            f.write(f"    Palavras-chave encontradas: {', '.join(ref['palavras_encontradas'][:5])}\n\n")
        
        f.write("\nEXEMPLOS DE REFERÊNCIAS EXCLUÍDAS:\n")
        f.write("-" * 40 + "\n")
        irrelevantes_amostra = relatorio['detalhes_irrelevantes'][:10]
        
        for i, ref in enumerate(irrelevantes_amostra, 1):
            f.write(f"{i:2d}. {ref['chave']} (Score: {ref['score']:.1f})\n")
            if ref['palavras_encontradas']:
                f.write(f"    Palavras encontradas: {', '.join(ref['palavras_encontradas'][:3])}\n")
            f.write("\n")
        
        f.write(f"\nCRITÉRIOS DE INCLUSÃO: {len(PALAVRAS_INCLUSAO)} palavras-chave relacionadas ao tema\n")
        f.write(f"CRITÉRIOS DE EXCLUSÃO: {len(PALAVRAS_EXCLUSAO)} palavras-chave de áreas não relacionadas\n")

def main():
    # Definir caminhos dos arquivos
    arquivo_entrada = "referencias_encontradas_para_adicionar.bib"
    arquivo_saida = "referencias_filtradas_tema_agroecologia.bib"
    arquivo_relatorio = "relatorio_filtragem_referencias.txt"
    
    print("🌱 FILTRO DE REFERÊNCIAS POR TEMA - AGROECOLOGIA TRADICIONAL")
    print("=" * 65)
    
    if not os.path.exists(arquivo_entrada):
        print(f"❌ Erro: Arquivo {arquivo_entrada} não encontrado!")
        return
    
    try:
        # Executar filtragem
        relatorio = filtrar_referencias(arquivo_entrada, arquivo_saida)
        
        # Gerar relatório
        print("📝 Gerando relatório detalhado...")
        gerar_relatorio_detalhado(relatorio, arquivo_relatorio)
        
        print("\n✅ FILTRAGEM CONCLUÍDA COM SUCESSO!")
        print("-" * 40)
        print(f"📁 Referências filtradas salvas em: {arquivo_saida}")
        print(f"📊 Relatório detalhado salvo em: {arquivo_relatorio}")
        print(f"🎯 {relatorio['relevantes']} referências relevantes de {relatorio['total']} analisadas")
        print(f"📈 Taxa de relevância: {relatorio['relevantes']/relatorio['total']*100:.1f}%")
        
    except Exception as e:
        print(f"❌ Erro durante a execução: {str(e)}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()