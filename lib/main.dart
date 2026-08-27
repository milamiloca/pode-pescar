import 'package:flutter/material.dart';
import 'dados.dart';
import 'desenhos.dart';
import 'tela_ameacadas.dart';
import 'tela_fiscal.dart';
import 'tela_petrechos.dart';
import 'tela_tamanho.dart';
import 'tema.dart';

// A conferência de desembarque existe em conferencia.dart e
// tela_conferencia.dart, mas saiu da tela inicial. Ficou guardada
// caso o caderno de bordo volte a fazer sentido.

void main() => runApp(const PodePescarApp());

class PodePescarApp extends StatelessWidget {
  const PodePescarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pode Pescar?',
      debugShowCheckedModeBanner: false,
      theme: montarTema(),
      home: const TelaInicial(),
    );
  }
}

// =====================================================================
// TELA INICIAL
//
// A faixa escura no topo é o bloco de título de uma carta náutica:
// nome, área coberta, e uma linha fina fechando. Embaixo, no claro,
// as perguntas que o app responde.
// =====================================================================

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Cabecalho(),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 24, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Porta(
                        titulo: 'Que tamanho pode pescar?',
                        detalhe:
                            'O tamanho mínimo de 35 espécies, como medir cada '
                            'um, e a conta da tolerância.',
                        norma: 'IN MMA 53/2005',
                        destino: _Destino.tamanho,
                      ),
                      SizedBox(height: 14),
                      _Porta(
                        titulo: 'Que apetrecho posso usar?',
                        detalhe:
                            'As 67 modalidades de permissão: apetrecho, peixe '
                            'e área de cada uma.',
                        norma: 'IN MPA/MMA 10/2011',
                        destino: _Destino.petrecho,
                      ),
                      SizedBox(height: 14),
                      _Porta(
                        titulo: 'Está na lista de ameaçadas?',
                        detalhe:
                            'As 490 espécies da Lista Nacional Oficial, por '
                            'nome científico, família ou ordem.',
                        norma: 'Portaria MMA 1.667/2026',
                        destino: _Destino.ameacadas,
                      ),
                      SizedBox(height: 14),
                      _Porta(
                        titulo: 'Para a fiscalização',
                        detalhe:
                            'Monta o enquadramento com a norma, o artigo e '
                            'os números, pronto para copiar.',
                        norma: 'enquadramento',
                        destino: _Destino.fiscal,
                      ),
                      SizedBox(height: 26),
                      _Promessa(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Cabecalho extends StatelessWidget {
  const _Cabecalho();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: corProfundo,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LITORAL DE SANTA CATARINA',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.2,
              color: Color(0xFF7FB3BF),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Pode\nPescar?',
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.bold,
              height: 1.02,
              letterSpacing: -1.2,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: const Color(0xFF23505C)),
          const SizedBox(height: 14),
          const Text(
            'As regras da pesca em palavra de todo dia, e sempre com a '
            'norma de onde ela saiu.',
            style: TextStyle(
              fontSize: 15,
              height: 1.45,
              color: Color(0xFFB9D2D8),
            ),
          ),
        ],
      ),
    );
  }
}

enum _Destino { tamanho, petrecho, ameacadas, fiscal }

class _Porta extends StatelessWidget {
  final String titulo;
  final String detalhe;
  final String norma;
  final _Destino destino;

  const _Porta({
    required this.titulo,
    required this.detalhe,
    required this.norma,
    required this.destino,
  });

  Widget _visual() {
    switch (destino) {
      case _Destino.tamanho:
        return const SizedBox(
          width: 108,
          height: 48,
          child: CustomPaint(
            painter: PeixePainter(
              forma: Forma.comum,
              cor: Color(0xFF9DB2BA),
              mostrarMedida: true,
            ),
          ),
        );
      case _Destino.petrecho:
        return const Glifo(metodo: Metodo.emalhe, largura: 80);
      case _Destino.ameacadas:
        return const SizedBox(
          width: 108,
          height: 48,
          child: CustomPaint(
            painter: PeixePainter(forma: Forma.tubarao, cor: corNaoPode),
          ),
        );
      case _Destino.fiscal:
        return const Icon(Icons.gavel, size: 44, color: corMar);
    }
  }

  Widget _tela() {
    switch (destino) {
      case _Destino.tamanho:
        return const TelaTamanhos();
      case _Destino.petrecho:
        return const TelaPetrechos();
      case _Destino.ameacadas:
        return const TelaAmeacadas();
      case _Destino.fiscal:
        return const TelaFiscal();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Cartao(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      aoTocar: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => _tela()),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 56,
            child: Align(alignment: Alignment.centerLeft, child: _visual()),
          ),
          const SizedBox(height: 10),
          Text(titulo,
              style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  height: 1.15,
                  color: corTinta)),
          const SizedBox(height: 6),
          Text(detalhe,
              style: const TextStyle(
                  fontSize: 15, height: 1.4, color: corApagada)),
          const SizedBox(height: 12),
          Row(
            children: [
              Selo(norma, cor: corMar),
              const Spacer(),
              const Icon(Icons.arrow_forward, size: 20, color: corMar),
            ],
          ),
        ],
      ),
    );
  }
}

class _Promessa extends StatelessWidget {
  const _Promessa();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: corSuperficie,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: corBorda),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ESTE APP NÃO ENVIA NADA', style: estiloEtiqueta),
          SizedBox(height: 8),
          Text(
            'Funciona sem internet. Não pede cadastro, não pede CPF e não '
            'sabe onde você está. Tudo fica guardado só no seu celular.',
            style: TextStyle(fontSize: 15, height: 1.45, color: corTinta),
          ),
          SizedBox(height: 12),
          Text(
            'As normas aqui dentro são de 2005, 2011, 2018 e 2026, e podem '
            'ter mudado. Este app não substitui a norma.',
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: corApagada,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
