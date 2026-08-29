import 'package:flutter/material.dart';
import 'areas.dart';
import 'calendario.dart' show DiaDeHoje;
import 'tema.dart';

// =====================================================================
// ONDE NÃO PODE
//
// Esta tela responde à primeira pergunta de uma abordagem em baía, que
// não é sobre o peixe: é sobre o LUGAR e o PETRECHO. Uma traineira
// arrastando dentro da Baía Sul comete infração ainda que a espécie no
// porão esteja liberada e no tamanho certo.
//
// A ordem na tela é a da abordagem, do mais perto para o mais longe:
// primeiro a baía e o estuário, onde a guarnição chega de bote; depois
// a costa; depois a faixa oceânica das regiões Sudeste e Sul.
//
// As regras sazonais aparecem primeiro quando estão valendo hoje. Uma
// proibição que só vale de 15 de maio a 15 de junho não pode ficar
// escondida no meio da lista no dia 20 de maio.
// =====================================================================

class TelaAreas extends StatelessWidget {
  const TelaAreas({super.key});

  @override
  Widget build(BuildContext context) {
    return DiaDeHoje(construir: (context, hoje) => _montar(context, hoje));
  }

  Widget _montar(BuildContext context, DateTime hoje) {
    final sazonaisHoje = restricoes
        .where((r) => !r.oAnoInteiro && r.valeEm(hoje))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Onde não pode')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            children: [
              const Text('Área, petrecho e porte', style: estiloTitulo),
              const SizedBox(height: 6),
              const Text(
                'A regra que não depende da espécie: onde a embarcação '
                'está, o que ela está usando e qual o porte dela. Vale em '
                'Santa Catarina.',
                style: estiloCorpo,
              ),
              const SizedBox(height: 16),
              const _Contagem(),
              const SizedBox(height: 20),
              if (sazonaisHoje.isNotEmpty) ...[
                _ValendoHoje(regras: sazonaisHoje, hoje: hoje),
                const SizedBox(height: 22),
              ],
              for (final a in Alcance.values)
                if (restricoes.any((r) => r.alcance == a))
                  _Grupo(
                    alcance: a,
                    regras:
                        restricoes.where((r) => r.alcance == a).toList(),
                    hoje: hoje,
                  ),
              const SizedBox(height: 8),
              const _Nota(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Quantas regras, e quantas com o texto da norma na mão.
class _Contagem extends StatelessWidget {
  const _Contagem();

  @override
  Widget build(BuildContext context) {
    final lidas = quantasRestricoesLidas;
    final total = quantasRestricoes;
    return Cartao(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$total regras de área e petrecho',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: corTinta,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  lidas == total
                      ? 'Todas com o texto da norma lido por inteiro.'
                      : '$lidas com o texto da norma lido por inteiro. '
                          '${total - lidas} registrada porque a regra '
                          'existe, com o texto ainda por obter.',
                  style: const TextStyle(
                      fontSize: 12.5, height: 1.4, color: corApagada),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// O que está valendo hoje e não vale o ano inteiro.
class _ValendoHoje extends StatelessWidget {
  final List<Restricao> regras;
  final DateTime hoje;

  const _ValendoHoje({required this.regras, required this.hoje});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 13, 15, 14),
      decoration: BoxDecoration(
        color: corNaoPode.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: corNaoPode.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Selo('valendo hoje', cor: corNaoPode, forte: true),
          const SizedBox(height: 9),
          Text(
            regras.length == 1
                ? 'Uma regra de área só vale em parte do ano, e hoje é '
                    'dentro dela.'
                : '${regras.length} regras de área só valem em parte do '
                    'ano, e hoje é dentro delas.',
            style: const TextStyle(
                fontSize: 13, height: 1.45, color: corTinta),
          ),
          const SizedBox(height: 10),
          for (final r in regras)
            Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6, right: 8),
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                        color: corNaoPode, shape: BoxShape.circle),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.titulo,
                            style: const TextStyle(
                                fontSize: 13.5,
                                height: 1.35,
                                fontWeight: FontWeight.w600,
                                color: corTinta)),
                        Text(r.quando,
                            style: const TextStyle(
                                fontSize: 12,
                                height: 1.4,
                                color: corApagada)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Grupo extends StatelessWidget {
  final Alcance alcance;
  final List<Restricao> regras;
  final DateTime hoje;

  const _Grupo({
    required this.alcance,
    required this.regras,
    required this.hoje,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(nomesDeAlcance[alcance]!.toUpperCase(), style: estiloEtiqueta),
          const SizedBox(height: 10),
          for (final r in regras)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _Regra(r: r, hoje: hoje),
            ),
        ],
      ),
    );
  }
}

class _Regra extends StatelessWidget {
  final Restricao r;
  final DateTime hoje;

  const _Regra({required this.r, required this.hoje});

  @override
  Widget build(BuildContext context) {
    final valeAgora = r.valeEm(hoje);
    return Cartao(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (r.oAnoInteiro)
                const Selo('o ano inteiro', cor: corApagada)
              else
                Selo(
                  valeAgora ? 'valendo hoje' : r.quando.toLowerCase(),
                  cor: valeAgora ? corNaoPode : corBoia,
                  forte: valeAgora,
                ),
              if (r.texto == TextoDaNorma.aObter)
                const Selo('texto a obter', cor: corBoia),
              if (r.temExcecao) const Selo('tem exceção', cor: corMar),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            r.titulo,
            style: const TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              height: 1.25,
              color: corTinta,
            ),
          ),
          const SizedBox(height: 10),
          _Campo(rotulo: 'ONDE', texto: r.onde),
          _Campo(rotulo: 'O QUE NÃO PODE', texto: r.oQueProibe),
          if (r.temExcecao)
            _Campo(rotulo: 'O QUE ESCAPA', texto: r.excecao, cor: corMar),
          if (!r.oAnoInteiro) _Campo(rotulo: 'QUANDO', texto: r.quando),
          const SizedBox(height: 4),
          Fonte(norma: r.norma, detalhe: r.artigo),
          if (r.ressalva.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.fromLTRB(11, 10, 11, 11),
              decoration: BoxDecoration(
                color: corBoia.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                r.ressalva,
                style: const TextStyle(
                    fontSize: 12.5, height: 1.5, color: corTinta),
              ),
            ),
          ],
          const SizedBox(height: 10),
          TextoDobravel(
            titulo: 'O texto da regra',
            texto: r.detalhe,
            realcarArea: true,
          ),
        ],
      ),
    );
  }
}

class _Campo extends StatelessWidget {
  final String rotulo;
  final String texto;
  final Color? cor;

  const _Campo({required this.rotulo, required this.texto, this.cor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(rotulo,
              style: estiloEtiqueta.copyWith(color: cor ?? corApagada)),
          const SizedBox(height: 2),
          Text(
            texto,
            style: TextStyle(
                fontSize: 13.5, height: 1.45, color: cor ?? corTinta),
          ),
        ],
      ),
    );
  }
}

class _Nota extends StatelessWidget {
  const _Nota();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Estas regras não dependem da espécie. Elas se somam ao tamanho '
      'mínimo, ao defeso e à vedação por ameaça de extinção — não '
      'substituem nenhum dos três, e nenhum dos três dispensa estas. '
      'Confira a vigência antes de aplicar.',
      style: TextStyle(fontSize: 12.5, height: 1.5, color: corApagada),
    );
  }
}
