# -*- coding: utf-8 -*-
"""Inventario de normas: o que o aplicativo usa e o que falta.

Sai dos dados, nunca escrito a mao. Uma lista de normas mantida a mao
envelhece em silencio — foi o que aconteceu com a base normativa da tela
inicial, que dizia cinco quando o app ja citava vinte.

A chave de cada norma e' (numero, ano), nao o texto: "Portaria
Interministerial no 24/2018" e "Portaria Interministerial no 24, de 15
de maio de 2018" sao a mesma norma escrita de dois jeitos.
"""
import io, re, json

LIB = 'pode_pescar/lib/'


def campo(b, n):
    m = re.search(n + r":\s*((?:'(?:[^'\\]|\\.)*'\s*)+)", b, re.S)
    return ''.join(re.findall(r"'((?:[^'\\]|\\.)*)'", m.group(1))
                   ).replace("\\'", "'") if m else ''


def blocos(arq, marca, classe):
    s = io.open(LIB + arq, encoding='utf-8').read()
    c = s.split(marca, 1)[1].split('\n];', 1)[0]
    return re.findall(classe + r'\((.*?)\n  \),', c, re.S)


# As duas expressões vêm do próprio normas.dart. Ter uma cópia aqui já
# custou uma norma sumida da lista sem aviso — a Portaria SUDEPE nº
# N-42/1984, quando passou a ser escrita por extenso.
_EXPRS = re.findall(r"RegExp\(\s*r'((?:[^'\\]|\\.)*)'\s*\)",
                    io.open(LIB + 'normas.dart', encoding='utf-8').read(), re.S)
assert len(_EXPRS) >= 2, 'normas.dart: esperava 2 expressões de leitura'
_NUM_ANO, _SUDEPE = (re.compile(e) for e in _EXPRS[:2])


def chave(t):
    """(número, ano) da norma — o que a identifica de verdade."""
    t = t.split(' — ')[0].split(', que ')[0].split(', na redação')[0]
    m = _NUM_ANO.search(t) or _SUDEPE.search(t)
    if not m:
        return None
    num = m.group(1).replace('.', '').replace(' ', '').strip('-')
    return (num.upper(), m.group(2))


def orgao(t):
    if 'Decreto SC' in t or ' SC ' in t and t.startswith('Decreto'):
        return 'Estado de SC'
    for o in ('GM/MMA', 'SAP/MAPA', 'SEAP-PR/MMA', 'MPA/MMA', 'IBAMA',
              'SUDEPE', 'MMA', 'MPA'):
        if o in t:
            return o
    if t.startswith('Lei'):
        return 'Congresso'
    return 'Interministerial'


N = {}


def junta(texto, lida, uso, papel=''):
    k = chave(texto)
    if k is None:
        return
    nome = texto.split(' — ')[0].split(', que ')[0].strip().rstrip('.')
    if k not in N:
        N[k] = {'num': k[0], 'ano': k[1], 'nome': nome, 'lida': lida,
                'orgao': orgao(texto), 'usos': set(), 'papel': papel}
    e = N[k]
    e['lida'] = e['lida'] or lida
    e['usos'].add(uso)
    if papel and not e['papel']:
        e['papel'] = papel
    if len(nome) > len(e['nome']):        # fica a grafia mais completa
        e['nome'] = nome


BASE = [
    ('Instrução Normativa MMA nº 53, de 22 de novembro de 2005',
     'Tamanho mínimo de captura de 35 espécies', True),
    ('Instrução Normativa Interministerial MPA/MMA nº 10, de 10 de junho '
     'de 2011', 'As 72 modalidades de permissionamento', True),
    ('Lei nº 11.959, de 29 de junho de 2009',
     'Política Nacional de Pesca: definições e fiscalização', True),
    ('Portaria GM/MMA nº 1.666, de 27 de abril de 2026',
     'As regras aplicáveis às espécies ameaçadas', True),
    ('Portaria GM/MMA nº 1.667, de 27 de abril de 2026',
     'A Lista Nacional Oficial: 490 espécies', True),
    ('Portaria MMA nº 445, de 17 de dezembro de 2014',
     'Lista anterior, revogada. Serve de comparação', True),
    ('Portaria MMA nº 148, de 7 de junho de 2022',
     'Substituiu o Anexo I da 445/2014', True),
    ('Portaria MMA nº 354, de 27 de janeiro de 2023',
     'Acrescentou 5 elasmobrânquios à 148/2022', True),
    ('Portaria MMA nº 73, de 26 de março de 2018',
     'Reescreveu o art. 3º da 445/2014: manejo sustentável', True),
    ('Portaria SAP/MAPA nº 617, de 8 de março de 2022',
     'Arrasto de praia em SC: modalidades 6.8 a 6.11', True),
    ('Portaria Interministerial MPA/MMA nº 51, de 27 de fevereiro de 2026',
     'Safra 2026 da tainha: cotas e confirmação das datas', True),
    ('Portaria Interministerial MPA/MMA nº 63, de 11 de junho de 2026',
     'Alterou a 51/2026', True),
    ('Portaria Interministerial MPA/MMA nº 57, de 12 de maio de 2026',
     'Alterou o art. 21 da 24/2018: rastreamento', True),
    ('Portaria Interministerial MPA/MMA nº 47, de 14 de janeiro de 2026',
     'Alterou o art. 18 da 656/2022: rastreamento', True),
    ('Portaria SAP/MAPA nº 695, de 27 de abril de 2022',
     'Alterou a 656/2022 dos camarões', True),
    ('Portaria SAP/MAPA nº 75, de 3 de abril de 2020',
     'Alterou o art. 3º, V da 24/2018 da tainha', True),
    ('Portaria MPA nº 127, de 29 de agosto de 2023',
     'RGP e Licença de Pescador Profissional; o REAP', True),
    ('Decreto SC nº 1.017, de 13 de novembro de 1991',
     'Policiamento florestal da PMSC. Base institucional do TCC, '
     'não do aplicativo', True),
]
for nome, papel, lida in BASE:
    junta(nome, lida, 'base normativa', papel)

for b in blocos('defesos.dart', 'const defesos = <Defeso>[', 'Defeso'):
    junta(campo(b, 'norma'), 'Origem.conferida' in b,
          'defeso: ' + campo(b, 'titulo'))

for b in blocos('regimes.dart', 'const planos = <Plano>[', 'Plano'):
    # quando a norma de ordenamento nao foi obtida, o ato do MMA
    # tambem nao foi: nenhum dos dois textos esta na mao
    obtida = 'normaObtida: false' not in b
    esp = campo(b, 'especie')
    junta(campo(b, 'ordenamento'), obtida, 'plano: ' + esp)
    ato = campo(b, 'atoDoMMA')
    junta(ato, obtida and 'texto obtido' in ato, 'plano: ' + esp)

for b in blocos('periodos.dart', 'const periodos = <Periodo>[', 'Periodo'):
    junta(campo(b, 'norma'), 'confirmado: false' not in b,
          'calendário: ' + campo(b, 'especie').split(' — ')[0])

for b in blocos('areas.dart', 'const restricoes = <Restricao>[', 'Restricao'):
    junta(campo(b, 'norma'), 'TextoDaNorma.lido' in b,
          'área: ' + campo(b, 'titulo'))

FALTAM = [(campo(b, 'titulo'), campo(b, 'falta'))
          for b in blocos('conflitos.dart',
                          'const conflitos = <Conflito>[', 'Conflito')]

# as que sabemos existir e nem citadas estao — vieram da pesquisa
# As cinco normas de área de Santa Catarina saíram desta lista em
# 29/08/2026: quatro entraram no aplicativo com o texto lido (SUDEPE
# N-51/1983, IBAMA 84/2002, IN MMA 20/2005, INI MPA/MMA 12/2012) e a
# quinta (IBAMA 107/1992) entrou registrada como norma a obter. Todas
# aparecem agora na contagem automática, não mais aqui.
SEM_CITAR = [
    ('Portaria Interministerial MPA/MMA nº 04, de 14 de maio de 2015 — '
     'REVOGADA, NÃO USAR', 'MPA/MMA',
     'Tratava das desembocaduras estuarino-lagunares: todas as modalidades '
     'salvo tarrafa, de 15/3 a 15/9. A Camila apurou em 29/08/2026 que está '
     'REVOGADA, antes de ela chegar a entrar no aplicativo. Fica registrada '
     'só para não ser recolhida de novo por engano. Falta saber qual norma '
     'a revogou e o que passou a valer no lugar.'),
    ('Instrução Normativa IBAMA nº 21, de 7 de julho de 2009', 'IBAMA',
     'Camarão no Complexo Lagunar Sul: defeso de 15/7 a 15/11. Não foi '
     'revogada pela Portaria 65/2026, e as datas coincidem.'),
    ('Instrução Normativa IBAMA nº 15, de 21 de maio de 2009', 'IBAMA',
     'Norma-base da sardinha-verdadeira. Temos a redação atual dos '
     'arts. 4º e 5º pela IN SAP/MAPA 18/2020, mas não o texto integral.'),
    ('Portaria Interministerial SEAP-PR/MMA nº 42, de 27 de julho de 2018 '
     '— REVOGADA, NÃO PROCURAR', 'SEAP-PR/MMA',
     'Era o ordenamento do pargo em 2018. Confirmado em 29/08/2026: está '
     'revogada/substituída. O que vale hoje é a Portaria Interministerial '
     'MPA/MMA nº 66, de 27 de julho de 2026, combinada com a Portaria MMA '
     'nº 1.742, de 24 de julho de 2026 — e é para essas duas que o Plano '
     'do pargo já aponta no aplicativo. Fica aqui só como histórico.'),
    ('Portaria IBAMA nº 107, de 29 de setembro de 1992 — RETIRADA DO '
     'APLICATIVO EM 01/09/2026', 'IBAMA',
     'Era a regra de distância mínima da costa para o arrasto motorizado '
     'em SC. Nunca teve o texto obtido, e tudo o que ela dizia foi '
     'apagado do aplicativo por ordem da Camila. A pesquisa a dá como '
     'revogada pela IN IBAMA nº 189/2008 — mas o texto da 189/2008 foi '
     'lido e o art. 8º dela revoga apenas as IN IBAMA 91/2006 e 92/2006. '
     'Fica registrada só como histórico. NÃO REPOR números dela sem o '
     'texto publicado na mão.'),
    ('Instrução Normativa MPA nº 14, de 3 de outubro de 2014 — '
     'CONSOLIDADO DA IN 10/2011', 'MPA',
     'EM VIGOR. Alterou o Anexo I da IN 10/2011: reestruturou a '
     'codificação das modalidades de embarcações artesanais e industriais '
     'e ajustou exigências de petrecho e de malha. A lista de 72 '
     'modalidades do aplicativo é o texto ORIGINAL de 2011 — os códigos '
     'podem estar desalinhados com o RGP ativo. PRIORIDADE.'),
    ('Instrução Normativa MPA/MMA nº 01, de 22 de janeiro de 2015 — '
     'CONSOLIDADO DA IN 10/2011', 'MPA/MMA',
     'EM VIGOR. Alterou e acrescentou regras de emalhe, cerco e espinhel '
     'na IN 10/2011. Mesma situação da IN 14/2014: sem o texto '
     'consolidado, os códigos do aplicativo podem estar velhos. '
     'PRIORIDADE.'),
]

lidas = sorted([v for v in N.values() if v['lida']],
               key=lambda x: (x['ano'], x['num']))
obter = sorted([v for v in N.values() if not v['lida']],
               key=lambda x: (x['ano'], x['num']))

print(f'{len(N)} normas citadas no aplicativo')
print(f'  {len(lidas)} com texto lido por inteiro')
print(f'  {len(obter)} citadas, texto não obtido')
print(f'  + {len(SEM_CITAR)} conhecidas pela pesquisa, ainda fora do app')
json.dump({'lidas': [{**v, 'usos': sorted(v['usos'])} for v in lidas],
           'obter': [{**v, 'usos': sorted(v['usos'])} for v in obter],
           'semcitar': SEM_CITAR, 'faltam': FALTAM},
          io.open('inventario.json', 'w', encoding='utf-8'),
          ensure_ascii=False, indent=1)
print()
for v in obter:
    print(f'  a obter: {v["nome"][:74]}')
