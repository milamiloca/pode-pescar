import 'package:flutter/material.dart';
import 'dados.dart';
import 'tema.dart';

// =====================================================================
// DESENHOS
//
// Tudo aqui é desenhado à mão com linhas e curvas, sem imagem e sem
// biblioteca de fora. Dois grupos:
//
//   PeixePainter    silhueta do peixe, com a régua da medição
//   PetrechoPainter esquema do apetrecho, no estilo de manual técnico
//
// Cada desenho vive num espaço fixo (100 de largura) e o Flutter
// estica pro tamanho que couber na tela.
// =====================================================================

// ---------------------------------------------------------------- peixe

class _Corpo {
  final Path caminho;
  final double focinho;
  final double furca;
  final double ponta;
  final double olhoX;
  final double olhoY;

  const _Corpo(
      this.caminho, this.focinho, this.furca, this.ponta, this.olhoX, this.olhoY);
}

_Corpo _montarCorpo(Forma forma) {
  final p = Path();
  switch (forma) {
    case Forma.robusto:
      p.moveTo(4, 22);
      p.quadraticBezierTo(28, -6, 60, 9);
      p.lineTo(72, 16);
      p.lineTo(96, 5);
      p.lineTo(88, 22);
      p.lineTo(96, 39);
      p.lineTo(72, 28);
      p.quadraticBezierTo(28, 50, 4, 22);
      p.close();
      return _Corpo(p, 4, 88, 96, 14, 18);

    case Forma.fita:
      p.moveTo(3, 20);
      p.quadraticBezierTo(30, 13, 70, 17);
      p.lineTo(97, 22);
      p.lineTo(70, 27);
      p.quadraticBezierTo(30, 29, 3, 20);
      p.close();
      return _Corpo(p, 3, 97, 97, 10, 19);

    case Forma.chato:
      p.moveTo(5, 23);
      p.quadraticBezierTo(30, -4, 66, 11);
      p.lineTo(80, 18);
      p.quadraticBezierTo(97, 7, 97, 23);
      p.quadraticBezierTo(97, 39, 80, 28);
      p.quadraticBezierTo(30, 48, 5, 23);
      p.close();
      return _Corpo(p, 5, 97, 97, 15, 15);

    case Forma.tubarao:
      p.moveTo(3, 21);
      p.quadraticBezierTo(22, 10, 40, 12);
      p.lineTo(46, 2);
      p.lineTo(54, 13);
      p.quadraticBezierTo(68, 15, 76, 18);
      p.lineTo(97, 4);
      p.lineTo(87, 22);
      p.lineTo(94, 34);
      p.lineTo(76, 25);
      p.quadraticBezierTo(60, 32, 44, 30);
      p.lineTo(38, 38);
      p.lineTo(34, 29);
      p.quadraticBezierTo(16, 27, 3, 21);
      p.close();
      return _Corpo(p, 3, 87, 97, 11, 19);

    case Forma.comum:
      p.moveTo(3, 21);
      p.quadraticBezierTo(30, 4, 60, 12);
      p.lineTo(72, 16);
      p.lineTo(96, 4);
      p.lineTo(87, 22);
      p.lineTo(96, 40);
      p.lineTo(72, 27);
      p.quadraticBezierTo(30, 39, 3, 21);
      p.close();
      return _Corpo(p, 3, 87, 96, 13, 19);
  }
}

class PeixePainter extends CustomPainter {
  final Forma forma;
  final Color cor;
  final bool mostrarMedida;
  final bool ateFurca;

  const PeixePainter({
    required this.forma,
    required this.cor,
    this.mostrarMedida = false,
    this.ateFurca = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final corpo = _montarCorpo(forma);
    canvas.save();
    canvas.scale(size.width / 100);

    canvas.drawPath(corpo.caminho, Paint()..color = cor);
    canvas.drawCircle(
      Offset(corpo.olhoX, corpo.olhoY),
      1.7,
      Paint()..color = Colors.white,
    );

    if (mostrarMedida) {
      final fim = ateFurca ? corpo.furca : corpo.ponta;
      final regua = Paint()
        ..color = corMar
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round;
      const y = 52.0;
      canvas.drawLine(Offset(corpo.focinho, y), Offset(fim, y), regua);
      canvas.drawLine(
          Offset(corpo.focinho, 44), Offset(corpo.focinho, y + 5), regua);
      canvas.drawLine(Offset(fim, 44), Offset(fim, y + 5), regua);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(PeixePainter antigo) =>
      antigo.forma != forma ||
      antigo.cor != cor ||
      antigo.mostrarMedida != mostrarMedida ||
      antigo.ateFurca != ateFurca;
}

// -------------------------------------------------------------- camarão

/// A figura do Anexo I da Portaria SAP/MAPA nº 656/2022.
///
/// É a imagem da própria norma, não um desenho parecido: os dois pontos
/// de referência da medida — rostro e telso — precisam ser os que o
/// documento mostra, porque é sobre eles que a discussão acontece em
/// campo.
///
/// Do arquivo original foi retirado só o cabeçalho, com o Brasão da
/// República e o nome do Ministério. Ele não faz parte do desenho, e
/// este aplicativo não é institucional. A figura está inteira: o título,
/// as duas setas, a chave do comprimento total e a nota de rodapé.
///
/// Imagem de 900 px de largura, 62 KB — é o único arquivo de imagem do
/// aplicativo.
class ComoMedirCamarao extends StatelessWidget {
  final double largura;
  const ComoMedirCamarao({super.key, this.largura = 260});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/camarao_656.png',
      width: largura,
      fit: BoxFit.contain,
      // A figura é traço preto sobre fundo branco. Num tema escuro ela
      // ficaria uma mancha; o fundo claro atrás dela resolve isso sem
      // mexer na imagem.
      errorBuilder: (context, erro, pilha) => Text(
        'Figura do Anexo I da Portaria SAP/MAPA nº 656/2022 — a medida '
        'vai da extremidade do rostro à ponta do telso.',
        style: const TextStyle(
            fontSize: 12.5, height: 1.45, color: corApagada),
      ),
    );
  }
}

// ------------------------------------------------------------- petrecho

/// Esquema do apetrecho, desenhado só com traço — o registro é o de
/// figura de manual, não de ilustração. Espaço de desenho: 100 x 70.
class PetrechoPainter extends CustomPainter {
  final Metodo metodo;
  final Color cor;

  const PetrechoPainter({required this.metodo, required this.cor});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100);

    final traco = Paint()
      ..color = cor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fino = Paint()
      ..color = cor.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round;

    final cheio = Paint()..color = cor;

    switch (metodo) {
      case Metodo.linha:
        // linha-mãe na superfície, boias em cima, anzóis pendurados
        canvas.drawLine(const Offset(6, 18), const Offset(94, 18), traco);
        for (final x in [20.0, 50.0, 80.0]) {
          canvas.drawCircle(Offset(x, 13), 3.4, cheio);
        }
        for (final x in [28.0, 50.0, 72.0]) {
          canvas.drawLine(Offset(x, 18), Offset(x, 44), fino);
          final anzol = Path()
            ..moveTo(x, 44)
            ..quadraticBezierTo(x, 53, x - 5, 52)
            ..quadraticBezierTo(x - 9, 51, x - 7, 46);
          canvas.drawPath(anzol, traco);
        }

      case Metodo.emalhe:
        // parede de rede: boias em cima, chumbadas embaixo, malha no meio
        canvas.drawLine(const Offset(8, 18), const Offset(92, 18), traco);
        canvas.drawLine(const Offset(8, 54), const Offset(92, 54), traco);
        canvas.drawLine(const Offset(8, 18), const Offset(8, 54), traco);
        canvas.drawLine(const Offset(92, 18), const Offset(92, 54), traco);
        for (final x in [20.0, 42.0, 64.0, 86.0]) {
          canvas.drawCircle(Offset(x - 3, 13), 3.2, cheio);
        }
        for (final x in [16.0, 38.0, 60.0, 82.0]) {
          canvas.drawRect(Rect.fromLTWH(x, 56, 5, 4), cheio);
        }
        for (var i = 0; i < 4; i++) {
          final x = 8.0 + i * 21;
          canvas.drawLine(Offset(x, 18), Offset(x + 21, 54), fino);
          canvas.drawLine(Offset(x, 54), Offset(x + 21, 18), fino);
        }

      case Metodo.arrasto:
        // dois cabos puxando um funil que termina no saco
        canvas.drawLine(const Offset(4, 34), const Offset(34, 16), fino);
        canvas.drawLine(const Offset(4, 38), const Offset(34, 56), fino);
        canvas.drawLine(const Offset(34, 16), const Offset(34, 56), traco);
        canvas.drawLine(const Offset(34, 16), const Offset(80, 28), traco);
        canvas.drawLine(const Offset(34, 56), const Offset(80, 44), traco);
        canvas.drawRect(
            Rect.fromLTRB(80, 28, 94, 44), traco); // saco (ensacador)
        for (var i = 1; i < 4; i++) {
          final t = i / 4;
          canvas.drawLine(
            Offset(34 + 46 * t, 16 + 12 * t),
            Offset(34 + 46 * t, 56 - 12 * t),
            fino,
          );
        }

      case Metodo.cerco:
        // rede fechando um cardume em círculo, boias na superfície
        canvas.drawLine(const Offset(6, 16), const Offset(94, 16), traco);
        for (final x in [16.0, 38.0, 62.0, 84.0]) {
          canvas.drawCircle(Offset(x, 11), 3.2, cheio);
        }
        final bolsa = Path()
          ..moveTo(14, 16)
          ..quadraticBezierTo(10, 52, 50, 58)
          ..quadraticBezierTo(90, 52, 86, 16);
        canvas.drawPath(bolsa, traco);
        canvas.drawLine(const Offset(18, 50), const Offset(82, 50), fino);
        for (final p in [
          const Offset(40, 34),
          const Offset(54, 30),
          const Offset(48, 42),
          const Offset(62, 40),
        ]) {
          canvas.drawCircle(p, 2.2, cheio);
        }

      case Metodo.armadilha:
        // covo: gaiola com boca em funil e boia na linha
        final gaiola = Path()
          ..moveTo(18, 58)
          ..lineTo(26, 24)
          ..lineTo(80, 24)
          ..lineTo(88, 58)
          ..close();
        canvas.drawPath(gaiola, traco);
        for (var i = 1; i < 4; i++) {
          final t = i / 4;
          canvas.drawLine(Offset(26 + 54 * t, 24), Offset(18 + 70 * t, 58), fino);
        }
        canvas.drawLine(const Offset(23, 38), const Offset(84, 38), fino);
        // boca em funil
        canvas.drawLine(const Offset(26, 30), const Offset(42, 40), traco);
        canvas.drawLine(const Offset(26, 46), const Offset(42, 40), traco);
        // cabo e boia
        canvas.drawLine(const Offset(53, 24), const Offset(53, 12), fino);
        canvas.drawCircle(const Offset(53, 9), 3.4, cheio);

      case Metodo.outros:
        // puçá: aro, saco de malha e cabo
        canvas.drawOval(Rect.fromLTRB(24, 14, 80, 28), traco);
        final saco = Path()
          ..moveTo(26, 22)
          ..quadraticBezierTo(34, 56, 52, 58)
          ..quadraticBezierTo(70, 56, 78, 22);
        canvas.drawPath(saco, traco);
        for (var i = 1; i < 4; i++) {
          final x = 26.0 + i * 13;
          canvas.drawLine(Offset(x, 24), Offset(x + 4, 52), fino);
        }
        canvas.drawLine(const Offset(28, 26), const Offset(74, 44), fino);
        canvas.drawLine(const Offset(24, 21), const Offset(6, 40), traco);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(PetrechoPainter antigo) =>
      antigo.metodo != metodo || antigo.cor != cor;
}

/// O esquema do apetrecho já embrulhado num quadrado, do jeito que
/// aparece nos cartões e no cabeçalho das telas.
class Glifo extends StatelessWidget {
  final Metodo metodo;
  final double largura;
  final Color? cor;

  const Glifo({super.key, required this.metodo, this.largura = 64, this.cor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: largura,
      height: largura * 0.7,
      child: CustomPaint(
        painter: PetrechoPainter(metodo: metodo, cor: cor ?? corMar),
      ),
    );
  }
}
