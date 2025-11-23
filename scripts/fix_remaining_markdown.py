import re
from pathlib import Path

p = Path(r"c:\Users\vidal\OneDrive\Documentos\13 - CLONEGIT\tese-catuxe\CAPITULOS\Artigo_1.tex")
text = p.read_text(encoding='utf-8')
backup = p.with_suffix('.tex.bak')
backup.write_text(text, encoding='utf-8')

# 1) Remove trailing double quote right before closing brace of \chapter{..."}
text = re.sub(r'(\\chapter\{[^}]*)"\}', r'\1}', text)

# 2) Replace HTML-like custom comment markers '<--! ... -->' with LaTeX comment
text = text.replace('<--!mexi aqui -->', '% mexi aqui')

# 3) Replace angle-bracket URLs <https://...> -> \url{...}
text = re.sub(r'<(https?://[^>\s]+)>', r'\\url{\1}', text)

# 4) Replace single-star emphasis *text* -> \emph{text}
# Avoid matching cases where star is used in math or as part of a lone symbol.
text = re.sub(r"\*(?=\S)(.+?)(?<=\S)\*", r"\\emph{\1}", text)

# Write modified file
p.write_text(text, encoding='utf-8')
print('Patched Artigo_1.tex; backup saved as', backup.name)
