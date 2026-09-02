# -*- coding: utf-8 -*-
"""Gera lib/fotos.dart a partir de um PDF-guia com tabela de especies.

Rodar de dentro de pode_pescar/. Precisa de: pdftohtml (poppler) e Pillow.

Pareia cada foto com o nome cientifico da linha — e RECUSA quando o
pareamento e' ambiguo.

O guia e' uma tabela: nome vulgar, nome cientifico em italico, imagem,
tamanho minimo. O pdftohtml -xml da' a posicao de cada texto e de cada
imagem, entao o pareamento e' geometrico.

A PRIMEIRA VERSAO DESTE SCRIPT CHUTAVA. Na pagina 7 ha' uma celula de
bagres com QUATRO nomes cientificos e TRES fotos empilhadas — "Genidens
genidens, Netuma barba ou Tachysurus baubus, T. upsulonophorus e T.
agassizii". Qual foto e' qual bicho nao da' para saber nem olhando. O
script antigo escolheu a mais proxima e seguiu em frente.

Num aplicativo de fiscalizacao isso vira identificacao errada no campo,
que e' pior que ficha sem foto. Entao agora:

  · a faixa vertical da imagem tem de conter UM nome, nao dois;
  · a faixa do nome tem de conter UMA imagem, nao duas;
  · nome terminado em virgula ou em "e" e' item de lista — recusado;
  · nome abreviado ("T. agassizii") nao tem genero por extenso — recusado.

O que for recusado sai no relatorio, para decidir a mao.
"""
import io, re, json
from xml.etree import ElementTree as ET

XML = 'guia_xml/g.xml'
BINOMIO = re.compile(r'^[A-Z][a-z]{2,}\s+(?:[a-z]{3,}|spp\.|sp\.)$')
# "Mugil platanus / Mugil Liza" — duas especies na mesma ficha, que
# e' como a IN 53 escreve algumas linhas. Isso NAO e' ambiguidade:
# a ficha do aplicativo tambem carrega o nome composto.
COMPOSTO = re.compile(r'^[A-Z][a-z]{2,}\s+[A-Za-z]{3,}(?:\s*/\s*[A-Z][a-z]*\.?\s+[A-Za-z]{3,})+$')

arv = ET.parse(XML).getroot()
pares, recusados = [], []

for pag in arv.findall('page'):
    n = int(pag.get('number'))
    imgs = []
    for im in pag.findall('image'):
        t, h = float(im.get('top')), float(im.get('height'))
        imgs.append({'src': im.get('src'), 'de': t, 'ate': t + h,
                     'w': int(float(im.get('width'))),
                     'h': int(float(im.get('height')))})
    nomes = []
    for tx in pag.findall('text'):
        it = tx.find('i')
        bruto = ' '.join((it.text or '').split()) if it is not None else ''
        if not bruto:
            continue
        y = float(tx.get('top')) + float(tx.get('height')) / 2
        nomes.append({'bruto': bruto, 'y': y})

    for nm in nomes:
        b = nm['bruto']
        limpo = b.rstrip(' ,;')
        # item de lista, ou nome abreviado: nao da' para saber a qual foto
        if b.rstrip().endswith((',', ' e')) or re.match(r'^[A-Z]\.\s', limpo):
            recusados.append({'pagina': n, 'nome': b,
                              'porque': 'nome dentro de uma lista de espécies '
                                        'na mesma célula'})
            continue
        if not BINOMIO.match(limpo):
            # NOME COMPOSTO NAO PODE SUMIR EM SILENCIO. A tainha ficou
            # sem foto por causa deste `continue`: o guia escreve "Mugil
            # platanus / Mugil Liza" e o BINOMIO so' aceita duas
            # palavras. O nome sumia sem entrar nem no relatorio de
            # recusados, entao ninguem via a falta.
            if COMPOSTO.match(limpo):
                pares.append({'cientifico': limpo, 'pagina': n,
                              'arquivo': '', 'w': 0, 'h': 0,
                              'composto': True})
            else:
                recusados.append({'pagina': n, 'nome': limpo,
                                  'porque': 'não tem forma de nome '
                                            'científico'})
            continue
        dentro = [im for im in imgs if im['de'] <= nm['y'] <= im['ate']]
        if len(dentro) != 1:
            recusados.append({'pagina': n, 'nome': limpo,
                              'porque': f'{len(dentro)} imagens na faixa do '
                                        f'nome'})
            continue
        im = dentro[0]
        # e a faixa da imagem pode conter um nome so'
        naFaixa = [x for x in nomes
                   if im['de'] <= x['y'] <= im['ate']
                   and BINOMIO.match(x['bruto'].rstrip(' ,;'))]
        if len(naFaixa) != 1:
            recusados.append({'pagina': n, 'nome': limpo,
                              'porque': f'{len(naFaixa)} nomes na faixa da '
                                        f'imagem {im["src"]}'})
            continue
        pares.append({'cientifico': limpo, 'pagina': n,
                      'arquivo': im['src'], 'w': im['w'], 'h': im['h']})

# uma foto nao pode servir a duas especies
porArquivo = {}
for p in pares:
    porArquivo.setdefault(p['arquivo'], []).append(p['cientifico'])
dobradas = {k: v for k, v in porArquivo.items() if len(v) > 1}
pares = [p for p in pares if p['arquivo'] not in dobradas]
for k, v in dobradas.items():
    recusados.append({'pagina': 0, 'nome': ' / '.join(v),
                      'porque': f'a mesma foto {k} serviria a {len(v)} espécies'})

json.dump(pares, io.open('pares_guia.json', 'w', encoding='utf-8'),
          ensure_ascii=False, indent=1)
json.dump(recusados, io.open('recusados_guia.json', 'w', encoding='utf-8'),
          ensure_ascii=False, indent=1)

print(f'pareados com segurança .... {len(pares)}')
print(f'recusados por ambiguidade . {len(recusados)}')
print()
for p in (1, 7, 14):
    print(f'--- página {p}:')
    for x in [i for i in pares if i['pagina'] == p]:
        print(f"    {x['arquivo']:14s} {x['cientifico']}")
    for r in [i for i in recusados if i['pagina'] == p]:
        print(f"    RECUSADO      {r['nome'][:36]:38s} {r['porque']}")
