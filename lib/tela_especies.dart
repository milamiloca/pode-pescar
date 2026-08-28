import 'package:flutter/material.dart';
import 'ameacadas.dart';
import 'conflitos.dart';
import 'dados.dart';
import 'defesos.dart';
import 'desenhos.dart';
import 'fichas.dart';
import 'tela_fiscal.dart';
import 'tela_apoio.dart';
import 'tela_conflitos.dart';
import 'tela_temporadas.dart';
import 'tema.dart';

const _in53 = 'Instrução Normativa MMA nº 53, de 22 de novembro de 2005';
const _in53d = 'Publicada no Diário Oficial em 24/11/2005.';
const _lista = 'Portaria GM/MMA nº 1.667, de 27 de abril de 2026 (a lista) '
    'e nº 1.666, de 27 de abril de 2026 (as regras)';
const _listad = 'Publicadas no Diário Oficial em 28/04/2026, edição 78, '
    'seção 1, página 96. A 1.667 revogou a Portaria MMA nº 445/2014.';

// =====================================================================
// ESPÉCIES — a lista única
//
// Uma busca só, 514 espécies. A ficha reúne o que cada norma diz sobre
// aquela espécie e nada mais: tamanho mínimo da IN 53, proibição da
// Lista Nacional, regra própria quando houver. O que a norma não diz,
// a tela não diz.
// =====================================================================

/// O que a busca pode filtrar.
enum _Filtro { todas, comTamanho, ameacadas, comDefeso }

class TelaEspecies extends StatefulWidget {
  const TelaEspecies({super.key});

  @override
  State<TelaEspecies> createState() => _TelaEspeciesState();
}

class _TelaEspeciesState extends State<TelaEspecies> {
  String busca = '';
  _Filtro filtro = _Filtro.todas;
  int grupo = -1;

  @override
  Widget build(BuildContext context) {
    final termo = semAcento(busca);
    final achadas = fichas.where((f) {
      switch (filtro) {
        case _Filtro.comTamanho:
          if (!f.temTamanho) return false;
        case _Filtro.ameacadas:
          if (!f.ameacada) return false;
        case _Filtro.comDefeso:
          if (!f.temTemporada) return false;
        case _Filtro.todas:
          break;
      }
      if (grupo >= 0 && (f.lista?.grupo ?? -1) != grupo) return false;
      if (termo.isEmpty) return true;
      return semAcento(f.textoDeBusca).contains(termo);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Espécies')),
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
                    const Text('Selecione a espécie', style: estiloTitulo),
                    const SizedBox(height: 6),
                    Text(
                      '${fichas.length} espécies. $quantasComTamanho com '
                      'tamanho mínimo na IN 53, $quantasAmeacadas na Lista '
                      'Nacional Oficial de ameaçadas.',
                      style: estiloCorpo,
                    ),
                    const SizedBox(height: 16),
                    CampoBusca(
                      dica: 'Nome popular, científico ou família',
                      aoMudar: (v) => setState(() => busca = v),
                    ),
                    const SizedBox(height: 12),
                    _Fichas(
                      filtro: filtro,
                      grupo: grupo,
                      aoTrocarFiltro: (f) => setState(() {
                        filtro = f;
                        if (f != _Filtro.ameacadas) grupo = -1;
                      }),
                      aoTrocarGrupo: (g) => setState(() => grupo = g),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      achadas.length == fichas.length
                          ? '${achadas.length} espécies'
                          : '${achadas.length} de ${fichas.length} espécies',
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
                        itemCount: achadas.length,
                        itemBuilder: (context, i) => _Linha(f: achadas[i]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Fichas extends StatelessWidget {
  final _Filtro filtro;
  final int grupo;
  final ValueChanged<_Filtro> aoTrocarFiltro;
  final ValueChanged<int> aoTrocarGrupo;

  const _Fichas({
    required this.filtro,
    required this.grupo,
    required this.aoTrocarFiltro,
    required this.aoTrocarGrupo,
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
            _Chip(
              texto: 'Todas',
              ligada: filtro == _Filtro.todas,
              aoTocar: () => aoTrocarFiltro(_Filtro.todas),
            ),
            _Chip(
              texto: 'Com tamanho mínimo',
              ligada: filtro == _Filtro.comTamanho,
              aoTocar: () => aoTrocarFiltro(_Filtro.comTamanho),
            ),
            _Chip(
              texto: 'Ameaçadas',
              ligada: filtro == _Filtro.ameacadas,
              aoTocar: () => aoTrocarFiltro(_Filtro.ameacadas),
            ),
            _Chip(
              texto: 'Com defeso',
              ligada: filtro == _Filtro.comDefeso,
              aoTocar: () => aoTrocarFiltro(_Filtro.comDefeso),
            ),
          ],
        ),
        if (filtro == _Filtro.ameacadas) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _Chip(
                texto: 'Todos os grupos',
                ligada: grupo < 0,
                aoTocar: () => aoTrocarGrupo(-1),
              ),
              for (var i = 0; i < gruposAmeacadas.length; i++)
                _Chip(
                  texto: gruposAmeacadas[i],
                  ligada: grupo == i,
                  aoTocar: () => aoTrocarGrupo(i),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String texto;
  final bool ligada;
  final VoidCallback aoTocar;

  const _Chip({
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

/// Uma linha da lista. À direita, o que decide na hora: proibida,
/// data em que passa a valer, ou a medida mínima.
class _Linha extends StatelessWidget {
  final Ficha f;
  const _Linha({required this.f});

  @override
  Widget build(BuildContext context) {
    final segunda = f.in53 != null
        ? f.cientifico
        : (f.lista!.pop445.isNotEmpty
            ? '${f.lista!.pop445}  ·  nome da portaria revogada'
            : '${f.lista!.familia} · ${f.lista!.ordem}');

    return Cartao(
      destaque: f.proibidaHoje ? corNaoPode : null,
      aoTocar: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => TelaFicha(f: f),
      )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (f.ameacada)
            Container(
              width: 4,
              height: 40,
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
                  f.titulo,
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        f.in53 == null ? FontStyle.italic : FontStyle.normal,
                    height: 1.2,
                    color: corTinta,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  segunda,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontStyle:
                        f.in53 != null ? FontStyle.italic : FontStyle.normal,
                    color: corApagada,
                  ),
                ),
                if (f.ameacada) ...[
                  const SizedBox(height: 3),
                  Text(
                    f.categoriaPorExtenso,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: corNaoPode,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          _Etiqueta(f: f),
        ],
      ),
    );
  }
}

class _Etiqueta extends StatelessWidget {
  final Ficha f;
  const _Etiqueta({required this.f});

  @override
  Widget build(BuildContext context) {
    if (f.temDuvida) {
      return const Selo('verificar', cor: corBoia, forte: true);
    }
    if (f.proibidaHoje) {
      return const Selo('não pode', cor: corNaoPode, forte: true);
    }
    if (f.proibidaDepois) {
      return const Selo('25/10', cor: corBoia, forte: true);
    }
    if (f.ameacada) {
      return const Selo('na Lista', cor: corNaoPode);
    }
    return Text(
      '${f.in53!.tamanho} cm',
      style: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.w600, color: corMar),
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
          'Nenhuma espécie encontrada.\n\nTente só o começo do nome, o '
          'gênero (Balistes), a família (Balistidae) ou a ordem.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, height: 1.5, color: corApagada),
        ),
      ),
    );
  }
}

// =====================================================================
// A FICHA DA ESPÉCIE
//
// Ordem de leitura: primeiro o que decide (proibida ou medida), depois
// o detalhe, depois as normas. O enquadramento fica aqui embaixo, já
// sabendo de que espécie se trata.
// =====================================================================

class TelaFicha extends StatelessWidget {
  final Ficha f;
  const TelaFicha({super.key, required this.f});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(f.ameacada ? 'Espécie ameaçada' : 'Espécie'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
            children: [
              Text(
                f.titulo,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  fontStyle:
                      f.in53 == null ? FontStyle.italic : FontStyle.normal,
                  height: 1.12,
                  color: corTinta,
                ),
              ),
              if (f.in53 != null) ...[
                const SizedBox(height: 2),
                Text(
                  f.cientifico,
                  style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: corApagada),
                ),
              ],
              if (f.in53?.observacao.isNotEmpty ?? false) ...[
                const SizedBox(height: 10),
                _Nota(texto: f.in53!.observacao),
              ],
              const SizedBox(height: 18),

              // 1. o veredito
              if (f.proibidaHoje) ..._proibida(context),
              if (f.proibidaDepois) ..._aindaNao(context),
              if (f.ameacada && !f.dataConferida) ..._naListaSemData(context),
              if (!f.ameacada && f.temTamanho) ..._medida(),

              // 2. o que ainda não está confirmado
              if (f.temDuvida) ..._duvidas(),

              // 3. defeso ou temporada da espécie
              if (f.temTemporada) ..._temporadas(),

              // 3. a classificação na Lista
              if (f.ameacada) ..._classificacao(),

              // 4. as ações
              const SizedBox(height: 22),
              if (f.ameacada) ...[
                BotaoGrande(
                  texto: 'Captura incidental — art. 3º, § 4º',
                  icone: Icons.waves,
                  aoTocar: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => TelaVeioNaRede(nome: f.titulo),
                  )),
                ),
                const SizedBox(height: 10),
              ],
              // A tolerância do art. 4º da IN 53 é sobre exemplares
              // abaixo da medida. Onde a vedação alcança qualquer
              // tamanho, não há percentual a calcular — o botão sai.
              if (f.temTamanho && !f.ameacada) ...[
                BotaoGrande(
                  texto: 'Calcular a tolerância',
                  icone: Icons.calculate_outlined,
                  aoTocar: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => TelaCalculadora(especie: f.in53!),
                  )),
                ),
                const SizedBox(height: 10),
              ],
              if (f.temTamanho)
                BotaoGrande(
                  texto: 'Montar enquadramento',
                  icone: Icons.gavel,
                  aoTocar: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => TelaEnquadramento(especie: f.in53!),
                  )),
                )
              else
                _SemEnquadramento(f: f),

              // 5. as fontes
              const SizedBox(height: 24),
              if (f.temTamanho) const Fonte(norma: _in53, detalhe: _in53d),
              if (f.temTamanho && f.ameacada) const SizedBox(height: 12),
              if (f.ameacada) const Fonte(norma: _lista, detalhe: _listad),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- proibida hoje ----------

  List<Widget> _proibida(BuildContext context) => [
        _Bloco(
          cor: corNaoPode,
          etiqueta: f.categoriaPorExtenso.toUpperCase(),
          titulo: 'Captura vedada',
          texto: 'Vedados também o transporte, a guarda a bordo, o '
              'armazenamento, o manejo, o beneficiamento e a comercialização '
              '(art. 3º da Portaria 1.666).',
        ),
        const SizedBox(height: 10),
        const _MesmaProtecao(),
        if (f.temTamanho) ...[
          const SizedBox(height: 12),
          _MedidaVencida(cm: f.in53!.tamanho),
        ],
      ];

  // ---------- entrou agora na Lista ----------

  List<Widget> _aindaNao(BuildContext context) {
    final dias = diasAteAsNovasProibicoes();
    return [
      _Bloco(
        cor: corBoia,
        etiqueta: f.categoriaPorExtenso.toUpperCase(),
        titulo: dias > 0
            ? 'Passa a ser vedada\nem 25 de outubro'
            : 'Captura vedada',
        texto: dias > 0
            ? 'A espécie não constava da Portaria MMA nº 445/2014. Pelo '
                'art. 12 da Portaria 1.666, a vedação do art. 3º entra em '
                'vigor em 25/10/2026 — faltam $dias dias. Até lá vale o '
                'tamanho mínimo da IN 53.'
            : 'O prazo de 180 dias do art. 12 da Portaria 1.666 venceu em '
                '25/10/2026. A vedação do art. 3º está em vigor.',
      ),
      const SizedBox(height: 10),
      const _MesmaProtecao(),
      if (f.temTamanho && dias > 0) ...[
        const SizedBox(height: 12),
        _MedidaValendo(e: f.in53!),
      ],
    ];
  }

  // ---------- na Lista, sem conferência de data ----------
  //
  // Para as 479 espécies fora da IN 53 o app não afirma desde quando a
  // vedação vale: isso depende de constar ou não da Portaria 445/2014,
  // e essa conferência só foi feita, uma a uma, para as da IN 53.

  List<Widget> _naListaSemData(BuildContext context) {
    final dias = diasAteAsNovasProibicoes();
    return [
      _Bloco(
        cor: corNaoPode,
        etiqueta: f.categoriaPorExtenso.toUpperCase(),
        titulo: 'Captura vedada',
        texto: 'Vedados também o transporte, a guarda a bordo, o '
            'armazenamento, o manejo, o beneficiamento e a comercialização '
            '(art. 3º da Portaria 1.666).',
      ),
      const SizedBox(height: 10),
      const _MesmaProtecao(),
      if (dias > 0) ...[
        const SizedBox(height: 12),
        _Aviso(
          etiqueta: 'DESDE QUANDO VALE',
          texto: 'Espécie que já constava da Portaria MMA nº 445/2014: a '
              'vedação vale hoje. Espécie que entrou agora: começa em '
              '25/10/2026, daqui a $dias dias (art. 12 da Portaria 1.666). '
              'Esta conferência foi feita, espécie por espécie, apenas para '
              'as $quantasComTamanho da IN 53. Para as demais, confira a '
              'Portaria 445/2014 antes de autuar.',
        ),
      ],
    ];
  }

  // ---------- só o tamanho mínimo ----------

  List<Widget> _medida() {
    final e = f.in53!;
    return [
      Container(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
        decoration: BoxDecoration(
          color: corSuperficie,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: corBorda),
        ),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 100 / 60,
              child: CustomPaint(
                painter: PeixePainter(
                  forma: e.forma,
                  cor: const Color(0xFF8FA6AF),
                  mostrarMedida: true,
                  ateFurca: e.furcal,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              e.furcal
                  ? 'Comprimento furcal: da ponta do focinho até a\n'
                      'forquilha da nadadeira caudal (art. 3º).'
                  : 'Comprimento total: da ponta do focinho até a\n'
                      'extremidade mais longa da caudal (art. 3º).',
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 15.5, height: 1.4, color: corTinta),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      _MedidaValendo(e: e),
      const SizedBox(height: 20),
      const TituloSecao('Vedação'),
      const Text(
        'Vedadas a captura, a manutenção a bordo e o desembarque de '
        'exemplares abaixo da medida. Aplica-se do Espírito Santo ao Rio '
        'Grande do Sul.',
        style: estiloCorpo,
      ),
      const SizedBox(height: 16),
      const TituloSecao('Tolerância — art. 4º'),
      Text(
        'Admite-se até ${e.tolerancia}% em peso, sobre o total da captura, '
        'de exemplares abaixo da medida. Acima disso, há infração.',
        style: estiloCorpo,
      ),
      const SizedBox(height: 16),
      const TituloSecao('Exclusão: pesca de arrasto'),
      const Text(
        'O tamanho mínimo não se aplica à pesca de arrasto (art. 2º, § 1º).',
        style: estiloCorpo,
      ),
    ];
  }

  // ---------- o que está em verificação ----------
  //
  // Vem logo depois do veredito, de propósito: se a resposta que o
  // policial acabou de ler pode estar errada, ele precisa saber antes
  // de rolar a tela.

  List<Widget> _duvidas() => [
        const SizedBox(height: 14),
        for (final c in f.emVerificacao) ...[
          CartaoConflito(c: c, comecaFechado: true),
          const SizedBox(height: 10),
        ],
      ];

  // ---------- defeso e temporada ----------

  List<Widget> _temporadas() => [
        const SizedBox(height: 24),
        TituloSecao(f.temporadas.length == 1
            ? 'Esta espécie tem período fechado'
            : 'Esta espécie tem ${f.temporadas.length} regras de período'),
        const Text(
          'Além do tamanho mínimo, a captura só é permitida dentro do '
          'período fixado em norma específica.',
          style: estiloCorpo,
        ),
        const SizedBox(height: 12),
        for (final d in f.temporadas) ...[
          CartaoDefeso(d: d, semTitulo: true),
          const SizedBox(height: 10),
        ],
      ];

  // ---------- classificação na Lista ----------

  List<Widget> _classificacao() {
    final a = f.lista!;
    return [
      const SizedBox(height: 24),
      const TituloSecao('Como a Lista classifica'),
      _Campo(rotulo: 'Item na Lista', valor: '${a.n}${a.marca ? "  *" : ""}'),
      _Campo(rotulo: 'Nome científico', valor: a.especie),
      _Campo(rotulo: 'Grupo taxonômico', valor: a.grupoPorExtenso),
      _Campo(rotulo: 'Classe', valor: a.classePorExtenso),
      _Campo(rotulo: 'Ordem', valor: a.ordem),
      _Campo(rotulo: 'Família', valor: a.familia),
      _Campo(rotulo: 'Categoria de risco', valor: a.categoriaPorExtenso),
      if (a.pop445.isNotEmpty && f.in53 == null) ...[
        const SizedBox(height: 6),
        _Aviso(
          etiqueta: 'NOME COMUM — NORMA REVOGADA',
          titulo: a.pop445,
          texto: 'É o nome da coluna "Nome comum" da Portaria MMA nº '
              '445/2014, revogada pela 1.667. A Lista em vigor não traz nome '
              'popular. Está aqui só para achar a espécie na busca: não '
              'fundamenta autuação, e o nome usado na região pode ser outro. '
              'O que vale é o nome científico.',
        ),
      ],
      if (a.marca) ...[
        const SizedBox(height: 12),
        const _Aviso(
          etiqueta: 'ESTE ITEM VEM COM ASTERISCO',
          texto: 'A Lista imprime um asterisco ao lado do número de 94 dos '
              '490 itens. O texto publicado no Diário Oficial não traz '
              'legenda para essa marca. Está reproduzida como está, sem '
              'interpretação.',
        ),
      ],
      if (_mesmoGenero(a).isNotEmpty) ...[
        const SizedBox(height: 18),
        TituloSecao('Outras do gênero ${a.genero} na Lista'),
        const SizedBox(height: 4),
        for (final o in _mesmoGenero(a))
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              '${o.especie} — ${o.categoriaPorExtenso} (item ${o.n})',
              style: const TextStyle(
                  fontSize: 14.5, height: 1.35, color: corTinta),
            ),
          ),
        const SizedBox(height: 4),
        const Text(
          'Espécies do mesmo gênero se parecem. Confira o nome científico '
          'inteiro antes de concluir.',
          style: TextStyle(fontSize: 13.5, height: 1.4, color: corApagada),
        ),
      ],
    ];
  }

  List<Ameacada> _mesmoGenero(Ameacada a) =>
      listaAmeacadas.where((o) => o.genero == a.genero && o.n != a.n).toList();
}

class _SemEnquadramento extends StatelessWidget {
  final Ficha f;
  const _SemEnquadramento({required this.f});

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
      child: const Text(
        'O gerador de enquadramento monta o cálculo da tolerância da IN 53, '
        'que não se aplica a esta espécie: a vedação do art. 3º alcança '
        'qualquer tamanho, sem percentual a apurar.',
        style: TextStyle(fontSize: 13.5, height: 1.45, color: corApagada),
      ),
    );
  }
}

// ---------------------------------------------------------------- peças

class _Bloco extends StatelessWidget {
  final Color cor;
  final String etiqueta;
  final String titulo;
  final String texto;

  const _Bloco({
    required this.cor,
    required this.etiqueta,
    required this.titulo,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(etiqueta,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                  color: Colors.white70)),
          const SizedBox(height: 8),
          Text(titulo,
              style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  height: 1.08,
                  color: Colors.white)),
          const SizedBox(height: 10),
          Text(texto,
              style: const TextStyle(
                  fontSize: 15, height: 1.4, color: Colors.white70)),
        ],
      ),
    );
  }
}

/// A medida que vale, em destaque.
class _MedidaValendo extends StatelessWidget {
  final Especie e;
  const _MedidaValendo({required this.e});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        color: corMar,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          const Text('TAMANHO MÍNIMO DE CAPTURA',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.3,
                  color: Colors.white70)),
          const SizedBox(height: 6),
          Text('${e.tamanho} cm',
              style: const TextStyle(
                  fontSize: 46,
                  fontWeight: FontWeight.bold,
                  height: 1,
                  color: Colors.white)),
        ],
      ),
    );
  }
}

/// A medida que continua na IN 53 mas não decide mais nada.
class _MedidaVencida extends StatelessWidget {
  final int cm;
  const _MedidaVencida({required this.cm});

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$cm cm',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: corApagada,
              decoration: TextDecoration.lineThrough,
              decorationThickness: 2,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Tamanho mínimo da IN 53. Continua na norma, mas não decide '
              'mais: a vedação alcança a espécie em qualquer tamanho.',
              style: TextStyle(fontSize: 13.5, height: 1.4, color: corApagada),
            ),
          ),
        ],
      ),
    );
  }
}

/// As três categorias não são três níveis de vedação.
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
        'tamanho da vedação.',
        style: TextStyle(fontSize: 13.5, height: 1.4, color: corApagada),
      ),
    );
  }
}

class _Aviso extends StatelessWidget {
  final String etiqueta;
  final String? titulo;
  final String texto;

  const _Aviso({required this.etiqueta, this.titulo, required this.texto});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(etiqueta,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: corBoia)),
          if (titulo != null) ...[
            const SizedBox(height: 8),
            Text(titulo!,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                    color: corTinta)),
          ],
          const SizedBox(height: 6),
          Text(texto,
              style: const TextStyle(
                  fontSize: 13.5, height: 1.45, color: corApagada)),
        ],
      ),
    );
  }
}

class _Nota extends StatelessWidget {
  final String texto;
  const _Nota({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: corBoia.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(texto,
          style: const TextStyle(
              fontSize: 13.5, height: 1.4, color: corApagada)),
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
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 132,
            child: Text(rotulo,
                style: const TextStyle(
                    fontSize: 13.5, height: 1.35, color: corApagada)),
          ),
          Expanded(
            child: Text(valor,
                style: const TextStyle(
                    fontSize: 14.5,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                    color: corTinta)),
          ),
        ],
      ),
    );
  }
}
