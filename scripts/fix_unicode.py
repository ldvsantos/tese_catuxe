import re
from pathlib import Path

p = Path(r"c:\Users\vidal\OneDrive\Documentos\13 - CLONEGIT\tese-catuxe\CAPITULOS\Artigo_1.tex")
text = p.read_text(encoding='utf-8')
backup = p.with_name(p.stem + '.tex.unicbak')
backup.write_text(text, encoding='utf-8')

# Replace ≥ with \geq
text = text.replace('≥', r'\geq')

p.write_text(text, encoding='utf-8')
print('Replaced ≥ with \\geq; backup at', backup.name)
