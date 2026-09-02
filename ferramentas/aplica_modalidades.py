# -*- coding: utf-8 -*-
"""Aplica nas modalidades a redacao MAIS RECENTE, extraida do DOU.

A regra da Camila: vale a norma mais recente. Mostrar a redacao de 2011
com um selo de "texto alterado" ainda e' mostrar a redacao de 2011.

Duas formas de alteracao, e trata-las igual seria desastroso:

  PI MPA/MMA no 14/2024, Anexo I — altera SO' UM CAMPO de cada uma das 9
  modalidades. O resto vem com a linha pontilhada do DOU, que significa
  "inalterado, omitido". Aplicar como reescrita total apagaria a
  especie-alvo de quatro modalidades e a autorizacao complementar de
  cinco.

  PI MPA/MMA no 66/2026, Anexo II — reescreve a modalidade INTEIRA de 8
  modalidades (1.6, 1.8, 1.9, 1.10, 1.11, 1.14 do Anexo I da IN 10/2011,
  e 3.11, 3.13 do Anexo III). Eu havia contado seis; a extracao achou
  oito.

Nada aqui foi redigitado: os valores saem do pdftotext do DOU, por
script, e o proprio script guarda o texto antigo para conferencia.
"""
import io, json, re

LIB = 'pode_pescar/lib/'
CAMPO = {
    'Outras definições regionais ou locais': 'locais',
    'Espécie-alvo': 'alvo',
    'Captura incidental': 'incidental',
    'Fauna acompanhante previsível': 'acompanhante',
    'Autorização Complementar': 'complementar',
    'Área de operação': 'area',
}
NORMA = {
    '14/2024': 'Portaria Interministerial MPA/MMA nº 14, de 1º de novembro '
               'de 2024',
    '66/2026': 'Portaria Interministerial MPA/MMA nº 66, de 27 de julho '
               'de 2026',
}

novos = json.load(io.open('modalidades_novas.json', encoding='utf-8'))
s = io.open(LIB + 'dados.dart', encoding='utf-8').read()
antes = {}
mudou = {}

for norma, mods in novos.items():
    for num, campos in sorted(mods.items()):
        m = re.search(r"(\n  Modalidade\(\s*\n\s*'" + re.escape(num) +
                      r"',.*?\n  \),)", s, re.S)
        assert m, f'modalidade {num} não encontrada em dados.dart'
        bloco = velho_bloco = m.group(1)
        feitos = []
        for rotulo, dartf in CAMPO.items():
            if rotulo not in campos:
                continue
            novo_valor = campos[rotulo].rstrip(' -').strip()
            assert "'" not in novo_valor, f'{num}/{dartf}: aspas no valor'
            # o valor pode estar na mesma linha OU na linha seguinte,
            # indentado — foi assim que a 6.10 escapou na primeira versão
            padrao = re.compile(r"(\n    " + dartf +
                                r":\s*)((?:'(?:[^'\\]|\\.)*'\s*)+)(,\n)")
            mm = padrao.search(bloco)
            if mm:
                antigo = ''.join(re.findall(r"'((?:[^'\\]|\\.)*)'", mm.group(2)))
                antes.setdefault(num, {})[dartf] = antigo
                if antigo.strip() == novo_valor:
                    continue
                bloco = bloco[:mm.start()] + f"\n    {dartf}: '{novo_valor}'" \
                    + mm.group(3) + bloco[mm.end():]
            else:
                # o campo não existia na redação de 2011; entra depois do alvo
                alvo = re.search(
                    r"(\n    alvo:\s*(?:'(?:[^'\\]|\\.)*'\s*)+,\n)", bloco)
                assert alvo, f'{num}: não achei onde inserir {dartf}'
                bloco = (bloco[:alvo.end()] + f"    {dartf}: '{novo_valor}',\n"
                         + bloco[alvo.end():])
                antes.setdefault(num, {})[dartf] = '(campo não existia)'
            feitos.append(dartf)
        if feitos:
            mudou[num] = (norma, feitos)
            s = s.replace(velho_bloco, bloco, 1)

io.open(LIB + 'dados.dart', 'w', encoding='utf-8').write(s)
json.dump(antes, io.open('modalidades_antes.json', 'w', encoding='utf-8'),
          ensure_ascii=False, indent=1)

print(f'{len(mudou)} modalidades atualizadas:\n')
for num, (norma, campos) in sorted(mudou.items(),
                                   key=lambda x: [int(p) for p in x[0].split('.')]):
    print(f'  {num:5s} {NORMA[norma][:52]:54s} {", ".join(campos)}')
print('\ntexto anterior guardado em modalidades_antes.json')
