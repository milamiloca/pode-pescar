import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dados.dart';
import 'tema.dart';

// =====================================================================
// O ENQUADRAMENTO
//
// Abre a partir da ficha da espécie, já sabendo de qual se trata.
// Monta o texto com a norma, o dispositivo e os valores apurados — o
// excesso em quilos quando é caso de tolerância, os artigos da
// Portaria 1.666 quando é espécie ameaçada.
//
// O texto vai para a área de transferência. Nada é enviado.
// =====================================================================

// =====================================================================
// O ENQUADRAMENTO
// =====================================================================

class TelaEnquadramento extends StatefulWidget {
  final Especie especie;
  const TelaEnquadramento({super.key, required this.especie});

  @override
  State<TelaEnquadramento> createState() => _TelaEnquadramentoState();
}

class _TelaEnquadramentoState extends State<TelaEnquadramento> {
  double? pesoTotal;
  double? pesoAbaixo;
  bool copiado = false;

  double? _num(String t) {
    final s = t.replaceAll(',', '.').trim();
    return s.isEmpty ? null : double.tryParse(s);
  }

  String _n(double v) =>
      v.toStringAsFixed(v == v.roundToDouble() ? 0 : 1).replaceAll('.', ',');

  String _carimbo() {
    final d = DateTime.now();
    String dd(int n) => n < 10 ? '0$n' : '$n';
    return '${dd(d.day)}/${dd(d.month)}/${d.year} às ${dd(d.hour)}:${dd(d.minute)}';
  }

  /// Quilos de exemplares abaixo da medida que excedem a tolerância.
  double get excesso {
    if (pesoTotal == null || pesoAbaixo == null) return 0;
    final t = widget.especie.tolerancia / 100;
    final x = (pesoAbaixo! - t * pesoTotal!) / (1 - t);
    return x < 0 ? 0 : x;
  }

  double get porcento => (pesoTotal == null || pesoAbaixo == null || pesoTotal == 0)
      ? 0
      : (pesoAbaixo! / pesoTotal!) * 100;

  bool get temPesos =>
      pesoTotal != null &&
      pesoAbaixo != null &&
      pesoTotal! > 0 &&
      pesoAbaixo! >= 0 &&
      pesoAbaixo! <= pesoTotal!;

  String _texto() {
    final e = widget.especie;
    final b = StringBuffer();

    if (e.ameacada) {
      b.writeln('ESPÉCIE AMEAÇADA DE EXTINÇÃO — ${_carimbo()}');
      b.writeln('');
      b.writeln('Espécie: ${e.nome} (${e.cientifico})');
      b.writeln('Categoria de risco: ${e.categoriaPorExtenso} (${e.ameaca})');
      b.writeln('Item ${e.itemLista} da Lista Nacional Oficial de Espécies '
          'da Fauna Ameaçadas de Extinção — Peixes e Invertebrados Aquáticos');
      b.writeln('Norma: Portaria GM/MMA nº 1.667, de 27/04/2026 (lista), '
          'e Portaria GM/MMA nº 1.666, de 27/04/2026 (regras)');
      b.writeln('');
      if (e.proibidaHoje) {
        b.writeln('SITUAÇÃO: captura proibida.');
        b.writeln('Art. 3º da Portaria nº 1.666: proteção integral, com '
            'proibição de captura, transporte, armazenamento, guarda, '
            'manejo, beneficiamento e comercialização.');
      } else {
        b.writeln('SITUAÇÃO: proibição ainda não vigente.');
        b.writeln('A espécie não constava da Portaria MMA nº 445/2014. '
            'Pelo art. 12 da Portaria nº 1.666, a proibição do art. 3º '
            'passa a valer em 25/10/2026.');
        b.writeln('Até essa data aplica-se o tamanho mínimo de '
            '${e.tamanho} cm da IN MMA nº 53/2005.');
      }
      b.writeln('');
      b.writeln('Exceção — art. 3º, § 4º da Portaria nº 1.666: as '
          'restrições não se aplicam a exemplares capturados '
          'incidentalmente, desde que liberados vivos ou descartados no '
          'ato da captura, com registro da captura e da liberação.');
      b.writeln('');
      b.writeln('Penalidades: Lei nº 5.197/1967 e Lei nº 9.605/1998.');
    }

    if (temPesos) {
      if (e.ameacada) {
        b.writeln('');
        b.writeln('---');
        b.writeln('');
      }
      b.writeln('TAMANHO MÍNIMO E TOLERÂNCIA — ${_carimbo()}');
      b.writeln('');
      b.writeln('Espécie: ${e.nome} (${e.cientifico})');
      b.writeln('Tamanho mínimo: ${e.tamanho} cm '
          '(${e.furcal ? "comprimento furcal" : "comprimento total"}), '
          'Anexo ${e.anexo == 1 ? "I" : "II"} da IN MMA nº 53/2005');
      b.writeln('Peso total da captura: ${_n(pesoTotal!)} kg');
      b.writeln('Peso abaixo do tamanho mínimo: ${_n(pesoAbaixo!)} kg');
      b.writeln('Percentual: ${_n(porcento)}%');
      b.writeln('Tolerância admitida: ${e.tolerancia}% em peso sobre o '
          'total da captura (art. 4º da IN MMA nº 53/2005)');
      b.writeln('');
      if (porcento <= e.tolerancia) {
        b.writeln('RESULTADO: dentro da tolerância.');
      } else {
        b.writeln('RESULTADO: excede a tolerância.');
        b.writeln('Excesso: ${_n(excesso)} kg de exemplares abaixo do '
            'tamanho mínimo.');
      }
    }

    b.writeln('');
    b.writeln('Gerado pelo aplicativo Consulta Pesqueira a partir do texto '
        'das normas. Confira sempre a norma oficial e a vigência.');
    return b.toString();
  }

  Future<void> _copiar() async {
    await Clipboard.setData(ClipboardData(text: _texto()));
    if (!mounted) return;
    setState(() => copiado = true);
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.especie;
    return Scaffold(
      appBar: AppBar(title: const Text('Enquadramento')),
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
              const SizedBox(height: 18),

              if (e.proibidaHoje)
                _Faixa(
                  cor: corNaoPode,
                  etiqueta: 'CAPTURA PROIBIDA',
                  titulo: 'Art. 3º da Portaria 1.666',
                  detalhe: 'Proteção integral: captura, transporte, '
                      'armazenamento, guarda, manejo, beneficiamento e '
                      'comercialização. ${e.categoriaPorExtenso} (${e.ameaca}), '
                      'item ${e.itemLista} da Lista.',
                )
              else if (e.proibidaDepois)
                _Faixa(
                  cor: corBoia,
                  etiqueta: 'PROIBIÇÃO A PARTIR DE 25/10/2026',
                  titulo: 'Art. 12 da Portaria 1.666',
                  detalhe: 'Não constava da Portaria 445/2014, então tem o '
                      'prazo de 180 dias. Até 24/10/2026 vale o tamanho '
                      'mínimo de ${e.tamanho} cm.',
                ),

              if (e.proibidaHoje) ...[
                const SizedBox(height: 12),
                const _Faixa(
                  cor: corPode,
                  etiqueta: 'A RESTRIÇÃO NÃO SE APLICA QUANDO',
                  titulo: 'Art. 3º, § 4º',
                  detalhe: 'Captura incidental com liberação viva ou '
                      'descarte no ato, com registro da captura e da '
                      'liberação, não está sujeita às restrições.',
                ),
              ],

              const SizedBox(height: 22),
              const TituloSecao('Tolerância na fiscalização'),
              const SizedBox(height: 2),
              Text(
                e.toleranciaEmPeso
                    ? 'Anexo ${e.anexo == 1 ? "I" : "II"} da IN 53: '
                        'tolerância de ${e.tolerancia}% EM PESO sobre o '
                        'total da captura.'
                    : 'Art. 2º da Portaria IBAMA nº 25-N/1993: tolerância '
                        'de ${e.tolerancia}% EM NÚMERO DE INDIVÍDUOS sobre '
                        'o total capturado DESTA espécie — não é '
                        'percentual em peso. Passando disso, o parágrafo '
                        'único manda apreender TODO o pescado. Esta tela '
                        'calcula por peso: para esta espécie ela não '
                        'responde, conte os indivíduos.',
                style: estiloCorpo,
              ),
              const SizedBox(height: 16),
              _Campo(
                rotulo: 'Peso total da captura',
                aoMudar: (t) => setState(() {
                  pesoTotal = _num(t);
                  copiado = false;
                }),
              ),
              const SizedBox(height: 14),
              _Campo(
                rotulo: 'Peso abaixo de ${e.tamanho} cm',
                aoMudar: (t) => setState(() {
                  pesoAbaixo = _num(t);
                  copiado = false;
                }),
              ),
              const SizedBox(height: 18),

              if (temPesos)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: (porcento <= e.tolerancia ? corPode : corNaoPode)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: porcento <= e.tolerancia ? corPode : corNaoPode,
                        width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_n(porcento)}% abaixo da medida',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: porcento <= e.tolerancia
                                  ? corPode
                                  : corNaoPode)),
                      const SizedBox(height: 4),
                      Text(
                        porcento <= e.tolerancia
                            ? 'Dentro do limite de ${e.tolerancia}%.'
                            : 'Excede o limite de ${e.tolerancia}%. '
                                'Excesso: ${_n(excesso)} kg.',
                        style: const TextStyle(
                            fontSize: 15, height: 1.4, color: corApagada),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),
              BotaoGrande(
                texto: copiado ? 'Copiado' : 'Copiar enquadramento',
                icone: copiado ? Icons.check : Icons.copy,
                aoTocar: _copiar,
              ),
              const SizedBox(height: 10),
              const Text(
                'O texto vai para a área de transferência do aparelho, com a '
                'norma, o dispositivo e os valores apurados.',
                style: TextStyle(fontSize: 13, height: 1.4, color: corApagada),
              ),
              const SizedBox(height: 20),
              const Fonte(
                norma: 'IN MMA nº 53/2005 e Portarias GM/MMA nº 1.666 e '
                    '1.667, de 27/04/2026',
                detalhe: 'O enquadramento é montado a partir do texto das '
                    'normas que estão dentro do aplicativo.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Faixa extends StatelessWidget {
  final Color cor;
  final String etiqueta;
  final String titulo;
  final String detalhe;

  const _Faixa({
    required this.cor,
    required this.etiqueta,
    required this.titulo,
    required this.detalhe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(etiqueta,
              style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.3,
                  color: cor)),
          const SizedBox(height: 5),
          Text(titulo,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: corTinta)),
          const SizedBox(height: 5),
          Text(detalhe,
              style: const TextStyle(
                  fontSize: 14, height: 1.4, color: corApagada)),
        ],
      ),
    );
  }
}

class _Campo extends StatelessWidget {
  final String rotulo;
  final ValueChanged<String> aoMudar;

  const _Campo({required this.rotulo, required this.aoMudar});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(rotulo,
            style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
                height: 1.25,
                color: corTinta)),
        const SizedBox(height: 6),
        TextField(
          onChanged: aoMudar,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: '0',
            suffixText: 'kg',
            suffixStyle: const TextStyle(fontSize: 17, color: corApagada),
            filled: true,
            fillColor: corSuperficie,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            border: bordaCampo(),
            enabledBorder: bordaCampo(),
            focusedBorder: bordaCampo(focado: true),
          ),
        ),
      ],
    );
  }
}
