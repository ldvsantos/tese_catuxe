import re
from pathlib import Path

p = Path(r"c:\Users\vidal\OneDrive\Documentos\13 - CLONEGIT\tese-catuxe\CAPITULOS\Artigo_1.tex")
text = p.read_text(encoding='utf-8')
# Backup with timestamp
backup = p.with_name(p.stem + '.tex.figbak')
backup.write_text(text, encoding='utf-8')

# Pattern to find includegraphics with 2-FIGURAS/2-EN
include_pat = re.compile(r"\\includegraphics\s*(?:\[[^\]]*\])?\s*\{2-FIGURAS/2-EN/[^}]+\}")

lines = text.splitlines()

i = 0
modified = False
while i < len(lines):
    if include_pat.search(lines[i]):
        # walk up to find \begin{figure} (or \begin{figure*})
        start = i
        while start >= 0 and not re.search(r"^\\begin\{figure(?:\*?)\}", lines[start]):
            start -= 1
        if start < 0:
            start = i
        # walk down to find \end{figure}
        end = i
        while end < len(lines) and not re.search(r"^\\end\{figure(?:\*?)\}", lines[end]):
            end += 1
        if end >= len(lines):
            end = i
        # Comment the block
        for j in range(start, end+1):
            if not lines[j].lstrip().startswith('%'):
                lines[j] = '% ' + lines[j]
                modified = True
        i = end + 1
    else:
        i += 1

if modified:
    p.write_text('\n'.join(lines), encoding='utf-8')
    print('Commented figure blocks referencing 2-FIGURAS/2-EN; backup at', backup.name)
else:
    print('No matching figure blocks found to comment.')
