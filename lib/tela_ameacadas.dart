import 'package:flutter/material.dart';
import 'ameacadas.dart';
import 'dados.dart';
import 'tema.dart';

const _lista = 'Portaria GM/MMA nº 1.667, de 27 de abril de 2026 (a lista) '
    'e nº 1.666, de 27 de abril de 2026 (as regras)';
const _listad = 'Publicadas no Diário Oficial em 28/04/2026, edição 78, '
    'seção 1, página 96. A 1.667 revogou a Portaria MMA nº 445/2014.';

// =====================================================================
// LISTA NACIONAL OFICIAL — as 490 espécies
//
// A tela de tamanho mínimo responde "peguei este peixe, e agora?" e só
// alcança as 35 espécies da IN 53. Esta responde a outra pergunta:
// "esta espécie está na lista?" — e alcança as 490.
//
// A Lista não traz nome popular. A busca aqui aceita nome científico,
// família, ordem e gênero, porque é o que a norma em vigor dá — e mais
// o nome comum que a Portaria 445/2014 usava, que entra só como pista
// de busca, marcado como norma revogada. Fora esses dois caminhos, não
// há de onde tirar nome popular sem inventar.
// =====================================================================

class TelaAmeacadas extends StatefulWidget {
  const TelaAmeacadas({super.key});

  @override
  State<TelaAmeacadas> createState() => _TelaAmeacadasState();
}

class _TelaAmeacadasState extends State<TelaAmeacadas> {
  String busca = '';

  /// Índice em [gruposAmeacadas], ou -1 para todos.
  int grupo = -1;

  /// 'CR', 'EN', 'VU', ou '' para todas.
  String categoria = '';

  @override
  Widget build(BuildContext context) {
    final termo = semAcento(busca);
    final achadas = listaAmeacadas.where((a) {
      if (grupo >= 0 && a.grupo != grupo) return false;
      if (categoria.isNotEmpty && a.cat != categoria) return false;
      if (termo.isEmpty) return true;
      return semAcento(a.especie).contains(termo) ||
          semAcento(a.familia).contains(termo) ||
          semAcento(a.ordem).contains(termo) ||
          semAcento(a.classePorExtenso).contains(termo) ||
          (a.pop445.isNotEmpty && semAcento(a.pop445).contains(termo));
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de ameaçadas')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Está na lista?', style: estiloTitulo),
                    const SizedBox(height: 6),
                    Text(
                      'As ${listaAmeacadas.length} espécies de peixes e '
                      'invertebrados aquáticos da Lista Nacional Oficial. '
                      'A norma em vigor só traz o nome científico; a busca '
                      'também aceita o nome comum da portaria anterior.',
                      style: estiloCorpo,
                    ),
                    const SizedBox(height: 16),
                    CampoBusca(
                      dica: 'Nome científico, família ou nome comum',
                      aoMudar: (v) => setState(() => busca = v),
                    ),
                    const SizedBox(height: 12),
                    _Filtros(
                      grupo: grupo,
                      categoria: categoria,
                      aoTrocarGrupo: (g) => setState(() => grupo = g),
                      aoTrocarCategoria: (c) => setState(() => categoria = c),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      achadas.length == listaAmeacadas.length
                          ? '${achadas.length} espécies'
                          : '${achadas.length} de ${listaAmeacadas.length} '
                              'espécies',
                      style: estiloEtiqueta,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Expanded(
                child: achadas.isEmpty
                    ? const _Vazio()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        itemCount: achadas.length + 1,
                        itemBuilder: (context, i) {
                          if (i == achadas.length) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Fonte(norma: _lista, detalhe: _listad),
                            );
                          }
                          return _Linha(a: achadas[i]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Filtros extends StatelessWidget {
  final int grupo;
  final String categoria;
  final ValueChanged<int> aoTrocarGrupo;
  final ValueChanged<String> aoTrocarCategoria;

  const _Filtros({
    required this.grupo,
    required this.categoria,
    required this.aoTrocarGrupo,
    required this.aoTrocarCategoria,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _Ficha(
              texto: 'Todos os grupos',
              ligada: grupo < 0,
              aoTocar: () => aoTrocarGrupo(-1),
            ),
            for (var i = 0; i < gruposAmeacadas.length; i++)
              _Ficha(
                texto: gruposAmeacadas[i],
                ligada: grupo == i,
                aoTocar: () => aoTrocarGrupo(i),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _Ficha(
              texto: 'Todas as categorias',
              ligada: categoria.isEmpty,
              aoTocar: () => aoTrocarCategoria(''),
            ),
            for (final c in const ['CR', 'EN', 'VU'])
              _Ficha(
                texto: switch (c) {
                  'CR' => 'Criticamente em Perigo',
                  'EN' => 'Em Perigo',
                  _ => 'Vulnerável',
                },
                ligada: categoria == c,
                aoTocar: () => aoTrocarCategoria(c),
              ),
          ],
        ),
      ],
    );
  }
}

class _Ficha extends StatelessWidget {
  final String texto;
  final bool ligada;
  final VoidCallback aoTocar;

  const _Ficha({
    required this.texto,
    required this.ligada,
    required this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ligada ? corMar : corSuperficie,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: aoTocar,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ligada ? corMar : corBorda),
          ),
          child: Text(
            texto,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: ligada ? FontWeight.w600 : FontWeight.w500,
              color: ligada ? Colors.white : corApagada,
            ),
          ),
        ),
      ),
    );
  }
}

/// Uma linha da lista. O nome científico manda, porque é o que a norma
/// traz. Quando a espécie também está na IN 53, o nome popular aparece
/// embaixo — é o único cruzamento que existe sem inventar nada.
class _Linha extends StatelessWidget {
  final Ameacada a;
  const _Linha({required this.a});

  @override
  Widget build(BuildContext context) {
    final naIn53 = especies.where((e) => e.itemLista == a.n).toList();

    return Cartao(
      aoTocar: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => TelaAmeacada(a: a),
      )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: (naIn53.isEmpty && a.pop445.isEmpty) ? 40 : 56,
            margin: const EdgeInsets.only(right: 12, top: 2),
            decoration: BoxDecoration(
              color: corNaoPode,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.especie,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    height: 1.2,
                    color: corTinta,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${a.familia} · ${a.ordem}',
                  style: const TextStyle(fontSize: 13, color: corApagada),
                ),
                const SizedBox(height: 4),
                Text(
                  a.categoriaPorExtenso,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: corNaoPode,
                  ),
                ),
                if (naIn53.isNotEmpty)
                  const SizedBox(height: 4),
                if (naIn53.isNotEmpty)
                  Text(
                    'Na IN 53: ${naIn53.first.nome}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: corMar,
                    ),
                  )
                else if (a.pop445.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${a.pop445}  ·  nome da portaria revogada',
                    style: const TextStyle(fontSize: 13, color: corApagada),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${a.n}${a.marca ? ' *' : ''}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: corApagada,
            ),
          ),
        ],
      ),
    );
  }
}

class _Vazio extends StatelessWidget {
  const _Vazio();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Text(
          'Não achei nada com esse termo.\n\nA Lista usa nome científico. '
          'Tente o gênero (Balistes), a família (Balistidae), a ordem, ou o '
          'nome comum que a portaria anterior usava (mero, pargo, caranha).',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, height: 1.5, color: corApagada),
        ),
      ),
    );
  }
}

// =====================================================================
// UMA ESPÉCIE DA LISTA
// =====================================================================

class TelaAmeacada extends StatelessWidget {
  final Ameacada a;
  const TelaAmeacada({super.key, required this.a});

  @override
  Widget build(BuildContext context) {
    final naIn53 = especies.where((e) => e.itemLista == a.n).toList();
    final mesmoGenero = listaAmeacadas
        .where((o) => o.genero == a.genero && o.n != a.n)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Espécie ameaçada')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
            children: [
              Text(
                a.especie,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  height: 1.1,
                  color: corTinta,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Item ${a.n} da Lista Nacional Oficial',
                style: const TextStyle(fontSize: 14, color: corApagada),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: corNaoPode,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.categoriaPorExtenso.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Proteção integral',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.05,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Proibida a captura, o transporte, o armazenamento, a '
                      'guarda, o manejo, o beneficiamento e a comercialização '
                      '(art. 3º da Portaria 1.666).',
                      style: TextStyle(
                          fontSize: 15, height: 1.4, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const _MesmaProtecao(),
              if (naIn53.isNotEmpty) ...[
                const SizedBox(height: 18),
                const TituloSecao('Nome popular'),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: corSuperficie,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: corBorda),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        naIn53.first.nome,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: corTinta,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'É o nome que a IN 53 usa para esta mesma espécie. A '
                        'Lista de ameaçadas não traz nome popular: o '
                        'cruzamento é feito pelo nome científico.',
                        style: TextStyle(
                            fontSize: 14, height: 1.4, color: corApagada),
                      ),
                    ],
                  ),
                ),
              ],
              if (naIn53.isEmpty && a.pop445.isNotEmpty) ...[
                const SizedBox(height: 18),
                const TituloSecao('Nome comum, para achar'),
                _NomeRevogado(nome: a.pop445),
              ],
              const SizedBox(height: 18),
              const TituloSecao('Como a Lista classifica'),
              _Campo(rotulo: 'Grupo taxonômico', valor: a.grupoPorExtenso),
              _Campo(rotulo: 'Classe', valor: a.classePorExtenso),
              _Campo(rotulo: 'Ordem', valor: a.ordem),
              _Campo(rotulo: 'Família', valor: a.familia),
              _Campo(rotulo: 'Categoria de risco', valor: a.categoriaPorExtenso),
              if (a.marca) ...[
                const SizedBox(height: 14),
                const _Asterisco(),
              ],
              if (mesmoGenero.isNotEmpty) ...[
                const SizedBox(height: 20),
                TituloSecao('Outras do gênero ${a.genero} na Lista'),
                const SizedBox(height: 4),
                for (final o in mesmoGenero)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '${o.especie} — ${o.categoriaPorExtenso} '
                      '(item ${o.n})',
                      style: const TextStyle(
                          fontSize: 14.5, height: 1.35, color: corTinta),
                    ),
                  ),
                const SizedBox(height: 4),
                const Text(
                  'Espécies do mesmo gênero se parecem. Confira o nome '
                  'científico inteiro antes de concluir.',
                  style:
                      TextStyle(fontSize: 13.5, height: 1.4, color: corApagada),
                ),
              ],
              const SizedBox(height: 20),
              const _Prazo(),
              const SizedBox(height: 16),
              const Fonte(norma: _lista, detalhe: _listad),
            ],
          ),
        ),
      ),
    );
  }
}

/// O nome comum vem de uma norma revogada. Serve para achar a espécie,
/// não para fundamentar nada — por isso aparece assim, com a ressalva
/// colada nele e sem o destaque que o nome científico tem.
class _NomeRevogado extends StatelessWidget {
  final String nome;
  const _NomeRevogado({required this.nome});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: corSuperficie,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: corBorda),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nome,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: corTinta,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'É o nome da coluna "Nome comum" da Portaria MMA nº 445/2014, '
            'revogada pela 1.667. A Lista em vigor não traz nome popular '
            'nenhum. Está aqui só para achar a espécie na busca: não '
            'fundamenta autuação, e o nome usado na sua região pode ser '
            'outro. O que vale é o nome científico.',
            style: TextStyle(fontSize: 14, height: 1.4, color: corApagada),
          ),
        ],
      ),
    );
  }
}

/// As três categorias não são três níveis de proibição.
class _MesmaProtecao extends StatelessWidget {
  const _MesmaProtecao();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: corNaoPode.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'Criticamente em Perigo, Em Perigo e Vulnerável recebem a mesma '
        'proteção integral. A categoria diz o risco de extinção, não o '
        'tamanho da proibição.',
        style: TextStyle(fontSize: 13.5, height: 1.4, color: corApagada),
      ),
    );
  }
}

/// O asterisco impresso na Lista, sem legenda no texto publicado.
class _Asterisco extends StatelessWidget {
  const _Asterisco();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: corBoia.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: corBoia.withValues(alpha: 0.35)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ESTE ITEM VEM COM ASTERISCO',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: corBoia)),
          SizedBox(height: 8),
          Text(
            'A Lista imprime um asterisco ao lado do número de 94 dos 490 '
            'itens. O texto publicado no Diário Oficial não traz legenda '
            'para essa marca. Está reproduzida aqui como está, sem '
            'interpretação.',
            style: TextStyle(fontSize: 13.5, height: 1.45, color: corApagada),
          ),
        ],
      ),
    );
  }
}

/// O prazo do art. 12 da Portaria 1.666.
class _Prazo extends StatelessWidget {
  const _Prazo();

  @override
  Widget build(BuildContext context) {
    final dias = diasAteAsNovasProibicoes();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: corSuperficie,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: corBorda),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('DESDE QUANDO VALE', style: estiloEtiqueta),
          const SizedBox(height: 8),
          Text(
            dias > 0
                ? 'Espécie que já constava da lista anterior (Portaria MMA '
                    'nº 445/2014): a proibição vale hoje. Espécie que entrou '
                    'agora: a proibição começa em 25 de outubro de 2026, '
                    'daqui a $dias dias (art. 12 da Portaria 1.666).'
                : 'O prazo de 180 dias do art. 12 da Portaria 1.666 já '
                    'venceu em 25 de outubro de 2026. A proibição vale para '
                    'todas as espécies da Lista.',
            style: const TextStyle(fontSize: 14.5, height: 1.45, color: corTinta),
          ),
          if (dias > 0) ...[
            const SizedBox(height: 10),
            const Text(
              'Para as 35 espécies da IN 53 essa conferência já está feita, '
              'espécie por espécie, na tela de tamanho mínimo. Para as '
              'demais, confira a Portaria 445/2014 antes de autuar.',
              style: TextStyle(fontSize: 13.5, height: 1.4, color: corApagada),
            ),
          ],
        ],
      ),
    );
  }
}

class _Campo extends StatelessWidget {
  final String rotulo;
  final String valor;
  const _Campo({required this.rotulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 132,
            child: Text(
              rotulo,
              style: const TextStyle(
                  fontSize: 13.5, height: 1.35, color: corApagada),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.35,
                  fontWeight: FontWeight.w500,
                  color: corTinta),
            ),
          ),
        ],
      ),
    );
  }
}
