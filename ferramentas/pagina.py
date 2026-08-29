# -*- coding: utf-8 -*-
"""Gera a pagina do inventario de normas a partir de inventario.json."""
import io, json, html
from datetime import date

d = json.load(io.open('inventario.json', encoding='utf-8'))
HOJE = date(2026, 8, 29)


def grupo_de(usos):
    u = ' '.join(usos)
    if 'base normativa' in u:
        return 'base'
    if 'plano:' in u:
        return 'plano'
    return 'defeso'


NOMES = {
    'base': ('Base normativa',
             'Valem para o aplicativo inteiro: o tamanho mínimo, as '
             'modalidades, a Lista e as regras que a acompanham.'),
    'defeso': ('Defesos, temporadas e áreas',
               'Cada uma responde por um período no calendário, com o '
               'artigo de onde a data sai.'),
    'plano': ('Planos de Recuperação',
              'O caminho do art. 4º da Portaria 1.666: onde há Plano, ato '
              'do MMA e norma de ordenamento, a pesca é regulada, não '
              'vedada.'),
}


def usos_curtos(usos):
    vistos, saida = set(), []
    for u in usos:
        t = u.split(': ', 1)[-1] if ': ' in u else u
        if t not in vistos:
            vistos.add(t)
            saida.append(t)
    return ', '.join(saida[:4]) + ('…' if len(saida) > 4 else '')


def linha(v, estado):
    return (
        f'<li class="norma {estado}">'
        f'<span class="ident"><b>{html.escape(v["num"])}</b>'
        f'<i>{v["ano"]}</i></span>'
        f'<span class="corpo">'
        f'<span class="nome">{html.escape(v["nome"])}</span>'
        f'<span class="papel">{html.escape(v.get("papel") or usos_curtos(v["usos"]))}</span>'
        f'</span>'
        f'<span class="orgao">{html.escape(v["orgao"])}</span>'
        f'</li>')


def secao(titulo, sub, itens, estado, nota=''):
    if not itens:
        return ''
    return (f'<section class="bloco"><header class="cab">'
            f'<h2>{titulo}</h2><p>{sub}</p></header>'
            + (f'<p class="nota">{nota}</p>' if nota else '')
            + f'<ol class="lista">{"".join(itens)}</ol></section>')


lidas, obter = d['lidas'], d['obter']
por_grupo = {'base': [], 'defeso': [], 'plano': []}
for v in lidas:
    por_grupo[grupo_de(v['usos'])].append(v)

corpo_lidas = ''
for g in ('base', 'defeso', 'plano'):
    t, s = NOMES[g]
    itens = [linha(v, 'lida') for v in por_grupo[g]]
    corpo_lidas += secao(t, s, itens, 'lida')

itens_obter = [linha(v, 'obter') for v in obter]
itens_fora = [
    f'<li class="norma fora"><span class="ident"><b>—</b><i></i></span>'
    f'<span class="corpo"><span class="nome">{html.escape(n)}</span>'
    f'<span class="papel">{html.escape(p)}</span></span>'
    f'<span class="orgao">{html.escape(o)}</span></li>'
    for n, o, p in d['semcitar']]

decisoes = ''.join(
    f'<li><h3>{html.escape(t)}</h3><p>{html.escape(f)}</p></li>'
    for t, f in d['faltam'])

io.open('normas.html', 'w', encoding='utf-8').write(f'''<title>Registro de Normas</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Newsreader:ital,opsz,wght@0,6..72,400;0,6..72,600;1,6..72,400&family=IBM+Plex+Sans:wght@400;500;600&family=IBM+Plex+Mono:wght@500;600&display=swap">
<style>
:root {{
  --papel: #F3F1EB;
  --carta: #FFFFFF;
  --tinta: #14242B;
  --tinta-2: #5A6C72;
  --fio: #DCDDD4;
  --fundo: #0F2830;
  --mar: #1D6A7D;
  --lida: #1B6B41;
  --obter: #96590F;
  --fora: #8C2F26;
  --realce: rgba(29,106,125,.08);
}}
@media (prefers-color-scheme: dark) {{
  :root:not([data-theme="light"]) {{
    --papel: #101A1E;
    --carta: #16242A;
    --tinta: #E8EDEC;
    --tinta-2: #93A6AC;
    --fio: #26383F;
    --fundo: #0A171C;
    --mar: #6FB6C8;
    --lida: #63C08E;
    --obter: #E0A64E;
    --fora: #E08B80;
    --realce: rgba(111,182,200,.10);
  }}
}}
:root[data-theme="dark"] {{
  --papel: #101A1E;
  --carta: #16242A;
  --tinta: #E8EDEC;
  --tinta-2: #93A6AC;
  --fio: #26383F;
  --fundo: #0A171C;
  --mar: #6FB6C8;
  --lida: #63C08E;
  --obter: #E0A64E;
  --fora: #E08B80;
  --realce: rgba(111,182,200,.10);
}}
* {{ box-sizing: border-box; }}
body {{
  margin: 0;
  background: var(--papel);
  color: var(--tinta);
  font: 400 16px/1.6 "IBM Plex Sans", system-ui, sans-serif;
  -webkit-font-smoothing: antialiased;
}}
.envelope {{ max-width: 62rem; margin: 0 auto; padding: 0 1.5rem 6rem; }}

/* cabeçalho */
.topo {{
  background: var(--fundo);
  color: #EAF1F2;
  margin-bottom: 2.5rem;
}}
.topo .envelope {{ padding-top: 3.5rem; padding-bottom: 2.5rem; }}
.eyebrow {{
  font: 600 11px/1 "IBM Plex Mono", monospace;
  letter-spacing: .18em;
  text-transform: uppercase;
  color: #7FB3BF;
  margin: 0 0 1.4rem;
}}
h1 {{
  font: 400 clamp(2.4rem, 6vw, 3.6rem)/1.05 Newsreader, Georgia, serif;
  letter-spacing: -.015em;
  margin: 0 0 1rem;
  text-wrap: balance;
}}
.resumo {{
  font: 400 17px/1.55 Newsreader, Georgia, serif;
  color: #B7CDD3;
  max-width: 44ch;
  margin: 0;
}}

/* contagem */
.placar {{
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(11rem, 1fr));
  gap: 1px;
  background: var(--fio);
  border: 1px solid var(--fio);
  margin-bottom: 3.5rem;
}}
.placar div {{ background: var(--carta); padding: 1.4rem 1.5rem; }}
.placar b {{
  display: block;
  font: 600 2.4rem/1 "IBM Plex Mono", monospace;
  font-variant-numeric: tabular-nums;
  letter-spacing: -.02em;
}}
.placar span {{
  display: block;
  font-size: 13.5px;
  line-height: 1.4;
  color: var(--tinta-2);
  margin-top: .5rem;
}}
.placar .n-lida b {{ color: var(--lida); }}
.placar .n-obter b {{ color: var(--obter); }}
.placar .n-fora b {{ color: var(--fora); }}

/* seções */
.bloco {{ margin-bottom: 3.25rem; }}
.cab {{
  border-top: 2px solid var(--tinta);
  padding-top: .9rem;
  margin-bottom: 1.25rem;
}}
.cab h2 {{
  font: 600 1.5rem/1.2 Newsreader, Georgia, serif;
  margin: 0 0 .4rem;
  letter-spacing: -.01em;
}}
.cab p {{
  margin: 0;
  color: var(--tinta-2);
  font-size: 14.5px;
  line-height: 1.55;
  max-width: 60ch;
}}
.nota {{
  background: var(--realce);
  border-left: 3px solid var(--mar);
  padding: .9rem 1.1rem;
  margin: 0 0 1.25rem;
  font-size: 14px;
  line-height: 1.55;
  color: var(--tinta-2);
}}

/* a lista, como registro */
.lista {{ list-style: none; margin: 0; padding: 0; }}
.norma {{
  display: grid;
  grid-template-columns: 5.5rem 1fr auto;
  gap: 1.1rem;
  align-items: baseline;
  padding: .85rem 0;
  border-bottom: 1px solid var(--fio);
}}
.norma:first-child {{ border-top: 1px solid var(--fio); }}
.ident {{
  font: 600 15px/1.25 "IBM Plex Mono", monospace;
  font-variant-numeric: tabular-nums;
  text-align: right;
  white-space: nowrap;
}}
.ident b {{ font-weight: 600; }}
.ident i {{
  display: block;
  font-style: normal;
  font-size: 12px;
  font-weight: 500;
  color: var(--tinta-2);
}}
.lida .ident b {{ color: var(--lida); }}
.obter .ident b {{ color: var(--obter); }}
.fora .ident b {{ color: var(--fora); }}
.corpo {{ min-width: 0; }}
.nome {{ display: block; font-weight: 500; line-height: 1.35; }}
.papel {{
  display: block;
  font-size: 13.5px;
  line-height: 1.45;
  color: var(--tinta-2);
  margin-top: .15rem;
}}
.orgao {{
  font: 500 11px/1 "IBM Plex Mono", monospace;
  letter-spacing: .06em;
  color: var(--tinta-2);
  border: 1px solid var(--fio);
  padding: .35rem .5rem;
  white-space: nowrap;
}}

/* decisões */
.decisoes {{ list-style: none; margin: 0; padding: 0; }}
.decisoes li {{
  border-top: 1px solid var(--fio);
  padding: 1.1rem 0;
}}
.decisoes h3 {{
  font: 600 16px/1.35 "IBM Plex Sans", sans-serif;
  margin: 0 0 .35rem;
}}
.decisoes p {{
  margin: 0;
  font-size: 14.5px;
  line-height: 1.6;
  color: var(--tinta-2);
  max-width: 66ch;
}}

.pe {{
  margin-top: 3.5rem;
  padding-top: 1.5rem;
  border-top: 1px solid var(--fio);
  font-size: 13.5px;
  line-height: 1.65;
  color: var(--tinta-2);
  max-width: 62ch;
}}
.pe em {{ font-family: Newsreader, Georgia, serif; }}

@media (max-width: 34rem) {{
  .norma {{ grid-template-columns: 4.5rem 1fr; }}
  .orgao {{ grid-column: 2; justify-self: start; margin-top: .4rem; }}
}}
</style>

<div class="topo"><div class="envelope">
  <p class="eyebrow">Consulta Pesqueira · {HOJE.day:02d}/{HOJE.month:02d}/{HOJE.year}</p>
  <h1>Registro de normas</h1>
  <p class="resumo">Tudo o que o aplicativo cita, separado entre o que foi
   lido por inteiro e o que ainda falta obter. Gerado a partir dos dados
   do próprio aplicativo — não escrito à mão.</p>
</div></div>

<div class="envelope">

<div class="placar">
  <div class="n-lida"><b>{len(lidas)}</b><span>normas com o texto lido
   por inteiro. São resposta do aplicativo.</span></div>
  <div class="n-obter"><b>{len(obter)}</b><span>citadas no aplicativo,
   texto ainda não obtido.</span></div>
  <div class="n-fora"><b>{len(d["semcitar"])}</b><span>que a pesquisa
   localizou e ainda não entraram.</span></div>
</div>

{corpo_lidas}

{secao("A obter", "O aplicativo cita estas normas, mas não reproduz regra "
       "nenhuma a partir delas. Entram só para dizer o que procurar.",
       itens_obter, "obter",
       "Onde uma destas alcança uma espécie, a ficha diz “Consulte a "
       "norma” e dá o nome — nunca “captura vedada”, porque onde existe "
       "Plano de Recuperação a vedação do art. 3º não se aplica sozinha.")}

{secao("Fora do aplicativo, por enquanto",
       "Localizadas na pesquisa em fontes oficiais. Não estão no "
       "aplicativo porque não temos o texto — só a citação.",
       itens_fora, "fora",
       "As seis primeiras vieram do calendário de proibições publicado "
       "pelo Governo de Santa Catarina. São regras de área, não de "
       "espécie, e é o tipo de regra que a guarnição usa em toda "
       "abordagem de costa.")}

<section class="bloco">
  <header class="cab">
    <h2>O que depende de decisão, não de norma</h2>
    <p>Os pontos em verificação registrados dentro do aplicativo. Cada
     um aparece na ficha das espécies que alcança.</p>
  </header>
  <ol class="decisoes">{decisoes}</ol>
</section>

<p class="pe">Este registro sai dos arquivos de dados do aplicativo a cada
 vez que é gerado, e por isso não tem como ficar defasado em relação a
 ele. <em>Uma lista de normas mantida à mão envelhece em silêncio</em> —
 foi o que aconteceu com a base normativa da tela inicial, que dizia
 cinco quando o aplicativo já citava mais de vinte.</p>

</div>''')
print('normas.html:', len(lidas), 'lidas |', len(obter), 'a obter |',
      len(d['semcitar']), 'fora')
