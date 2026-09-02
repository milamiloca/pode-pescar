# -*- coding: utf-8 -*-
"""Extrai do DOU o texto NOVO das modalidades, sem redigitar nada.

A regra que a Camila deu: vale a norma mais recente. Entao o aplicativo
nao pode mostrar a redacao de 2011 de uma modalidade que foi reescrita em
2024 ou 2026 — nem com selo de aviso.

DUAS FORMAS DE ALTERACAO, e elas nao sao iguais:

  PI MPA/MMA no 14/2024, Anexo I — altera SO' o campo "Autorizacao
  Complementar" de 9 modalidades. O resto vem com a linha pontilhada do
  DOU (".........."), que quer dizer "texto inalterado, omitido".

  PI MPA/MMA no 66/2026, Anexo II — reescreve a modalidade INTEIRA de 6
  modalidades: outras definicoes, especie-alvo, captura incidental, fauna
  acompanhante, autorizacao complementar e area de operacao.

Confundir as duas seria desastroso: aplicar a 14/2024 como reescrita
total apagaria a especie-alvo de nove modalidades.

Este script so' LE' e MOSTRA. Nao escreve no aplicativo.
"""
import io, re, subprocess

UP = '/root/.claude/uploads/54d325c1-5a89-537c-895a-8ced8a74f7a9/'
P14 = UP + ('2f6c66ef-Portaria_INTERMINISTERIAL_MPAMMA_n__14_de_1__de_'
            'novembro_de_2024__Portaria_INTERMINISTERIAL_MPAMMA_n__14_de_'
            '1__de_novembro_de_2024__DOU__Imprensa_Nacional.pdf')
P66 = UP + ('f3544e09-PORTARIA_INTERMINISTERIAL_MPAMMA_N__66_DE_27_DE_'
            'JULHO_DE_2026__PORTARIA_INTERMINISTERIAL_MPAMMA_N__66_DE_27_'
            'DE_JULHO_DE_2026__DOU__Imprensa_Nacional.pdf')

LIXO = re.compile(r'(https://www\.in\.gov\.br\S*|Page \d+ of \d+|'
                  r'^\s*\d{2}/\d{2}/\d{2},.*$|Imprensa Nacional|'
                  r'^Portaria INTERMINISTERIAL.*$|^PORTARIA INTERMINISTERIAL.*$)',
                  re.M)


def texto(pdf):
    t = subprocess.run(['pdftotext', '-layout', pdf, '-'],
                       capture_output=True, text=True).stdout
    t = LIXO.sub(' ', t)
    t = re.sub(r'\.{6,}', '\n@@CORTE@@\n', t)      # a linha pontilhada do DOU
    t = re.sub(r'[ \t]+', ' ', t)
    return t


def blocos(t, inicio):
    """Divide em blocos por '<numero>. Modalidades e/ou petrechos:'."""
    t = t[t.index(inicio):]
    ms = list(re.finditer(r'(\d+\.\d+)\.\s*Modalidades e/ou petrechos:', t))
    out = []
    for k, m in enumerate(ms):
        fim = ms[k + 1].start() if k + 1 < len(ms) else len(t)
        out.append((m.group(1), t[m.start():fim]))
    return out


CAMPOS = ['Outras definições regionais ou locais', 'Espécie-alvo',
          'Captura incidental', 'Fauna acompanhante previsível',
          'Autorização Complementar', 'Área de operação']


def campos(b):
    d = {}
    pat = '|'.join(re.escape(c) for c in CAMPOS)
    for m in re.finditer(rf'({pat})\s*:\s*(.*?)(?=(?:{pat})\s*:|@@CORTE@@|$)',
                         b, re.S):
        d[m.group(1)] = ' '.join(m.group(2).split())
    return d


print('=' * 70)
print('PI MPA/MMA nº 14/2024 — Anexo I  (altera SÓ a Aut. Complementar)')
print('=' * 70)
t14 = texto(P14)
for num, b in blocos(t14, 'ANEXO I'):
    d = campos(b)
    print(f'\n### {num}   campos presentes: {list(d)}')
    for k, v in d.items():
        print(f'   {k}: {v[:150]}{"..." if len(v) > 150 else ""}')

print('\n' + '=' * 70)
print('PI MPA/MMA nº 66/2026 — Anexo II  (reescreve a modalidade inteira)')
print('=' * 70)
t66 = texto(P66)
for num, b in blocos(t66, 'ANEXO II'):
    d = campos(b)
    print(f'\n### {num}   campos presentes: {list(d)}')
    for k, v in d.items():
        print(f'   {k}: {v[:150]}{"..." if len(v) > 150 else ""}')
