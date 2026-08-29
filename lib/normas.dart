import 'areas.dart';
import 'defesos.dart';
import 'periodos.dart';
import 'regimes.dart';

// =====================================================================
// AS NORMAS QUE O APLICATIVO CITA
//
// Esta lista é CALCULADA a partir dos dados — dos defesos, dos períodos
// e dos Planos de Recuperação. Não existe em lugar nenhum uma lista
// escrita à mão que precise ser lembrada.
//
// A razão é prática: a base normativa da tela inicial já foi uma lista
// à mão com cinco linhas, e continuou dizendo cinco enquanto o
// aplicativo passava a citar mais de vinte normas. Uma lista à mão
// envelhece em silêncio. Esta não tem como: acrescentar uma norma a
// qualquer arquivo de dados a faz aparecer aqui.
//
// A ordem é a da hierarquia das normas, não a alfabética nem a
// cronológica. Numa dúvida entre duas normas, a de escalão mais alto
// prevalece — e quem consulta precisa ver isso de relance.
// =====================================================================

/// O escalão da norma, do mais alto para o mais baixo.
enum Escalao {
  lei,
  decreto,
  interministerial,
  ministerio,
  secretaria,
  autarquia,
}

const nomesDeEscalao = <Escalao, String>{
  Escalao.lei: 'Lei',
  Escalao.decreto: 'Decreto',
  Escalao.interministerial: 'Portaria Interministerial',
  Escalao.ministerio: 'Ato de Ministério',
  Escalao.secretaria: 'Ato de Secretaria',
  Escalao.autarquia: 'Ato de autarquia',
};

const explicacaoDeEscalao = <Escalao, String>{
  Escalao.lei: 'Aprovada pelo Congresso e sancionada. Está acima de '
      'todas as demais.',
  Escalao.decreto: 'Do Presidente da República ou do Governador. '
      'Regulamenta a lei.',
  Escalao.interministerial: 'Assinada por dois ou mais ministros. É onde '
      'estão as regras de ordenamento da pesca.',
  Escalao.ministerio: 'Do Ministério do Meio Ambiente ou do Ministério da '
      'Pesca e Aquicultura, isoladamente.',
  Escalao.secretaria: 'De secretaria — a SAP/MAPA e a antiga SEAP da '
      'Presidência.',
  Escalao.autarquia: 'Do IBAMA ou da extinta SUDEPE. São as mais antigas, '
      'e muitas seguem em vigor.',
};

class NormaCitada {
  final String nome;
  final String numero;
  final String ano;
  final Escalao escalao;
  final bool lida;
  final List<String> usos;

  const NormaCitada({
    required this.nome,
    required this.numero,
    required this.ano,
    required this.escalao,
    required this.lida,
    required this.usos,
  });

  /// Como aparece na lista: "nº 24/2018".
  String get identidade => 'nº $numero/$ano';
}

final _numeroEAno = RegExp(
    r'n[º°o]?\s*([\d.]+\s*-?\s*[A-Z]?)[,/ ]+.*?((?:19|20)\d\d)');

/// As portarias da SUDEPE e as antigas do IBAMA vêm com o número colado
/// à letra N — "N-42/1984", "nº N-42, de 18 de outubro de 1984",
/// "nº 70/03-N". A expressão de cima não lê nenhuma delas, porque espera
/// dígito logo depois do "nº". Esta lê as três.
final _sudepe = RegExp(r'N-\s*(\d+)\s*[,/][^.]*?((?:19|20)\d\d)');

Escalao _escalaoDe(String t) {
  if (t.startsWith('Lei')) return Escalao.lei;
  if (t.startsWith('Decreto')) return Escalao.decreto;
  if (t.contains('Interministerial') || t.contains('GM/MMA')) {
    return Escalao.interministerial;
  }
  if (t.contains('IBAMA') || t.contains('SUDEPE')) return Escalao.autarquia;
  if (t.contains('SAP/MAPA') || t.contains('SEAP')) return Escalao.secretaria;
  return Escalao.ministerio;
}

List<NormaCitada>? _cache;

/// Todas as normas citadas, sem repetir, na ordem da hierarquia.
///
/// Duas grafias da mesma norma — "Portaria nº 24/2018" e "Portaria nº 24,
/// de 15 de maio de 2018" — contam como uma só: a chave é o número e o
/// ano, não o texto.
List<NormaCitada> normasCitadas() {
  if (_cache != null) return _cache!;

  final por = <String, _Acumulado>{};

  void juntar(String texto, bool lida, String uso) {
    final base = texto.split(' — ').first.split(', que ').first;
    final m = _numeroEAno.firstMatch(base) ?? _sudepe.firstMatch(base);
    if (m == null) return;
    final numero = m.group(1)!.replaceAll('.', '').replaceAll(' ', '');
    final ano = m.group(2)!;
    final chave = '$numero/$ano';
    final nome = base.trim();
    final a = por.putIfAbsent(
      chave,
      () => _Acumulado(nome, numero, ano, _escalaoDe(base)),
    );
    a.lida = a.lida || lida;
    if (!a.usos.contains(uso)) a.usos.add(uso);
    if (nome.length > a.nome.length) a.nome = nome;
  }

  for (final n in _base) {
    juntar(n[0], true, n[1]);
  }
  for (final d in defesos) {
    juntar(d.norma, d.origem == Origem.conferida, 'defeso: ${d.titulo}');
  }
  for (final p in planos) {
    juntar(p.ordenamento, p.normaObtida, 'plano: ${p.especie}');
    juntar(p.atoDoMMA, p.atoDoMMA.contains('texto obtido'),
        'plano: ${p.especie}');
  }
  for (final p in periodos) {
    juntar(p.norma, p.confirmado, 'calendário: ${p.especie.split(' — ').first}');
  }
  for (final r in restricoes) {
    juntar(r.norma, r.texto == TextoDaNorma.lido, 'área: ${r.titulo}');
  }

  final saida = por.values
      .map((a) => NormaCitada(
            nome: a.nome,
            numero: a.numero,
            ano: a.ano,
            escalao: a.escalao,
            lida: a.lida,
            usos: a.usos,
          ))
      .toList()
    ..sort((a, b) {
      final e = a.escalao.index.compareTo(b.escalao.index);
      if (e != 0) return e;
      final ano = b.ano.compareTo(a.ano);
      if (ano != 0) return ano;
      return a.nome.compareTo(b.nome);
    });

  _cache = saida;
  return saida;
}

/// As que valem para o aplicativo inteiro e não saem de um defeso nem de
/// um Plano. Entram aqui porque não têm outro lugar de onde sair.
const _base = <List<String>>[
  ['Lei nº 11.959, de 29 de junho de 2009',
      'Política Nacional de Pesca: definições e fiscalização'],
  ['Instrução Normativa MMA nº 53, de 22 de novembro de 2005',
      'Tamanho mínimo de captura'],
  ['Instrução Normativa Interministerial MPA/MMA nº 10, de 10 de junho '
      'de 2011', 'As 72 modalidades de permissionamento'],
  ['Portaria GM/MMA nº 1.666, de 27 de abril de 2026',
      'As regras das espécies ameaçadas'],
  ['Portaria GM/MMA nº 1.667, de 27 de abril de 2026',
      'A Lista Nacional Oficial: 490 espécies'],
  ['Portaria MMA nº 445, de 17 de dezembro de 2014',
      'Lista anterior, revogada. Serve de comparação'],
  ['Portaria MMA nº 148, de 7 de junho de 2022',
      'Substituiu o Anexo I da 445/2014'],
  ['Portaria MMA nº 354, de 27 de janeiro de 2023',
      'Acrescentou cinco elasmobrânquios à 148/2022'],
  ['Portaria MMA nº 73, de 26 de março de 2018',
      'Reescreveu o art. 3º da 445/2014: manejo sustentável'],
  ['Portaria SAP/MAPA nº 617, de 8 de março de 2022',
      'Arrasto de praia em SC: modalidades 6.8 a 6.11'],
  ['Portaria SAP/MAPA nº 695, de 27 de abril de 2022',
      'Alterou a 656/2022 dos camarões'],
  ['Portaria SAP/MAPA nº 75, de 3 de abril de 2020',
      'Alterou o art. 3º, V da 24/2018 da tainha'],
  ['Portaria Interministerial MPA/MMA nº 51, de 27 de fevereiro de 2026',
      'Safra 2026 da tainha: cotas e confirmação das datas'],
  ['Portaria Interministerial MPA/MMA nº 63, de 11 de junho de 2026',
      'Alterou a 51/2026'],
  ['Portaria Interministerial MPA/MMA nº 57, de 12 de maio de 2026',
      'Alterou o art. 21 da 24/2018: rastreamento'],
  ['Portaria Interministerial MPA/MMA nº 47, de 14 de janeiro de 2026',
      'Alterou o art. 18 da 656/2022: rastreamento'],
  ['Portaria MPA nº 127, de 29 de agosto de 2023',
      'RGP, Licença de Pescador Profissional e o REAP'],
];

class _Acumulado {
  String nome;
  final String numero;
  final String ano;
  final Escalao escalao;
  bool lida = false;
  final List<String> usos = [];
  _Acumulado(this.nome, this.numero, this.ano, this.escalao);
}

/// Quantas normas o aplicativo cita, e quantas leu por inteiro.
int get quantasNormas => normasCitadas().length;
int get quantasNormasLidas => normasCitadas().where((n) => n.lida).length;
