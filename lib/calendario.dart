import 'dart:async';

import 'package:flutter/material.dart';
import 'periodos.dart';
import 'tema.dart';

// =====================================================================
// O CALENDÁRIO DO ANO
//
// Doze meses numa faixa, uma barra por período, e uma linha vertical em
// hoje. A pergunta que ele responde de relance é a que quem consulta faz
// primeiro: estamos em defeso de alguma coisa agora?
//
// Duas cores, e a diferença entre elas importa:
//   vermelho — período de proibição. Dentro dele, não pode.
//   verde    — janela de permissão. FORA dela, não pode.
//
// A tainha é o caso que obriga essa distinção: o art. 2º da Portaria 24
// não fixa um defeso, fixa a temporada em que a pesca é permitida. Uma
// barra verde curta quer dizer um ano quase todo fechado.
//
// E duas camadas, separadas na tela e no desenho:
//   barra cheia      — a norma foi lida por inteiro. É resposta.
//   barra hachurada  — a data veio do levantamento, a norma ainda não
//                      foi obtida. Não é resposta: é aviso de que há
//                      norma para procurar antes de aplicar.
//
// A camada de baixo nunca se mistura com a de cima. Ela vem depois de
// um cabeçalho próprio, com a cor da dúvida, e cada barra dela carrega
// a hachura, que é o mesmo sinal do selo "a confirmar".
// =====================================================================

const _meses = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];

class Calendario extends StatelessWidget {
  final DateTime hoje;
  const Calendario({super.key, required this.hoje});

  Map<String, List<Periodo>> _agrupar(bool confirmado) {
    final grupos = <String, List<Periodo>>{};
    for (final p in periodos) {
      if (p.confirmado != confirmado) continue;
      grupos.putIfAbsent(p.especie, () => []).add(p);
    }
    return grupos;
  }

  @override
  Widget build(BuildContext context) {
    final firmes = _agrupar(true);
    final duvidosos = _agrupar(false);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: corSuperficie,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: corBorda),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EscalaMeses(mesDeHoje: hoje.month),
          const SizedBox(height: 10),
          for (final e in firmes.entries) ...[
            _Grupo(nome: e.key, linhas: e.value, hoje: hoje),
            for (final p in e.value) _Linha(p: p, hoje: hoje),
            const SizedBox(height: 12),
          ],
          if (duvidosos.isNotEmpty) ...[
            const _DivisorAConfirmar(),
            for (final e in duvidosos.entries) ...[
              _Grupo(nome: e.key, linhas: e.value, hoje: hoje),
              for (final p in e.value) _Linha(p: p, hoje: hoje),
              const SizedBox(height: 12),
            ],
          ],
          const Regua(),
          const SizedBox(height: 10),
          const _Legenda(),
        ],
      ),
    );
  }
}

class _EscalaMeses extends StatelessWidget {
  final int mesDeHoje;
  const _EscalaMeses({required this.mesDeHoje});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < 12; i++)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 3),
              decoration: i + 1 == mesDeHoje
                  ? BoxDecoration(
                      color: corProfundo.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(4),
                    )
                  : null,
              child: Text(
                _meses[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: i + 1 == mesDeHoje ? corProfundo : corApagada,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// O cabeçalho da espécie, com o veredito do grupo ao lado.
///
/// A tainha tem cinco modalidades e quatro áreas fechadas: dez linhas.
/// Ler as dez para saber se a tainha está fechada é trabalho demais
/// para uma pergunta que cabe numa frase.
class _Grupo extends StatelessWidget {
  final String nome;
  final List<Periodo> linhas;
  final DateTime hoje;

  const _Grupo({
    required this.nome,
    required this.linhas,
    required this.hoje,
  });

  @override
  Widget build(BuildContext context) {
    final fechadas = linhas.where((p) => p.fechadoEm(hoje)).length;
    final confirmado = linhas.first.confirmado;
    final cor = !confirmado
        ? corApagada
        : fechadas == 0
            ? corPode
            : corNaoPode;
    final resumo = linhas.length == 1
        ? (fechadas == 1 ? 'fechado hoje' : 'aberto hoje')
        : fechadas == 0
            ? 'nenhuma fechada hoje'
            : fechadas == linhas.length
                ? 'todas fechadas hoje'
                : '$fechadas de ${linhas.length} fechadas hoje';

    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              nome,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
                height: 1.25,
                color: corTinta,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            resumo,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: cor,
            ),
          ),
        ],
      ),
    );
  }
}

/// A linha que separa as duas camadas. Existe para que ninguém leia a
/// segunda achando que é a primeira.
class _DivisorAConfirmar extends StatelessWidget {
  const _DivisorAConfirmar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 1, color: corBoia.withValues(alpha: 0.4)),
          const SizedBox(height: 10),
          const Text(
            'A CONFIRMAR — NORMA AINDA NÃO OBTIDA',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: corBoia,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Datas do levantamento da UNIVALI. Servem para saber que há '
            'norma a procurar, não como resposta pronta.',
            style: TextStyle(fontSize: 12, height: 1.4, color: corApagada),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _Linha extends StatelessWidget {
  final Periodo p;
  final DateTime hoje;
  const _Linha({required this.p, required this.hoje});

  @override
  Widget build(BuildContext context) {
    final fechado = p.fechadoEm(hoje);

    // Na camada confirmada o aplicativo afirma. Na camada a confirmar
    // ele só indica, e o texto do selo diz isso.
    final String selo;
    final Color corSelo;
    if (p.confirmado) {
      selo = fechado ? 'fechado hoje' : 'aberto hoje';
      corSelo = fechado ? corNaoPode : corPode;
    } else {
      selo = fechado ? 'indica fechado' : 'a confirmar';
      corSelo = fechado ? corBoia : corApagada;
    }
    final destacar = fechado && p.confirmado;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  p.detalhe,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.3,
                    fontWeight: destacar ? FontWeight.w600 : FontWeight.w400,
                    color: destacar ? corTinta : corApagada,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                margin: const EdgeInsets.only(top: 3),
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: corSelo,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              SizedBox(
                width: 74,
                child: Text(
                  selo,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: corSelo,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 12,
            child: CustomPaint(
              size: const Size(double.infinity, 12),
              painter: _BarraPainter(p: p, hoje: hoje),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  p.datas,
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.3,
                    fontWeight: destacar ? FontWeight.w600 : FontWeight.w500,
                    color: p.confirmado
                        ? (p.tipo == TipoPeriodo.fechado
                            ? corNaoPode
                            : corPode)
                        : corApagada,
                  ),
                ),
              ),
              if (p.viraOAno)
                const Text(
                  'vira o ano',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontStyle: FontStyle.italic,
                    color: corApagada,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Desenha a barra do ano: fundo neutro, o período pintado, e o traço
/// de hoje por cima. Período confirmado sai cheio; período a confirmar
/// sai hachurado, lavado, com contorno — a mesma cor, sem o peso dela.
class _BarraPainter extends CustomPainter {
  final Periodo p;
  final DateTime hoje;
  const _BarraPainter({required this.p, required this.hoje});

  @override
  void paint(Canvas canvas, Size size) {
    const raio = Radius.circular(3);
    final fundo = Paint()..color = const Color(0xFFE3EBED);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, raio),
      fundo,
    );

    // a coluna do mês corrente, para o olho alinhar a faixa ao mês sem
    // precisar contar divisórias
    const diasDoMes = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    var antes = 0;
    for (var i = 0; i < hoje.month - 1; i++) {
      antes += diasDoMes[i];
    }
    canvas.drawRect(
      Rect.fromLTRB(
        antes / 365 * size.width,
        0,
        (antes + diasDoMes[hoje.month - 1]) / 365 * size.width,
        size.height,
      ),
      Paint()..color = corProfundo.withValues(alpha: 0.07),
    );

    final cor = p.tipo == TipoPeriodo.fechado ? corNaoPode : corPode;
    final tinta = Paint()..color = cor;

    void faixa(int de, int ate) {
      final x1 = (diaDoAno(de) - 1) / 365 * size.width;
      final bruto = diaDoAno(ate) / 365 * size.width;
      final x2 = bruto < x1 + 2
          ? x1 + 2
          : (bruto > size.width ? size.width : bruto);
      final r = RRect.fromRectAndRadius(
        Rect.fromLTRB(x1, 0, x2, size.height),
        raio,
      );

      if (p.confirmado) {
        canvas.drawRRect(r, tinta);
        return;
      }

      canvas.drawRRect(r, Paint()..color = cor.withValues(alpha: 0.14));
      canvas.save();
      canvas.clipRRect(r);
      final hachura = Paint()
        ..color = cor.withValues(alpha: 0.55)
        ..strokeWidth = 1.4;
      for (var x = x1 - size.height; x < x2 + size.height; x += 5) {
        canvas.drawLine(
          Offset(x, size.height),
          Offset(x + size.height, 0),
          hachura,
        );
      }
      canvas.restore();
      canvas.drawRRect(
        r,
        Paint()
          ..color = cor.withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    if (p.viraOAno) {
      faixa(p.de, 1231);
      faixa(101, p.ate);
    } else {
      faixa(p.de, p.ate);
    }

    // divisórias dos meses, finas, por cima
    final risco = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..strokeWidth = 1;
    var acumulado = 0;
    const dias = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    for (var i = 0; i < 11; i++) {
      acumulado += dias[i];
      final x = acumulado / 365 * size.width;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), risco);
    }

    // hoje
    final d = diaDoAno(hoje.month * 100 + hoje.day);
    final xh = (d - 0.5) / 365 * size.width;
    canvas.drawLine(
      Offset(xh, -3),
      Offset(xh, size.height + 3),
      Paint()
        ..color = corProfundo
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_BarraPainter velho) =>
      velho.p != p || velho.hoje != hoje;
}

class _Legenda extends StatelessWidget {
  const _Legenda();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ItemLegenda(
          marca: _Ponto(cor: corNaoPode),
          texto: 'Período de proibição: dentro da faixa, não pode.',
        ),
        const SizedBox(height: 5),
        const _ItemLegenda(
          marca: _Ponto(cor: corPode),
          texto: 'Temporada permitida: fora da faixa, não pode.',
        ),
        const SizedBox(height: 5),
        const _ItemLegenda(
          marca: SizedBox(width: 8),
          texto: 'A data embaixo de cada faixa diz o período: "fechado de" '
              'é proibição; "só pode de" é temporada — fora dela, não '
              'pode.',
        ),
        const SizedBox(height: 5),
        const _ItemLegenda(
          marca: _AmostraHachura(),
          texto: 'Faixa hachurada: data do levantamento, norma ainda não '
              'obtida. Confirmar antes de aplicar.',
        ),
        const SizedBox(height: 5),
        _ItemLegenda(
          marca: Container(
            margin: const EdgeInsets.only(left: 3),
            width: 2,
            height: 11,
            color: corProfundo,
          ),
          texto: 'A linha vertical é hoje.',
        ),
      ],
    );
  }
}

class _ItemLegenda extends StatelessWidget {
  final Widget marca;
  final String texto;
  const _ItemLegenda({required this.marca, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 18, child: Center(child: marca)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            texto,
            style: const TextStyle(fontSize: 12, height: 1.4, color: corApagada),
          ),
        ),
      ],
    );
  }
}

class _Ponto extends StatelessWidget {
  final Color cor;
  const _Ponto({required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
    );
  }
}

/// O mesmo desenho da barra a confirmar, em miniatura, para que a
/// legenda seja reconhecível ao lado da faixa e não só descrita.
class _AmostraHachura extends StatelessWidget {
  const _AmostraHachura();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 16,
      height: 10,
      child: CustomPaint(painter: _AmostraPainter()),
    );
  }
}

class _AmostraPainter extends CustomPainter {
  const _AmostraPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final r = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(2),
    );
    canvas.drawRRect(r, Paint()..color = corNaoPode.withValues(alpha: 0.14));
    canvas.save();
    canvas.clipRRect(r);
    final hachura = Paint()
      ..color = corNaoPode.withValues(alpha: 0.55)
      ..strokeWidth = 1.4;
    for (var x = -size.height; x < size.width + size.height; x += 5) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        hachura,
      );
    }
    canvas.restore();
    canvas.drawRRect(
      r,
      Paint()
        ..color = corNaoPode.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(_AmostraPainter velho) => false;
}

// =====================================================================
// A VIRADA DA MEIA-NOITE
//
// Toda tela lê DateTime.now() no build, então abrir o aplicativo em 20
// de dezembro dá a resposta de 20 de dezembro, em qualquer ano — a
// comparação é feita só por mês e dia.
//
// Mas build() roda quando a tela é construída, e não de novo sozinho.
// Um aparelho que fica aberto atravessando a meia-noite mostraria a
// resposta de ontem. Numa consulta de madrugada isso é resposta errada: o
// defeso do caranguejo começa à zero hora de 1º de outubro, o da
// garoupa à zero hora de 1º de novembro.
//
// Este widget reconstrói na virada, e também quando o aplicativo volta
// do segundo plano — porque um aparelho no bolso, com a tela apagada,
// pode não executar o temporizador.
// =====================================================================

class DiaDeHoje extends StatefulWidget {
  final Widget Function(BuildContext, DateTime) construir;
  const DiaDeHoje({super.key, required this.construir});

  @override
  State<DiaDeHoje> createState() => _DiaDeHojeState();
}

class _DiaDeHojeState extends State<DiaDeHoje> with WidgetsBindingObserver {
  DateTime hoje = DateTime.now();
  Timer? _relogio;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _agendar();
  }

  void _agendar() {
    _relogio?.cancel();
    final agora = DateTime.now();
    final meiaNoite = DateTime(agora.year, agora.month, agora.day)
        .add(const Duration(days: 1));
    _relogio = Timer(
      meiaNoite.difference(agora) + const Duration(seconds: 2),
      () {
        if (mounted) setState(() => hoje = DateTime.now());
        _agendar();
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState estado) {
    if (estado != AppLifecycleState.resumed) return;
    final agora = DateTime.now();
    final virou = agora.day != hoje.day ||
        agora.month != hoje.month ||
        agora.year != hoje.year;
    if (virou && mounted) setState(() => hoje = agora);
    _agendar();
  }

  @override
  void dispose() {
    _relogio?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.construir(context, hoje);
}

// =====================================================================
// O AVISO DA TELA INICIAL
// =====================================================================

/// Diz, na abertura do aplicativo, o que está fechado na data de hoje.
/// Recalcula a cada abertura, porque lê DateTime.now().
///
/// O número grande conta só as normas conferidas. O que o levantamento
/// indica vem embaixo, em outra cor, contado à parte — porque é outra
/// coisa, e misturar os dois números seria dar peso de norma a uma
/// tabela de terceiro.
class AvisoDeHoje extends StatelessWidget {
  final VoidCallback aoTocar;
  const AvisoDeHoje({super.key, required this.aoTocar});

  @override
  Widget build(BuildContext context) =>
      DiaDeHoje(construir: (context, hoje) => _montar(context, hoje));

  Widget _montar(BuildContext context, DateTime hoje) {
    final fechados = fechadosEm(hoje);
    final aConfirmar = fechadosAConfirmarEm(hoje);
    final especies = especiesFechadasEm(hoje);
    final tem = fechados.isNotEmpty;
    final cor = tem ? corNaoPode : corPode;

    String dois(int n) => n < 10 ? '0$n' : '$n';
    final data = '${dois(hoje.day)}/${dois(hoje.month)}/${hoje.year}';

    return Material(
      color: cor.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: aoTocar,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cor.withValues(alpha: 0.35)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 4, right: 10),
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HOJE, $data',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.3,
                        color: cor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      tem
                          ? '${fechados.length} '
                              '${fechados.length == 1 ? "restrição" : "restrições"} '
                              'em curso: ${especies.join(", ").toLowerCase()}'
                          : 'Nenhuma restrição de período em curso',
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: corTinta,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Contando apenas as normas com texto conferido.',
                      style: TextStyle(
                          fontSize: 12.5, height: 1.35, color: corApagada),
                    ),
                    if (aConfirmar.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Container(height: 1, color: corBoia.withValues(alpha: 0.35)),
                      const SizedBox(height: 9),
                      Text(
                        '+ ${aConfirmar.length} a confirmar: '
                        '${_nomes(aConfirmar).join(", ").toLowerCase()}',
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                          color: corBoia,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'O levantamento indica defeso, a norma ainda não foi '
                        'obtida.',
                        style: TextStyle(
                            fontSize: 12.5, height: 1.35, color: corApagada),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.arrow_forward, size: 19, color: cor),
            ],
          ),
        ),
      ),
    );
  }
}

/// Nomes de espécie sem repetir, para caber numa linha do aviso.
List<String> _nomes(List<Periodo> lista) {
  final vistas = <String>[];
  for (final p in lista) {
    final nome = p.especie.split(' — ').first;
    if (!vistas.contains(nome)) vistas.add(nome);
  }
  return vistas;
}


// =====================================================================
// AS PRÓXIMAS VIRADAS
//
// O calendário responde "como é o ano". Isto responde "o que muda a
// seguir", que é outra pergunta e aparece tanto quanto. Saber que o
// cherne fecha em três dias vale mais, na prática, do que saber a forma
// da barra dele.
// =====================================================================

class ProximasViradas extends StatelessWidget {
  final DateTime hoje;
  const ProximasViradas({super.key, required this.hoje});

  @override
  Widget build(BuildContext context) {
    final viradas = proximasViradas(hoje);
    if (viradas.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: corSuperficie,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: corBorda),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < viradas.length; i++)
            _LinhaVirada(v: viradas[i], primeira: i == 0),
        ],
      ),
    );
  }
}

class _LinhaVirada extends StatelessWidget {
  final Virada v;
  final bool primeira;
  const _LinhaVirada({required this.v, required this.primeira});

  @override
  Widget build(BuildContext context) {
    final cor = v.fecha ? corNaoPode : corPode;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
      decoration: BoxDecoration(
        border: primeira
            ? null
            : const Border(top: BorderSide(color: Color(0xFFEEF3F4))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                v.data,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  color: cor,
                ),
              ),
              const Spacer(),
              Text(
                v.quando,
                style: const TextStyle(fontSize: 11.5, color: corApagada),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            v.verbo,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              color: cor,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            v.especie,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              height: 1.25,
              color: corTinta,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            v.periodo.detalhe,
            style: const TextStyle(
                fontSize: 12.5, height: 1.35, color: corApagada),
          ),
          if (v.periodo.onde.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              v.periodo.onde,
              style: const TextStyle(
                  fontSize: 11.5, height: 1.35, color: Color(0xFF8AA0A8)),
            ),
          ],
          // O aviso que evita a leitura permissiva: uma regra que termina
          // não é uma pescaria que abre.
          if (!v.fecha && v.aindaRestrita) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              decoration: BoxDecoration(
                color: corNaoPode.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4, right: 8),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                        color: corNaoPode, shape: BoxShape.circle),
                  ),
                  Expanded(
                    child: Text(
                      'Não é a pescaria que abre: só esta regra que '
                      'termina. ${v.especie} segue com '
                      '${v.quantasOutras == 1 ? "outra restrição" : "${v.quantasOutras} outras restrições"} '
                      'nesta data.',
                      style: const TextStyle(
                          fontSize: 12, height: 1.35, color: corNaoPode),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
