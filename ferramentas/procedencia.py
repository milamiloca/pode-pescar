# -*- coding: utf-8 -*-
"""De onde vem CADA dado de citacao das normas que o app nao leu.

POR QUE ISTO EXISTE. Em 01/09/2026 apareceram duas datas inventadas
dentro do aplicativo:

  "IN MPA/MMA no 01, de 22 DE JANEIRO de 2015"  -> e' de 26 de marco
  "IN MPA no 14, de 3 DE OUTUBRO de 2014"       -> dia e mes desconhecidos

As duas foram escritas com confianca, sem fonte, e passaram por todas as
provas — porque nenhuma prova olhava para a PROCEDENCIA de uma citacao.
A prova 18 pega palpite hedgeado ("provavelmente"); uma data errada dita
com firmeza nao tem hedge nenhum para pegar.

A REGRA. Norma cujo TEXTO foi lido por inteiro dispensa registro: a
citacao sai do proprio documento. Norma NAO LIDA que mesmo assim aparece
no app com dia e mes precisos tem de declarar aqui de onde veio essa
data. Sem registro, esta prova falha.

Isso nao impede errar. Impede errar EM SILENCIO — que e' diferente.
"""
import io, json, re

# Norma não lida + data precisa no app = precisa de linha aqui.
# A chave é (número, ano), como no inventario.py.
FONTES = {
    # --- a fila de 02/09/2026 -------------------------------------
    # A Camila mandou uma lista de normas com numero, data e ementa de
    # cada uma. NAO e' o texto das normas: e' um indice. Serve para
    # saber o que procurar, e as datas abaixo vem dai' — nao de leitura
    # do DOU. Enquanto a norma nao for lida, o aplicativo nao reproduz
    # regra nenhuma dela, so' o nome.
    ('08', '2014'):
        'Lista de normas recebida em 02/09/2026, que traz "Instrução '
        'Normativa Interministerial MPA/MMA nº 8, 06/11/2014 — Proíbe a '
        'pesca direcionada (...) do tubarão lombo-preto (Carcharhinus '
        'falciformis)", com link para o PDF do CEPSUL/ICMBio.',
    ('13', '2015'):
        'Mesma lista de 02/09/2026: "Portaria Interministerial MPA/MMA nº '
        '13, 02/10/2015 — Proíbe a pesca direcionada (...) do mero '
        '(Epinephelus itajara)". A mesma data consta da página 9 do guia '
        'de identificação da PMA e da mensagem da Camila de 01/09/2026.',
    ('14', '2015'):
        'Mesma lista de 02/09/2026: "Portaria Interministerial MPA/MMA nº '
        '14, 02/10/2015 — cherne-poveiro (Polyprion americanus)". '
        'Confere com a página 9 do guia da PMA.',
    ('43', '2007'):
        'Lista de normas recebida em 02/09/2026: "Portaria IBAMA nº 43, '
        '24/09/2007 — Proibe a captura das espécies corvina (Micropogonias '
        'furnieri), castanha (Umbrina canosai), pescadinha-real (Macrodon '
        'ancylodon) e pescada-olhuda (Cynoscion guatucupa, sin. C. '
        'striatus), por embarcações de cerco de traineira no Mar '
        'Territorial e ZEE das regiões SE-S", com link para o PDF do '
        'CEPSUL/ICMBio.',
    ('05', '2011'):
        'Mesma lista de 02/09/2026 e página 9 do guia da PMA: moratória '
        'do tubarão-raposa (Alopias superciliosus), de 15/04/2011. A '
        'lista a chama de "Portaria Interministerial" e o nome do '
        'arquivo oficial do IBAMA diz "IN0005-150411" — a data bate nas '
        'duas, a espécie do ato é que precisa ser confirmada.',
    ('01', '2013'):
        'Mesma lista de 02/09/2026 e página 9 do guia da PMA: moratória '
        'do tubarão-galha-branca (Carcharhinus longimanus), de '
        '12/03/2013. Mesma divergência de nomenclatura da de 2011.',
    ('02', '2013'):
        'Mesma lista de 02/09/2026 e página 9 do guia da PMA: moratória '
        'das raias da família Mobulidae, de 13/03/2013. Mesma '
        'divergência de nomenclatura.',
    ('14', '2012'):
        'Mesma lista de 02/09/2026: "Instrução Normativa Interministerial '
        'MPA/MMA nº 14, 26/11/2012 — Dispõe sobre normas e procedimentos '
        'para o desembarque, o transporte, o armazenamento e a '
        'comercialização de tubarões e raias", com link para o PDF do '
        'CEPSUL/ICMBio.',
    ('452', '2021'):
        'Mesma lista de 02/09/2026: "Portaria SAP-MAPA nº 452, 18/11/2021 '
        '— Estabelece as regras de ordenamento para a atividade de pesca '
        'do polvo nas regiões SE-S", com link para o DOU.',
    ('128', '2018'):
        'Página oficial do MMA, "Planos de Recuperação para Espécies '
        'Aquáticas Ameaçadas de Extinção", que lista "Portaria MMA nº 128, '
        'de 27 de abril de 2018" como o ato que reconhece o Plano do '
        'Guaiamum. Consultada em 01/09/2026.',
    ('38', '2018'):
        'Mesma página do MMA, que lista "Portaria Interministerial '
        'SEAP-PR/MMA nº 38, de 26 de julho de 2018" como norma de '
        'ordenamento do Guaiamum, com link para o PDF.',
    ('230', '2018'):
        'Mesma página do MMA, que lista "Portaria MMA nº 230, de 14 de '
        'junho de 2018" como o ato do Plano da Gurijuba, com link.',
    ('43', '2018'):
        'Mesma página do MMA, que lista "Portaria Interministerial '
        'SEAP-PR/MMA nº 43, de 27 de julho de 2018" como norma de '
        'ordenamento da Gurijuba, com link.',
    ('355', '2023'):
        'Mesma página do MMA, que lista "Portaria MMA nº 355, de 27 de '
        'janeiro de 2023" como o ato do Plano do Pintado, com link.',
    ('19', '2024'):
        'Página oficial do Ministério da Pesca e Aquicultura, "Atos '
        'Normativos / 2024", que lista "PORTARIA INTERMINISTERIAL MPA/MMA '
        'Nº 19, DE 24 DE DEZEMBRO DE 2024 - Proíbe o registro de novas '
        'embarcações de pesca nas modalidades de permissionamento 1.2, '
        '1.3, 1.4 e 1.15 da Instrução Normativa Interministerial nº 10". '
        'Consultada em 01/09/2026.',
    ('16', '2024'):
        'Mesma página de Atos Normativos de 2024 do MPA, que lista '
        '"Portaria INTERMINISTERIAL MPA/MMA nº 16, de 18 de dezembro de '
        '2024 - Estabelece os procedimentos para recepção da Declaração '
        'de Estoque dos recursos pesqueiros sujeitos ao defeso". A '
        'Portaria Interministerial MPA/MMA nº 66/2026 também a cita, no '
        'art. 11, § 5º, com essa mesma data.',
    ('53', '2026'):
        'Citada no art. 5º, parágrafo único, da Portaria GM/MMA nº 1.742, '
        'de 24 de julho de 2026, cujo texto foi lido: "instâncias de '
        'Gestão Participativa de que trata a Portaria Interministerial '
        'MPA/MMA nº 53, de 12 de março de 2026".',
    ('15', '2024'):
        'Mesma página do MMA, que lista "Portaria Interministerial '
        'MPA/MMA nº 15, de 06 de dezembro de 2024" como norma de '
        'ordenamento do Pintado, com link.',
}

# Normas não lidas que o app cita SEM data precisa, de propósito, porque
# a fonte não dá a data. Registradas para não voltarem a ganhar data.
SEM_DATA = {
    ('03', '2006'):
        'IN MMA nº 03, de 2006. A única fonte é a lista de normas '
        'recebida em 02/09/2026, que na entrada da IN MMA nº 53/2005 diz '
        '"Alterada (IN MMA n° 03/2006)" e traz o mesmo no nome do arquivo '
        'do CEPSUL: "..._altrd_in_mma_03_2006.pdf". Dá número e ano, e '
        'NÃO dá dia nem mês. Também não se sabe O QUE ela alterou — e a '
        'IN 53 é a norma de tamanho mínimo deste aplicativo. É a primeira '
        'da fila.',
    ('14', '2014'):
        'IN MPA nº 14, de 2014. A única fonte é o cabeçalho do PDF da IN '
        '10/2011 publicado pelo Ministério: "ALTERADA PELA IN MPA Nº 14 '
        '2014, IN MPA/MMA Nº 01/2015" — dá número e ano, e NÃO dá dia nem '
        'mês. O aplicativo afirmou "3 de outubro de 2014" até 01/09/2026; '
        'a data não tinha fonte e foi retirada. NÃO REPOR sem o texto '
        'publicado ou fonte oficial que traga a data.',
}

_DATA = re.compile(r',\s*de\s+\d{1,2}\s+de\s+\w+\s+de\s+(19|20)\d\d', re.I)


def rodar():
    d = json.load(io.open('inventario.json', encoding='utf-8'))
    falhas = []
    for v in d['obter']:
        k = (str(v['num']).strip(), str(v['ano']).strip())
        tem_data = bool(_DATA.search(v['nome']))
        if tem_data and k not in FONTES:
            falhas.append(
                f'"{v["nome"][:64]}" não foi lida e mesmo assim o app '
                f'afirma dia e mês. De onde veio essa data? Registre em '
                f'FONTES, ou tire a data.')
        if not tem_data and k not in FONTES and k not in SEM_DATA:
            falhas.append(
                f'"{v["nome"][:64]}" não foi lida e não tem registro de '
                f'procedência. Registre em FONTES ou em SEM_DATA.')
    print(f'PROCEDÊNCIA — normas citadas sem o texto lido\n')
    print(f'  {len(d["obter"])} normas não lidas')
    print(f'  {len(FONTES)} com fonte declarada para a citação')
    print(f'  {len(SEM_DATA)} citadas sem data, de propósito')
    if falhas:
        print(f'\nFALHAS ({len(falhas)}):')
        for f in falhas:
            print('   X ' + f)
        return 1
    print('\ntoda citação de norma não lida tem procedência declarada')
    return 0


if __name__ == '__main__':
    raise SystemExit(rodar())
