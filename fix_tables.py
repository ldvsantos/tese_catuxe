from pathlib import Path
import re
p=Path(r'c:\Users\vidal\OneDrive\Documentos\13 - CLONEGIT\tese-catuxe\CAPITULOS\Artigo_1.tex')
s=p.read_text(encoding='utf-8')
lines=s.splitlines()
out=[]
i=0
N=len(lines)
changed=False
while i<N:
    if lines[i].lstrip().startswith('|'):
        # collect block
        j=i
        block=[]
        while j<N and lines[j].lstrip().startswith('|'):
            block.append(lines[j])
            j+=1
        # parse header & rows
        # remove empty |--| rows
        if len(block) >= 1:
            header = [c.strip() for c in block[0].strip().strip('|').split('|')]
            # detect if second line is divider
            start_idx=1
            if len(block)>1 and re.match(r'^\s*\|\s*[-:|\s]+$', block[1]):
                start_idx=2
            rows=[]
            for ln in block[start_idx:]:
                cells=[c.strip() for c in ln.strip().strip('|').split('|')]
                rows.append(cells)
            ncols = len(header)
            colspec='|'.join(['l']*ncols)
            table_lines=['\\begin{table}[h]','\\centering','\\small',f'\\begin{{tabular}}{{|{colspec}|}}','\\hline']
            table_lines.append(' & '.join(header) + ' \\ \\hline')
            for r in rows:
                if len(r)<ncols:
                    r += ['']*(ncols-len(r))
                table_lines.append(' & '.join(r) + ' \\ \\hline')
            table_lines.append('\\end{tabular}')
            table_lines.append('\\end{table}')
            out.extend(table_lines)
            changed=True
            i=j
            continue
    out.append(lines[i])
    i+=1
result='\n'.join(out)
if changed:
    p.write_text(result,encoding='utf-8')
    print('Tables converted')
else:
    print('No tables found')
