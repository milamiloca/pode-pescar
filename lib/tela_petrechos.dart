import 'package:flutter/material.dart';
import 'dados.dart';
import 'desenhos.dart';
import 'fichas.dart';
import 'tema.dart';

const _fonteNorma =
    'Instrução Normativa MPA/MMA nº 10, de 10 de junho de 2011';
const _fonteDetalhe = 'Anexos publicados no Diário Oficial em 07/11/2011.';

/// O aviso que precede a lista.
///
/// A lista abaixo é o Anexo I ORIGINAL da IN 10/2011. Duas normas
/// posteriores, ambas em vigor, alteraram esse anexo — e não se tem o
/// texto consolidado. Quem confere um código de permissionamento contra
/// o RGP precisa saber disso ANTES de comparar, não depois.
const _avisoDeVersao =
    'ESTA LISTA É O TEXTO ORIGINAL DE 2011.\n\n'
    'Quatro normas posteriores alteraram a matriz de modalidades. O '
    'aplicativo tem o texto de duas delas, e por isso consegue marcar, '
    'uma a uma, quais modalidades mudaram — as marcadas trazem o selo '
    '"texto alterado".\n\n'
    'O QUE ALTEROU A MATRIZ\n\n'
    '1. Instrução Normativa MPA nº 14, de 2014. Alterou o Anexo I. Texto '
    'não obtido: não se sabe quais modalidades alcançou. O dia e o mês '
    'dela também não são conhecidos — a fonte disponível traz apenas '
    '"IN MPA Nº 14 2014".\n\n'
    '2. Instrução Normativa Interministerial MPA/MMA nº 01, de 26 de '
    'março de 2015 (DOU de 27/04/2015, seção 1, página 66). O art. 1º '
    'acrescentou ao art. 5º da IN 10/2011 as definições de Fauna '
    'Acompanhante Previsível e de Espécies de Captura Incidental; o art. '
    '2º revogou o art. 11 da IN 10/2011. O art. 3º, na redação da '
    'Instrução Normativa Interministerial nº 46, de 30 de dezembro de '
    '2015, diz que "o art. 1º desta Instrução Normativa Interministerial '
    'terá vigência até 31 de dezembro de 2016" — as duas definições '
    'tinham prazo; a revogação do art. 11 não tem.\n\n'
    '3. Portaria Interministerial MPA/MMA nº 14, de 1º de novembro de '
    '2024 (lulas). O art. 8º e o Anexo I dela reescrevem as modalidades '
    '2.2, 2.4, 3.8, 3.9, 6.7, 6.8, 6.9, 6.10 e 6.11.\n\n'
    '4. Portaria Interministerial MPA/MMA nº 66, de 27 de julho de 2026 '
    '(pargo). O art. 6º, § 2º e o Anexo II dela reescrevem as '
    'modalidades 1.6, 1.8, 1.9, 1.10, 1.11 e 1.14.\n\n'
    'Há ainda duas alterações pontuais: a Portaria Interministerial nº '
    '24/2018 acrescentou ao Anexo II a modalidade emalhe anilhado; e a '
    'Portaria Interministerial nº 59-B, de 9 de novembro de 2018, no art. '
    '9º, revogou o inciso II do § 2º do art. 8º da IN 10/2011.\n\n'
    'ATENÇÃO AO "ALTERADA PELA"\n'
    'O PDF da IN 10/2011 que circula nos sites oficiais traz no topo '
    '"ALTERADA PELA IN MPA Nº 14 2014, IN MPA/MMA Nº 01/2015". Isso é um '
    'AVISO de que a norma foi alterada, e NÃO um texto consolidado: '
    'naquele PDF, o art. 5º ainda tem apenas os §§ 1º e 2º, e o art. 11 '
    'continua no corpo — embora a IN 01/2015 tenha acrescentado dois '
    'parágrafos àquele e revogado este. Quem o lê como texto vigente lê '
    'um artigo a mais e dois parágrafos a menos.\n\n'
    'AO PROCURAR A IN MPA Nº 14/2014\n'
    'Existe uma Instrução Normativa IBAMA nº 14, de 2014, com o mesmo '
    'número e ano, que trata de recadastramento de fauna silvestre. Não é '
    'a mesma norma: a que altera a matriz é do Ministério da Pesca e '
    'Aquicultura.\n\n'
    'O CÓDIGO DE UMA MODALIDADE AQUI PODE NÃO SER O CÓDIGO QUE ESTÁ NO '
    'RGP HOJE. Antes de usar um número em conferência de licença ou em '
    'qualquer decisão, confira a modalidade no registro do MPA e a norma '
    'nos sites oficiais.';

// =====================================================================
// OS SEIS MÉTODOS
// =====================================================================

class TelaPetrechos extends StatefulWidget {
  const TelaPetrechos({super.key});

  @override
  State<TelaPetrechos> createState() => _TelaPetrechosState();
}

class _TelaPetrechosState extends State<TelaPetrechos> {
  String busca = '';

  // Começa desligado de propósito. A marcação de "vale em SC" é uma
  // leitura do campo "área de operação" de cada modalidade, feita na
  // montagem dos dados — não é classificação da norma. Enquanto não
  // for validada modalidade por modalidade, o padrão é mostrar tudo,
  // com a área exatamente como está escrita.
  bool soSc = false;

  List<Modalidade> get _visiveis =>
      soSc ? modalidades.where((m) => m.valeEmSc).toList() : modalidades;

  @override
  Widget build(BuildContext context) {
    final termo = semAcento(busca);
    final procurando = termo.isNotEmpty;

    final achadas = _visiveis.where((m) {
      return semAcento(m.petrecho).contains(termo) ||
          semAcento(m.locais).contains(termo) ||
          semAcento(m.alvo).contains(termo) ||
          semAcento(m.metodo.nome).contains(termo);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Apetrechos')),
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
                    const Text('Modalidades e petrechos',
                        style: estiloTitulo),
                    const SizedBox(height: 6),
                    const Text(
                      'Cada modalidade tem petrecho, espécies-alvo e área '
                      'de operação próprios. Busque pelo nome local do '
                      'petrecho.',
                      style: estiloCorpo,
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.fromLTRB(13, 11, 13, 12),
                      decoration: BoxDecoration(
                        color: corBoia.withValues(alpha: 0.09),
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(
                            color: corBoia.withValues(alpha: 0.3)),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Selo('confira o código no RGP', cor: corBoia),
                          SizedBox(height: 8),
                          TextoDobravel(
                            titulo: 'Por que este aviso',
                            texto: _avisoDeVersao,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    CampoBusca(
                      dica: 'Ex.: malhão, covo, tainha',
                      aoMudar: (v) => setState(() => busca = v),
                    ),
                    const SizedBox(height: 10),
                    _FiltroSc(
                      ligado: soSc,
                      total: modalidades.length,
                      quantas: modalidades.where((m) => m.valeEmSc).length,
                      aoMudar: (v) => setState(() => soSc = v),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              Expanded(
                child: procurando
                    ? _ListaResultados(achadas: achadas)
                    : _ListaMetodos(visiveis: _visiveis, soSc: soSc),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FiltroSc extends StatelessWidget {
  final bool ligado;
  final int total;
  final int quantas;
  final ValueChanged<bool> aoMudar;

  const _FiltroSc({
    required this.ligado,
    required this.total,
    required this.quantas,
    required this.aoMudar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(value: ligado, onChanged: aoMudar),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            ligado
                ? 'Filtro não oficial: $quantas que parecem alcançar SC. '
                    'Confira sempre a área na tela da modalidade.'
                : 'Mostrando todas as $total, com a área como está na norma',
            style: const TextStyle(fontSize: 14, color: corApagada, height: 1.3),
          ),
        ),
      ],
    );
  }
}

class _ListaMetodos extends StatelessWidget {
  final List<Modalidade> visiveis;
  final bool soSc;

  const _ListaMetodos({required this.visiveis, required this.soSc});

  @override
  Widget build(BuildContext context) {
    final metodos =
        Metodo.values.where((m) => visiveis.any((x) => x.metodo == m)).toList();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      itemCount: metodos.length,
      itemBuilder: (context, i) {
        final metodo = metodos[i];
        final quantas = visiveis.where((x) => x.metodo == metodo).length;
        return Cartao(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          aoTocar: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => TelaModalidades(metodo: metodo, soSc: soSc),
          )),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Glifo(metodo: metodo, largura: 72),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(metodo.nome,
                        style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: corTinta)),
                    const SizedBox(height: 4),
                    Text(metodo.explicacao,
                        style: const TextStyle(
                            fontSize: 14, height: 1.35, color: corApagada)),
                    const SizedBox(height: 8),
                    Text(
                      quantas == 1
                          ? '1 modalidade'
                          : '$quantas modalidades',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: corMar),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ListaResultados extends StatelessWidget {
  final List<Modalidade> achadas;
  const _ListaResultados({required this.achadas});

  @override
  Widget build(BuildContext context) {
    if (achadas.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(28),
          child: Text(
            'Nenhuma modalidade encontrada.\n\nTente uma palavra só, ou '
            'desligue o filtro de Santa Catarina.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17, color: corApagada, height: 1.4),
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      itemCount: achadas.length,
      itemBuilder: (context, i) => _CartaoModalidade(m: achadas[i]),
    );
  }
}

// =====================================================================
// MODALIDADES DE UM MÉTODO
// =====================================================================

class TelaModalidades extends StatelessWidget {
  final Metodo metodo;
  final bool soSc;

  const TelaModalidades({super.key, required this.metodo, required this.soSc});

  @override
  Widget build(BuildContext context) {
    final lista = modalidades
        .where((m) => m.metodo == metodo && (!soSc || m.valeEmSc))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(metodo.nome)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: corProfundo,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Glifo(
                        metodo: metodo,
                        largura: 130,
                        cor: const Color(0xFF8FD3DE),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(metodo.explicacao,
                        style: const TextStyle(
                            fontSize: 16,
                            height: 1.4,
                            color: Color(0xFFDCE9EC))),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                lista.length == 1
                    ? '1 modalidade'
                    : '${lista.length} modalidades',
                style: estiloEtiqueta,
              ),
              const SizedBox(height: 10),
              for (final m in lista) _CartaoModalidade(m: m),
              const SizedBox(height: 14),
              const Fonte(norma: _fonteNorma, detalhe: _fonteDetalhe),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartaoModalidade extends StatelessWidget {
  final Modalidade m;
  const _CartaoModalidade({required this.m});

  @override
  Widget build(BuildContext context) {
    return Cartao(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      aoTocar: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => TelaModalidade(m: m),
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(m.numero,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: corApagada)),
              const SizedBox(width: 8),
              Text(m.metodo.nome.toUpperCase(), style: estiloEtiqueta),
              const Spacer(),
              if (redacaoDaModalidade(m.numero).isNotEmpty)
                const Selo('redação nova', cor: corMar),
            ],
          ),
          const SizedBox(height: 8),
          Text(m.petrecho,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                  color: corTinta)),
          if (m.locais.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text('Também chamam de: ${m.locais}',
                style: const TextStyle(
                    fontSize: 14,
                    height: 1.3,
                    fontWeight: FontWeight.w500,
                    color: corBoia)),
          ],
          const SizedBox(height: 6),
          Text(
            m.alvo.length > 90 ? '${m.alvo.substring(0, 88)}…' : m.alvo,
            style: const TextStyle(fontSize: 14, height: 1.35, color: corApagada),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// UMA MODALIDADE
// =====================================================================

class TelaModalidade extends StatelessWidget {
  final Modalidade m;
  const TelaModalidade({super.key, required this.m});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Modalidade ${m.numero}')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
            children: [
              Row(
                children: [
                  Glifo(metodo: m.metodo, largura: 54),
                  const SizedBox(width: 12),
                  Text(m.metodo.nome.toUpperCase(), style: estiloEtiqueta),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 14),
              Text(m.petrecho, style: estiloTitulo),
              ..._daLista(m),
              if (temRegistroFechado(m.numero)) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 15),
                  decoration: BoxDecoration(
                    color: corNaoPode.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: corNaoPode.withValues(alpha: 0.35)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Selo('registro fechado', cor: corNaoPode),
                      const SizedBox(height: 10),
                      const Text(
                        textoDoRegistroFechado,
                        style: TextStyle(
                            fontSize: 13, height: 1.5, color: corTinta),
                      ),
                      const SizedBox(height: 11),
                      Container(height: 1, color: corBorda),
                      const SizedBox(height: 9),
                      const Text(
                        normaDoRegistroFechado,
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                          color: corApagada,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (redacaoDaModalidade(m.numero).isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(15, 13, 15, 14),
                  decoration: BoxDecoration(
                    color: corMar.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: corMar.withValues(alpha: 0.28)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Selo('redação nova', cor: corMar, forte: true),
                      const SizedBox(height: 10),
                      const Text(
                        'A DESCRIÇÃO ABAIXO NÃO É A DE 2011. Esta '
                        'modalidade foi reescrita por norma posterior, e o '
                        'que está aqui é a redação nova.',
                        style: TextStyle(
                            fontSize: 13, height: 1.5, color: corTinta),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Redação dada por:\n${redacaoDaModalidade(m.numero)}',
                        style: const TextStyle(
                            fontSize: 12.5,
                            height: 1.45,
                            fontWeight: FontWeight.w500,
                            color: corApagada),
                      ),
                    ],
                  ),
                ),
              ],
              if (m.locais.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: corBoia.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('COMO TAMBÉM CHAMAM',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.4,
                              color: corBoia)),
                      const SizedBox(height: 5),
                      Text(m.locais,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                              color: corTinta)),
                    ],
                  ),
                ),
              ],
              if (m.regras.isNotEmpty) ...[
                const SizedBox(height: 22),
                const TituloSecao('Regras desta modalidade'),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: corSuperficie,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: corBorda),
                  ),
                  child: Text(
                    m.regras,
                    style: const TextStyle(
                        fontSize: 15, height: 1.5, color: corTinta),
                  ),
                ),
              ],
              const SizedBox(height: 22),
              const TituloSecao('Espécies-alvo'),
              const SizedBox(height: 4),
              TextoDobravel(titulo: 'Espécie-alvo', texto: m.alvo),
              const SizedBox(height: 14),
              const TituloSecao('Onde a modalidade opera'),
              const SizedBox(height: 4),
              TextoDobravel(
                  titulo: 'Área de operação',
                  texto: m.area,
                  realcarArea: true),
              if (m.complementar.isNotEmpty) ...[
                const SizedBox(height: 14),
                const TituloSecao('Autorização complementar'),
                const SizedBox(height: 2),
                const Text(
                  'Espécies que podem ser capturadas mediante autorização '
                  'à parte, inclusive no defeso da espécie principal.',
                  style: estiloCorpo,
                ),
                const SizedBox(height: 8),
                TextoDobravel(
                    titulo: 'Espécies alternativas', texto: m.complementar),
              ],
              if (m.incidental.isNotEmpty || m.acompanhante.isNotEmpty) ...[
                const SizedBox(height: 14),
                const TituloSecao('Captura incidental e fauna acompanhante'),
                const SizedBox(height: 2),
                const Text(
                  'A norma relaciona o que costuma ser capturado sem ser o '
                  'alvo. Boa parte dessas espécies é protegida.',
                  style: estiloCorpo,
                ),
                const SizedBox(height: 8),
                if (m.incidental.isNotEmpty)
                  TextoDobravel(
                      titulo: 'Captura incidental', texto: m.incidental),
                if (m.acompanhante.isNotEmpty)
                  TextoDobravel(
                      titulo: 'Fauna acompanhante previsível',
                      texto: m.acompanhante),
              ],
              const SizedBox(height: 16),
              Fonte(
                norma: m.norma.isEmpty ? _fonteNorma : m.norma,
                detalhe: m.norma.isEmpty
                    ? _fonteDetalhe
                    : 'Modalidade incluída no Anexo II da IN MPA/MMA nº '
                        '10/2011 por esta portaria.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// As espécies da Lista Nacional Oficial que esta modalidade nomeia.
///
/// A matriz de modalidades é de 2011 e lista espécie-alvo, captura
/// incidental, fauna acompanhante e autorização complementar. A Lista é
/// de 2026. Trinta e três espécies estão nas duas, e dezoito aparecem na
/// matriz como espécie-alvo — inclusive tubarões Criticamente em Perigo.
///
/// Isto NÃO afirma "proibido": o art. 4º da Portaria GM/MMA nº
/// 1.666/2026 admite o uso onde há Plano de Recuperação, ato do MMA e
/// norma de ordenamento. Quem dá o veredito é a ficha da espécie.
List<Widget> _daLista(Modalidade m) {
  final naLista = ameacadasNaModalidade(m);
  if (naLista.isEmpty) return const [];
  return [
    const SizedBox(height: 14),
    Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 13, 15, 14),
      decoration: BoxDecoration(
        color: corNaoPode.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: corNaoPode.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Selo('${naLista.length} na Lista de ameaçadas',
              cor: corNaoPode, forte: true),
          const SizedBox(height: 10),
          const Text(
            'ESTA MODALIDADE NOMEIA ESPÉCIES QUE ESTÃO NA LISTA NACIONAL '
            'OFICIAL. A matriz de modalidades é de 2011; a Lista, de 2026. '
            'Aparecer aqui como espécie-alvo ou fauna acompanhante não '
            'quer dizer que a captura esteja liberada.',
            style: TextStyle(fontSize: 13, height: 1.5, color: corTinta),
          ),
          const SizedBox(height: 12),
          for (final e in naLista)
            Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Selo(e.categoria, cor: corNaoPode),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.cientifico,
                            style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                                height: 1.3,
                                color: corTinta)),
                        Text('nesta modalidade, em ${e.campo}',
                            style: const TextStyle(
                                fontSize: 12,
                                height: 1.35,
                                color: corApagada)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Container(height: 1, color: corBorda),
          const SizedBox(height: 10),
          const Text(
            'Abra a ficha de cada espécie na tela Espécies: é lá que está '
            'o que vale — vedação, Plano de Recuperação ou tamanho mínimo. '
            'Na dúvida, consulte a norma nos sites oficiais.',
            style: TextStyle(
                fontSize: 12.5,
                height: 1.45,
                fontWeight: FontWeight.w500,
                color: corApagada),
          ),
        ],
      ),
    ),
  ];
}
