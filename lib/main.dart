import 'package:flutter/material.dart';
import 'dados.dart';
import 'desenhos.dart';
import 'calendario.dart';
import 'conflitos.dart';
import 'defesos.dart';
import 'areas.dart';
import 'fichas.dart';
import 'normas.dart';
import 'periodos.dart';
import 'regimes.dart';
import 'tela_conflitos.dart';
import 'tela_especies.dart';
import 'tela_areas.dart';
import 'tela_petrechos.dart';
import 'tela_temporadas.dart';
import 'tema.dart';

// A conferência de desembarque existe em conferencia.dart e
// tela_conferencia.dart, mas saiu da tela inicial. Ficou guardada
// caso o caderno de bordo volte a fazer sentido.

void main() => runApp(const ConsultaPesqueiraApp());

class ConsultaPesqueiraApp extends StatelessWidget {
  const ConsultaPesqueiraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta Pesqueira',
      debugShowCheckedModeBanner: false,
      theme: montarTema(),
      home: const TelaInicial(),
    );
  }
}

// =====================================================================
// TELA INICIAL
//
// O topo é um bloco de identificação: fiadas finas em cima e embaixo
// do nome, como o cabeçalho de um documento de serviço ou o quadro de
// título de uma carta náutica.
//
// Os números de espécies e modalidades saem das listas, nunca escritos
// à mão: já aconteceu de a tela dizer 34 quando o app tinha 35.
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Cabecalho(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AvisoDeHoje(
                        aoTocar: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const TelaTemporadas()),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _Porta(
                        titulo: 'Espécies',
                        detalhe: 'As ${fichas.length} espécies com regra: '
                            'tamanho mínimo, ameaça de extinção, defeso, '
                            'área proibida, petrecho e Plano de '
                            'Recuperação.',
                        norma: 'IN 53 · Portaria 25-N · Portarias 1.666 e '
                            '1.667 · Planos de Recuperação · Portaria 532',
                        destino: _Destino.especies,
                      ),
                      const SizedBox(height: 12),
                      _Porta(
                        titulo: 'Petrechos e modalidades',
                        detalhe: 'As ${modalidades.length} modalidades de '
                            'permissionamento: petrecho, espécies-alvo e '
                            'área de operação.',
                        norma: 'IN MPA/MMA 10/2011',
                        destino: _Destino.petrecho,
                      ),
                      const SizedBox(height: 12),
                      _Porta(
                        titulo: 'Defesos e temporadas',
                        detalhe: 'As ${defesos.length} regras de período '
                            'fechado: tainha, camarões, enchova, bagre, '
                            'sardinha, garoupa, caranguejo e outras.',
                        norma: 'defeso por espécie',
                        destino: _Destino.temporadas,
                      ),
                      const SizedBox(height: 12),
                      _Porta(
                        titulo: 'Onde não pode',
                        detalhe: 'As $quantasRestricoes regras que não '
                            'dependem da espécie: baía, estuário, distância '
                            'da costa, petrecho e porte da embarcação.',
                        norma: 'área e petrecho em SC',
                        destino: _Destino.areas,
                      ),
                      const SizedBox(height: 26),
                      const _BaseNormativa(),
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
    const fio = Color(0xFF23505C);
    return Container(
      color: corProfundo,
      padding: const EdgeInsets.fromLTRB(20, 54, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FISCALIZAÇÃO DA PESCA  ·  SANTA CATARINA',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.0,
              color: Color(0xFF7FB3BF),
            ),
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: fio),
          const SizedBox(height: 18),
          const Text(
            'Consulta\nPesqueira',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              height: 1.05,
              letterSpacing: -1.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 18),
          Container(height: 1, color: fio),
          const SizedBox(height: 14),
          const Text(
            'Tamanho mínimo, defeso, espécie ameaçada e área proibida '
            'em Santa Catarina.',
            style: TextStyle(
              fontSize: 14.5,
              height: 1.5,
              color: Color(0xFFB9D2D8),
            ),
          ),
        ],
      ),
    );
  }
}

enum _Destino { especies, petrecho, temporadas, areas }

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
      case _Destino.especies:
        return const SizedBox(
          width: 96,
          height: 42,
          child: CustomPaint(
            painter: PeixePainter(
              forma: Forma.comum,
              cor: Color(0xFF9DB2BA),
              mostrarMedida: true,
            ),
          ),
        );
      case _Destino.petrecho:
        return const Glifo(metodo: Metodo.emalhe, largura: 72);
      case _Destino.temporadas:
        return const Icon(Icons.schedule, size: 36, color: corBoia);
      case _Destino.areas:
        return const Icon(Icons.map_outlined, size: 36, color: corBoia);
    }
  }

  Widget _tela() {
    switch (destino) {
      case _Destino.especies:
        return const TelaEspecies();
      case _Destino.petrecho:
        return const TelaPetrechos();
      case _Destino.temporadas:
        return const TelaTemporadas();
      case _Destino.areas:
        return const TelaAreas();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Cartao(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      aoTocar: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => _tela()),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 46,
            child: Align(alignment: Alignment.centerLeft, child: _visual()),
          ),
          const SizedBox(height: 20),
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.2,
              color: corTinta,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            detalhe,
            style: const TextStyle(
                fontSize: 14.5, height: 1.45, color: corApagada),
          ),
          const SizedBox(height: 12),
          const Regua(),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  norma.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: corMar,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward, size: 19, color: corMar),
            ],
          ),
        ],
      ),
    );
  }
}

/// O caminho para os pontos em verificação. Fica no pé da base
/// normativa porque é parte dela: o que o aplicativo ainda não pôde
/// confirmar é tão parte da base quanto o que ele confirmou.
class _EmVerificacao extends StatelessWidget {
  const _EmVerificacao();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const TelaConflitos()),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 9),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    color: corBoia, shape: BoxShape.circle),
              ),
              Expanded(
                child: Text(
                  '${conflitos.length} pontos em verificação',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: corBoia,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward, size: 18, color: corBoia),
            ],
          ),
        ),
      ),
    );
  }
}

/// O que está dentro do aplicativo, com data. Quem vai usar isso em
/// serviço precisa saber qual é a base, e de quando ela é, antes de
/// confiar na resposta.
class _BaseNormativa extends StatelessWidget {
  const _BaseNormativa();

  /// As cinco normas de base, que valem para o aplicativo inteiro. As
  /// demais saem dos dados — ver [_outras] — para que a lista nunca
  /// fique menor que o que o aplicativo de fato cita. Já aconteceu de a
  /// tela mostrar cinco normas quando o app usava vinte.
  static const _normas = <List<String>>[
    ['IN MMA nº 53, de 22/11/2005', 'Tamanho mínimo de captura'],
    ['IN MPA/MMA nº 10, de 10/06/2011', 'Modalidades de permissionamento'],
    ['Lei nº 11.959, de 29/06/2009', 'Política Nacional de Pesca'],
    [
      'Portaria GM/MMA nº 1.666, de 27/04/2026',
      'Regras das espécies ameaçadas'
    ],
    ['Portaria GM/MMA nº 1.667, de 27/04/2026', 'Lista Nacional Oficial'],
  ];


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: corSuperficie,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: corBorda),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('BASE NORMATIVA', style: estiloEtiqueta),
          const SizedBox(height: 12),
          for (final n in _normas) ...[
            Text(
              n[0],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.3,
                color: corTinta,
              ),
            ),
            Text(
              n[1],
              style: const TextStyle(
                  fontSize: 13, height: 1.35, color: corApagada),
            ),
            const SizedBox(height: 10),
          ],
          const Regua(),
          const SizedBox(height: 12),
          const _TodasAsNormas(),
          const SizedBox(height: 12),
          const Regua(),
          const SizedBox(height: 12),
          const Text(
            'Ferramenta de consulta. Não substitui o texto da norma. '
            'Confira a vigência nos sites oficiais antes de aplicar.',
            style: TextStyle(fontSize: 13, height: 1.45, color: corApagada),
          ),
          const SizedBox(height: 10),
          const Regua(),
          const _EmVerificacao(),
        ],
      ),
    );
  }
}


/// Todas as normas que o aplicativo cita, na ordem da hierarquia.
///
/// Fica recolhida por padrão: quem abre o aplicativo quer uma resposta,
/// não uma bibliografia. Mas quem precisa montar um enquadramento
/// precisa ver a lista inteira, e ela tem que estar aqui.
///
/// A ordem é a da hierarquia porque numa dúvida entre duas normas é o
/// escalão que decide qual prevalece.
class _TodasAsNormas extends StatefulWidget {
  const _TodasAsNormas();

  @override
  State<_TodasAsNormas> createState() => _TodasAsNormasState();
}

class _TodasAsNormasState extends State<_TodasAsNormas> {
  bool aberta = false;

  @override
  Widget build(BuildContext context) {
    final todas = normasCitadas();
    final lidas = quantasNormasLidas;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => setState(() => aberta = !aberta),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          aberta
                              ? 'Recolher a lista'
                              : 'Ver as ${todas.length} normas',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: corMar,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${todas.length - lidas} ainda por obter, '
                          'em vermelho na lista',
                          style: const TextStyle(
                              fontSize: 12.5, height: 1.35, color: corApagada),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    aberta ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                    color: corMar,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (aberta) ...[
          const SizedBox(height: 4),
          for (final e in Escalao.values)
            if (todas.any((n) => n.escalao == e))
              _GrupoDeEscalao(
                escalao: e,
                normas: todas.where((n) => n.escalao == e).toList(),
              ),
          const SizedBox(height: 8),
          const Text(
            'A lista sai dos dados do aplicativo: toda norma citada em um '
            'defeso, num período do calendário ou num Plano de Recuperação '
            'aparece aqui sozinha.',
            style: TextStyle(fontSize: 12.5, height: 1.45, color: corApagada),
          ),
        ],
      ],
    );
  }
}

class _GrupoDeEscalao extends StatelessWidget {
  final Escalao escalao;
  final List<NormaCitada> normas;

  const _GrupoDeEscalao({required this.escalao, required this.normas});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${nomesDeEscalao[escalao]!.toUpperCase()}  ·  '
                  '${normas.length}',
                  style: estiloEtiqueta,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            explicacaoDeEscalao[escalao]!,
            style: const TextStyle(
                fontSize: 12, height: 1.4, color: corApagada),
          ),
          const SizedBox(height: 9),
          for (final n in normas) _LinhaDeNorma(n: n),
        ],
      ),
    );
  }
}

class _LinhaDeNorma extends StatelessWidget {
  final NormaCitada n;
  const _LinhaDeNorma({required this.n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 9),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: n.lida ? corPode : corNaoPode,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  n.nome,
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.35,
                    fontWeight:
                        n.lida ? FontWeight.normal : FontWeight.w600,
                    color: n.lida ? corTinta : corNaoPode,
                  ),
                ),
                if (n.legenda.isNotEmpty)
                  Text(
                    n.legenda,
                    style: const TextStyle(
                        fontSize: 11.5, height: 1.4, color: corApagada),
                  ),
                if (!n.lida)
                  const Text(
                    'TEXTO AINDA POR OBTER',
                    style: TextStyle(
                      fontSize: 10.5,
                      height: 1.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.7,
                      color: corNaoPode,
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
