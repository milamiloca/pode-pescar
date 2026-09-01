import 'package:flutter/material.dart';
import 'ameacadas.dart';
import 'conflitos.dart';
import 'dados.dart';
import 'defesos.dart';
import 'desenhos.dart';
import 'fichas.dart';
import 'nomes.dart';
import 'procura.dart';
import 'regimes.dart';
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
                    ? _Vazio(termo: busca)
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
    // O nome comum oficial da Portaria 532/2025 vem antes do nome da
    // portaria revogada: é o que está em vigor, e é o que a pessoa fala.
    final oficial = f.nomesComuns.take(3).join(', ');
    final segunda = f.in53 != null
        ? (oficial.isNotEmpty ? '${f.cientifico}  ·  $oficial' : f.cientifico)
        : (oficial.isNotEmpty
            ? oficial
            : (f.lista!.pop445.isNotEmpty
                ? '${f.lista!.pop445}  ·  nome da portaria revogada'
                : '${f.lista!.familia} · ${f.lista!.ordem}'));

    return Cartao(
      destaque: f.vedadaHoje && !f.temPlano ? corNaoPode : null,
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
    if (f.temPlano) {
      return const Selo('regulada', cor: corMar, forte: true);
    }
    if (f.temDuvida) {
      return const Selo('verificar', cor: corBoia, forte: true);
    }
    if (f.planoSemNorma) {
      return const Selo('ver norma', cor: corBoia, forte: true);
    }
    if (f.vedadaEm2510) {
      return const Selo('25/10', cor: corBoia, forte: true);
    }
    if (f.ameacada) {
      return const Selo('não pode', cor: corNaoPode, forte: true);
    }
    if (!f.temTamanho) return const SizedBox.shrink();
    return Text(
      '${f.in53!.tamanho} cm',
      style: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.w600, color: corMar),
    );
  }
}

/// O que o aplicativo responde quando não encontra ficha.
///
/// Antes respondia só "nenhuma espécie encontrada", e isso é perigoso:
/// esta tela cobre tamanho mínimo e espécie ameaçada, mais nada. Um
/// peixe pode não ter ficha aqui e mesmo assim estar num defeso, numa
/// área fechada ou numa modalidade. Quem procurou e não achou lê o
/// silêncio como "não há regra", e não é isso que o silêncio quer dizer.
///
/// Então a busca continua: pela Portaria MPA nº 532/2025, para descobrir
/// por qual nome científico a norma chama aquilo; e pelas outras telas,
/// para mostrar onde o termo aparece.
class _Vazio extends StatelessWidget {
  final String termo;
  const _Vazio({required this.termo});

  @override
  Widget build(BuildContext context) {
    final t = termo.trim();
    if (t.length < 3) {
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

    final cientificos = cientificosDoTermo(t);
    final mencoes = ondeMaisAparece(t);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(15, 14, 15, 15),
          decoration: BoxDecoration(
            color: corBoia.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: corBoia.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Selo('não consta nesta tela', cor: corBoia, forte: true),
              const SizedBox(height: 10),
              Text(
                'Nenhuma espécie desta tela atende por "$t".',
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                    color: corTinta),
              ),
              const SizedBox(height: 8),
              const Text(
                'ISSO NÃO QUER DIZER QUE A PESCA SEJA LIVRE. Esta tela '
                'responde por duas coisas apenas: tamanho mínimo da IN 53 '
                'e espécie na Lista Nacional Oficial de ameaçadas. Defeso, '
                'área proibida e petrecho estão nas outras telas, e uma '
                'espécie pode estar em qualquer uma delas sem ter ficha '
                'aqui.',
                style: TextStyle(fontSize: 13, height: 1.5, color: corTinta),
              ),
            ],
          ),
        ),
        if (cientificos.isNotEmpty) ...[
          const SizedBox(height: 22),
          Text('COMO A NORMA CHAMA', style: estiloEtiqueta),
          const SizedBox(height: 3),
          const Text(
            'Pela Portaria MPA nº 532, de 23 de setembro de 2025, que fixa '
            'os nomes comuns oficiais.',
            style: TextStyle(fontSize: 12.5, height: 1.4, color: corApagada),
          ),
          const SizedBox(height: 10),
          for (final c in cientificos.take(8))
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Cartao(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c,
                      style: const TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        color: corTinta,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      comunsEmLinha(c),
                      style: const TextStyle(
                          fontSize: 13, height: 1.4, color: corApagada),
                    ),
                  ],
                ),
              ),
            ),
          if (cientificos.length > 8)
            Text('… e mais ${cientificos.length - 8}.',
                style: const TextStyle(fontSize: 12.5, color: corApagada)),
        ],
        if (mencoes.isNotEmpty) ...[
          const SizedBox(height: 22),
          Text('ONDE ESTE NOME APARECE NO APLICATIVO', style: estiloEtiqueta),
          const SizedBox(height: 3),
          const Text(
            'O aplicativo mostra onde o nome aparece. Qual regra se aplica '
            'depende do lugar, do petrecho e da data — isso o aplicativo '
            'não decide por você.',
            style: TextStyle(fontSize: 12.5, height: 1.4, color: corApagada),
          ),
          const SizedBox(height: 10),
          for (final m in mencoes)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Cartao(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Selo(nomesDeCamada[m.camada]!, cor: corMar),
                    const SizedBox(height: 8),
                    Text(
                      m.titulo,
                      style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                          color: corTinta),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'aparece ${m.onde}',
                      style: const TextStyle(
                          fontSize: 12.5, height: 1.4, color: corApagada),
                    ),
                    const SizedBox(height: 8),
                    Container(height: 1, color: corBorda),
                    const SizedBox(height: 7),
                    Text(
                      m.norma,
                      style: const TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                          color: corApagada),
                    ),
                  ],
                ),
              ),
            ),
        ],
        if (cientificos.isEmpty && mencoes.isEmpty) ...[
          const SizedBox(height: 20),
          const Text(
            'Também não encontrei esse nome nas outras telas nem na '
            'Portaria MPA nº 532/2025 dos nomes oficiais.\n\n'
            'Tente só o começo do nome, o gênero (Balistes), a família '
            '(Balistidae) ou a ordem. Se ainda assim não aparecer, '
            'consulte a norma nos sites oficiais.',
            style: TextStyle(fontSize: 14, height: 1.55, color: corApagada),
          ),
        ],
        const SizedBox(height: 20),
        const Text(
          'Na dúvida, consulte a norma nos sites oficiais.',
          style: TextStyle(fontSize: 12.5, height: 1.5, color: corApagada),
        ),
      ],
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
              ..._veredito(context),

              // 2. o que ainda não está confirmado
              if (f.temDuvida) ..._duvidas(),

              // 3. defeso ou temporada da espécie
              if (f.temTemporada) ..._temporadas(),

              // 3. a classificação na Lista
              if (f.ameacada) ..._classificacao(),

              // 3b. o que o aplicativo procurou e não encontrou
              ..._naoEncontrado(),

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

  // ---------- o que o aplicativo procurou e não encontrou ----------
  //
  // Antes a ficha só omitia a seção que a norma não alcançava. Omitir é
  // a resposta errada, e é errada sempre para o mesmo lado: quem abre a
  // ficha de um peixe e não lê nada sobre tamanho conclui que pode levar
  // de qualquer medida.
  //
  // O aplicativo carrega as duas listas por inteiro — as 35 espécies da
  // IN 53 e as 490 do Anexo I da Portaria 1.667. A ausência nelas não é
  // "não achei": é fato conferível. O que ele não pode afirmar é que não
  // exista tamanho mínimo em lugar nenhum, porque existe em Plano de
  // Recuperação, em norma estadual e em norma específica de espécie. Daí
  // o texto dizer onde procurou, e mandar consultar o resto.

  List<Widget> _naoEncontrado() {
    final semTamanho = !f.temTamanho && (f.plano?.cmMinimo ?? 0) == 0;
    final foraDaLista = !f.ameacada;
    if (!semTamanho && !foraDaLista) return const [];

    return [
      const SizedBox(height: 12),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 15),
        decoration: BoxDecoration(
          color: corSuperficie,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: corBorda),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Selo('não localizado', cor: corApagada),
            const SizedBox(height: 11),
            if (semTamanho) ...[
              const Text(
                'TAMANHO MÍNIMO',
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: corApagada),
              ),
              const SizedBox(height: 5),
              const Text(
                'Não foi encontrada regulamentação de tamanho mínimo de '
                'captura para esta espécie na Instrução Normativa MMA nº '
                '53/2005, que é a norma de tamanhos que este aplicativo '
                'carrega.\n\n'
                'Isso não quer dizer que não exista tamanho mínimo. Pode '
                'haver medida fixada em Plano de Recuperação, em norma '
                'estadual ou em norma específica da espécie. Consulte a '
                'norma nos sites oficiais.',
                style: TextStyle(
                    fontSize: 13, height: 1.5, color: corTinta),
              ),
            ],
            if (semTamanho && foraDaLista) const SizedBox(height: 13),
            if (foraDaLista) ...[
              const Text(
                'LISTA NACIONAL DE ESPÉCIES AMEAÇADAS',
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: corApagada),
              ),
              const SizedBox(height: 5),
              const Text(
                'Esta espécie não consta do Anexo I da Portaria GM/MMA nº '
                '1.667, de 27 de abril de 2026 — a Lista Nacional Oficial '
                'de Espécies Ameaçadas de Extinção. O aplicativo carrega '
                'esse anexo por inteiro.\n\n'
                'A vedação de captura do art. 3º da Portaria GM/MMA nº '
                '1.666/2026 alcança as espécies da Lista. Não estar nela '
                'afasta essa vedação, e só ela: defeso, área proibida, '
                'petrecho e tamanho seguem valendo pelas normas próprias '
                'de cada um.',
                style: TextStyle(
                    fontSize: 13, height: 1.5, color: corTinta),
              ),
            ],
            const SizedBox(height: 12),
            Container(height: 1, color: corBorda),
            const SizedBox(height: 10),
            const Text(
              'Na dúvida, consulte a norma nos sites oficiais.',
              style: TextStyle(
                  fontSize: 12.5,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  color: corApagada),
            ),
          ],
        ),
      ),
    ];
  }

  // ---------- qual veredito a ficha dá ----------
  //
  // A ordem importa e é a da norma. O Plano de Recuperação vem
  // primeiro porque o art. 4º da Portaria 1.666 é exceção ao art. 3º:
  // onde há plano, a pesca é regulada, e dizer "vedada" ali seria
  // errado. Só depois vem a vedação, e só no fim o tamanho mínimo.
  List<Widget> _veredito(BuildContext context) {
    if (f.temPlano) return _reguladaPorPlano(context);
    if (f.planoSemNorma) return _planoSemNorma(context);
    if (f.vedadaEm2510) return _aindaNao(context);
    if (f.ameacada) return _proibida(context);
    if (f.temTamanho) return _medida();
    return const [];
  }

  // ---------- pesca regulada por Plano de Recuperação ----------

  List<Widget> _reguladaPorPlano(BuildContext context) {
    final p = f.plano!;
    return [
      _Bloco(
        cor: corProfundo,
        etiqueta: '${f.categoriaPorExtenso.toUpperCase()}  ·  '
            'PLANO DE RECUPERAÇÃO',
        titulo: 'Pesca regulada',
        texto: 'Está na Lista, mas a captura não é vedada: há Plano de '
            'Recuperação, ato do Ministério do Meio Ambiente reconhecendo '
            'o uso e norma de ordenamento (art. 4º da Portaria 1.666). '
            'Valem as regras abaixo, não a vedação do art. 3º.',
      ),
      const SizedBox(height: 12),
      _RegraDoPlano(p: p),
      if (p.emVigor.isNotEmpty) ...[
        const SizedBox(height: 12),
        _EstaSendoAplicada(texto: p.emVigor),
      ],
      const SizedBox(height: 12),
      _Aviso(
        etiqueta: 'CONFIRMAR A VIGÊNCIA',
        titulo: p.atoDoMMA,
        texto: avisoVigencia,
      ),
      // O aviso só sai quando os números realmente diferem. A garoupa
      // e o peixe-batata têm o mesmo mínimo nas duas normas; alarmar
      // ali gastaria a atenção de quem precisa dela no bagre-branco e
      // no badejo quadrado.
      if (f.temTamanho && f.in53!.tamanho != p.cmMinimo) ...[
        const SizedBox(height: 12),
        _TamanhoDivergente(cmIn53: f.in53!.tamanho, cmPlano: p.cmMinimo),
      ],
      if (p.cmMaximo > 0) ...[
        const SizedBox(height: 12),
        _TetoDeTamanho(cm: p.cmMaximo, temIn53: f.temTamanho),
      ],
    ];
  }

  // ---------- há Plano, mas a norma não foi obtida ----------
  //
  // O pior erro possível aqui seria repetir "captura vedada", porque
  // onde existe Plano a vedação do art. 3º não é automática. O segundo
  // pior seria inventar uma regra. O aplicativo faz a terceira coisa:
  // diz o nome da norma e manda consultar.

  List<Widget> _planoSemNorma(BuildContext context) {
    final p = f.plano!;
    return [
      _Bloco(
        cor: corBoia,
        etiqueta: '${f.categoriaPorExtenso.toUpperCase()}  ·  '
            'PLANO DE RECUPERAÇÃO',
        titulo: 'Consulte a norma',
        texto: 'Esta espécie tem Plano de Recuperação. Onde há Plano, a '
            'vedação do art. 3º da Portaria 1.666 não se aplica sozinha — '
            'quem diz o que pode é a norma de ordenamento, e o aplicativo '
            'não obteve o texto dela.',
      ),
      const SizedBox(height: 12),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
        decoration: BoxDecoration(
          color: corSuperficie,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: corBorda),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CampoDoPlano(
                rotulo: 'NORMA DE ORDENAMENTO A CONSULTAR',
                texto: p.ordenamento,
                destaque: true),
            _CampoDoPlano(
                rotulo: 'PLANO DE RECUPERAÇÃO', texto: p.atoDoMMA),
            _CampoDoPlano(rotulo: 'PARA ONDE VALE', texto: p.abrangencia),
          ],
        ),
      ),
      const SizedBox(height: 12),
      const _Aviso(etiqueta: 'O QUE O APLICATIVO NÃO DIZ', texto: remissao),
    ];
  }

  // ---------- proibida hoje ----------

  List<Widget> _proibida(BuildContext context) => [
        _Bloco(
          cor: corNaoPode,
          etiqueta: f.categoriaPorExtenso.toUpperCase(),
          titulo: 'Vedação por padrão',
          texto: 'Vedados também o transporte, a guarda a bordo, o '
              'armazenamento, o manejo, o beneficiamento e a comercialização '
              '(art. 3º da Portaria 1.666).',
        ),
        const SizedBox(height: 12),
        const _OQueADataQuerDizer(nova: false, dias: 0),
        const SizedBox(height: 12),
        const _PlanoNaoConferido(),
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
            ? 'O item desta espécie tem asterisco na Lista: ela é nova, '
                'não constava da lista anterior. Pelo art. 12 da Portaria '
                '1.666, a vedação do art. 3º entra em vigor em 25/10/2026 '
                '— faltam $dias dias.'
            : 'O prazo de 180 dias do art. 12 da Portaria 1.666 venceu em '
                '25/10/2026. A vedação do art. 3º está em vigor.',
      ),
      const SizedBox(height: 12),
      _OQueADataQuerDizer(nova: true, dias: dias),
      const SizedBox(height: 10),
      const _MesmaProtecao(),
      if (f.temTamanho && dias > 0) ...[
        const SizedBox(height: 12),
        _MedidaValendo(e: f.in53!),
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
              'fundamenta decisão nenhuma, e o nome usado na região pode '
              'ser outro. O que vale é o nome científico.',
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
/// As regras do Plano, em campos, para consulta rápida.
class _RegraDoPlano extends StatelessWidget {
  final Plano p;
  const _RegraDoPlano({required this.p});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
      decoration: BoxDecoration(
        color: corSuperficie,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: corBorda),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            p.ordenamento.toUpperCase(),
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              height: 1.4,
              color: corMar,
            ),
          ),
          const SizedBox(height: 14),
          _CampoDoPlano(rotulo: 'PARA ONDE VALE', texto: p.abrangencia),
          if (p.ondePode.isNotEmpty)
            _CampoDoPlano(rotulo: 'ONDE PODE', texto: p.ondePode,
                destaque: true),
          _CampoDoPlano(rotulo: 'TAMANHO', texto: p.tamanho),
          if (p.defeso.isNotEmpty)
            _CampoDoPlano(rotulo: 'PERÍODO FECHADO', texto: p.defeso),
          _CampoDoPlano(rotulo: 'QUEM PODE', texto: p.quemPode),
          _CampoDoPlano(rotulo: 'CAPTURA INCIDENTAL', texto: p.incidental),
        ],
      ),
    );
  }
}

class _CampoDoPlano extends StatelessWidget {
  final String rotulo;
  final String texto;
  final bool destaque;

  const _CampoDoPlano({
    required this.rotulo,
    required this.texto,
    this.destaque = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rotulo,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.3,
              color: destaque ? corNaoPode : corApagada,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            texto,
            style: TextStyle(
              fontSize: 15,
              height: 1.4,
              fontWeight: destaque ? FontWeight.w600 : FontWeight.w500,
              color: destaque ? corNaoPode : corTinta,
            ),
          ),
        ],
      ),
    );
  }
}

/// Onde a IN 53 e o Plano dão números diferentes, os dois aparecem, e
/// o aplicativo diz qual prevalece e por quê. Esconder um deles seria
/// mais limpo e menos honesto: quem for aplicar vai encontrar os dois.
class _TamanhoDivergente extends StatelessWidget {
  final int cmIn53;
  final int cmPlano;

  const _TamanhoDivergente({required this.cmIn53, required this.cmPlano});

  @override
  Widget build(BuildContext context) {
    return _Aviso(
      etiqueta: 'DOIS NÚMEROS PARA A MESMA ESPÉCIE',
      titulo: 'IN 53: $cmIn53 cm  ·  Plano: $cmPlano cm',
      texto: 'A favor do número maior: a norma do Plano é de 2018, treze '
          'anos posterior à IN 53; é específica de uma espécie, contra as '
          '35 da IN 53; e é Portaria Interministerial, assinada por dois '
          'ministros. Pelo art. 2º, § 1º da LINDB, a norma posterior que '
          'regula inteiramente a matéria revoga a anterior.\n\n'
          'A favor do número menor: o art. 5º da IN 53 preserva as regras '
          'de portarias específicas apenas "para espécies que NÃO constam '
          'nos Anexos I e II" — e esta consta. Lido a contrario, sugere '
          'que para as espécies dos anexos valem os números dela. E, em '
          'matéria sancionadora, dúvida real não se resolve contra quem '
          'é fiscalizado.\n\n'
          'Consulte as duas normas nos sites oficiais antes de aplicar '
          'um dos dois números.',
    );
  }
}

/// Prova de que a norma está sendo aplicada. Verde, e não âmbar,
/// porque não é dúvida: é o órgão fiscalizador agindo sob a norma, com
/// data. Vale mais que qualquer raciocínio sobre vigência.
class _EstaSendoAplicada extends StatelessWidget {
  final String texto;
  const _EstaSendoAplicada({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: corPode.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: corPode.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ESTÁ SENDO APLICADA',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: corPode)),
          const SizedBox(height: 8),
          Text(texto,
              style: const TextStyle(
                  fontSize: 13.5, height: 1.45, color: corApagada)),
        ],
      ),
    );
  }
}

/// O que a data da vedação quer dizer.
///
/// O art. 12 da Portaria 1.666 deu 180 dias às espécies que entraram
/// agora na Lista. Quem vai usar isto em campo não precisa da história
/// da decisão — precisa saber o que a data significa para o exemplar
/// que está na mão dela.
class _OQueADataQuerDizer extends StatelessWidget {
  final bool nova;
  final int dias;

  const _OQueADataQuerDizer({required this.nova, required this.dias});

  @override
  Widget build(BuildContext context) {
    return _Aviso(
      etiqueta: 'O QUE ESSA DATA QUER DIZER',
      titulo: nova
          ? 'Espécie nova na Lista'
          : 'Espécie que já era da Lista',
      texto: nova
          ? 'A Lista Nacional Oficial foi publicada em 28 de abril de '
              '2026. Para as espécies que NÃO estavam na lista anterior, '
              'o art. 12 da Portaria 1.666 deu 180 dias antes de a '
              'vedação começar a valer. Esse prazo vence em 25 de outubro '
              'de 2026 — daqui a $dias dias.\n\n'
              'Até lá, a captura desta espécie não é vedada por estar na '
              'Lista. As demais regras continuam valendo: tamanho mínimo, '
              'defeso, petrecho e área, quando houver.\n\n'
              'A partir de 25 de outubro, vale a vedação integral do art. '
              '3º — captura, transporte, guarda a bordo, armazenamento, '
              'manejo, beneficiamento e comercialização.'
          : 'Esta espécie já constava da lista anterior, de 2014. O prazo '
              'de 180 dias do art. 12 da Portaria 1.666 vale só para as '
              'que entraram agora — e não é o caso desta.\n\n'
              'A vedação do art. 3º vale desde já.',
    );
  }
}

/// O teto de tamanho./// O teto de tamanho. Só o Plano da garoupa tem um, e é o tipo de
/// regra que passa despercebida: quem cresceu com a IN 53 na cabeça
/// procura o peixe pequeno demais, não o grande demais.
class _TetoDeTamanho extends StatelessWidget {
  final int cm;
  final bool temIn53;

  const _TetoDeTamanho({required this.cm, required this.temIn53});

  @override
  Widget build(BuildContext context) {
    return _Aviso(
      etiqueta: 'TEM TETO, NÃO SÓ PISO',
      titulo: 'Acima de $cm cm também é irregular',
      texto: temIn53
          ? 'O Plano de Recuperação permite a captura dentro de uma FAIXA. '
              'A IN 53 fixa só o mínimo e não tem teto: um exemplar acima '
              'de $cm cm é regular por ela e irregular pelo Plano.'
          : 'O Plano de Recuperação permite a captura dentro de uma FAIXA. '
              'O exemplar acima de $cm cm está fora dela.',
    );
  }
}

/// O aviso que separa "não pode" de "não conferi". Sem ele, o
/// aplicativo afirmaria para 480 e poucas espécies uma coisa que só
/// conferiu em oito.
class _PlanoNaoConferido extends StatelessWidget {
  const _PlanoNaoConferido();

  @override
  Widget build(BuildContext context) {
    return _Aviso(
      etiqueta: 'PLANO DE RECUPERAÇÃO — NÃO CONFERIDO',
      texto: 'Estar na Lista não veda a captura por si só. O art. 4º da '
          'Portaria 1.666 admite o uso quando há Plano de Recuperação, ato '
          'do Ministério do Meio Ambiente reconhecendo o uso e norma de '
          'ordenamento — e o art. 11, parágrafo único, mantém em vigor os '
          'planos e as regras anteriores durante a revisão.\n\n'
          'O aplicativo conferiu isso em $quantosPlanos espécies, e não '
          'nesta. A vedação acima é o padrão do art. 3º, não uma resposta '
          'fechada: confirme se existe plano antes de qualquer medida.',
    );
  }
}

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
