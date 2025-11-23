import re
from pathlib import Path

p = Path(r"c:\Users\vidal\OneDrive\Documentos\13 - CLONEGIT\tese-catuxe\CAPITULOS\Artigo_1.tex")
text = p.read_text(encoding='utf-8')
backup = p.with_name(p.stem + '.tex.corrbak')
backup.write_text(text, encoding='utf-8')

# 1) Replace percentages: \d+% -> \d+\%
text = re.sub(r'(\d+(?:,\d+)?)%', r'\1\%', text)

# 2) Replace citations: [@label] -> \cite{label}
# But only if they are not already \cite or \citeonline
# Actually, [@label] is correct for abntex2, but if user wants \cite{label}, do it.
text = re.sub(r'\[@([A-Za-z0-9_]+)\]', r'\\cite{\1}', text)

# 3) Replace any remaining @label without brackets to \cite{label}
text = re.sub(r'(?<!\[)@([A-Za-z0-9_]+)(?![@\]])', r'\\cite{\1}', text)

p.write_text(text, encoding='utf-8')
print('Corrected percentages and citations; backup at', backup.name)
