import 'package:flutter/material.dart';
import 'dados.dart';
import 'tema.dart';

const _in53 = 'Instrução Normativa MMA nº 53, de 22 de novembro de 2005';
const _in53d = 'Publicada no Diário Oficial em 24/11/2005.';

// =====================================================================
// TELAS DE APOIO
//
// Duas telas que a ficha da espécie abre: a da captura incidental
// (art. 3º, § 4º da Portaria 1.666) e a do cálculo da tolerância
// (art. 4º da IN 53). Ficam à parte porque cada uma é um procedimento
// inteiro, com entrada de dados e resposta própria.
// =====================================================================

class TelaVeioNaRede extends StatelessWidget {
  /// Só o nome da espécie: esta tela fala do § 4º, que não depende de
  /// tamanho nem de categoria.
  final String nome;
  const TelaVeioNaRede({super.key, required this.nome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Captura incidental')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
            children: [
              Text('Captura incidental', style: estiloTitulo),
              const SizedBox(height: 4),
              Text(nome,
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
                    const Text('A liberação for\nviva e imediata',
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
                titulo: 'Liberação viva ou descarte no ato',
                detalhe: 'No ato da captura, sem manutenção a bordo nem '
                    'acondicionamento em gelo.',
              ),
              const _Regra(
                cor: corPode,
                titulo: 'Registre',
                detalhe: 'A captura e a devolução precisam ser registradas, '
                    'conforme regulamentação específica.',
              ),
              const _Regra(
                cor: corNaoPode,
                titulo: 'Retenção configura captura',
                detalhe: 'A guarda a bordo, o desembarque e a '
                    'comercialização configuram captura, sujeitas às '
                    'penalidades da Lei nº 9.605/1998.',
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
      appBar: AppBar(title: const Text('Cálculo da tolerância')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
            children: [
              Text(e.nome, style: estiloSubtitulo),
              const SizedBox(height: 4),
              Text('O limite para esta espécie é ${e.tolerancia}% em peso.',
                  style: estiloCorpo),
              const SizedBox(height: 24),
              _CampoPeso(
                pergunta: 'Peso total da captura, em quilos',
                aoMudar: (t) => setState(() => pesoTotal = _lerNumero(t)),
              ),
              const SizedBox(height: 18),
              _CampoPeso(
                pergunta:
                    'Peso dos exemplares abaixo de ${e.tamanho} cm, em quilos',
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
                    'Informe os dois pesos acima.',
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
                        'da captura está abaixo da medida.',
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
              const TituloSecao('Alcance da tolerância'),
              const Text(
                'A margem cobre o que a seletividade do petrecho não '
                'evita. Não autoriza a captura dirigida a exemplares '
                'abaixo da medida.',
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
