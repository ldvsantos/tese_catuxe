#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script para converter citações do formato (Autor, ano) para \cite{chave} nos arquivos de metodologia
"""

import re
import os

def extrair_chaves_references(arquivo_bib):
    """Extrai todas as chaves de citação do arquivo references.bib"""
    chaves = []
    try:
        with open(arquivo_bib, 'r', encoding='utf-8') as f:
            conteudo = f.read()
            # Busca por entradas do tipo @article{chave, @book{chave, etc.
            matches = re.findall(r'@\w+\{([^,\s]+)', conteudo)
            chaves = [match.strip() for match in matches]
    except Exception as e:
        print(f"Erro ao ler arquivo de bibliografia: {e}")
    
    return chaves

def criar_mapa_citacoes():
    """Cria um mapeamento de citações (Autor, ano) para chaves LaTeX"""
    # Mapeamento manual baseado nas citações encontradas
    mapa = {
        # Citações encontradas no arquivo
        '(Padigala, 2015)': r'\cite{Padigala2015}',
        '(Barrera-Bassols; Alfred Zinck; Van Ranst, 2006)': r'\cite{BarreraBassols2006}',
        '(Pieroni; Price; Vandebroek, 2005)': r'\cite{Pieroni2005}',
        '(Lakshmanan; Lakshmanan, 2014)': r'\cite{Lakshmanan2014}',
        '(Zhong et al., 2022)': r'\cite{Zhong2022}',
        '(Verma, 2019)': r'\cite{Verma2019}',
        '(Kline; Waring; Salerno, 2018)': r'\cite{Kline2018}',
        '(Kawecki; Ebert, 2004)': r'\cite{Kawecki2004}',
        "(D'Ambrosio, 2015)": r'\cite{DAmbrosio2015}',
        '(Souravi; Rajasekharan, 2019)': r'\cite{Souravi2019}',
        '(Altieri, 2019)': r'\cite{Altieri2019}',
        '(Irhza et al., 2023)': r'\cite{Irhza2023}',
        '(Borah; Ladon; Garkoti, 2023)': r'\cite{Borah2023}',
        '(Fernández-Llamazares et al., 2015)': r'\cite{FernandezLlamazares2015}',
        '(Nazarea, 2006)': r'\cite{Nazarea2006}',
        '(Gavin et al., 2015)': r'\cite{Gavin2015}',
        '(Fernández‐Llamazares; Cabeza, 2018)': r'\cite{FernandezLlamazares2018}',
        '(Altieri, 2002)': r'\cite{Altieri2002}',
        '(Elhussiny et al., 2023)': r'\cite{Elhussiny2023}',
        '(Elhussiny, 2023)': r'\cite{Elhussiny2023}',
        '(Kamyab et al., 2021)': r'\cite{Kamyab2021}',
        '(Souza et al., 2022)': r'\cite{Souza2022}',
        '(Yeasmin et al., 2022)': r'\cite{Yeasmin2022}',
        '(Tuluxun et al., 2025)': r'\cite{Tuluxun2025}',
        '(Tuluxun, 2025)': r'\cite{Tuluxun2025}',
    }
    return mapa

def processar_arquivo_metodos(arquivo_entrada, arquivo_saida=None):
    """Processa os arquivos de metodologia convertendo citações"""
    if arquivo_saida is None:
        arquivo_saida = arquivo_entrada
    
    try:
        # Lê o arquivo original
        with open(arquivo_entrada, 'r', encoding='utf-8') as f:
            conteudo = f.read()
        
        # Obtém o mapeamento de citações
        mapa_citacoes = criar_mapa_citacoes()
        
        # Contador de substituições
        total_substituicoes = 0
        
        # Aplica as substituições
        conteudo_original = conteudo
        for citacao_antiga, citacao_nova in mapa_citacoes.items():
            if citacao_antiga in conteudo:
                conteudo = conteudo.replace(citacao_antiga, citacao_nova)
                count = conteudo_original.count(citacao_antiga)
                total_substituicoes += count
                print(f"✓ Substituído '{citacao_antiga}' por '{citacao_nova}' ({count} ocorrências)")
        
        # Salva o arquivo modificado
        with open(arquivo_saida, 'w', encoding='utf-8') as f:
            f.write(conteudo)
        
        print(f"\n📝 Total de substituições realizadas: {total_substituicoes}")
        print(f"✅ Arquivo salvo: {arquivo_saida}")
        
        return total_substituicoes
        
    except Exception as e:
        print(f"❌ Erro ao processar arquivo: {e}")
        return 0

def verificar_referencias_faltantes():
    """Verifica quais referências estão faltando no arquivo references.bib"""
    print("\n🔍 Verificando referências no arquivo references.bib...")
    
    # Lista de chaves que precisaríamos ter
    chaves_necessarias = [
        'Padigala2015', 'BarreraBassols2006', 'Pieroni2005', 'Lakshmanan2014',
        'Zhong2022', 'Verma2019', 'Kline2018', 'Kawecki2004', 'DAmbrosio2015',
        'Souravi2019', 'Altieri2019', 'Irhza2023', 'Borah2023', 'FernandezLlamazares2015',
        'Nazarea2006', 'Gavin2015', 'FernandezLlamazares2018', 'Altieri2002',
        'Elhussiny2023', 'Kamyab2021', 'Souza2022', 'Yeasmin2022', 'Tuluxun2025'
    ]
    
    # Verifica se existem no arquivo references.bib
    arquivo_bib = r'c:\Users\vidal\OneDrive\Documentos\1 - ACADEMICO\1- UFS\2 - POS\3- DOUTORADO\TESE_ATUAL\references.bib'
    chaves_existentes = extrair_chaves_references(arquivo_bib)
    
    faltantes = []
    encontradas = []
    
    for chave in chaves_necessarias:
        if chave in chaves_existentes:
            encontradas.append(chave)
        else:
            faltantes.append(chave)
    
    print(f"✅ Referências encontradas no references.bib: {len(encontradas)}")
    for chave in encontradas:
        print(f"   - {chave}")
    
    print(f"\n❌ Referências faltantes no references.bib: {len(faltantes)}")
    for chave in faltantes:
        print(f"   - {chave}")
    
    return faltantes, encontradas

def main():
    """Função principal"""
    print("🔄 Convertendo citações do formato (Autor, ano) para \\cite{chave}")
    print("=" * 60)
    
    # Caminho do arquivo
    # Caminhos dos arquivos de metodologia
    arquivo_met_psicometrica = r'c:\Users\vidal\OneDrive\Documentos\1 - ACADEMICO\1- UFS\2 - POS\3- DOUTORADO\TESE_ATUAL\CONTEUDOS\METODOLOGIA\Met_psicometrica.tex'
    arquivo_metodologia_rs = r'c:\Users\vidal\OneDrive\Documentos\1 - ACADEMICO\1- UFS\2 - POS\3- DOUTORADO\TESE_ATUAL\CONTEUDOS\METODOLOGIA\Met_rs.tex'
    arquivo_met_machine_learning = r'c:\Users\vidal\OneDrive\Documentos\1 - ACADEMICO\1- UFS\2 - POS\3- DOUTORADO\TESE_ATUAL\CONTEUDOS\METODOLOGIA\Met_machine_learning.tex'
    
    # Verifica se os arquivos existem
    arquivos_metodologia = [arquivo_met_psicometrica, arquivo_metodologia_rs, arquivo_met_machine_learning]
    
    for arquivo in arquivos_metodologia:
        if not os.path.exists(arquivo):
            print(f"❌ Arquivo não encontrado: {arquivo}")
            continue
        
        # Processa as conversões
        substituicoes = processar_arquivo_metodos(arquivo)
    
    # Verifica referências faltantes
    faltantes, encontradas = verificar_referencias_faltantes()
    
    print("\n" + "=" * 60)
    print("📊 RESUMO:")
    print(f"• Substituições realizadas: {substituicoes}")
    print(f"• Referências encontradas no .bib: {len(encontradas)}")
    print(f"• Referências faltantes no .bib: {len(faltantes)}")
    
    if faltantes:
        print("\n⚠️  AVISO: Algumas referências precisam ser adicionadas ao references.bib")
        print("   Caso contrário, haverá erros de compilação no LaTeX.")

if __name__ == "__main__":
    main()