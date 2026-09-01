import 'package:flutter/material.dart';
import 'conflitos.dart';
import 'tema.dart';

// =====================================================================
// EM VERIFICAÇÃO
//
// A lista dos pontos em que o aplicativo dá uma resposta e existe
// indício de que ela pode estar errada. Serve para duas pessoas: quem
// está consultando, para não confiar cegamente naquele ponto; e quem vai
// buscar a norma que falta, para saber exatamente qual pedir.
// =====================================================================

class TelaConflitos extends StatelessWidget {
  const TelaConflitos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Em verificação')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
            children: [
              const Text('Pontos em verificação', style: estiloTitulo),
              const SizedBox(height: 6),
              Text(
                '${conflitos.length} respostas do aplicativo têm indício de '
                'que podem estar erradas. Cada uma diz o que falta para '
                'resolver.',
                style: estiloCorpo,
              ),
              const SizedBox(height: 18),
              for (final c in conflitos) ...[
                CartaoConflito(c: c),
                const SizedBox(height: 14),
              ],
              const _Porque(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Um ponto em verificação. Público porque a ficha da espécie usa.
class CartaoConflito extends StatefulWidget {
  final Conflito c;

  /// Na ficha da espécie começa fechado; na lista, aberto.
  final bool comecaFechado;

  const CartaoConflito({super.key, required this.c, this.comecaFechado = false});

  @override
  State<CartaoConflito> createState() => _CartaoConflitoState();
}

class _CartaoConflitoState extends State<CartaoConflito> {
  late bool aberto = !widget.comecaFechado;

  @override
  Widget build(BuildContext context) {
    final c = widget.c;
    return Container(
      decoration: BoxDecoration(
        color: corBoia.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: corBoia.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 3, right: 9),
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                          color: corBoia, shape: BoxShape.circle),
                    ),
                    const Expanded(
                      child: Text('EM VERIFICAÇÃO',
                          style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.4,
                              color: corBoia)),
                    ),
                    Text('desde ${c.desde}',
                        style: const TextStyle(
                            fontSize: 11.5, color: corApagada)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  c.titulo,
                  style: const TextStyle(
                    fontSize: 17.5,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                    color: corTinta,
                  ),
                ),
              ],
            ),
          ),
          if (!aberto)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
              child: Text(
                'O que falta: ${c.falta.split(".").first}.',
                style: const TextStyle(
                    fontSize: 14, height: 1.45, color: corApagada),
              ),
            ),
          if (aberto) ...[
            const SizedBox(height: 14),
            _Secao(rotulo: 'O QUE O APLICATIVO DIZ HOJE', texto: c.appDiz),
            _Secao(rotulo: 'O QUE INDICA O CONTRÁRIO', texto: c.indicio),
            if (c.tambemAlcanca.isNotEmpty)
              _Secao(rotulo: 'ALCANCE', texto: c.tambemAlcanca),
            _Secao(rotulo: 'O QUE FALTA PARA RESOLVER', texto: c.falta),
          ],
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => setState(() => aberto = !aberto),
              child: Text(aberto ? 'Mostrar menos' : 'Ver o ponto inteiro'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Secao extends StatelessWidget {
  final String rotulo;
  final String texto;
  const _Secao({required this.rotulo, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(rotulo,
              style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.3,
                  color: corApagada)),
          const SizedBox(height: 6),
          Text(texto,
              style: const TextStyle(
                  fontSize: 14.5, height: 1.5, color: corTinta)),
        ],
      ),
    );
  }
}

class _Porque extends StatelessWidget {
  const _Porque();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: corSuperficie,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: corBorda),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('POR QUE ISTO ESTÁ À VISTA', style: estiloEtiqueta),
          SizedBox(height: 10),
          Text(
            'Enquanto a dúvida existe, quem consulta precisa saber que '
            'ela existe. Um aplicativo que esconde o que não conferiu é '
            'pior do que não ter aplicativo: ele dá confiança onde não '
            'deveria haver.',
            style: TextStyle(fontSize: 14, height: 1.5, color: corTinta),
          ),
          SizedBox(height: 12),
          Text(
            'Quando a norma que falta chegar, o ponto sai desta lista e a '
            'resposta do aplicativo é corrigida.',
            style: TextStyle(fontSize: 13.5, height: 1.45, color: corApagada),
          ),
        ],
      ),
    );
  }
}
