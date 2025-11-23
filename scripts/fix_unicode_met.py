import re
from pathlib import Path

p = Path(r"c:\Users\vidal\OneDrive\Documentos\13 - CLONEGIT\tese-catuxe\CONTEUDOS\METODOLOGIA\Met_rs.tex")
text = p.read_text(encoding='utf-8')

# Replace ≥ with \geq
text = text.replace('≥', r'\geq')

p.write_text(text, encoding='utf-8')
print('Replaced ≥ with \\geq in Met_rs.tex')
