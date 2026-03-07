"""Fix double-encoded UTF-8 (mojibake) in references.bib"""
import shutil

path = r'c:\Users\vidal\OneDrive\Documentos\13 - CLONEGIT\tese-catuxe\references.bib'

with open(path, 'rb') as f:
    data = f.read()

replacements = {
    b'\xc3\x83\xc2\x81': 'Á'.encode('utf-8'),
    b'\xc3\x83\xc2\xa1': 'á'.encode('utf-8'),
    b'\xc3\x83\xc2\xa0': 'à'.encode('utf-8'),
    b'\xc3\x83\xc2\xa2': 'â'.encode('utf-8'),
    b'\xc3\x83\xc2\xa3': 'ã'.encode('utf-8'),
    b'\xc3\x83\xc2\xa4': 'ä'.encode('utf-8'),
    b'\xc3\x83\xc2\xa7': 'ç'.encode('utf-8'),
    b'\xc3\x83\xc2\xa9': 'é'.encode('utf-8'),
    b'\xc3\x83\xc2\xa8': 'è'.encode('utf-8'),
    b'\xc3\x83\xc2\xaa': 'ê'.encode('utf-8'),
    b'\xc3\x83\xc2\xab': 'ë'.encode('utf-8'),
    b'\xc3\x83\xc2\xad': 'í'.encode('utf-8'),
    b'\xc3\x83\xc2\xb3': 'ó'.encode('utf-8'),
    b'\xc3\x83\xc2\xb4': 'ô'.encode('utf-8'),
    b'\xc3\x83\xc2\xb5': 'õ'.encode('utf-8'),
    b'\xc3\x83\xc2\xba': 'ú'.encode('utf-8'),
    b'\xc3\x83\xc2\xbc': 'ü'.encode('utf-8'),
    b'\xc3\x83\xc2\x87': 'Ç'.encode('utf-8'),
    b'\xc3\x83\xc2\x89': 'É'.encode('utf-8'),
    b'\xc3\x83\xc2\x8d': 'Í'.encode('utf-8'),
    b'\xc3\x83\xc2\x93': 'Ó'.encode('utf-8'),
    b'\xc3\x83\xc2\x95': 'Õ'.encode('utf-8'),
    b'\xc3\x83\xc2\x9a': 'Ú'.encode('utf-8'),
    b'\xc3\x82\xc2\xba': 'º'.encode('utf-8'),
    b'\xc3\x82\xc2\xaa': 'ª'.encode('utf-8'),
    b'\xc3\x82\xc2\xa1': 'á'.encode('utf-8'),
    b'\xc3\x82\xc2\xa7': 'ç'.encode('utf-8'),
    b'\xc3\x82\xc2\xac': 'ê'.encode('utf-8'),
    b'\xc3\x82\xc2\xad': '\u00AD'.encode('utf-8'),
    b'\xc3\x82\xc2\xae': '®'.encode('utf-8'),
    b'\xc3\x82\xc2\xa9': '©'.encode('utf-8'),
    b'\xc3\x86\xc2\x92': 'ƒ'.encode('utf-8'),
}

total = 0
for old, new in replacements.items():
    c = data.count(old)
    if c > 0:
        data = data.replace(old, new)
        total += c
        char_repr = new.decode('utf-8')
        print(f'  {old.hex()} -> "{char_repr}" : {c} occurrences')

with open(path, 'wb') as f:
    f.write(data)

remaining_0081 = data.count(b'\xc2\x81')
print(f'\nTotal replacements: {total}')
print(f'Remaining U+0081: {remaining_0081}')

for byte_val in range(0x80, 0x90):
    count = data.count(bytes([0xc2, byte_val]))
    if count > 0:
        print(f'  Remaining U+00{byte_val:02X}: {count}')
