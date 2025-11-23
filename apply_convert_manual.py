import re
from pathlib import Path
p=Path(r'c:\Users\vidal\OneDrive\Documentos\13 - CLONEGIT\tese-catuxe\CAPITULOS\Artigo_1.tex')
s=p.read_text(encoding='utf-8')
orig=s

# Remove YAML frontmatter blocks and stray '---' lines
s=re.sub(r'^---[\s\S]*?---\s*','',s,flags=re.MULTILINE)
# Replace headings: ### -> \subsubsection{...}, ## -> \subsection{...}, # -> \section{...}
s=re.sub(r'^###\s*(.+)$', r'\\subsubsection{\1}', s, flags=re.MULTILINE)
s=re.sub(r'^##\s*(.+)$', r'\\subsection{\1}', s, flags=re.MULTILINE)
s=re.sub(r'^#\s*(.+)$', r'\\section{\1}', s, flags=re.MULTILINE)

# Convert **bold** -> \textbf{} and `code` -> \texttt{}
# avoid replacing inside \textbf or \textit or existing LaTeX commands
s=re.sub(r'\*\*(.*?)\*\*', r'\\textbf{\1}', s)
s=re.sub(r'`([^`]+?)`', r'\\texttt{\1}', s)

# Convert image markdown patterns to LaTeX figure
# Patterns: ![](path){#label width="80%"} or ![](path){#label}

def conv_width(w):
    if not w: return ''
    w=w.strip()
    if w.endswith('%'):
        try:
            n=float(w.strip('%'))/100.0
            return f'{n}\\textwidth'
        except:
            return w
    return w

# first with width and label
s=re.sub(r'!\[\]\(([^\)]+?)\)\{#([^\s\}]+)\s+width="([^"]+)"\}', lambda m: '\\begin{figure}[h]\n\\centering\n\\includegraphics[width=%s]{%s}\n\\caption{}\n\\label{%s}\n\\end{figure}'% (conv_width(m.group(3)),m.group(1),m.group(2)), s)
# with label only
s=re.sub(r'!\[\]\(([^\)]+?)\)\{#([^\}]+)\}', lambda m: '\\begin{figure}[h]\n\\centering\n\\includegraphics{%s}\n\\caption{}\n\\label{%s}\n\\end{figure}'%(m.group(1),m.group(2)), s)
# plain ![](path)
s=re.sub(r'!\[\]\(([^\)]+?)\)', lambda m: '\\begin{figure}[h]\n\\centering\n\\includegraphics{%s}\n\\caption{}\n\\end{figure}'%m.group(1), s)

# Convert contiguous Markdown pipe tables to LaTeX tabulars
import itertools
lines=s.splitlines()
out=[]
i=0
N=len(lines)
while i<N:
    if lines[i].lstrip().startswith('|'):
        # collect block
        j=i
        block=[]
        while j<N and lines[j].lstrip().startswith('|'):
            block.append(lines[j])
            j+=1
        # require at least header and divider
        if len(block)>=2 and re.search(r'\|\s*-{2,}', block[1]):
            # parse header
            header=[h.strip() for h in block[0].strip().strip('|').split('|')]
            rows=[]
            for ln in block[2:]:
                cells=[c.strip() for c in ln.strip().strip('|').split('|')]
                rows.append(cells)
            n=len(header)
            colspec='|'.join(['l']*n)
            out.append('\\begin{table}[h]')
            out.append('\\centering')
            out.append('\\small')
            out.append(f'\\begin{{tabular}}{{|{colspec}|}}')
            out.append('\\hline')
            out.append(' & '.join(header) + ' \\ \\hline')
            for r in rows:
                if len(r)<n:
                    r += ['']*(n-len(r))
                out.append(' & '.join(r) + ' \\ \\hline')
            out.append('\\end{tabular}')
            out.append('\\end{table}')
            i=j
            continue
        else:
            # not a proper table, emit as-is
            out.extend(block)
            i=j
            continue
    else:
        out.append(lines[i])
        i+=1
s='\n'.join(out)

# Clean up stray markdown emphasis markers leftover in places like }terroir\textit{
# Fix patterns where we accidentally converted formatting inside braces in wrong order
s=s.replace('}terroir\\textit{','\\textit{terroir}')

# Final sanity: replace sequences of multiple blank lines with two blank lines
s=re.sub(r'\n{3,}','\n\n',s)

if s==orig:
    print('No changes applied')
else:
    p.write_text(s,encoding='utf-8')
    print('Artigo_1.tex updated')
