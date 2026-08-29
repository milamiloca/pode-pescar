import io, re, glob, os

LIB = 'pode_pescar/lib'
arquivos = {os.path.basename(p): io.open(p, encoding='utf-8').read()
            for p in sorted(glob.glob(LIB + '/*.dart'))}

# o que cada arquivo declara no topo
declara = {}
for nome, src in arquivos.items():
    d = set()
    d |= set(re.findall(r'^class\s+(\w+)', src, re.M))
    d |= set(re.findall(r'^enum\s+(\w+)', src, re.M))
    d |= set(re.findall(r'^(?:final|const)\s+(?:\w[\w<>?, ]*\s+)?(\w+)\s*=',
                        src, re.M))
    d |= set(re.findall(r'^[\w<>?, ]+\s+(\w+)\s*[({=]', src, re.M))
    declara[nome] = {x for x in d if not x.startswith('_')}

print('ARQUIVOS E IMPORTS')
problema = False
for nome, src in arquivos.items():
    imps = re.findall(r"import '(?!package:)([^']+)'", src)
    corpo = re.sub(r"^import '[^']+';\n", '', src, flags=re.M)
    corpo_sem_str = re.sub(r"'(?:[^'\\]|\\.)*'", "''", corpo)
    corpo_sem_str = re.sub(r'//[^\n]*', '', corpo_sem_str)
    linhas = []
    for imp in imps:
        alvo = os.path.basename(imp)
        if alvo not in declara:
            linhas.append(f'    !! {alvo} nao existe')
            problema = True
            continue
        usados = [s for s in declara[alvo]
                  if re.search(r'\b' + re.escape(s) + r'\b', corpo_sem_str)]
        if not usados:
            linhas.append(f'    ?? {alvo} importado mas nada usado')
            problema = True
        else:
            linhas.append(f'    ok {alvo:22s} ({len(usados)} simbolos)')
    print(f'\n  {nome}')
    for l in linhas:
        print(l)

# arquivos que ninguem importa
print('\n\nARQUIVOS ORFAOS')
importados = set()
for src in arquivos.values():
    importados |= {os.path.basename(x)
                   for x in re.findall(r"import '(?!package:)([^']+)'", src)}
orfaos = [n for n in arquivos if n not in importados and n != 'main.dart']
print('  ', orfaos or 'nenhum')
