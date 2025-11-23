import re

# Read the file
SRC = r'c:\\Users\\vidal\\OneDrive\\Documentos\\13 - CLONEGIT\\tese-catuxe\\CAPITULOS\\Artigo_1.tex'

with open(SRC, 'r', encoding='utf-8') as f:
    content = f.read()

# 1) Remove YAML frontmatter blocks (--- ... ---) if present
content = re.sub(r'^---[\s\S]*?---\s*', '', content, flags=re.MULTILINE)

# 2) Headers: ### -> \subsubsection, ## -> \subsection, # -> \section
content = re.sub(r'^###\s*(.+)', r'\\subsubsection{\1}', content, flags=re.MULTILINE)
content = re.sub(r'^##\s*(.+)', r'\\subsection{\1}', content, flags=re.MULTILINE)
content = re.sub(r'^#\s*(.+)', r'\\section{\1}', content, flags=re.MULTILINE)

# 3) Only convert bold **...** -> \textbf{...}; do NOT convert single *...* automatically
content = re.sub(r'\*\*(.+?)\*\*', r'\\textbf{\1}', content, flags=re.DOTALL)

# 4) Inline code/backticks -> \texttt{...}
content = re.sub(r'`([^`]+?)`', r'\\texttt{\1}', content)

# 5) Convert Markdown image syntax to LaTeX figure environments
def conv_width(w):
    if not w:
        return ''
    w = w.strip()
    if w.endswith('%'):
        try:
            n = float(w.strip('%'))/100.0
            return f'{n}\\textwidth'
        except:
            return w
    return w

def repl_img_with_width(match):
    path = match.group(1)
    label = match.group(2) if match.lastindex >= 2 else ''
    width_raw = match.group(3) if match.lastindex and match.lastindex >= 3 else ''
    width = conv_width(width_raw)
    if width:
        return f"\\begin{{figure}}[h]\n\\centering\n\\includegraphics[width={width}]{{{path}}}\n\\caption{{}}\n\\label{{{label}}}\n\\end{{figure}}"
    else:
        return f"\\begin{{figure}}[h]\n\\centering\n\\includegraphics{{{path}}}\n\\caption{{}}\n\\label{{{label}}}\n\\end{{figure}}"

content = re.sub(r'!\[\]\(([^\)]+?)\)\{#([^\s\}]+) width="([^\"]+)"\}', repl_img_with_width, content)
content = re.sub(r'!\[\]\(([^\)]+?)\)\{#([^\}]+)\}', repl_img_with_width, content)
content = re.sub(r'!\[\]\(([^\)]+?)\)', lambda m: f"\\begin{{figure}}[h]\n\\centering\n\\includegraphics{{{m.group(1)}}}\n\\caption{{}}\n\\end{{figure}}", content)

# 6) Convert contiguous Markdown tables (pipe | ) into simple LaTeX tabulars
# Match blocks where second line is the typical divider (----)
table_re = re.compile(r'(^\|.*\n^\|[-:\s|]*\n(?:^\|.*\n)*)', re.MULTILINE)

def convert_table_block(block: str) -> str:
    # split lines and filter
    lines = [ln.strip() for ln in block.strip().splitlines() if ln.strip()]
    if len(lines) < 2:
        return block
    header = [c.strip() for c in lines[0].strip('|').split('|')]
    # detect delimiter line and remove it
    body_lines = []
    for ln in lines[1:]:
        if re.match(r'^\|[-:\s|]+$', ln):
            continue
        body_lines.append([c.strip() for c in ln.strip('|').split('|')])

    ncols = len(header)
    colspec = '|'.join(['l'] * ncols)
    out = []
    out.append('\\begin{table}[h]')
    out.append('\\centering')
    out.append('\\small')
    out.append(f'\\begin{{tabular}}{{|{colspec}|}}')
    out.append('\\hline')
    out.append(' & '.join(header) + ' \\ \\hline')
    for row in body_lines:
        # ensure row length
        if len(row) < ncols:
            row += [''] * (ncols - len(row))
        out.append(' & '.join(row) + ' \\ \\hline')
    out.append('\\end{tabular}')
    out.append('\\end{table}')
    return '\n'.join(out)

content = table_re.sub(lambda m: convert_table_block(m.group(0)), content)

# Write back
with open(SRC, 'w', encoding='utf-8') as f:
    f.write(content)

print('Finished (single-pass)')