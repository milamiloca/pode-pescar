import 'package:flutter/material.dart';
import 'dados.dart';
import 'desenhos.dart';
import 'tema.dart';

const _in53 = 'Instrução Normativa MMA nº 53, de 22 de novembro de 2005';
const _in53d = 'Publicada no Diário Oficial em 24/11/2005.';
const _lista = 'Portaria GM/MMA nº 1.667, de 27 de abril de 2026 (a lista) '
    'e nº 1.666, de 27 de abril de 2026 (as regras)';
const _listad = 'Publicadas no Diário Oficial em 28/04/2026. A 1.667 '
    'revogou a Portaria MMA nº 445/2014.';

// =====================================================================
// LISTA DE ESPÉCIES
// =====================================================================

class TelaTamanhos extends StatefulWidget {
  const TelaTamanhos({super.key});

  @override
  State<TelaTamanhos> createState() => _TelaTamanhosState();
}

class _TelaTamanhosState extends State<TelaTamanhos> {
  String busca = '';

  @override
  Widget build(BuildContext context) {
    final termo = semAcento(busca);
    final achadas = especies
        .where((e) =>
            semAcento(e.nome).contains(termo) ||
            semAcento(e.cientifico).contains(termo))
        .toList();
    final bloqueadas = especies.where((e) => e.ameacada).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Tamanho mínimo')),
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
                    const Text('Qual peixe você pegou?', style: estiloTitulo),
                    const SizedBox(height: 6),
                    Text(
                      '$bloqueadas destas espécies estão na lista de '
                      'ameaçadas de extinção e não podem ser capturadas.',
                      style: estiloCorpo,
                    ),
                    const SizedBox(height: 16),
                    CampoBusca(
                      dica: 'Escreva o nome do peixe',
                      aoMudar: (v) => setState(() => busca = v),
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
              Expanded(
                child: achadas.isEmpty
                    ? const _Vazio(
                        'Não achei esse peixe.\n\nTente escrever só o começo '
                        'do nome.')
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        itemCount: achadas.length,
                        itemBuilder: (context, i) =>
                            _CartaoEspecie(especie: achadas[i]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartaoEspecie extends StatelessWidget {
  final Especie especie;
  const _CartaoEspecie({required this.especie});

  @override
  Widget build(BuildContext context) {
    final e = especie;
    return Cartao(
      destaque: e.proibidaHoje
          ? corNaoPode
          : e.proibidaDepois
              ? corBoia
              : null,
      aoTocar: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => TelaEspecie(especie: e),
      )),
      child: Row(
        children: [
          SizedBox(
            width: 58,
            height: 26,
            child: CustomPaint(
              painter: PeixePainter(
                forma: e.forma,
                cor: e.proibidaHoje
                    ? const Color(0xFFC08A84)
                    : const Color(0xFF9DB2BA),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.nome,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                        color: corTinta)),
                const SizedBox(height: 2),
                Text(e.cientifico,
                    style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: corApagada)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (e.proibidaHoje)
            const Selo('não pode', cor: corNaoPode, forte: true)
          else if (e.proibidaDepois)
            const Selo('25/10', cor: corBoia, forte: true)
          else
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${e.tamanho}',
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        height: 1,
                        color: corMar)),
                const Text('cm',
                    style: TextStyle(fontSize: 12, color: corApagada)),
              ],
            ),
        ],
      ),
    );
  }
}

// =====================================================================
// A ESPÉCIE
//
// Três estados: proibida hoje, proibida a partir de 25/10/2026, ou
// liberada pelo tamanho mínimo. A proibição não é uma observação sobre
// a medida — ela substitui a medida.
// =====================================================================

class TelaEspecie extends StatelessWidget {
  final Especie especie;
  const TelaEspecie({super.key, required this.especie});

  @override
  Widget build(BuildContext context) {
    final e = especie;
    return Scaffold(
      appBar: AppBar(
        title: Text(e.ameacada ? 'Espécie ameaçada' : 'Como medir'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
            children: [
              Text(e.nome, style: estiloTitulo),
              const SizedBox(height: 2),
              Text(e.cientifico,
                  style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: corApagada)),
              if (e.observacao.isNotEmpty) ...[
                const SizedBox(height: 10),
                _Nota(texto: e.observacao, cor: corBoia),
              ],
              const SizedBox(height: 18),
              if (e.proibidaHoje) ..._proibida(context, e),
              if (e.proibidaDepois) ..._aindaNao(context, e),
              if (!e.ameacada) ..._liberada(context, e),
              if (e.regras.isNotEmpty) ..._regrasProprias(e),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- proibida hoje ----------

  List<Widget> _proibida(BuildContext context, Especie e) {
    return [
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
            const Text('CAPTURA PROIBIDA',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: Colors.white70)),
            const SizedBox(height: 8),
            const Text('Não pode pescar',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    height: 1.05,
                    color: Colors.white)),
            const SizedBox(height: 10),
            const Text(
              'Também não pode transportar, guardar a bordo, armazenar, '
              'manejar, beneficiar nem vender.',
              style:
                  TextStyle(fontSize: 15, height: 1.4, color: Colors.white70),
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      _MedidaRiscada(e: e),
      const SizedBox(height: 14),
      BotaoGrande(
        texto: 'Veio na rede? Veja o que fazer',
        icone: Icons.waves,
        aoTocar: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => TelaVeioNaRede(especie: e),
        )),
      ),
      const SizedBox(height: 20),
      _Categoria(e: e),
      const SizedBox(height: 16),
      const Fonte(norma: _lista, detalhe: _listad),
    ];
  }

  // ---------- na lista, mas ainda não vigente ----------

  List<Widget> _aindaNao(BuildContext context, Especie e) {
    final dias = diasAteAsNovasProibicoes();
    return [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: corBoia.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: corBoia, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('PROIBIÇÃO AINDA NÃO VIGENTE',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                    color: corBoia)),
            const SizedBox(height: 8),
            const Text('Passa a ser proibida\nem 25 de outubro',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    height: 1.12,
                    color: corTinta)),
            const SizedBox(height: 8),
            Text(
              dias > 0
                  ? 'Faltam $dias dias. Até lá vale o tamanho mínimo da IN 53.'
                  : 'O prazo já venceu. A captura está proibida.',
              style: const TextStyle(
                  fontSize: 15, height: 1.4, color: corApagada),
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
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
            const Text('ATÉ 24 DE OUTUBRO DE 2026', style: estiloEtiqueta),
            const SizedBox(height: 4),
            Text('${e.tamanho} cm',
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: corTinta)),
            const SizedBox(height: 4),
            Text(
              'Tamanho mínimo pela IN 53. Depois dessa data, a captura fica '
              'proibida em qualquer tamanho.',
              style: const TextStyle(
                  fontSize: 14, height: 1.4, color: corApagada),
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      const _Nota(
        texto: 'O art. 12 da Portaria 1.666 dá 180 dias, contados de '
            '28/04/2026, para as espécies que não constavam da lista '
            'anterior. Esta é uma delas.',
        cor: corMar,
      ),
      const SizedBox(height: 16),
      _Categoria(e: e),
      const SizedBox(height: 16),
      const Fonte(norma: _lista, detalhe: _listad),
    ];
  }

  // ---------- liberada, vale o tamanho ----------

  List<Widget> _liberada(BuildContext context, Especie e) {
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
                  ? 'Meça do focinho até a forquilha do rabo,\n'
                      'onde ele se abre em dois.'
                  : 'Meça do focinho até a ponta mais\ncomprida do rabo.',
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 16, height: 1.4, color: corTinta),
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          color: corMar,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            const Text('MENOR QUE ISSO NÃO PODE',
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
      ),
      const SizedBox(height: 22),
      const TituloSecao('O que não pode'),
      const Text(
        'Pescar, guardar no barco ou desembarcar peixe menor que essa '
        'medida. Vale do Espírito Santo ao Rio Grande do Sul.',
        style: estiloCorpo,
      ),
      const SizedBox(height: 18),
      const TituloSecao('Sempre vem peixe pequeno junto'),
      Text(
        'A lei sabe disso. Ela aceita até ${e.tolerancia}% do peso do que '
        'você pescou abaixo da medida. Passou disso, é multa.',
        style: estiloCorpo,
      ),
      const SizedBox(height: 12),
      BotaoGrande(
        texto: 'Ver se estou dentro',
        icone: Icons.calculate_outlined,
        aoTocar: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => TelaCalculadora(especie: e),
        )),
      ),
      const SizedBox(height: 22),
      const TituloSecao('Quem pesca de arrasto'),
      const Text(
        'Essa regra de tamanho não vale para a pesca de arrasto. É o que '
        'diz o artigo 2º, parágrafo 1º da norma.',
        style: estiloCorpo,
      ),
      const SizedBox(height: 24),
      const Fonte(norma: _in53, detalhe: _in53d),
    ];
  }

  // ---------- regras próprias, vindas de outra norma ----------
  //
  // Tamanho mínimo é a IN 53. Temporada e área fechada são de outra
  // norma, com outra data. Ficam em bloco separado, com a norma de
  // origem à vista, porque envelhecem em ritmo diferente.

  List<Widget> _regrasProprias(Especie e) {
    return [
      const SizedBox(height: 26),
      const TituloSecao('Esta espécie tem norma própria'),
      const Text(
        'Além do tamanho mínimo, há temporada e áreas fechadas fixadas '
        'em norma específica.',
        style: estiloCorpo,
      ),
      const SizedBox(height: 12),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: corSuperficie,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: corBorda),
        ),
        child: TextoComArea(
          texto: e.regras,
          estilo: const TextStyle(
              fontSize: 14.5, height: 1.55, color: corTinta),
        ),
      ),
      const SizedBox(height: 12),
      _NormaDatada(norma: e.regrasNorma),
    ];
  }
}

/// A norma de origem das regras próprias, com a data em destaque.
///
/// A portaria é de 2018 e tem duas metades com validades diferentes: o
/// Capítulo I (temporada e áreas) segue valendo e é a base da
/// fiscalização da safra; o Capítulo II (cotas) era daquele ano. Mostrar
/// a data sem dizer isso faria o policial desconfiar da parte que vale.
class _NormaDatada extends StatelessWidget {
  final String norma;
  const _NormaDatada({required this.norma});

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
          const Text('BASE DA FISCALIZAÇÃO DA TAINHA',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: corBoia)),
          const SizedBox(height: 8),
          Text(norma,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                  color: corTinta)),
          const SizedBox(height: 6),
          const Text(
            'O texto acima é o Capítulo I: temporada por modalidade e '
            'áreas fechadas. As cotas de captura do Capítulo II eram da '
            'safra de 2018 e não estão aqui — cota e número de '
            'autorizações saem em norma própria a cada safra.',
            style: TextStyle(fontSize: 13.5, height: 1.45, color: corApagada),
          ),
        ],
      ),
    );
  }
}

class _MedidaRiscada extends StatelessWidget {
  final Especie e;
  const _MedidaRiscada({required this.e});

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
          const Text('A MEDIDA DA IN 53', style: estiloEtiqueta),
          const SizedBox(height: 4),
          Text('${e.tamanho} cm',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: corApagada,
                decoration: TextDecoration.lineThrough,
                decorationThickness: 2,
              )),
          const SizedBox(height: 6),
          const Text(
            'Continua na norma, mas não vale mais: a proibição alcança a '
            'espécie em qualquer tamanho.',
            style: TextStyle(fontSize: 14, height: 1.4, color: corApagada),
          ),
        ],
      ),
    );
  }
}

class _Categoria extends StatelessWidget {
  final Especie e;
  const _Categoria({required this.e});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: corNaoPode.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CATEGORIA DE RISCO', style: estiloEtiqueta),
          const SizedBox(height: 6),
          Text(
            e.categoriaPorExtenso,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: corNaoPode,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Sigla ${e.ameaca} na Lista Nacional Oficial, item '
            '${e.itemLista}.',
            style: const TextStyle(
                fontSize: 14, height: 1.35, color: corApagada),
          ),
          const SizedBox(height: 8),
          const Text(
            'Criticamente em Perigo, Em Perigo e Vulnerável recebem a mesma '
            'proteção integral. A categoria diz o risco de extinção, não o '
            'tamanho da proibição.',
            style: TextStyle(fontSize: 13.5, height: 1.4, color: corApagada),
          ),
        ],
      ),
    );
  }
}

class _Nota extends StatelessWidget {
  final String texto;
  final Color cor;
  const _Nota({required this.texto, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(texto,
          style: const TextStyle(
              fontSize: 13.5, height: 1.4, color: corApagada)),
    );
  }
}

// =====================================================================
// VEIO NA REDE
//
// Art. 3º, § 4º da Portaria 1.666: as restrições não se aplicam a
// exemplares capturados incidentalmente, desde que liberados vivos ou
// descartados no ato da captura, com registro. Sem esta tela o app
// diria a alguém que ele cometeu crime ao puxar a rede — o que é falso.
// =====================================================================

class TelaVeioNaRede extends StatelessWidget {
  final Especie especie;
  const TelaVeioNaRede({super.key, required this.especie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Veio na rede')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
            children: [
              Text('Caiu sem querer\nna rede?', style: estiloTitulo),
              const SizedBox(height: 4),
              Text(especie.nome,
                  style: const TextStyle(fontSize: 15, color: corApagada)),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: corPode.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: corPode, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('NÃO É INFRAÇÃO SE',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.4,
                            color: corPode)),
                    const SizedBox(height: 8),
                    const Text('Você devolver viva,\nna hora',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                            color: corTinta)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const _Regra(
                cor: corPode,
                titulo: 'Devolva ainda viva',
                detalhe: 'No ato da captura, sem levar a bordo nem colocar '
                    'no gelo.',
              ),
              const _Regra(
                cor: corPode,
                titulo: 'Registre',
                detalhe: 'A captura e a devolução precisam ser registradas, '
                    'conforme regulamentação específica.',
              ),
              const _Regra(
                cor: corNaoPode,
                titulo: 'Se levar, vira infração',
                detalhe: 'Guardar a bordo, desembarcar ou vender já é '
                    'captura, e aí valem as penalidades da Lei nº 9.605/98.',
              ),
              const SizedBox(height: 18),
              const Fonte(
                norma: 'Portaria GM/MMA nº 1.666, art. 3º, § 4º',
                detalhe: 'Publicada no Diário Oficial em 28/04/2026.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Regra extends StatelessWidget {
  final Color cor;
  final String titulo;
  final String detalhe;

  const _Regra({
    required this.cor,
    required this.titulo,
    required this.detalhe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.only(left: 14),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: cor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo,
              style: const TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                  color: corTinta)),
          const SizedBox(height: 3),
          Text(detalhe,
              style: const TextStyle(
                  fontSize: 14, height: 1.4, color: corApagada)),
        ],
      ),
    );
  }
}

// =====================================================================
// CALCULADORA DE TOLERÂNCIA
// =====================================================================

class TelaCalculadora extends StatefulWidget {
  final Especie especie;
  const TelaCalculadora({super.key, required this.especie});

  @override
  State<TelaCalculadora> createState() => _TelaCalculadoraState();
}

class _TelaCalculadoraState extends State<TelaCalculadora> {
  double? pesoTotal;
  double? pesoPequeno;

  double? _lerNumero(String texto) {
    final limpo = texto.replaceAll(',', '.').trim();
    if (limpo.isEmpty) return null;
    return double.tryParse(limpo);
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.especie;
    final temTudo = pesoTotal != null &&
        pesoPequeno != null &&
        pesoTotal! > 0 &&
        pesoPequeno! >= 0 &&
        pesoPequeno! <= pesoTotal!;
    final porcento = temTudo ? (pesoPequeno! / pesoTotal!) * 100 : 0.0;
    final dentro = porcento <= e.tolerancia;

    return Scaffold(
      appBar: AppBar(title: const Text('Estou dentro?')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
            children: [
              Text(e.nome, style: estiloSubtitulo),
              const SizedBox(height: 4),
              Text('O limite para esse peixe é ${e.tolerancia}% do peso.',
                  style: estiloCorpo),
              const SizedBox(height: 24),
              _CampoPeso(
                pergunta: 'Quantos quilos você pescou no total?',
                aoMudar: (t) => setState(() => pesoTotal = _lerNumero(t)),
              ),
              const SizedBox(height: 18),
              _CampoPeso(
                pergunta:
                    'Desses, quantos quilos estão menores que ${e.tamanho} cm?',
                aoMudar: (t) => setState(() => pesoPequeno = _lerNumero(t)),
              ),
              const SizedBox(height: 26),
              if (!temTudo)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: corSuperficie,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: corBorda),
                  ),
                  child: const Text(
                    'Escreva os dois pesos acima e a resposta\naparece aqui.',
                    textAlign: TextAlign.center,
                    style: estiloCorpo,
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
                  decoration: BoxDecoration(
                    color: dentro ? corPode : corNaoPode,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Icon(dentro ? Icons.check_circle : Icons.cancel,
                          color: Colors.white, size: 44),
                      const SizedBox(height: 10),
                      Text(dentro ? 'ESTÁ DENTRO' : 'ESTÁ FORA',
                          style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: Colors.white)),
                      const SizedBox(height: 8),
                      Text(
                        '${porcento.toStringAsFixed(1).replaceAll('.', ',')}% '
                        'do seu peixe está abaixo da medida.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.white, height: 1.4),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dentro
                            ? 'O limite é ${e.tolerancia}%.'
                            : 'O limite é ${e.tolerancia}%. Passou.',
                        style: const TextStyle(
                            fontSize: 15, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 22),
              const TituloSecao('Uma coisa importante'),
              const Text(
                'Essa margem existe porque rede não escolhe peixe, e sempre '
                'vem filhote junto. Ela não é permissão pra pescar pequeno de '
                'propósito.',
                style: estiloCorpo,
              ),
              const SizedBox(height: 20),
              const Fonte(norma: _in53, detalhe: _in53d),
            ],
          ),
        ),
      ),
    );
  }
}

class _CampoPeso extends StatelessWidget {
  final String pergunta;
  final ValueChanged<String> aoMudar;

  const _CampoPeso({required this.pergunta, required this.aoMudar});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(pergunta,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: corTinta,
                height: 1.3)),
        const SizedBox(height: 8),
        TextField(
          onChanged: aoMudar,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: '0',
            suffixText: 'kg',
            suffixStyle: const TextStyle(fontSize: 18, color: corApagada),
            filled: true,
            fillColor: corSuperficie,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: bordaCampo(),
            enabledBorder: bordaCampo(),
            focusedBorder: bordaCampo(focado: true),
          ),
        ),
      ],
    );
  }
}

class _Vazio extends StatelessWidget {
  final String texto;
  const _Vazio(this.texto);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Text(texto,
            textAlign: TextAlign.center,
            style:
                const TextStyle(fontSize: 17, color: corApagada, height: 1.4)),
      ),
    );
  }
}
