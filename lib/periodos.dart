// =====================================================================
// O ANO, EM PERÍODOS
//
// As datas das normas cujo texto foi conferido, num formato que a tela
// consegue desenhar e comparar com hoje.
//
// Duas camadas, e a diferença aparece no desenho:
//
//   confirmado: true  — saiu de norma lida por inteiro. Barra cheia.
//   confirmado: false — a data veio do levantamento da UNIVALI, a norma
//                       ainda não foi obtida. Barra hachurada, e o
//                       aplicativo diz que precisa ser confirmada antes
//                       de aplicar.
//
// A segunda camada existe porque saber que provavelmente há defeso é
// melhor do que não saber nada. Mas ela nunca se disfarça da primeira.
//
// As datas ficam como MMDD (601 é 1º de junho, 1231 é 31 de dezembro).
// Quando `de` é maior que `ate`, o período vira o ano.
// =====================================================================

enum TipoPeriodo {
  /// Período em que a captura é proibida.
  fechado,

  /// Janela em que a captura é permitida; fora dela, é proibida.
  permitido,
}

class Periodo {
  /// A espécie, como cabeçalho do grupo.
  final String especie;

  /// A modalidade ou a área a que o período se refere.
  final String detalhe;

  final TipoPeriodo tipo;

  /// Início e fim, em MMDD.
  final int de;
  final int ate;

  /// Onde vale, quando a norma restringe.
  final String onde;

  final String norma;
  final String artigo;

  /// Falso quando a data veio do levantamento e a norma não foi obtida.
  final bool confirmado;

  const Periodo({
    required this.especie,
    required this.detalhe,
    required this.tipo,
    required this.de,
    required this.ate,
    required this.norma,
    required this.artigo,
    this.onde = '',
    this.confirmado = true,
  });

  bool contem(DateTime dia) {
    final d = dia.month * 100 + dia.day;
    return de <= ate ? (d >= de && d <= ate) : (d >= de || d <= ate);
  }

  /// Vira o ano — 1º de novembro a 30 de abril, por exemplo.
  bool get viraOAno => de > ate;

  /// Fechado hoje: ou é um período de proibição em curso, ou é uma
  /// janela de permissão e estamos fora dela.
  bool fechadoEm(DateTime dia) =>
      tipo == TipoPeriodo.fechado ? contem(dia) : !contem(dia);
}

const periodos = <Periodo>[
  // ---------------------------------------------------------- camarões
  Periodo(
    especie: 'Camarões marinhos',
    detalhe: 'Rosa, sete-barbas, branco, santana e barba-ruça',
    tipo: TipoPeriodo.fechado,
    de: 128,
    ate: 430,
    onde: 'RJ, SP, PR, SC e RS, no mar territorial e na ZEE',
    norma: 'Portaria SAP/MAPA nº 656/2022',
    artigo: 'art. 2º',
  ),

  Periodo(
    especie: 'Camarões no Complexo Lagunar Sul',
    detalhe: 'Camarão-rosa e camarão-branco, pesca artesanal',
    tipo: TipoPeriodo.permitido,
    de: 1116,
    ate: 714,
    onde: 'Lagoas Mirim, Imaruí, Santo Antônio dos Anjos, Santa Marta '
        'Pequena, Camacho e Garopaba do Sul, e seus tributários',
    norma: 'Portaria Interministerial MPA/MMA nº 65/2026',
    artigo: 'art. 3º, I',
  ),

  // ------------------------------------------- tainha: quando se pode
  Periodo(
    especie: 'Tainha',
    detalhe: 'Cerco e traineira',
    tipo: TipoPeriodo.permitido,
    de: 601,
    ate: 731,
    norma: 'Portaria Interministerial nº 24/2018',
    artigo: 'art. 2º, I',
  ),
  Periodo(
    especie: 'Tainha',
    detalhe: 'Emalhe costeiro de superfície sem anilhas, até 10 AB',
    tipo: TipoPeriodo.permitido,
    de: 515,
    ate: 1015,
    norma: 'Portaria Interministerial nº 24/2018',
    artigo: 'art. 2º',
  ),
  Periodo(
    especie: 'Tainha',
    detalhe: 'Emalhe costeiro de superfície sem anilhas, acima de 10 AB',
    tipo: TipoPeriodo.permitido,
    de: 515,
    ate: 731,
    norma: 'Portaria Interministerial nº 24/2018',
    artigo: 'art. 2º',
  ),
  Periodo(
    especie: 'Tainha',
    detalhe: 'Emalhe anilhado',
    tipo: TipoPeriodo.permitido,
    de: 515,
    ate: 731,
    norma: 'Portaria Interministerial nº 24/2018',
    artigo: 'art. 2º',
  ),
  Periodo(
    especie: 'Tainha',
    detalhe: 'Desembarcada ou embarcação sem motor',
    tipo: TipoPeriodo.permitido,
    de: 501,
    ate: 1231,
    norma: 'Portaria Interministerial nº 24/2018',
    artigo: 'art. 2º',
  ),

  // ------------------------------------------ tainha: áreas fechadas
  Periodo(
    especie: 'Tainha — áreas fechadas',
    detalhe: 'Todas as modalidades, exceto tarrafa',
    tipo: TipoPeriodo.fechado,
    de: 315,
    ate: 915,
    onde: 'Todas as desembocaduras estuarino-lagunares',
    norma: 'Portaria Interministerial nº 24/2018',
    artigo: 'art. 3º',
  ),
  Periodo(
    especie: 'Tainha — áreas fechadas',
    detalhe: 'Redes de trolha, cercos flutuantes, redes de emalhe, faróis '
        'manuais, anzóis, fisgas e garatéias',
    tipo: TipoPeriodo.fechado,
    de: 501,
    ate: 1231,
    onde: 'Litoral de Santa Catarina, a menos de 300 m dos costões '
        'rochosos e a menos de 1 milha náutica da costa',
    norma: 'Portaria Interministerial nº 24/2018',
    artigo: 'art. 3º',
  ),
  Periodo(
    especie: 'Tainha — áreas fechadas',
    detalhe: 'Captura de isca viva',
    tipo: TipoPeriodo.fechado,
    de: 501,
    ate: 731,
    onde: 'Litoral de Santa Catarina, mesmas distâncias',
    norma: 'Portaria Interministerial nº 24/2018',
    artigo: 'art. 3º',
  ),
  Periodo(
    especie: 'Tainha — áreas fechadas',
    detalhe: 'Cerco e traineira',
    tipo: TipoPeriodo.fechado,
    de: 601,
    ate: 731,
    onde: 'Até 5 milhas náuticas da costa em SP, PR e SC',
    norma: 'Portaria Interministerial nº 24/2018',
    artigo: 'art. 3º',
  ),
  // =================================================================
  // A CONFIRMAR — datas do levantamento, norma ainda não obtida
  // =================================================================
  Periodo(
    especie: 'Enchova ou anchova',
    detalhe: 'Defeso',
    tipo: TipoPeriodo.fechado,
    de: 1201,
    ate: 331,
    norma: 'IN Interministerial MPA/MMA nº 02/2009',
    artigo: 'norma a obter',
    confirmado: false,
  ),
  Periodo(
    especie: 'Bagre rosado',
    detalhe: 'Defeso',
    tipo: TipoPeriodo.fechado,
    de: 101,
    ate: 331,
    norma: 'Portaria SUDEPE N-42/1984',
    artigo: 'norma a obter',
    confirmado: false,
  ),
  Periodo(
    especie: 'Sardinha-verdadeira',
    detalhe: 'Defeso',
    tipo: TipoPeriodo.fechado,
    de: 1001,
    ate: 228,
    onde: 'Entre os paralelos 22°00\' S e 28°36\' S',
    norma: 'IN SAP/MAPA nº 18/2020',
    artigo: 'norma a obter',
    confirmado: false,
  ),
  Periodo(
    especie: 'Sardinha-verdadeira',
    detalhe: 'Captura para isca-viva, frota de atum de vara',
    tipo: TipoPeriodo.fechado,
    de: 615,
    ate: 731,
    norma: 'IN IBAMA nº 16/2009',
    artigo: 'norma a obter',
    confirmado: false,
  ),
  Periodo(
    especie: 'Garoupa-verdadeira',
    detalhe: 'Defeso',
    tipo: TipoPeriodo.fechado,
    de: 1101,
    ate: 228,
    norma: 'Portaria Interministerial nº 41/2018',
    artigo: 'norma a obter',
    confirmado: false,
  ),
  Periodo(
    especie: 'Cherne-verdadeiro e peixe-batata',
    detalhe: 'Defeso, entre 100 e 600 m de profundidade',
    tipo: TipoPeriodo.fechado,
    de: 901,
    ate: 1031,
    norma: 'Portaria Interministerial nº 40/2018',
    artigo: 'norma a obter',
    confirmado: false,
  ),
  Periodo(
    especie: 'Caranguejo-uçá',
    detalhe: 'Defeso, machos e fêmeas',
    tipo: TipoPeriodo.fechado,
    de: 1001,
    ate: 1130,
    norma: 'Portaria IBAMA nº 52/2003',
    artigo: 'norma a obter',
    confirmado: false,
  ),
  Periodo(
    especie: 'Caranguejo-uçá',
    detalhe: 'Defeso, somente fêmeas',
    tipo: TipoPeriodo.fechado,
    de: 1201,
    ate: 1231,
    norma: 'Portaria IBAMA nº 52/2003',
    artigo: 'norma a obter',
    confirmado: false,
  ),
  Periodo(
    especie: 'Lagostas',
    detalhe: 'Defeso',
    tipo: TipoPeriodo.fechado,
    de: 1101,
    ate: 430,
    norma: 'Portaria SAP/MAPA nº 221/2021',
    artigo: 'norma a obter',
    confirmado: false,
  ),
  Periodo(
    especie: 'Mexilhão ou marisco da pedra',
    detalhe: 'Defeso',
    tipo: TipoPeriodo.fechado,
    de: 901,
    ate: 1231,
    norma: 'IN IBAMA nº 105/2006',
    artigo: 'norma a obter',
    confirmado: false,
  ),
  Periodo(
    especie: 'Lulas',
    detalhe: 'Janela de pesca permitida em Santa Catarina',
    tipo: TipoPeriodo.permitido,
    de: 1101,
    ate: 331,
    norma: 'Portaria Interministerial MPA/MMA nº 14/2024',
    artigo: 'norma a obter',
    confirmado: false,
  ),
];

/// O que está fechado numa data, com norma conferida.
List<Periodo> fechadosEm(DateTime dia) => periodos
    .where((p) => p.confirmado && p.fechadoEm(dia))
    .toList();

/// O que o levantamento indica como fechado, sem norma conferida.
List<Periodo> fechadosAConfirmarEm(DateTime dia) => periodos
    .where((p) => !p.confirmado && p.fechadoEm(dia))
    .toList();

/// As espécies com alguma restrição em curso, sem repetir.
List<String> especiesFechadasEm(DateTime dia) {
  final vistas = <String>[];
  for (final p in fechadosEm(dia)) {
    final nome = p.especie.split(' — ').first;
    if (!vistas.contains(nome)) vistas.add(nome);
  }
  return vistas;
}

/// Dia do ano de uma data MMDD, num ano comum de 365 dias. Serve só
/// para desenhar a barra: um dia de diferença em ano bissexto não muda
/// nada na tela, e a comparação com hoje é feita em MMDD, não aqui.
int diaDoAno(int mmdd) {
  const antes = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
  final mes = mmdd ~/ 100;
  final dia = mmdd % 100;
  return antes[mes - 1] + dia;
}
