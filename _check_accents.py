import glob, re

pattern = re.compile(r"\\['\^`~c]\{[a-zA-Z]\}")

files = []
for d in ['CONTEUDOS', 'CAPITULOS', 'Pre_Textual', 'Pos_Textual', 'CEP']:
    files += glob.glob(f'{d}/**/*.tex', recursive=True)

files = [f for f in files if '.bak' not in f]

found = 0
for f in sorted(files):
    with open(f, encoding='utf-8', errors='replace') as fh:
        for i, line in enumerate(fh, 1):
            if line.strip().startswith('%'):
                continue
            matches = pattern.findall(line)
            if matches:
                for m in matches:
                    print(f'{f}:{i}: {m}')
                    found += 1

print(f'\nTotal: {found} escape sequences found')
