# -*- coding: utf-8 -*-
"""Argumentos nomeados repetidos dentro do mesmo construtor.

Nasceu de um erro real: um script de patch inseria campos enquanto
iterava sobre posicoes da string original, e as insercoes deslocaram as
posicoes seguintes. O resultado foi 'Duplicated named argument' — que o
checar.py nao pega, porque os parenteses continuavam balanceados.

Uso: python3 duplicados.py pode_pescar/lib/*.dart
"""
import io, re, sys

# construtores de dados do app: nome da const -> nome da classe
LISTAS = [
    ('const defesos = <Defeso>[', 'Defeso'),
    ('const periodos = <Periodo>[', 'Periodo'),
    ('const planos = <Plano>[', 'Plano'),
    ('const conflitos = <Conflito>[', 'Conflito'),
    ('const listaAmeacadas = <Ameacada>[', 'Ameacada'),
]

problemas = 0
for arq in sys.argv[1:]:
    try:
        s = io.open(arq, encoding='utf-8').read()
    except OSError:
        continue
    for marca, classe in LISTAS:
        if marca not in s:
            continue
        corpo = s.split(marca, 1)[1].split('\n];', 1)[0]
        blocos = re.findall(classe + r'\((.*?)\n  \),', corpo, re.S)
        for i, b in enumerate(blocos):
            # so os campos no nivel do construtor (4 espacos de recuo)
            campos = re.findall(r'^ {4}(\w+):', b, re.M)
            vistos, repetidos = set(), []
            for c in campos:
                if c in vistos:
                    repetidos.append(c)
                vistos.add(c)
            if repetidos:
                rot = re.search(r"(?:titulo|especie): '([^']*)'", b)
                print(f'  ERRO {arq.split("/")[-1]}: {classe} #{i + 1} '
                      f'({rot.group(1) if rot else "?"}) '
                      f'repete {", ".join(sorted(set(repetidos)))}')
                problemas += 1

print(f'argumentos nomeados repetidos: '
      f'{problemas if problemas else "nenhum"}')
sys.exit(1 if problemas else 0)
