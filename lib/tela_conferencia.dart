import 'package:flutter/material.dart';
import 'conferencia.dart';
import 'dados.dart';
import 'tema.dart';

const _fonte = 'IN MMA nº 53/2005 (tamanho e tolerância) e '
    'IN MPA/MMA nº 10/2011 (modalidade)';
const _fonteDetalhe = 'A conferência usa as duas normas que estão dentro '
    'do aplicativo.';

// =====================================================================
// AS TRÊS PERGUNTAS
// =====================================================================

class TelaConferencia extends StatefulWidget {
  const TelaConferencia({super.key});

  @override
  State<TelaConferencia> createState() => _TelaConferenciaState();
}

class _TelaConferenciaState extends State<TelaConferencia> {
  int passo = 0; // 0, 1, 2
  String? especieEscolhida;
  double? pesoTotal;
  double? pesoPequeno;
  final Set<String> marcados = {};

  double? _lerNumero(String texto) {
    final limpo = texto.replaceAll(',', '.').trim();
    if (limpo.isEmpty) return null;
    return double.tryParse(limpo);
  }

  Especie? get especie =>
      especieEscolhida == null ? null : acharEspecie(especieEscolhida!);

  bool get podeAvancar {
    if (passo == 0) return especieEscolhida != null;
    if (passo == 1) {
      return pesoTotal != null &&
          pesoPequeno != null &&
          pesoTotal! > 0 &&
          pesoPequeno! >= 0 &&
          pesoPequeno! <= pesoTotal!;
    }
    return true;
  }

  void _avancar() {
    if (!podeAvancar) return;
    if (passo < 2) {
      setState(() => passo++);
      return;
    }
    final e = especie;
    if (e == null) return;
    final conferencia = Conferencia(
      quando: DateTime.now(),
      especie: e.nome,
      tamanhoMinimo: e.tamanho,
      tolerancia: e.tolerancia,
      pesoTotal: pesoTotal!,
      pesoPequeno: pesoPequeno!,
      faltando: itensDeBordo.where((i) => !marcados.contains(i)).toList(),
    );
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => TelaResultado(conferencia: conferencia),
    ));
  }

  void _voltar() {
    if (passo == 0) {
      Navigator.of(context).pop();
    } else {
      setState(() => passo--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _voltar,
        ),
        title: Text('Pergunta ${passo + 1} de 3'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: (passo + 1) / 3,
                    minHeight: 5,
                    backgroundColor: corBorda,
                    valueColor: const AlwaysStoppedAnimation(corMar),
                  ),
                ),
              ),
              Expanded(child: _conteudo()),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: BotaoGrande(
                  texto: passo < 2 ? 'Continuar' : 'Conferir',
                  aoTocar: _avancar,
                  desligado: !podeAvancar,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _conteudo() {
    switch (passo) {
      case 0:
        return _passoEspecie();
      case 1:
        return _passoPesos();
      default:
        return _passoItens();
    }
  }

  // ---------- pergunta 1 ----------

  Widget _passoEspecie() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      children: [
        const Text('Que peixe está no barco?', style: estiloTitulo),
        const SizedBox(height: 6),
        const Text(
          'Uma espécie por conferência. Se tiver mais de uma, faça uma '
          'conferência para cada.',
          style: estiloCorpo,
        ),
        const SizedBox(height: 18),
        for (final nome in especiesComuns)
          _Opcao(
            titulo: nome,
            detalhe: acharEspecie(nome) == null
                ? ''
                : 'mínimo ${acharEspecie(nome)!.tamanho} cm',
            marcado: especieEscolhida == nome,
            redondo: true,
            aoTocar: () => setState(() => especieEscolhida = nome),
          ),
      ],
    );
  }

  // ---------- pergunta 2 ----------

  Widget _passoPesos() {
    final e = especie!;
    final temTudo = pesoTotal != null &&
        pesoPequeno != null &&
        pesoTotal! > 0 &&
        pesoPequeno! >= 0;
    final excede = pesoPequeno != null &&
        pesoTotal != null &&
        pesoPequeno! > pesoTotal!;
    final porcento =
        temTudo && !excede ? (pesoPequeno! / pesoTotal!) * 100 : 0.0;
    final dentro = porcento <= e.tolerancia;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      children: [
        Text('Quanto de ${e.nome.toLowerCase()} você pegou?',
            style: estiloTitulo),
        const SizedBox(height: 6),
        const Text('Por cima está bom. Não precisa ser exato.',
            style: estiloCorpo),
        const SizedBox(height: 20),
        _CampoPeso(
          rotulo: 'No total',
          dica: 'tudo que está no porão',
          aoMudar: (t) => setState(() => pesoTotal = _lerNumero(t)),
        ),
        const SizedBox(height: 16),
        _CampoPeso(
          rotulo: 'Desses, quanto está menor que ${e.tamanho} cm',
          dica: 'o peixe que não bateu a medida',
          aoMudar: (t) => setState(() => pesoPequeno = _lerNumero(t)),
        ),
        const SizedBox(height: 18),
        if (excede)
          _Aviso(
            cor: corNaoPode,
            titulo: 'O peixe pequeno não pode pesar mais que o total',
            detalhe: 'Confira os dois números.',
          )
        else if (temTudo)
          _Aviso(
            cor: dentro ? corPode : corNaoPode,
            titulo:
                '${numeroBonito(porcento)}% abaixo da medida',
            detalhe: dentro
                ? 'o limite para ${e.nome.toLowerCase()} é ${e.tolerancia}%'
                : 'o limite para ${e.nome.toLowerCase()} é ${e.tolerancia}%, '
                    'você passou',
          ),
      ],
    );
  }

  // ---------- pergunta 3 ----------

  Widget _passoItens() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      children: [
        const Text('O que está com você?', style: estiloTitulo),
        const SizedBox(height: 6),
        const Text('Marque só o que estiver a bordo agora.',
            style: estiloCorpo),
        const SizedBox(height: 18),
        for (final item in itensDeBordo)
          _Opcao(
            titulo: item,
            detalhe: '',
            marcado: marcados.contains(item),
            redondo: false,
            aoTocar: () => setState(() {
              if (marcados.contains(item)) {
                marcados.remove(item);
              } else {
                marcados.add(item);
              }
            }),
          ),
      ],
    );
  }
}

// =====================================================================
// O RESULTADO
// =====================================================================

class TelaResultado extends StatefulWidget {
  final Conferencia conferencia;
  const TelaResultado({super.key, required this.conferencia});

  @override
  State<TelaResultado> createState() => _TelaResultadoState();
}

class _TelaResultadoState extends State<TelaResultado> {
  bool guardado = false;
  bool guardando = false;

  Future<void> _guardar() async {
    setState(() => guardando = true);
    await guardarConferencia(widget.conferencia);
    if (!mounted) return;
    setState(() {
      guardando = false;
      guardado = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.conferencia;
    final certo = c.tudoCerto;
    final n = c.quantosProblemas;

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: certo
                      ? corPode.withValues(alpha: 0.12)
                      : corNaoPode.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: certo ? corPode : corNaoPode,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      certo ? Icons.check_circle : Icons.error,
                      color: certo ? corPode : corNaoPode,
                      size: 38,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        certo
                            ? 'Está tudo em ordem'
                            : n == 1
                                ? 'Tem um problema'
                                : 'Tem $n problemas',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          height: 1.15,
                          color: certo ? corPode : corNaoPode,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              if (!c.dentroDaTolerancia)
                _Item(
                  ok: false,
                  titulo: 'Passou da tolerância',
                  detalhe: '${numeroBonito(c.porcento)}% da sua '
                      '${c.especie.toLowerCase()} está abaixo de '
                      '${c.tamanhoMinimo} cm. O limite é ${c.tolerancia}%. '
                      'Separe ${numeroBonito(c.kgParaSeparar)} kg de peixe '
                      'pequeno e você fica dentro.',
                )
              else
                _Item(
                  ok: true,
                  titulo: 'Dentro da tolerância',
                  detalhe: '${numeroBonito(c.porcento)}% abaixo da medida, '
                      'e o limite é ${c.tolerancia}%.',
                ),

              for (final item in c.faltando)
                _Item(ok: false, titulo: 'Falta: $item', detalhe: ''),

              for (final item in itensDeBordo.where(
                  (i) => !c.faltando.contains(i)))
                _Item(ok: true, titulo: item, detalhe: ''),

              const SizedBox(height: 20),
              const Fonte(norma: _fonte, detalhe: _fonteDetalhe),
              const SizedBox(height: 8),
              const _NotaDefeso(),
              const SizedBox(height: 18),

              if (guardado)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: corSuperficie,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: corBorda),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check, color: corPode),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Guardado no seu celular.',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                )
              else
                BotaoGrande(
                  texto: guardando ? 'Guardando…' : 'Guardar no histórico',
                  aoTocar: guardando ? () {} : _guardar,
                  desligado: guardando,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotaDefeso extends StatelessWidget {
  const _NotaDefeso();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: corBoia.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 20, color: corBoia),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Esta conferência não olha defeso. As datas de defeso mudam '
              'várias vezes por ano — consulte a norma nos sites oficiais '
              'antes de aplicar.',
              style: TextStyle(fontSize: 13, height: 1.4, color: corApagada),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// O HISTÓRICO
// =====================================================================

class TelaHistorico extends StatefulWidget {
  const TelaHistorico({super.key});

  @override
  State<TelaHistorico> createState() => _TelaHistoricoState();
}

class _TelaHistoricoState extends State<TelaHistorico> {
  List<Conferencia>? lista;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final l = await lerConferencias();
    if (!mounted) return;
    setState(() => lista = l);
  }

  @override
  Widget build(BuildContext context) {
    final l = lista;
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas conferências')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: l == null
              ? const Center(child: CircularProgressIndicator())
              : l.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(28),
                        child: Text(
                          'Você ainda não guardou nenhuma conferência.\n\n'
                          'Faça uma antes de desembarcar e ela aparece aqui.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 17, color: corApagada, height: 1.45),
                        ),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      children: [
                        const Text('Suas últimas saídas', style: estiloTitulo),
                        const SizedBox(height: 6),
                        const Text('Fica só no seu celular.',
                            style: estiloCorpo),
                        const SizedBox(height: 18),
                        for (final c in l) _LinhaHistorico(c: c),
                      ],
                    ),
        ),
      ),
    );
  }
}

class _LinhaHistorico extends StatelessWidget {
  final Conferencia c;
  const _LinhaHistorico({required this.c});

  @override
  Widget build(BuildContext context) {
    final certo = c.tudoCerto;
    return Cartao(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(dataCurta(c.quando).toUpperCase(),
                  style: estiloEtiqueta),
              const Spacer(),
              Selo(certo ? 'dentro' : 'fora',
                  cor: certo ? corPode : corNaoPode),
            ],
          ),
          const SizedBox(height: 8),
          Text('${c.especie} · ${numeroBonito(c.pesoTotal)} kg',
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w600, color: corTinta)),
          const SizedBox(height: 3),
          Text(
            certo
                ? '${numeroBonito(c.porcento)}% abaixo · tudo em ordem'
                : '${numeroBonito(c.porcento)}% abaixo · '
                    '${c.quantosProblemas} ${c.quantosProblemas == 1 ? "problema" : "problemas"}',
            style: const TextStyle(fontSize: 14, color: corApagada),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// PEDACINHOS
// =====================================================================

class _Opcao extends StatelessWidget {
  final String titulo;
  final String detalhe;
  final bool marcado;
  final bool redondo;
  final VoidCallback aoTocar;

  const _Opcao({
    required this.titulo,
    required this.detalhe,
    required this.marcado,
    required this.redondo,
    required this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: marcado ? corMar.withValues(alpha: 0.08) : corSuperficie,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: marcado ? corMar : corBorda,
          width: marcado ? 2 : 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: aoTocar,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: redondo ? BoxShape.circle : BoxShape.rectangle,
                    borderRadius: redondo ? null : BorderRadius.circular(6),
                    color: marcado ? corMar : Colors.transparent,
                    border: Border.all(
                      color: marcado ? corMar : corBorda,
                      width: 2,
                    ),
                  ),
                  child: marcado
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(titulo,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.25,
                              color: corTinta)),
                      if (detalhe.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(detalhe,
                            style: const TextStyle(
                                fontSize: 13, color: corApagada)),
                      ],
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

class _CampoPeso extends StatelessWidget {
  final String rotulo;
  final String dica;
  final ValueChanged<String> aoMudar;

  const _CampoPeso({
    required this.rotulo,
    required this.dica,
    required this.aoMudar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(rotulo,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.25,
                color: corTinta)),
        const SizedBox(height: 7),
        TextField(
          onChanged: aoMudar,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
        const SizedBox(height: 4),
        Text(dica, style: const TextStyle(fontSize: 13, color: corApagada)),
      ],
    );
  }
}

class _Aviso extends StatelessWidget {
  final Color cor;
  final String titulo;
  final String detalhe;

  const _Aviso({
    required this.cor,
    required this.titulo,
    required this.detalhe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  height: 1.25,
                  color: cor)),
          if (detalhe.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(detalhe,
                style: const TextStyle(
                    fontSize: 14, height: 1.35, color: corApagada)),
          ],
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final bool ok;
  final String titulo;
  final String detalhe;

  const _Item({required this.ok, required this.titulo, required this.detalhe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.cancel,
            color: ok ? corPode : corNaoPode,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: corTinta)),
                if (detalhe.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(detalhe,
                      style: const TextStyle(
                          fontSize: 14, height: 1.4, color: corApagada)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
