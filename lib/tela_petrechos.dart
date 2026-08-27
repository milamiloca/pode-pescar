import 'package:flutter/material.dart';
import 'dados.dart';
import 'desenhos.dart';
import 'tema.dart';

const _fonteNorma =
    'Instrução Normativa MPA/MMA nº 10, de 10 de junho de 2011';
const _fonteDetalhe = 'Anexos publicados no Diário Oficial em 07/11/2011. '
    'Alterada pela IN MPA nº 14/2014, pela IN MPA/MMA nº 01/2015 e pela '
    'Portaria Interministerial nº 24/2018, que incluiu a modalidade '
    'emalhe anilhado no Anexo II. Essa modalidade ainda não consta desta '
    'lista.';

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
                    const Text('Que apetrecho posso usar?',
                        style: estiloTitulo),
                    const SizedBox(height: 6),
                    const Text(
                      'Cada modalidade tem apetrecho, peixe e área próprios. '
                      'Procure pelo nome que você usa.',
                      style: estiloCorpo,
                    ),
                    const SizedBox(height: 16),
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
            'Não achei nada com esse nome.\n\nTente uma palavra só, ou '
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
              const TituloSecao('O peixe que você pode pegar'),
              const SizedBox(height: 4),
              TextoDobravel(titulo: 'Espécie-alvo', texto: m.alvo),
              const SizedBox(height: 14),
              const TituloSecao('Onde pode operar'),
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
                  'O que você também pode pescar com autorização à parte, '
                  'inclusive no defeso da espécie principal.',
                  style: estiloCorpo,
                ),
                const SizedBox(height: 8),
                TextoDobravel(
                    titulo: 'Espécies alternativas', texto: m.complementar),
              ],
              if (m.incidental.isNotEmpty || m.acompanhante.isNotEmpty) ...[
                const SizedBox(height: 14),
                const TituloSecao('O que vem junto'),
                const SizedBox(height: 2),
                const Text(
                  'A norma já prevê o que costuma cair na rede sem ser o alvo. '
                  'Vale conhecer: muita espécie dessa lista é protegida.',
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
