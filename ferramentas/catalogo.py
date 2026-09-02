# -*- coding: utf-8 -*-
"""Gera lib/catalogo.dart — as especies que so' o catalogo de nomes alcanca.

Rodar de dentro de pode_pescar/:   python3 ferramentas/catalogo.py

CRITERIO, e ele nao depende de opiniao: entra a especie que a Portaria
MPA no 532/2025 nomeia E que alguma norma carregada pelo aplicativo cita
(modalidades da IN 10/2011, defesos, areas, planos). Se nenhuma norma do
aplicativo fala do bicho, ele nao ganha pagina — a 532 e' norma de
ROTULAGEM e cobre importado, cultivo e esturjao.

DUAS ARMADILHAS, que a prova 16 do coerencia.py guarda:
  · ficha com cientifico COMPOSTO. "Mugil platanus / Mugil liza" faz
    "Mugil liza" parecer orfa. Abrir pagina para ela seria abrir uma
    segunda tainha. O filtro compara por substring contra o blob dos
    cientificos, nao por igualdade.
  · SINONIMO. "Pogonias cromis" nao e' orfa: e' o nome antigo da
    miraguaia, que ja' tem ficha como "Pogonias courbina". Sai a mao, e
    a justificativa e' de norma — a Portaria SAQ no 009/2025 do Estado
    de Santa Catarina registra que as duas foram reconhecidas como
    distintas e que cromis nao ocorre no Brasil.
"""
import io, re

LIB = 'lib/'

SINONIMOS = {
    'Pogonias cromis':
        'sinônimo antigo de Pogonias courbina, que já tem ficha. A Portaria '
        'SAQ nº 009/2025 do Estado de Santa Catarina registra que as duas '
        'foram reconhecidas como espécies distintas e que Pogonias cromis não '
        'ocorre no Brasil.',
}

NORMA = ['dados.dart', 'defesos.dart', 'areas.dart', 'regimes.dart',
         'periodos.dart']


def ler(f):
    return io.open(LIB + f, encoding='utf-8').read()


esp, ame, nom = ler('dados.dart'), ler('ameacadas.dart'), ler('nomes.dart')
norma = ''.join(ler(f) for f in NORMA)

cients = [c for _, c, _ in re.findall(
    r"Especie\('([^']*)',\s*'([^']*)',\s*(\d+)", esp)]
cients += [c for _, c in re.findall(r"Ameacada\((\d+),\s*'([^']*)'", ame)]
blob = ' ;; '.join(cients)
c532 = dict(re.findall(r"^\s*'([^']+)':\s*\[(.*?)\],\s*$", nom, re.M))

cand = [c for c in sorted(set(c532) - set(cients))
        if c in norma and c not in blob and c not in SINONIMOS]

L = ['// GERADO POR ferramentas/catalogo.py — NÃO EDITAR À MÃO.', '//']
L += ['// ' + x for x in (
    '====================================================================',
    'AS ESPÉCIES QUE SÓ O CATÁLOGO DE NOMES ALCANÇA',
    '',
    'A ficha do aplicativo nasce de duas normas: a IN MMA 53/2005, que dá',
    'tamanho mínimo, e o Anexo I da Portaria GM/MMA 1.667/2026, que dá a',
    'Lista de ameaçadas. Espécie fora das duas não tinha página — e quem',
    'procurava por ela não achava nada.',
    '',
    'Foi o caso da carapeba. A pessoa digita "carapeba", a espécie não tem',
    'tamanho mínimo nem está na Lista, e o aplicativo ficava mudo. O',
    'silêncio é lido como permissão, que é o erro que mais importa evitar.',
    '',
    'Aqui entram as espécies que a Portaria MPA nº 532/2025 nomeia E que',
    'alguma norma carregada pelo aplicativo cita. O critério é esse, e não',
    'opinião sobre o que ocorre em Santa Catarina: se nenhuma norma do',
    'aplicativo nomeia o bicho, ele não ganha página.',
    '',
    'A 532 tem 571 espécies e aqui há %d. As demais são de rotulagem —' % len(cand),
    'importados, cultivo, esturjões, espécies amazônicas — e nenhuma norma',
    'de ordenamento do aplicativo fala delas. Continuam achá-veis pela',
    'busca, que responde com o nome científico e com onde o termo aparece.',
    '',
    'A página que sai daqui NÃO AFIRMA REGRA NENHUMA. Ela diz o nome',
    'científico, os nomes comuns oficiais, e diz em voz alta as duas',
    'ausências: sem tamanho mínimo na IN 53, fora da Lista.',
    '====================================================================')]
L += ['', '/// Sinônimos deixados de fora de propósito, para não abrir duas',
      '/// páginas para o mesmo bicho:']
for k, v in SINONIMOS.items():
    L.append(f'///   {k} — {v}')
L += ['', 'const catalogo = <String>[']
for c in cand:
    L.append(f"  '{c}', // {c532[c].split(',')[0].strip().strip(chr(39))}")
L += ['];', '', '/// Quantas espécies entram só pelo catálogo de nomes.',
      'int get quantasSoNoCatalogo => catalogo.length;']
io.open(LIB + 'catalogo.dart', 'w', encoding='utf-8').write('\n'.join(L) + '\n')
print(f'catalogo.dart: {len(cand)} espécies')
