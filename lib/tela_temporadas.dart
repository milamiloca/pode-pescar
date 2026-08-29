import 'package:flutter/material.dart';
import 'calendario.dart';
import 'defesos.dart';
import 'periodos.dart';
import 'tema.dart';

// =====================================================================
// DEFESOS E TEMPORADAS
//
// Tamanho mínimo e vedação por ameaça de extinção valem o ano inteiro.
// Defeso não: depende da data, às vezes da modalidade, e vem de norma
// própria, com data própria.
//
// A tela abre pelo calendário, porque a primeira pergunta em serviço é
// "estamos em defeso de alguma coisa agora?". Depois vêm os defesos com
// o texto da norma conferido — esses são resposta do aplicativo. Por
// último, a lista do que ainda falta obter, que não é resposta de nada:
// é a lista de compras de normas.
// =====================================================================

class TelaTemporadas extends StatefulWidget {
  const TelaTemporadas({super.key});

  @override
  State<TelaTemporadas> createState() => _TelaTemporadasState();
}

class _TelaTemporadasState extends State<TelaTemporadas> {
  @override
  Widget build(BuildContext context) =>
      DiaDeHoje(construir: (context, hoje) => _montar(context, hoje));

  Widget _montar(BuildContext context, DateTime hoje) {
    final conferidos =
        defesos.where((d) => d.origem == Origem.conferida).toList();
    final pendentes =
        defesos.where((d) => d.origem == Origem.pendente).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Defesos e temporadas')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
            children: [
              const Text('O ano, em períodos', style: estiloTitulo),
              const SizedBox(height: 6),
              const Text(
                'O calendário tem duas camadas. Em cima, faixa cheia: norma '
                'lida por inteiro, é resposta do aplicativo. Embaixo, faixa '
                'hachurada: data que veio do levantamento e cuja norma ainda '
                'não foi obtida — serve para saber o que procurar, não para '
                'autuar.',
                style: estiloCorpo,
              ),
              const SizedBox(height: 16),
              Calendario(hoje: hoje),
              const SizedBox(height: 12),
              _Agora(hoje: hoje),
              const SizedBox(height: 28),
              const TituloSecao('O que muda a seguir'),
              const SizedBox(height: 4),
              const Text(
                'As próximas viradas, na ordem em que acontecem. Só entre '
                'as normas conferidas: uma data que não saiu de norma não '
                'serve para avisar ninguém.',
                style: TextStyle(
                    fontSize: 14, height: 1.45, color: corApagada),
              ),
              const SizedBox(height: 14),
              ProximasViradas(hoje: hoje),
              const SizedBox(height: 28),
              const TituloSecao('Normas conferidas'),
              const SizedBox(height: 4),
              Text(
                '${conferidos.length} normas lidas por inteiro e '
                'reproduzidas. São resposta do aplicativo.',
                style: const TextStyle(
                    fontSize: 14, height: 1.45, color: corApagada),
              ),
              const SizedBox(height: 14),
              for (final d in conferidos) ...[
                CartaoDefeso(d: d),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 16),
              const TituloSecao('Normas a obter'),
              const SizedBox(height: 4),
              Text(
                '${pendentes.length} defesos que existem e cujo texto ainda '
                'não foi obtido. Não são resposta do aplicativo — estão aqui '
                'para dizer qual norma procurar.',
                style: const TextStyle(
                    fontSize: 14, height: 1.45, color: corApagada),
              ),
              const SizedBox(height: 14),
              for (final d in pendentes) ...[
                _CartaoPendente(d: d),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 14),
              const _Nota(),
            ],
          ),
        ),
      ),
    );
  }
}

/// O resumo do que está fechado hoje, logo abaixo do calendário. Dois
/// quadros, nunca um só: o que a norma conferida fecha, e o que o
/// levantamento indica sem norma na mão. Somar os dois números daria a
/// uma tabela de terceiro o peso de portaria.
class _Agora extends StatelessWidget {
  final DateTime hoje;
  const _Agora({required this.hoje});

  @override
  Widget build(BuildContext context) {
    final fechados = fechadosEm(hoje);
    final aConfirmar = fechadosAConfirmarEm(hoje);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (fechados.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: corPode.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: corPode.withValues(alpha: 0.3)),
            ),
            child: const Text(
              'Nenhuma restrição de período em curso hoje, entre as normas '
              'conferidas.',
              style: TextStyle(fontSize: 14.5, height: 1.45, color: corTinta),
            ),
          )
        else
          _Quadro(
            cor: corNaoPode,
            etiqueta: 'FECHADO HOJE — ${fechados.length} '
                '${fechados.length == 1 ? "RESTRIÇÃO" : "RESTRIÇÕES"}',
            lista: fechados,
          ),
        if (aConfirmar.isNotEmpty) ...[
          const SizedBox(height: 12),
          _Quadro(
            cor: corBoia,
            etiqueta: 'A CONFIRMAR — ${aConfirmar.length} '
                '${aConfirmar.length == 1 ? "INDICAÇÃO" : "INDICAÇÕES"}',
            rodape: 'O levantamento indica período fechado nesta data. A '
                'norma não foi obtida, então isto não é resposta do '
                'aplicativo: é o que conferir antes de qualquer medida.',
            lista: aConfirmar,
          ),
        ],
      ],
    );
  }
}

class _Quadro extends StatelessWidget {
  final Color cor;
  final String etiqueta;
  final String rodape;
  final List<Periodo> lista;

  const _Quadro({
    required this.cor,
    required this.etiqueta,
    required this.lista,
    this.rodape = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            etiqueta,
            style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.3,
                color: cor),
          ),
          const SizedBox(height: 10),
          for (final p in lista) ...[
            Text(
              '${p.especie.split(" — ").first} · ${p.detalhe}',
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                  color: corTinta),
            ),
            if (p.onde.isNotEmpty)
              Text(
                p.onde,
                style: const TextStyle(
                    fontSize: 13, height: 1.35, color: corApagada),
              ),
            Text(
              p.confirmado ? '${p.norma}, ${p.artigo}' : '${p.norma} — a obter',
              style: const TextStyle(
                  fontSize: 12, height: 1.4, color: corApagada),
            ),
            const SizedBox(height: 10),
          ],
          if (rodape.isNotEmpty) ...[
            Container(height: 1, color: cor.withValues(alpha: 0.3)),
            const SizedBox(height: 10),
            Text(
              rodape,
              style: const TextStyle(
                  fontSize: 12.5, height: 1.45, color: corApagada),
            ),
          ],
        ],
      ),
    );
  }
}

/// Um defeso com o texto da norma conferido.
class CartaoDefeso extends StatefulWidget {
  final Defeso d;

  /// Na ficha da espécie o título da espécie já apareceu em cima.
  final bool semTitulo;

  const CartaoDefeso({super.key, required this.d, this.semTitulo = false});

  @override
  State<CartaoDefeso> createState() => _CartaoDefesoState();
}

class _CartaoDefesoState extends State<CartaoDefeso> {
  bool aberto = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.d;
    return Container(
      decoration: BoxDecoration(
        color: corSuperficie,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: corBorda),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
            decoration: const BoxDecoration(
              color: corProfundo,
              borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!widget.semTitulo) ...[
                  Text(
                    d.titulo,
                    style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        height: 1.15,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    d.cientificos.join(', '),
                    style: const TextStyle(
                        fontSize: 12.5,
                        fontStyle: FontStyle.italic,
                        height: 1.35,
                        color: Color(0xFF9EC2CB)),
                  ),
                  const SizedBox(height: 12),
                  Container(height: 1, color: const Color(0xFF23505C)),
                  const SizedBox(height: 12),
                ],
                const Text('PERÍODO',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: Color(0xFF7FB3BF))),
                const SizedBox(height: 5),
                Text(
                  d.periodo,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                      color: Colors.white),
                ),
                const SizedBox(height: 12),
                const Text('PARA ONDE VALE',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: Color(0xFF7FB3BF))),
                const SizedBox(height: 5),
                Text(
                  d.abrangencia,
                  style: const TextStyle(
                      fontSize: 13.5, height: 1.4, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  d.norma,
                  style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                      color: Color(0xFFB9D2D8)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 4, right: 9),
                  width: 8,
                  height: 8,
                  decoration:
                      const BoxDecoration(color: corPode, shape: BoxShape.circle),
                ),
                const Expanded(
                  child: Text(
                    'Texto da norma conferido e reproduzido no aplicativo.',
                    style: TextStyle(
                        fontSize: 12.5,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                        color: corPode),
                  ),
                ),
              ],
            ),
          ),
          if (d.ressalva.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: corBoia.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: corBoia.withValues(alpha: 0.35)),
                ),
                child: Text(
                  d.ressalva,
                  style: const TextStyle(
                      fontSize: 13, height: 1.45, color: corApagada),
                ),
              ),
            ),
          if (d.detalhe.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
              child: aberto
                  ? TextoComArea(
                      texto: d.detalhe,
                      estilo: const TextStyle(
                          fontSize: 14.5, height: 1.55, color: corTinta),
                    )
                  : Text(
                      d.detalhe.length > 150
                          ? '${d.detalhe.substring(0, 150)}…'
                          : d.detalhe,
                      style: const TextStyle(
                          fontSize: 14.5, height: 1.5, color: corTinta),
                    ),
            ),
            if (d.detalhe.length > 150)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => setState(() => aberto = !aberto),
                  child: Text(aberto ? 'Mostrar menos' : 'Ver o texto inteiro'),
                ),
              )
            else
              const SizedBox(height: 16),
          ] else
            const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Um defeso que se sabe existir, mas cuja norma ainda não foi obtida.
/// Não dá resposta: diz o que procurar.
class _CartaoPendente extends StatefulWidget {
  final Defeso d;
  const _CartaoPendente({required this.d});

  @override
  State<_CartaoPendente> createState() => _CartaoPendenteState();
}

class _CartaoPendenteState extends State<_CartaoPendente> {
  bool aberto = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.d;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: corSuperficie,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: corBorda),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  d.titulo,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                      color: corTinta),
                ),
              ),
              const SizedBox(width: 8),
              const Selo('a obter', cor: corBoia),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            d.cientificos.join(', '),
            style: const TextStyle(
                fontSize: 12, fontStyle: FontStyle.italic, color: corApagada),
          ),
          const SizedBox(height: 10),
          const Text('NORMA A OBTER',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.3,
                  color: corBoia)),
          const SizedBox(height: 4),
          Text(
            d.norma,
            style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                height: 1.35,
                color: corTinta),
          ),
          const SizedBox(height: 10),
          const Text('PARA ONDE VALE', style: estiloEtiqueta),
          const SizedBox(height: 4),
          Text(
            d.abrangencia,
            style: const TextStyle(
                fontSize: 13.5, height: 1.4, color: corTinta),
          ),
          if (aberto) ...[
            const SizedBox(height: 12),
            const Regua(),
            const SizedBox(height: 10),
            const Text(
              'O QUE O LEVANTAMENTO INDICA — NÃO É RESPOSTA DO APLICATIVO',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  height: 1.3,
                  color: corApagada),
            ),
            const SizedBox(height: 6),
            Text(
              'Período: ${d.periodo}.',
              style: const TextStyle(
                  fontSize: 13.5, height: 1.45, color: corApagada),
            ),
            if (d.detalhe.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                d.detalhe,
                style: const TextStyle(
                    fontSize: 13.5, height: 1.45, color: corApagada),
              ),
            ],
            if (d.ressalva.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                d.ressalva,
                style: const TextStyle(
                    fontSize: 13.5, height: 1.45, color: corApagada),
              ),
            ],
          ],
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => setState(() => aberto = !aberto),
              child: Text(aberto ? 'Mostrar menos' : 'O que se sabe até aqui'),
            ),
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
          Text('COMO ESTA LISTA FOI MONTADA', style: estiloEtiqueta),
          SizedBox(height: 10),
          Text(
            'A relação de defesos veio do levantamento "Legislação Pesqueira '
            'em Santa Catarina" (Prof. Roberto Wahrlich, Laboratório de '
            'Tecnologia e Extensão Pesqueira/UNIVALI, 10 de junho de 2025), '
            'usado como índice: ele diz que a regra existe e qual norma '
            'procurar.',
            style: TextStyle(fontSize: 13.5, height: 1.5, color: corTinta),
          ),
          SizedBox(height: 12),
          Text(
            'Cada norma obtida é lida por inteiro e passa para a seção '
            'conferida, com o texto reproduzido. O levantamento não vira '
            'resposta do aplicativo em nenhum momento.',
            style: TextStyle(fontSize: 13.5, height: 1.45, color: corApagada),
          ),
          SizedBox(height: 12),
          Text(
            'A relação foi cruzada com a tabela de períodos de defeso '
            'publicada pelo Ministério da Pesca e Aquicultura, e ficou '
            'apenas o que alcança Santa Catarina. Defeso de outro estado '
            'não entra: não é resposta errada, é resposta de outro lugar.',
            style: TextStyle(fontSize: 13.5, height: 1.45, color: corTinta),
          ),
          SizedBox(height: 12),
          Text(
            'O levantamento exclui pescarias além da isóbata de 100 m, '
            'licenciamento, procedimentos administrativos, Unidades de '
            'Conservação e normas municipais. Defesos estaduais e municipais '
            'não estão aqui.',
            style: TextStyle(fontSize: 13.5, height: 1.45, color: corApagada),
          ),
        ],
      ),
    );
  }
}
