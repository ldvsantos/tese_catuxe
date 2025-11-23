import re
from pathlib import Path

# Arquivos
capitulos_bib = Path(r"c:\Users\vidal\OneDrive\Documentos\13 - CLONEGIT\tese-catuxe\CAPITULOS\referencias.bib")
tese_bib = Path(r"c:\Users\vidal\OneDrive\Documentos\13 - CLONEGIT\tese-catuxe\references.bib")

# Chaves citadas no Artigo_1.tex
chaves = [
    'academico', 'yahoo', 'SAATY1991', 'tMUNN2018', 'ricco2018', 'Tricco2018',
    'Young2019', 'Casey2021', 'webster2002', 'tranfield2003', 'hong2018',
    'pluye2009', 'Likert3vs5_2025', 'shrout1979', 'lotka1926', 'RCoreTeam2024',
    'RStudioTeam2023', 'Le2008', 'Greenacre2017', 'Csardi2006', 'Schoch202',
    'Blondel2008', 'Spearman1904', 'Cleveland1979'
]

# Ler o bib do CAPITULOS
with open(capitulos_bib, 'r', encoding='utf-8') as f:
    bib_text = f.read()

# Encontrar entradas
entradas = re.findall(r'@\w+\{([^,]+),.*?\n\}', bib_text, re.DOTALL)

# Filtrar pelas chaves
entradas_filtradas = []
for entrada in entradas:
    chave = entrada.split('\n')[0].strip()
    if chave in chaves:
        # Encontrar a entrada completa
        match = re.search(r'@\w+\{' + re.escape(chave) + r',.*?\n\}', bib_text, re.DOTALL)
        if match:
            entradas_filtradas.append(match.group(0))

# Ler o bib da tese
with open(tese_bib, 'r', encoding='utf-8') as f:
    tese_text = f.read()

# Verificar se já existem
novas_entradas = []
for entrada in entradas_filtradas:
    chave = re.search(r'@\w+\{([^,]+),', entrada).group(1)
    if chave not in tese_text:
        novas_entradas.append(entrada)

# Adicionar ao final
if novas_entradas:
    with open(tese_bib, 'a', encoding='utf-8') as f:
        f.write('\n\n% ======= REFERÊNCIAS DO ARTIGO 1 =======\n\n')
        for entrada in novas_entradas:
            f.write(entrada + '\n\n')
    print(f'Adicionadas {len(novas_entradas)} referências ao references.bib')
else:
    print('Nenhuma nova referência a adicionar.')
