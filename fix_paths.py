import re

# Ler o arquivo
with open(r'c:\Users\vidal\OneDrive\Documentos\13 - CLONEGIT\tese-catuxe\CAPITULOS\Artigo_1.tex', 'r', encoding='utf-8') as f:
    content = f.read()

# Substituir
content = content.replace('2-FIGURAS/2-EN/', 'Imagens/2-EN/')

# Escrever de volta
with open(r'c:\Users\vidal\OneDrive\Documentos\13 - CLONEGIT\tese-catuxe\CAPITULOS\Artigo_1.tex', 'w', encoding='utf-8') as f:
    f.write(content)

print("Substituições feitas.")