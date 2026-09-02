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

  /// Do que a norma trata, em uma linha, para quem lê a lista saber o
  /// que é sem abrir nada.
  ///
  /// Sai dos próprios `usos`: o primeiro é a descrição escrita à mão
  /// quando a norma está na base curada, e nas demais é o lugar do
  /// aplicativo que a cita — "defeso: Tainha", "área: ...". Duas, no
  /// máximo, para a linha não virar parágrafo.
  String get legenda {
    if (usos.isEmpty) return '';
    final ate = usos.length > 2 ? usos.sublist(0, 2) : usos;
    return ate.join(' · ');
  }
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
    // n[2] diz se o TEXTO foi lido. Antes isto era `true` fixo, o que
    // funcionava enquanto a _base só tinha norma lida — e passaria a
    // mentir no instante em que entrasse uma não obtida.
    juntar(n[0], n[2] == 'lida', n[1]);
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
    // revogada conta como lida para o inventário: o texto está em mão.
    // O que ela não é, é norma em vigor — quem diz isso é a ficha.
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
      'Política Nacional de Pesca: definições e fiscalização', 'lida'],
  ['Instrução Normativa MMA nº 53, de 22 de novembro de 2005',
      'Tamanho mínimo de captura de espécies marinhas e estuarinas',
      'lida'],
  ['Portaria IBAMA nº 25-N, de 9 de março de 1993',
      'Tamanho mínimo de 14 espécies de ÁGUA DOCE. O art. 1º nomeia '
      'Santa Catarina. Tolerância de 10% em número de indivíduos, não '
      'em peso', 'lida'],
  ['Instrução Normativa Interministerial MPA/MMA nº 10, de 10 de junho '
      'de 2011', 'As 72 modalidades de permissionamento', 'lida'],
  ['Portaria GM/MMA nº 1.666, de 27 de abril de 2026',
      'As regras das espécies ameaçadas', 'lida'],
  ['Portaria GM/MMA nº 1.667, de 27 de abril de 2026',
      'A Lista Nacional Oficial: 490 espécies', 'lida'],
  ['Portaria MMA nº 445, de 17 de dezembro de 2014',
      'Lista anterior, revogada. Serve de comparação', 'lida'],
  ['Portaria MMA nº 148, de 7 de junho de 2022',
      'Substituiu o Anexo I da 445/2014', 'lida'],
  ['Portaria SAQ nº 009, de 12 de novembro de 2025',
      'ESTADUAL — Santa Catarina. Tamanho mínimo da miraguaia ou '
      'burriquete: 55 cm. Ver o ponto em verificação', 'lida'],
  ['Portaria MMA nº 354, de 27 de janeiro de 2023',
      'Acrescentou cinco elasmobrânquios à 148/2022', 'lida'],
  ['Portaria MMA nº 73, de 26 de março de 2018',
      'Reescreveu o art. 3º da 445/2014: manejo sustentável', 'lida'],
  ['Portaria SAP/MAPA nº 617, de 8 de março de 2022',
      'Arrasto de praia em SC: modalidades 6.8 a 6.11', 'lida'],
  ['Portaria SAP/MAPA nº 695, de 27 de abril de 2022',
      'Alterou a 656/2022 dos camarões', 'lida'],
  ['Portaria SAP/MAPA nº 75, de 3 de abril de 2020',
      'Alterou o art. 3º, V da 24/2018 da tainha', 'lida'],
  ['Portaria Interministerial MPA/MMA nº 51, de 27 de fevereiro de 2026',
      'Safra 2026 da tainha: cotas e confirmação das datas', 'lida'],
  ['Portaria Interministerial MPA/MMA nº 63, de 11 de junho de 2026',
      'Alterou a 51/2026', 'lida'],
  ['Portaria Interministerial MPA/MMA nº 57, de 12 de maio de 2026',
      'Alterou o art. 21 da 24/2018: rastreamento', 'lida'],
  ['Portaria Interministerial MPA/MMA nº 47, de 14 de janeiro de 2026',
      'Alterou o art. 18 da 656/2022: rastreamento', 'lida'],
  ['Portaria MPA nº 127, de 29 de agosto de 2023',
      'RGP, Licença de Pescador Profissional e o REAP', 'lida'],
  // --------------------------------------------------------------
  // Alteram a matriz de modalidades da IN 10/2011, ou disciplinam
  // procedimento que o aplicativo cita. Antes viviam só dentro de um
  // texto corrido e não apareciam na lista.
  // --------------------------------------------------------------
  ['Instrução Normativa Interministerial MPA/MMA nº 01, de 26 de março '
      'de 2015',
      'Altera a IN 10/2011: acrescenta ao art. 5º as definições de fauna '
      'acompanhante e captura incidental, e revoga o art. 11', 'lida'],
  ['Instrução Normativa Interministerial nº 46, de 30 de dezembro de 2015',
      'Dá nova redação ao art. 3º da IN 01/2015, que limita a vigência do '
      'art. 1º dela a 31 de dezembro de 2016', 'lida'],
  ['Instrução Normativa MPA nº 14, de 2014',
      'Altera o Anexo I da IN 10/2011. Texto não obtido; o dia e o mês '
      'não são conhecidos', 'a obter'],
  ['Instrução Normativa Interministerial MPA/MMA nº 04, de 16 de outubro '
      'de 2013',
      'Emalhe costeiro diversificado de anchova, corvina, pescada, '
      'castanha e abrótea. A ementa diz Sudeste e Sul; os artigos dizem '
      'litoral do Rio Grande do Sul', 'lida'],
  ['Portaria Interministerial MPA/MMA nº 19, de 24 de dezembro de 2024',
      'Fecha o registro de embarcação nova nas modalidades 1.2, 1.3, 1.4 '
      'e 1.15 da IN 10/2011. Substituição, transformação e pesquisa '
      'continuam permitidas', 'lida'],
  ['Portaria Interministerial MPA/MMA nº 16, de 18 de dezembro de 2024',
      'Procedimentos para recepção da Declaração de Estoque dos recursos '
      'sujeitos a defeso. Texto não obtido', 'a obter'],
  ['Portaria Interministerial MPA/MMA nº 53, de 12 de março de 2026',
      'Instâncias de Gestão Participativa, citadas pela Portaria GM/MMA '
      'nº 1.742/2026. Texto não obtido', 'a obter'],
  // --------------------------------------------------------------
  // A FILA. Normas que o aplicativo AINDA NÃO CARREGA e que alcançam
  // Santa Catarina. Entram aqui para aparecer em vermelho na lista, e
  // não para serem aplicadas: enquanto o texto não estiver em mão, o
  // aplicativo não reproduz regra nenhuma delas.
  //
  // Todas saem da lista de normas recebida em 02/09/2026, exceto as
  // cinco moratórias, que vieram por mensagem em 01/09/2026 e estão
  // também na página 9 do guia de identificação.
  // --------------------------------------------------------------
  ['Instrução Normativa MMA nº 03, de 2006',
      'Alterou a IN MMA nº 53/2005 em algum ponto que não se sabe qual. '
      'Os 34 tamanhos do Anexo I não parecem ser: o guia da PMA, de '
      '2018, reproduz a mesma tabela deste aplicativo, sem divergir em '
      'nenhuma linha. Dia e mês desconhecidos', 'a obter'],
  ['Instrução Normativa Interministerial MPA/MMA nº 08, de 6 de novembro '
      'de 2014',
      'Moratória do tubarão lombo-preto (Carcharhinus falciformis), que a '
      'matriz de modalidades nomeia como espécie-alvo da 2.1', 'a obter'],
  ['Portaria IBAMA nº 43, de 24 de setembro de 2007',
      'Proíbe a captura de corvina, castanha, pescadinha-real e '
      'pescada-olhuda por cerco de traineira no Sudeste e Sul', 'a obter'],
  ['Instrução Normativa Interministerial MPA/MMA nº 14, de 26 de novembro '
      'de 2012',
      'Desembarque, transporte, armazenamento e comercialização de '
      'tubarões e raias. Altera a Portaria IBAMA nº 121/1998', 'a obter'],
  ['Portaria SAP/MAPA nº 452, de 18 de novembro de 2021',
      'Ordenamento da pesca do polvo no Sudeste e Sul. O aplicativo não '
      'tem ficha de polvo', 'a obter'],
  ['Portaria Interministerial MPA/MMA nº 13, de 2 de outubro de 2015',
      'Moratória do mero (Epinephelus itajara)', 'a obter'],
  ['Portaria Interministerial MPA/MMA nº 14, de 2 de outubro de 2015',
      'Moratória do cherne-poveiro (Polyprion americanus)', 'a obter'],
  ['Instrução Normativa Interministerial MPA/MMA nº 05, de 15 de abril '
      'de 2011',
      'Moratória do tubarão-raposa (Alopias superciliosus). A lista '
      'recebida chama esta norma de Portaria; o nome do arquivo oficial '
      'diz Instrução Normativa — confirmar qual é', 'a obter'],
  ['Instrução Normativa Interministerial MPA/MMA nº 01, de 12 de março '
      'de 2013',
      'Moratória do tubarão-galha-branca (Carcharhinus longimanus). '
      'Mesma divergência de nomenclatura da INI 05/2011', 'a obter'],
  ['Instrução Normativa Interministerial MPA/MMA nº 02, de 13 de março '
      'de 2013',
      'Moratória das raias da família Mobulidae. Mesma divergência de '
      'nomenclatura da INI 05/2011', 'a obter'],
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
