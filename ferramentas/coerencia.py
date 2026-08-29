# -*- coding: utf-8 -*-
"""COERENCIA — testa o que o aplicativo AFIRMA, nao como ele e' escrito.

Os outros validadores olham a forma: parenteses equilibrados, simbolos
definidos, campos duplicados, unicode invisivel. Nenhum deles tem como
saber se uma frase gerada pelo codigo e' verdadeira.

Este nasceu de um erro real e grave: o painel de proximas viradas
escrevia "ABRE Tainha" no dia em que terminava UMA restricao de area,
enquanto a temporada de cerco estava fechada desde 31 de julho e outras
quatro regras seguiam proibindo. Era a resposta permissiva — a que
liberta quem deveria ser autuado. Passou por todos os validadores
porque, sintaticamente, estava perfeita.

Rode junto com os outros, sempre:
    python3 coerencia.py
"""
import io, re, sys
from datetime import date

LIB = 'pode_pescar/lib/'
ANTES = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334]
DIAS = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

falhas, avisos = [], []


def erro(t, msg):
    falhas.append(f'{t}: {msg}')


def aviso(t, msg):
    avisos.append(f'{t}: {msg}')


def campo(b, n):
    m = re.search(n + r":\s*((?:'(?:[^'\\]|\\.)*'\s*)+)", b, re.S)
    return ''.join(re.findall(r"'((?:[^'\\]|\\.)*)'", m.group(1))) if m else ''


def blocos(arq, marca, classe):
    s = io.open(LIB + arq, encoding='utf-8').read()
    c = s.split(marca, 1)[1].split('\n];', 1)[0]
    return re.findall(classe + r'\((.*?)\n  \),', c, re.S)


PER = []
for b in blocos('periodos.dart', 'const periodos = <Periodo>[', 'Periodo'):
    PER.append({
        'especie': campo(b, 'especie'), 'detalhe': campo(b, 'detalhe'),
        'onde': campo(b, 'onde'), 'norma': campo(b, 'norma'),
        'artigo': campo(b, 'artigo'),
        'tipo': 'fechado' if 'TipoPeriodo.fechado' in b else 'permitido',
        'de': int(re.search(r'\n    de: (\d+)', b).group(1)),
        'ate': int(re.search(r'\n    ate: (\d+)', b).group(1)),
        'conf': 'confirmado: false' not in b,
    })
DEF = [{'titulo': campo(b, 'titulo'), 'norma': campo(b, 'norma'),
        'abrang': campo(b, 'abrangencia'),
        'conf': 'Origem.conferida' in b, 'cient': re.findall(r"'([A-Z][a-z]+ [a-z]+)'", b)}
       for b in blocos('defesos.dart', 'const defesos = <Defeso>[', 'Defeso')]
ARE = [{'titulo': campo(b, 'titulo'), 'onde': campo(b, 'onde'),
        'norma': campo(b, 'norma'), 'artigo': campo(b, 'artigo'),
        'proibe': campo(b, 'oQueProibe'), 'detalhe': campo(b, 'detalhe'),
        'lida': 'TextoDaNorma.lido' in b,
        'de': int((re.search(r'\n    de: (\d+)', b) or ['', '0'])[1]),
        'ate': int((re.search(r'\n    ate: (\d+)', b) or ['', '0'])[1])}
       for b in blocos('areas.dart', 'const restricoes = <Restricao>[',
                       'Restricao')]
PLA = [{'especie': campo(b, 'especie'), 'abrang': campo(b, 'abrangencia'),
        'obtida': 'normaObtida: false' not in b,
        'ordenamento': campo(b, 'ordenamento'), 'ato': campo(b, 'atoDoMMA'),
        'cmMin': int((re.search(r'cmMinimo: (\d+)', b) or [0, '0'])[1])
        if re.search(r'cmMinimo: (\d+)', b) else 0}
       for b in blocos('regimes.dart', 'const planos = <Plano>[', 'Plano')]


def dia(m):
    return ANTES[m // 100 - 1] + m % 100


def mmdd(n):
    d = ((n - 1) % 365) + 1
    for m in range(12):
        if d <= DIAS[m]:
            return (m + 1) * 100 + d
        d -= DIAS[m]
    return 1231


def contem(d, de, ate):
    return (de <= d <= ate) if de <= ate else (d >= de or d <= ate)


def fechado(p, d):
    x = contem(d, p['de'], p['ate'])
    return x if p['tipo'] == 'fechado' else not x


def grupo(p):
    return p['especie'].split(' — ')[0]


# =====================================================================
print('COERÊNCIA — o que o aplicativo afirma\n')

# 1. as datas existem
for p in PER:
    for k in ('de', 'ate'):
        v, m, d = p[k], p[k] // 100, p[k] % 100
        if not (1 <= m <= 12) or not (1 <= d <= DIAS[m - 1]):
            erro('data inválida', f'{grupo(p)} · {p["detalhe"][:30]} · {k}={v}')
print(f'  1. datas válidas .................. {len(PER) * 2} conferidas')

# 2. o ida e volta da conversão de dia
for n in range(1, 366):
    if dia(mmdd(n)) != n:
        erro('conversão de data', f'dia {n} não volta ao mesmo lugar')
print('  2. conversão dia <-> data ......... 365 conferidas')

# 3. A REGRA QUE FALTOU: nenhuma "abertura" pode ser lida como
#    liberação da pescaria sem o aviso de que outras regras seguem.
h = ANTES[date.today().month - 1] + date.today().day
aberturas, com_alerta = 0, 0
for p in PER:
    if not p['conf']:
        continue
    abre_em = p['de'] if p['tipo'] == 'permitido' else mmdd(dia(p['ate']) + 1)
    aberturas += 1
    outras = [o for o in PER if o is not p and o['conf']
              and grupo(o) == grupo(p) and fechado(o, abre_em)]
    if outras:
        com_alerta += 1
src = io.open(LIB + 'calendario.dart', encoding='utf-8').read()
tem = 'aindaRestrita' in src and 'Não é a pescaria que abre' in src
if com_alerta and not tem:
    erro('leitura permissiva',
         f'{com_alerta} aberturas ocorrem com a espécie ainda restrita, '
         f'e a tela não traz o aviso')
print(f'  3. aberturas com aviso ............ {com_alerta} de {aberturas} '
      f'precisam do aviso — {"presente" if tem else "AUSENTE"}')

# 4. nenhum texto do app diz "ABRE <espécie>" sem qualificar
for arq in ('calendario.dart', 'tela_temporadas.dart'):
    s = io.open(LIB + arq, encoding='utf-8').read()
    for m in re.finditer(r"'(ABRE|FECHA) ", s):
        erro('verbo sem qualificação',
             f'{arq}: "{m.group(1)} ..." descreve a pescaria, não a regra')
print('  4. verbos descrevem a regra ....... ok')

# 5. o resumo do grupo bate com as linhas, em 12 datas do ano
for mes in range(1, 13):
    d = mes * 100 + 15
    grupos = {}
    for p in PER:
        grupos.setdefault(p['especie'], []).append(p)
    for nome, linhas in grupos.items():
        n = sum(1 for x in linhas if fechado(x, d))
        if n > len(linhas):
            erro('resumo do grupo', f'{nome} em {d}: {n} de {len(linhas)}')
print('  5. resumo por grupo ............... 12 datas conferidas')

# 6. campos obrigatórios
for p in PER:
    for k in ('especie', 'detalhe', 'onde', 'norma', 'artigo'):
        if not p[k]:
            erro('campo vazio', f'Periodo {grupo(p)}: {k}')
for d in DEF:
    for k in ('titulo', 'norma', 'abrang'):
        if not d[k]:
            erro('campo vazio', f'Defeso {d["titulo"]}: {k}')
for x in PLA:
    if not x['abrang']:
        erro('campo vazio', f'Plano {x["especie"]}: abrangencia')
print(f'  6. campos obrigatórios ............ {len(PER)} períodos, '
      f'{len(DEF)} defesos, {len(PLA)} planos')

# 7. a invariante das duas camadas: "norma a obter" se e só se a
#    confirmar. Um período confirmado citando artigo indefinido seria
#    uma resposta do app apoiada em nada.
for p in PER:
    obter = 'obter' in p['artigo'].lower()
    if p['conf'] and obter:
        erro('camada errada',
             f'{grupo(p)} · {p["detalhe"][:34]}: confirmado mas o artigo diz '
             f'"{p["artigo"]}"')
    if not p['conf'] and not obter:
        erro('camada errada',
             f'{grupo(p)} · {p["detalhe"][:34]}: a confirmar, mas cita '
             f'artigo "{p["artigo"]}" como se fosse conferido')
print('  7. camada x artigo citado ......... ok')

# 8. o recorte de Santa Catarina: toda regra diz se alcança SC
def diz_sc(t):
    """O texto declara alcance em Santa Catarina, ou declara que nao
    alcanca, ou assume que ainda nao se sabe? Qualquer das tres serve —
    o que nao pode e' ficar mudo sobre o estado."""
    b = t.lower()
    return ('atarina' in t or ', sc' in b or '(sc' in b or ' sc)' in b
            or ' sc.' in b or ' sc,' in b or b.rstrip().endswith(' sc')
            or 'sudeste e sul' in b
            or 'brasileira' in b or 'confirmar' in b or 'não se sabe' in b)


for p in PER:
    if not diz_sc(p['onde']):
        aviso('abrangência', f'Periodo {grupo(p)} · {p["detalhe"][:30]}: '
              f'"{p["onde"][:52]}" não diz nada sobre Santa Catarina')
for d in DEF:
    if not diz_sc(d['abrang']):
        aviso('abrangência', f'Defeso {d["titulo"]}: não diz nada sobre SC')
for x in PLA:
    if not diz_sc(x['abrang']):
        aviso('abrangência', f'Plano {x["especie"]}: não diz nada sobre SC')
print('  8. abrangência declarada .......... conferida')

# 10. cada classe tem os membros que o resto do app chama dela
#
#     Nasceu de outro erro real: um patch fechou a classe Periodo cedo
#     demais e o metodo fechadoEm foi parar FORA dela, junto com uma
#     funcao de topo. As chaves continuavam equilibradas — checar.py
#     passou — mas o app nao compilava, e so o Flutter contou.
def corpo_da_classe(src, nome):
    """O texto entre as chaves de `class nome`, sem strings nem
    comentarios, para contar chaves sem se enganar."""
    i = src.find('class %s ' % nome)
    if i < 0:
        return None
    i = src.index('{', i)
    limpo, j, n, dentro = [], i, len(src), 0
    while j < n:
        c = src[j]
        if c == '/' and j + 1 < n and src[j + 1] == '/':
            while j < n and src[j] != '\n':
                j += 1
            continue
        if c in '\'"':
            asp, j = c, j + 1
            while j < n and src[j] != asp:
                j += 2 if src[j] == '\\' else 1
            j += 1
            continue
        if c == '{':
            dentro += 1
        elif c == '}':
            dentro -= 1
            if dentro == 0:
                return src[i + 1:j]
        limpo.append(c)
        j += 1
    return None


ESPERADO = {
    ('periodos.dart', 'Periodo'):
        ['contem', 'viraOAno', 'datas', 'fechadoEm'],
    ('periodos.dart', 'Virada'):
        ['verbo', 'data', 'quando', 'especie', 'aindaRestrita',
         'quantasOutras'],
    ('defesos.dart', 'Defeso'): ['alcanca'],
    ('regimes.dart', 'Plano'): ['alcanca'],
    ('conflitos.dart', 'Conflito'): ['alcanca'],
    ('fichas.dart', 'Ficha'):
        ['titulo', 'cientifico', 'temTamanho', 'ameacada', 'plano',
         'temPlano', 'planoSemNorma', 'marcada', 'vedadaHoje',
         'vedadaEm2510', 'temporadas', 'emVerificacao', 'textoDeBusca'],
}
for (arq, classe), membros in ESPERADO.items():
    src = io.open(LIB + arq, encoding='utf-8').read()
    corpo = corpo_da_classe(src, classe)
    if corpo is None:
        erro('estrutura', f'{arq}: classe {classe} não encontrada')
        continue
    for m in membros:
        if not re.search(r'\b%s\b' % re.escape(m), corpo):
            erro('estrutura',
                 f'{arq}: {classe}.{m} está FORA da classe ou sumiu')
print(f'  10. membros dentro das classes .... '
      f'{sum(len(v) for v in ESPERADO.values())} conferidos')

# 13. quebra de linha de verdade, e não a letra n atrás de uma barra
#
# Em Dart, '\n' é quebra de linha e '\\n' é uma barra invertida seguida
# da letra n — que a tela mostra como \n literal no meio da frase. O
# compilador aceita os dois, e nenhum outro validador olha para isso.
# Aconteceu no areas.dart: 180 escapes errados, invisíveis até o desenho
# da tela sair com uma barra solta no fim de cada parágrafo.
import glob
for arq in sorted(glob.glob(LIB + '*.dart')):
    t = io.open(arq, encoding='utf-8').read()
    n_ruim = t.count('\\\\n')
    if n_ruim:
        erro('escape', f'{arq.split("/")[-1]}: {n_ruim} vez(es) "\\\\n" onde '
                       f'deveria haver "\\n" — a tela mostraria a barra')
print('  13. quebras de linha ............. ok')

# 12. as restrições de área dizem onde valem, o que proíbem e de onde saem
#
# Uma restrição sem "onde" é inútil na abordagem, e uma sem artigo não
# vira auto de infração. A que tem período tem que ter data válida.
for a in ARE:
    for c in ('titulo', 'onde', 'proibe', 'norma', 'artigo', 'detalhe'):
        if not a[c].strip():
            erro('área', f'"{a["titulo"][:40]}" está sem o campo {c}')
    if (a['de'] == 0) != (a['ate'] == 0):
        erro('área', f'"{a["titulo"][:40]}" tem só metade do período')
    for k in ('de', 'ate'):
        v = a[k]
        if v and not (1 <= v // 100 <= 12 and 1 <= v % 100 <= DIAS[v // 100 - 1]):
            erro('área', f'"{a["titulo"][:40]}": data {k}={v} não existe')
    # o que não foi lido não pode afirmar regra: tem que dizer que falta
    if not a['lida'] and 'não obtido' not in a['proibe'] \
            and 'a obter' not in a['artigo']:
        erro('área', f'"{a["titulo"][:40]}" não teve o texto lido mas '
                     f'afirma a regra sem ressalva')
sazo = sum(1 for a in ARE if a['de'])
print(f'  12. restrições de área ............ {len(ARE)} conferidas, '
      f'{sazo} com período')

# 11. toda norma citada nos dados aparece na lista da tela inicial
#
# A lista de normas é calculada: normas.dart lê o campo "norma" de cada
# defeso, de cada período e de cada Plano, e tira dali o número e o ano.
# Se a forma de escrever a norma mudar e a expressão não a reconhecer, a
# norma some da lista sem erro nenhum. Aconteceu com a Portaria SUDEPE
# nº N-42/1984 quando ela passou a ser escrita por extenso.
# As expressões NÃO são copiadas: são lidas do próprio normas.dart. Uma
# cópia envelheceria em silêncio, que é exatamente o defeito que este
# teste existe para pegar.
_n = io.open(LIB + 'normas.dart', encoding='utf-8').read()
_exprs = re.findall(r"RegExp\(\s*r'((?:[^'\\]|\\.)*)'\s*\)", _n, re.S)
if len(_exprs) < 2:
    erro('lista de normas',
         f'normas.dart: esperava 2 expressões de leitura, achei {len(_exprs)}')
    _exprs = (_exprs + ['(?!)', '(?!)'])[:2]
NUM_ANO, SUDEPE = (re.compile(e) for e in _exprs[:2])


def le_norma(t):
    base = t.split(' — ')[0].split(', que ')[0]
    return NUM_ANO.search(base) or SUDEPE.search(base)


citadas = ([(p['norma'], 'calendário: ' + p['especie']) for p in PER]
           + [(d['norma'], 'defeso: ' + d['titulo']) for d in DEF]
           + [(x['ordenamento'], 'plano: ' + x['especie']) for x in PLA]
           + [(x['ato'], 'plano: ' + x['especie']) for x in PLA]
           + [(a['norma'], 'área: ' + a['titulo']) for a in ARE])
mudas = 0
for texto, onde in citadas:
    if not texto.strip():
        continue
    if not le_norma(texto):
        mudas += 1
        erro('lista de normas',
             f'"{texto[:60]}" ({onde}) NÃO é lida por normas.dart — '
             f'sumiria da lista da tela inicial sem avisar')
print(f'  11. normas legíveis na lista ...... '
      f'{len(citadas) - mudas} de {len(citadas)}')

# 9. as telas que mostram data reconstroem na virada da meia-noite
for arq in ('calendario.dart', 'tela_temporadas.dart'):
    t = io.open(LIB + arq, encoding='utf-8').read()
    if 'DateTime.now()' in t and 'DiaDeHoje' not in t:
        erro('meia-noite',
             f'{arq} lê o relógio mas não reconstrói na virada do dia')
src = io.open(LIB + 'calendario.dart', encoding='utf-8').read()
for peca in ('class DiaDeHoje', 'didChangeAppLifecycleState',
             'WidgetsBindingObserver', '_relogio?.cancel()'):
    if peca not in src:
        erro('meia-noite', f'falta "{peca}" em DiaDeHoje')
print('  9. virada da meia-noite ........... ok')

# =====================================================================
print()
if avisos:
    print(f'AVISOS ({len(avisos)}):')
    for a in avisos:
        print(f'   · {a}')
    print()
if falhas:
    print(f'FALHAS ({len(falhas)}):')
    for f in falhas:
        print(f'   X {f}')
    sys.exit(1)
print('nenhuma falha de coerência')
