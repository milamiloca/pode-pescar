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
        'revogada': 'TextoDaNorma.revogada' in b,
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

# 23. toda foto aponta para especie que existe, e declara origem
#
# Uma foto e' uma AFIRMACAO de que aquele bicho e' aquela especie. Duas
# formas de errar:
#
#   · apontar para nome cientifico que nenhuma ficha tem — a foto nunca
#     apareceria, e ninguem notaria a falta;
#   · entrar sem declarar de onde veio — que e' o mesmo defeito das
#     datas sem fonte, so' que com imagem.
#
# O arquivo tambem precisa existir em assets/especies/, senao a ficha
# mostra um buraco.
_ft = io.open(LIB + 'fotos.dart', encoding='utf-8').read()
_FOTOS = re.findall(
    r"Foto\(\s*cientifico:\s*'([^']+)',\s*arquivo:\s*'([^']+)',\s*"
    r"origem:\s*OrigemDaFoto\.(\w+)", _ft)
_nomes = set()
# especiesSoDaFoto entra aqui porque fichas.dart monta ficha para cada
# uma delas — a lista de nomes tem de ser a mesma que a das fichas, e
# nao uma copia que envelhece (foi assim que o inventario.py errou).
_SO_FOTO = re.findall(r"^\s*'([A-Z][a-z]+[^']*)',",
                      _ft.split('const especiesSoDaFoto')[1]
                      .split('];')[0], re.M) if \
    'const especiesSoDaFoto' in _ft else []
_nomes |= set(_SO_FOTO)
for _f in ('dados.dart', 'ameacadas.dart', 'catalogo.dart'):
    _t = io.open(LIB + _f, encoding='utf-8').read()
    _nomes |= set(re.findall(r"Especie\('[^']*',\s*'([^']*)'", _t))
    _nomes |= set(re.findall(r"Ameacada\(\d+,\s*'([^']*)'", _t))
    _nomes |= set(re.findall(r"^\s*'([A-Z][a-z]+ [a-z.]+)',", _t, re.M))
for _f in ('defesos.dart', 'regimes.dart'):
    for _b in re.findall(r"cientificos:\s*\[(.*?)\]",
                         io.open(LIB + _f, encoding='utf-8').read(), re.S):
        _nomes |= {x for x in re.findall(r"'([^']+)'", _b)}
_blob = ' ;; '.join(_nomes)
import os as _os
for _c, _a, _o in _FOTOS:
    if _c not in _nomes and _c not in _blob:
        erro('foto', f'"{_c}" não existe em nenhuma ficha — a foto '
                     f'{_a} nunca apareceria')
    if not _os.path.exists('pode_pescar/assets/especies/' + _a):
        erro('foto', f'o arquivo {_a} não está em assets/especies/')
    if _o not in ('orgao', 'catalogo', 'norma', 'naoDeclarada'):
        erro('foto', f'{_a}: origem "{_o}" desconhecida')
_dobrada = [c for c in {x[0] for x in _FOTOS}
            if [x[0] for x in _FOTOS].count(c) > 1]
for _c in _dobrada:
    erro('foto', f'"{_c}" tem mais de uma foto')
# 23b. a especie que entra SO' pela foto tem de ter foto, e nao pode ja'
# estar coberta por norma — senao sao duas paginas para o mesmo bicho.
_comFoto = {c for c, _, _ in _FOTOS}
_deNorma = set()
for _f in ('dados.dart', 'ameacadas.dart', 'catalogo.dart'):
    _t = io.open(LIB + _f, encoding='utf-8').read()
    _deNorma |= set(re.findall(r"Especie\('[^']*',\s*'([^']*)'", _t))
    _deNorma |= set(re.findall(r"Ameacada\(\d+,\s*'([^']*)'", _t))
    _deNorma |= set(re.findall(r"^\s*'([A-Z][a-z]+ [a-z.]+)',", _t, re.M))
for _n in _SO_FOTO:
    if _n not in _comFoto:
        erro('só-foto', f'"{_n}" entra só pela foto e NÃO TEM foto — '
                        f'a ficha nasceria vazia')
    if _n in _deNorma:
        erro('só-foto', f'"{_n}" entra só pela foto mas alguma norma já '
                        f'a nomeia — sairiam duas páginas para o mesmo bicho')
_maus23b = len([f for f in falhas if f.startswith('só-foto')])
print(f'  23b. entram só pela foto ........ '
      + (f'{len(_SO_FOTO)} conferidas, todas com foto e sem repetir ficha'
         if _maus23b == 0 else f'{_maus23b} PROBLEMA(S)'))

_maus23 = len([f for f in falhas if f.startswith('foto')])
_semOrigem = sum(1 for x in _FOTOS if x[2] == 'naoDeclarada')
print(f'  23. fotos das espécies .......... '
      + (f'{len(_FOTOS)} conferidas, {_semOrigem} com origem não declarada'
         if _maus23 == 0 else f'{_maus23} PROBLEMA(S)'))

# 22. o texto do art. 3o esta' completo e com as sete excecoes
#
# A restricao da Lista costuma ser citada so' pelo caput — "ficam
# protegidas de modo integral... proibicao de captura, transporte..." — e
# o caput sozinho e' RESTRITIVO DEMAIS: o art. 3o tem sete paragrafos de
# excecao, e dois deles decidem abordagem. O § 4o tira a captura
# incidental liberada no ato; o § 2o tira o exemplar vindo de cultivo em
# aquicultura licenciada.
#
# Falta tambem e' erro: uma pessoa parada com especie ameacada vinda de
# cultivo tem defesa na norma, e o aplicativo tem de trazer isso.
_te = io.open(LIB + 'tela_especies.dart', encoding='utf-8').read()
_faltam = [p for p in ('§ 1º', '§ 2º', '§ 3º', '§ 4º', '§ 5º', '§ 6º',
                       '§ 7º') if p not in _te]
if _faltam:
    erro('art. 3º',
         f'o texto do art. 3º da Portaria 1.666 está no aplicativo sem '
         f'{", ".join(_faltam)} — o caput sozinho proíbe mais do que a '
         f'norma proíbe')
for _chave, _porque in (
        ('cultivo na aquicultura', 'o § 2º tira o exemplar de cultivo'),
        ('capturados incidentalmente', 'o § 4º tira a captura incidental'),
        ('art. 4º', 'sem o art. 4º o art. 3º proíbe onde há Plano')):
    if _chave not in _te:
        erro('art. 3º', f'falta "{_chave}" no texto da regra — {_porque}')
_maus22 = len([f for f in falhas if f.startswith('art. 3º')])
print(f'  22. texto do art. 3º ............ '
      + ('caput e os sete parágrafos' if _maus22 == 0
         else f'{_maus22} PROBLEMA(S)'))

# 21. a matriz x a Lista: o cruzamento existe e nao esta' vazio
#
# O aplicativo tinha as duas coisas — a matriz da IN 10/2011 e a Lista da
# Portaria 1.667/2026 — e nunca as encostou. Trinta e tres especies da
# Lista sao nomeadas na matriz, dezoito delas como ESPECIE-ALVO,
# inclusive tubaroes CR na modalidade 2.1.
#
# Esta prova garante que o cruzamento continua achando o que deve achar.
# Se cair para zero, ou o codigo quebrou ou alguem mudou a grafia de um
# nome cientifico nos dois lados — e o aviso some da tela em silencio.
_ame = io.open(LIB + 'ameacadas.dart', encoding='utf-8').read()
_LST = {}
for _m in re.finditer(r"Ameacada\((\d+),\s*'([^']*)'((?:,[^,)]*){4,8})\)", _ame):
    _c = re.search(r"'(CR|EN|VU|EW|EX|RE)'", _m.group(3))
    if _c:
        _LST[_m.group(2).strip()] = _c.group(1)
_dd = io.open(LIB + 'dados.dart', encoding='utf-8').read()
_corpo = _dd.split('const List<Modalidade> modalidades = [')[1]
_cruz, _comoAlvo = set(), set()
for _num, _b in re.findall(
        r"Modalidade\(\s*\n\s*'([\d.A-Za-z-]+)',(.*?)\n  \),", _corpo, re.S):
    for _f in ('alvo', 'incidental', 'acompanhante', 'complementar'):
        _mm = re.search(r"\n    " + _f + r":\s*((?:'(?:[^'\\]|\\.)*'\s*)+),", _b)
        if not _mm:
            continue
        _t = ''.join(re.findall(r"'((?:[^'\\]|\\.)*)'", _mm.group(1)))
        for _cient in _LST:
            if _cient in _t:
                _cruz.add(_cient)
                if _f == 'alvo':
                    _comoAlvo.add(_cient)
if len(_cruz) < 25:
    erro('matriz x Lista',
         f'o cruzamento achou só {len(_cruz)} espécies da Lista dentro da '
         f'matriz — eram 33. Ou o código quebrou, ou a grafia de um nome '
         f'científico mudou de um lado só')
if not _comoAlvo:
    erro('matriz x Lista',
         'nenhuma espécie da Lista aparece como espécie-alvo — eram 18. '
         'Confira antes de acreditar')
print(f'  21. matriz x Lista .............. {len(_cruz)} espécies da Lista '
      f'na matriz, {len(_comoAlvo)} como espécie-alvo')

# 20. campo de NOME DE NORMA nao aceita prosa
#
# Aconteceu e a Camila viu na tela: o campo `ordenamento` de um Plano
# recebeu a frase "NAO LOCALIZADA. A Portaria Interministerial no 59-B...
# que o aplicativo chegou a atribuir aos budioes em geral...". Esse campo
# alimenta a lista de normas, entao a frase inteira virou o NOME de uma
# norma na tela.
#
# E ha' um agravante: quando duas grafias da mesma norma se encontram,
# normas.dart fica com A MAIS LONGA (para preferir "de 9 de novembro de
# 2018" a "59-B/2018"). Isso faz a prosa GANHAR da grafia limpa. Foi o
# que aconteceu: uma frase substituiu o nome de uma norma federal.
#
# A regra: o campo tem de COMECAR com um tipo de norma.
_TIPOS = (r'(Lei|Decreto|Decreto-lei|Portaria|Instrução Normativa|IN |INI |'
          r'Resolução|Medida Provisória)')
_ALVOS = [('regimes.dart', PLA, ['ordenamento', 'ato']),
          ('defesos.dart', DEF, ['norma']),
          ('periodos.dart', PER, ['norma']),
          ('areas.dart', ARE, ['norma'])]
_n20 = 0
for _arq, _itens, _chaves in _ALVOS:
    for _it in _itens:
        for _k in _chaves:
            _v = (_it.get(_k) or '').strip()
            if not _v:
                continue
            _n20 += 1
            # o nome que a lista mostra e' o pedaco ANTES do travessao —
            # normas.dart corta ali. Se o pedaco vier longo demais, e'
            # porque ha' explicacao colada no nome, sem separador.
            _curto = _v.split(' — ')[0].split(', que ')[0]
            if len(_curto) > 90:
                erro('nome de norma',
                     f'{_arq}: campo {_k} tem {len(_curto)} caracteres antes '
                     f'do travessão — "{_curto[:60]}...". Separe a explicação '
                     f'com " — ", que é onde normas.dart corta')
            if not re.match(r'^' + _TIPOS, _v):
                erro('nome de norma',
                     f'{_arq}: campo {_k} começa com prosa — "{_v[:56]}...". '
                     f'Esse campo vira o nome da norma na lista, e a grafia '
                     f'mais longa vence a limpa. Mova o texto para um campo '
                     f'de prosa e deixe aqui só o nome, ou vazio')
_maus20 = len([f for f in falhas if f.startswith('nome de norma')])
print(f'  20. campo de nome de norma ...... '
      + (f'{_n20} conferidos, todos com nome' if _maus20 == 0
         else f'{_maus20} COM PROSA'))

# 19. borra de PDF dentro de campo de dado
#
# Aconteceu ao trazer a redacao nova das modalidades: a extracao do DOU
# levou, junto com a "Area de operacao" da modalidade 3.13, TODO o rodape
# do PDF — o Anexo III, o Anexo IV, o formulario de declaracao de entrada
# em empresa pesqueira e o "Este conteudo nao substitui o publicado na
# versao certificada". Meia pagina de texto virou area de operacao.
#
# Ninguem le' isso e acha bonito, mas o problema nao e' estetico: e' o
# aplicativo afirmando, num campo normativo, coisa que a norma nao diz
# daquele campo.
_SUJEIRA = [r'ANEXO [IVX]+', r'Page \d+ of \d+', r'in\.gov\.br',
            r'\d{2}/\d{2}/\d{2},\s*\d{2}:\d{2}', r'Imprensa Nacional',
            r'Este conteúdo não substitui', r'DECLARAÇÃO DE ENTRADA']
_txt = io.open(LIB + 'dados.dart', encoding='utf-8').read()
_achados = 0
for _m in re.finditer(r"'((?:[^'\\]|\\.){20,})'", _txt):
    for _p in _SUJEIRA:
        if re.search(_p, _m.group(1)):
            _achados += 1
            erro('borra de PDF',
                 f'campo com "{_p}" dentro: "{_m.group(1)[:70]}..." — '
                 f'sobra de extração, não é texto de norma')
            break
print(f'  19. borra de PDF em dados.dart .. '
      + ('nenhuma' if _achados == 0 else f'{_achados} CAMPO(S) SUJO(S)'))

# 18. o aplicativo nao da' palpite
#
# Aconteceu, e ficou meses no ar: o plano da gurijuba dizia "A especie e'
# do litoral Norte; PROVAVELMENTE nao alcanca Santa Catarina". Isso nao
# saiu de norma nenhuma — saiu do que quem escreveu sabia sobre onde o
# peixe vive. E o efeito e' permissivo: quem le' "provavelmente nao
# alcanca" conclui que nao precisa abrir a norma.
#
# Esta prova le' os CAMPOS DE DADOS (nao os comentarios) e falha se
# achar palavra de palpite. Se algum dia uma norma usar uma dessas
# palavras no proprio texto, cite-a entre aspas no campo detalhe, que
# nao e' varrido aqui.
_PALPITE = ['provavelmente', 'possivelmente', 'presumivelmente',
            'deve alcançar', 'não deve alcançar', 'acredito', 'imagino',
            'em tese', 'tipicamente', 'ao que tudo indica', 'creio']
_CAMPOS = [('regimes.dart', PLA, ['abrang', 'especie']),
           ('periodos.dart', PER, ['onde', 'detalhe', 'especie']),
           ('defesos.dart', DEF, ['abrang', 'periodo', 'titulo']),
           ('areas.dart', ARE, ['onde', 'proibe', 'titulo'])]
_n = 0
for arq, itens, chaves in _CAMPOS:
    for it in itens:
        for k in chaves:
            t = (it.get(k) or '').lower()
            _n += 1
            for w in _PALPITE:
                if w in t:
                    erro('palpite', f'{arq}: "{it.get(chaves[-1], "?")[:34]}" '
                                    f'usa "{w}" no campo {k} — o aplicativo '
                                    f'não opina, ou cita norma ou diz que '
                                    f'não sabe')
_maus18 = len([f for f in falhas if f.startswith('palpite')])
print(f'  18. palpite nos campos .......... '
      + (f'nenhum em {_n} campos' if _maus18 == 0
         else f'{_maus18} PALPITE(S) em {_n} campos'))

# 17. as modalidades com redacao nova precisam existir na matriz
#
# O selo "texto alterado" aponta para uma linha da matriz. Se o numero no
# mapa nao corresponder a nenhuma modalidade, o selo nao aparece em lugar
# nenhum e o aviso se perde em silencio — que e' a falha que este
# aplicativo mais tenta evitar.
_dados = io.open(LIB + 'dados.dart', encoding='utf-8').read()
_ALT = re.findall(r"^\s*'([\d.]+)':\s*'", _dados.split(
    'const redacaoDe')[1].split('};')[0], re.M)
# o código pode ter letra: a modalidade 2.2-A, emalhe anilhado, entrou
# pela Portaria Interministerial nº 24/2018. Uma expressão só de dígitos
# a perdia em silêncio — a asserção abaixo é o que apanhou isso.
_NUMS = set(re.findall(r"\n  Modalidade\(\s*\n\s*'([\d.A-Za-z-]+)'", _dados))
assert len(_NUMS) == _dados.count('\n  Modalidade('), (
    f'prova 17: li {len(_NUMS)} modalidades mas o arquivo tem '
    f'{_dados.count(chr(10) + "  Modalidade(")} — a expressão está '
    f'subcontando, conserte-a antes de confiar nesta prova')
for c in _ALT:
    if c not in _NUMS:
        erro('modalidade alterada',
             f'"{c}" está no mapa redacaoDe mas não existe na '
             f'matriz — o selo não apareceria em lugar nenhum')
if len(_ALT) != len(set(_ALT)):
    erro('modalidade alterada', 'número repetido no mapa')
print(f'  17. modalidades alteradas ....... {len(_ALT)} marcadas, '
      f'todas existem na matriz de {len(_NUMS)}')

# 16. o catalogo nao pode abrir pagina dobrada
#
# Aconteceu na geracao: "Mugil liza" e "Atherinella brasiliensis" entraram
# como candidatas porque a ficha da tainha e a do peixe-rei guardam o
# cientifico COMPOSTO ("Mugil platanus / Mugil liza"). Se tivessem
# passado, o aplicativo teria duas paginas para a tainha — a especie mais
# importante do trabalho inteiro. "Pogonias cromis" e' o mesmo caso, por
# sinonimia, e sai a mao.
#
# Esta prova falha se qualquer nome do catalogo aparecer dentro do
# cientifico de uma ficha que ja' existe.
CAT = re.findall(r"^\s*'([^']+)',", io.open(LIB+'catalogo.dart',encoding='utf-8').read(), re.M)
cients = [c for _, c, _ in re.findall(
    r"Especie\('([^']*)',\s*'([^']*)',\s*(\d+)", io.open(LIB+'dados.dart',encoding='utf-8').read())]
cients += [c for _, c in re.findall(
    r"Ameacada\((\d+),\s*'([^']*)'", io.open(LIB+'ameacadas.dart',encoding='utf-8').read())]
_blob = ' ;; '.join(cients)
for c in CAT:
    if c in _blob:
        dono = [f for f in cients if c in f]
        erro('catálogo', f'"{c}" já está coberto pela ficha {dono} — '
                         f'abriria página dobrada')
_vistos = set()
for c in CAT:
    if c in _vistos:
        erro('catálogo', f'"{c}" repetido no catálogo')
    _vistos.add(c)
_semNome = [c for c in CAT if f"'{c}':" not in io.open(LIB+'nomes.dart',encoding='utf-8').read()]
if _semNome:
    erro('catálogo', f'{len(_semNome)} do catálogo não estão na Portaria '
                     f'532: {_semNome[:4]}')
_maus = len([f for f in falhas if f.startswith('catálogo')])
print(f'  16. catálogo de nomes ........... {len(CAT)} espécies, '
      + ('nenhuma dobrada' if _maus == 0 else f'{_maus} PROBLEMA(S)'))

# 15. nada de entrada repetida
#
# Aconteceu: a lula ja' estava no aplicativo, vinda da compilacao, e uma
# segunda entrada foi acrescentada por cima sem ninguem conferir. Duas
# linhas para a mesma regra no calendario e' ruim de duas maneiras — a
# contagem mente ("2 de 3 fechadas hoje") e quem le acha que sao regras
# diferentes.
import unicodedata


def _mesmo_bicho(a, b):
    """"Lula" e "Lulas" são o mesmo bicho; "Tainha" e "Sardinha" não."""
    def limpo(x):
        x = unicodedata.normalize('NFKD', x).encode('ascii', 'ignore').decode()
        x = x.lower().strip().rstrip('s')
        return x
    return limpo(a) == limpo(b)


# mesma norma + mesmas datas + mesmo tipo: pode ser duplicata, pode ser
# modalidade diferente. Só é falha quando a espécie também é a mesma.
por_norma = {}
for p in PER:
    k = (p['norma'].strip(), p['de'], p['ate'], p['tipo'])
    por_norma.setdefault(k, []).append(p)
for k, lista in por_norma.items():
    if len(lista) < 2:
        continue
    for i in range(len(lista)):
        for j in range(i + 1, len(lista)):
            a, b = lista[i], lista[j]
            # No calendário isto é AVISO, não falha: a tainha tem, de
            # propósito, duas linhas com a mesma norma e as mesmas datas
            # — uma por modalidade. Não dá para distinguir por máquina o
            # desdobramento proposital da duplicata acidental; dá para
            # colocar as duas à vista de quem lê.
            aviso('repetido',
                  f'calendário: "{a["especie"]}" ({a["detalhe"][:34]}) e '
                  f'"{b["especie"]}" ({b["detalhe"][:34]}) dividem norma, '
                  f'datas e tipo — modalidades diferentes, ou duplicata?')

por_norma_d = {}
for d in DEF:
    if d['norma'].strip():
        por_norma_d.setdefault(d['norma'].strip(), []).append(d['titulo'])
for norma, titulos in por_norma_d.items():
    for i in range(len(titulos)):
        for j in range(i + 1, len(titulos)):
            if _mesmo_bicho(titulos[i], titulos[j]):
                erro('repetido', f'defeso: "{titulos[i]}" e "{titulos[j]}" '
                                 f'são a mesma coisa, pela mesma norma')

vistosa = {}
for a in ARE:
    k = (a['norma'].strip(), a['artigo'].strip())
    if k in vistosa:
        erro('repetido', f'área: "{a["titulo"]}" e "{vistosa[k]}" são a mesma '
                         f'norma e o mesmo artigo')
    else:
        vistosa[k] = a['titulo']
print(f'  15. entradas repetidas ........... nenhuma em '
      f'{len(PER)} períodos, {len(DEF)} defesos, {len(ARE)} áreas')

# 14. a tabela de nomes da Portaria 532 esta sa
#
# Nasceu da busca por "carapeba" nao devolver nada. Se a tabela quebrar
# na geracao, o app volta a responder silencio — e silencio, aqui, e' a
# resposta que libera quem nao deveria ser liberado.
tn = io.open(LIB + 'nomes.dart', encoding='utf-8').read()
pares = re.findall(r"^  '([^']+)': \[([^\]]*)\],$", tn, re.M)
if len(pares) < 400:
    erro('nomes', f'nomes.dart tem só {len(pares)} espécies — a geração quebrou')
maus = 0
for cient, comuns in pares:
    if not re.match(r"^[A-Z][a-z]+ (?:[a-zç][a-zç-]+|spp\.|sp\.)", cient):
        erro('nomes', f'"{cient}" não parece nome científico')
        maus += 1
    if not comuns.strip():
        erro('nomes', f'"{cient}" está sem nome comum')
        maus += 1
    if maus > 6:
        break
# a busca precisa achar o caso que originou tudo isto
tem_carapeba = any('Carapeba' in c for _, c in pares)
if not tem_carapeba:
    erro('nomes', 'a carapeba sumiu da tabela — foi ela que originou o caso')
print(f'  14. tabela de nomes .............. {len(pares)} espécies, carapeba presente')

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

# 13b. a MESMA familia: aspa escapada duas vezes.
#
# Aconteceu ao gerar o fotos.dart: o texto da duvida da miraguaia saiu
# com \\' onde devia sair \'. Em Dart isso e' barra invertida seguida de
# fim de string — nao compila, ou compila errado. E' o mesmo defeito do
# \\n: um gerador escapando o que ja' estava escapado.
_barras = 0
for _f in glob.glob(LIB + '*.dart'):
    _t = io.open(_f, encoding='utf-8').read()
    for _seq, _oque in ((r"\\\\'", "aspa escapada duas vezes"),
                        (r'\\\\n', 'quebra de linha escapada duas vezes')):
        _n = len(re.findall(_seq, _t))
        if _n:
            _barras += _n
            erro('escape', f'{_f.split("/")[-1]}: {_n}x {_oque} — '
                           f'gerador escapou o que já estava escapado')
print(f'  13b. escape duplicado ........... '
      + ('nenhum' if _barras == 0 else f'{_barras} OCORRÊNCIA(S)'))


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
    if not a['lida'] and not a['revogada'] and 'não obtido' not in a['proibe'] \
            and 'a obter' not in a['artigo']:
        erro('área', f'"{a["titulo"][:40]}" não teve o texto lido mas '
                     f'afirma a regra sem ressalva')
    # a norma revogada TEM texto lido; o que ela nao pode e' ser lida
    # como regra em vigor. Entao a proibicao precisa dizer que caiu, e o
    # campo da norma precisa carregar a palavra.
    if a['revogada'] and ('REVOGADA' not in a['norma'].upper()
                          or 'NÃO ESTÁ MAIS EM VIGOR' not in a['proibe'].upper()):
        erro('área', f'"{a["titulo"][:40]}" está marcada como revogada mas '
                     f'não diz isso no campo da norma e na proibição')
sazo = sum(1 for a in ARE if a['de'])
_rev = sum(1 for a in ARE if a['revogada'])
print(f'  12. restrições de área ............ {len(ARE)} conferidas, '
      f'{sazo} com período, {_rev} de norma revogada')

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
