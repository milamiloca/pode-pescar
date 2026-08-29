"""Procura nomes públicos declarados em dois arquivos que são importados
juntos. Foi o erro do enum Fonte: o compilador só reclama quando o nome
é usado, então dá para passar despercebido até a hora de rodar."""
import io, re, glob, os

LIB = 'pode_pescar/lib'
arquivos = {os.path.basename(p): io.open(p, encoding='utf-8').read()
            for p in sorted(glob.glob(LIB + '/*.dart'))}

FLUTTER = {'material.dart'}


def publicos(src):
    """Só declarações de topo: em Dart elas começam na coluna 0. Membros
    de classe vêm indentados e não colidem entre arquivos."""
    topo = [l for l in src.split('\n') if l and not l[0].isspace()]
    t = '\n'.join(topo)
    d = set()
    d |= set(re.findall(r'^(?:abstract\s+)?class\s+(\w+)', t, re.M))
    d |= set(re.findall(r'^enum\s+(\w+)', t, re.M))
    d |= set(re.findall(r'^mixin\s+(\w+)', t, re.M))
    d |= set(re.findall(r'^extension\s+(\w+)', t, re.M))
    d |= set(re.findall(r'^typedef\s+(\w+)', t, re.M))
    # variáveis e constantes de topo
    d |= set(re.findall(r'^(?:final|const)\s+(?:[\w<>?,\s]+\s)?(\w+)\s*=',
                        t, re.M))
    # funções e getters de topo
    d |= set(re.findall(r'^[\w<>?,\s]+\s(\w+)\s*\(', t, re.M))
    d |= set(re.findall(r'^[\w<>?,\s]+\sget\s+(\w+)', t, re.M))
    palavras = {'if', 'for', 'while', 'switch', 'return', 'else', 'do',
                'try', 'catch', 'assert', 'get', 'set', 'final', 'const',
                'void', 'import', 'export', 'part', 'library'}
    return {x for x in d if not x.startswith('_') and x not in palavras}


decl = {n: publicos(s) for n, s in arquivos.items()}

problemas = 0
for nome, src in arquivos.items():
    imps = [os.path.basename(x)
            for x in re.findall(r"import '(?!package:)([^']+)'", src)]
    imps = [i for i in imps if i in decl]
    corpo = re.sub(r"^import '[^']+';\n", '', src, flags=re.M)
    corpo = re.sub(r"'(?:[^'\\]|\\.)*'", "''", corpo)
    corpo = re.sub(r'//[^\n]*', '', corpo)
    for i, a in enumerate(imps):
        for b in imps[i + 1:]:
            comuns = decl[a] & decl[b]
            for c in sorted(comuns):
                usado = re.search(r'\b' + re.escape(c) + r'\b', corpo)
                marca = 'USADO — ERRO DE COMPILAÇÃO' if usado else 'não usado'
                print(f'  {nome}: "{c}" vem de {a} e de {b}  [{marca}]')
                if usado:
                    problemas += 1

print()
print('colisões que quebram a compilação:', problemas or 'nenhuma')
raise SystemExit(1 if problemas else 0)
