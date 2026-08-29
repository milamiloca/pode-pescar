"""Balanço de parênteses/chaves/colchetes em Dart, ignorando strings e
comentários. Não é um compilador — pega o erro mais comum de patch."""
import io, sys, os


def limpar(src):
    """Devolve o código com strings e comentários trocados por espaços."""
    out = []
    i, n = 0, len(src)
    while i < n:
        c = src[i]
        # comentários
        if c == '/' and i + 1 < n and src[i + 1] == '/':
            while i < n and src[i] != '\n':
                out.append(' ')
                i += 1
            continue
        if c == '/' and i + 1 < n and src[i + 1] == '*':
            j = src.find('*/', i + 2)
            j = n if j < 0 else j + 2
            out.append(' ' * (j - i))
            i = j
            continue
        # strings
        if c in '\'"' or (c == 'r' and i + 1 < n and src[i + 1] in '\'"'):
            cru = c == 'r'
            if cru:
                out.append(' ')
                i += 1
                c = src[i]
            tripla = src[i:i + 3] in ("'''", '"""')
            fecha = src[i:i + 3] if tripla else c
            out.append(' ' * len(fecha))
            i += len(fecha)
            while i < n:
                if not cru and src[i] == '\\':
                    out.append('  ')
                    i += 2
                    continue
                if not cru and src[i] == '$' and i + 1 < n and src[i + 1] == '{':
                    # interpolação: o código de dentro é balanceado, mantém
                    out.append('  ')
                    i += 2
                    prof = 1
                    while i < n and prof:
                        if src[i] == '{':
                            prof += 1
                        elif src[i] == '}':
                            prof -= 1
                        out.append(' ' if src[i] != '\n' else '\n')
                        i += 1
                    continue
                if src.startswith(fecha, i):
                    out.append(' ' * len(fecha))
                    i += len(fecha)
                    break
                out.append('\n' if src[i] == '\n' else ' ')
                i += 1
            continue
        out.append(c)
        i += 1
    return ''.join(out)


pares = {')': '(', ']': '[', '}': '{'}
falhou = False
for p in sorted(sys.argv[1:]):
    src = io.open(p, encoding='utf-8').read()
    cod = limpar(src)
    pilha, erro = [], None
    linha = 1
    for ch in cod:
        if ch == '\n':
            linha += 1
        elif ch in '([{':
            pilha.append((ch, linha))
        elif ch in ')]}':
            if not pilha or pilha[-1][0] != pares[ch]:
                erro = f'linha {linha}: {ch!r} sem par'
                break
            pilha.pop()
    if not erro and pilha:
        erro = f'nao fechou {pilha[-1][0]!r} aberto na linha {pilha[-1][1]}'
    nome = os.path.basename(p)
    if erro:
        falhou = True
        print(f'  ERRO  {nome:24s} {erro}')
    else:
        print(f'   ok   {nome:24s} {len(src):>7,} bytes')
sys.exit(1 if falhou else 0)
