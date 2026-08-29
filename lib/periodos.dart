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
// Ela tem duas fontes, e as duas são índice, não resposta: o
// levantamento da UNIVALI e a tabela de períodos de defeso publicada
// pelo Ministério da Pesca e Aquicultura no gov.br. Onde as duas
// coincidem, a indicação é mais forte — mas segue sendo indicação.
//
// RECORTE: este aplicativo é de Santa Catarina. Todo período diz em
// `onde` para quais estados a norma vale, e só entra aqui o que
// alcança SC. Defeso de outro estado não é resposta errada: é resposta
// de outro lugar, e atrapalha quem está trabalhando aqui.
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

  /// As datas por extenso, com o verbo certo para o tipo. A barra
  /// desenha a forma do período; isto diz o número, que é o que a
  /// guarnição precisa falar em voz alta na abordagem.
  String get datas => tipo == TipoPeriodo.fechado
      ? 'Fechado de ${porExtenso(de)} a ${porExtenso(ate)}'
      : 'Só pode de ${porExtenso(de)} a ${porExtenso(ate)}';

  /// Fechado hoje: ou é um período de proibição em curso, ou é uma
  /// janela de permissão e estamos fora dela.
  bool fechadoEm(DateTime dia) =>
      tipo == TipoPeriodo.fechado ? contem(dia) : !contem(dia);
}

const _meses = [
  'janeiro',
  'fevereiro',
  'março',
  'abril',
  'maio',
  'junho',
  'julho',
  'agosto',
  'setembro',
  'outubro',
  'novembro',
  'dezembro',
];

/// 601 vira "1º de junho"; 1231 vira "31 de dezembro".
String porExtenso(int mmdd) {
  final mes = mmdd ~/ 100;
  final dia = mmdd % 100;
  return '${dia == 1 ? "1º" : "$dia"} de ${_meses[mes - 1]}';
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
    onde: 'Santa Catarina — Lagoas Mirim, Imaruí, Santo Antônio dos '
        'Anjos, Santa Marta '
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
    onde: 'Regiões Sudeste e Sul, inclusive Santa Catarina',
    norma: 'Portaria Interministerial nº 24/2018',
    artigo: 'art. 2º, I',
  ),
  Periodo(
    especie: 'Tainha',
    detalhe: 'Emalhe costeiro de superfície sem anilhas, até 10 AB',
    tipo: TipoPeriodo.permitido,
    de: 515,
    ate: 1015,
    onde: 'Regiões Sudeste e Sul, inclusive Santa Catarina',
    norma: 'Portaria Interministerial nº 24/2018',
    artigo: 'art. 2º',
  ),
  Periodo(
    especie: 'Tainha',
    detalhe: 'Emalhe costeiro de superfície sem anilhas, acima de 10 AB',
    tipo: TipoPeriodo.permitido,
    de: 515,
    ate: 731,
    onde: 'Regiões Sudeste e Sul, inclusive Santa Catarina',
    norma: 'Portaria Interministerial nº 24/2018',
    artigo: 'art. 2º',
  ),
  Periodo(
    especie: 'Tainha',
    detalhe: 'Emalhe anilhado',
    tipo: TipoPeriodo.permitido,
    de: 515,
    ate: 731,
    onde: 'Regiões Sudeste e Sul, inclusive Santa Catarina',
    norma: 'Portaria Interministerial nº 24/2018',
    artigo: 'art. 2º',
  ),
  Periodo(
    especie: 'Tainha',
    detalhe: 'Desembarcada ou embarcação sem motor',
    tipo: TipoPeriodo.permitido,
    de: 501,
    ate: 1231,
    onde: 'Regiões Sudeste e Sul, inclusive Santa Catarina',
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
    onde: 'Todas as desembocaduras estuarino-lagunares das regiões '
        'Sudeste e Sul, inclusive Santa Catarina',
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
    detalhe: 'Cerco e traineira AUTORIZADA à captura de tainha',
    tipo: TipoPeriodo.fechado,
    de: 601,
    ate: 731,
    onde: 'Até 5 milhas náuticas da costa em SP, PR e SC',
    norma: 'Portaria Interministerial nº 24/2018, na redação da '
        'Portaria SAP/MAPA nº 75/2020',
    artigo: 'art. 3º, primeiro inciso V',
  ),
  // ---------------------------- espécies com Plano de Recuperação
  //
  // Estas saíram da camada a confirmar em 29/08/2026, quando as
  // Portarias Interministeriais foram obtidas e lidas por inteiro.
  Periodo(
    especie: 'Garoupa-verdadeira',
    detalhe: 'Todos os métodos e todas as embarcações',
    tipo: TipoPeriodo.fechado,
    de: 1101,
    ate: 228,
    onde: 'Águas jurisdicionais brasileiras',
    norma: 'Portaria Interministerial nº 41/2018',
    artigo: 'art. 2º',
  ),
  Periodo(
    especie: 'Sirigado, badejo-amarelo, garoupa-de-São-Tomé e caranha',
    detalhe: 'Defeso das quatro espécies, desde 2019',
    tipo: TipoPeriodo.fechado,
    de: 801,
    ate: 930,
    onde: 'Águas jurisdicionais brasileiras',
    norma: 'Portaria Interministerial nº 59-C/2018',
    artigo: 'art. 5º',
  ),
  Periodo(
    especie: 'Cherne-verdadeiro e peixe-batata',
    detalhe: 'Pesca entre 100 e 600 m de profundidade, modalidades '
        '1.6, 1.7, 3.10, 3.11 e 3.12',
    tipo: TipoPeriodo.fechado,
    de: 901,
    ate: 1031,
    onde: 'Litoral Sudeste e Sul',
    norma: 'Portaria Interministerial nº 40/2018',
    artigo: 'art. 6º',
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
    onde: 'Paraná, Santa Catarina e Rio Grande do Sul',
    norma: 'Instrução Normativa Interministerial MPA/MMA nº 02, de 27 '
        'de novembro de 2009',
    artigo: 'norma a obter',
    confirmado: false,
  ),
  Periodo(
    especie: 'Bagre rosado',
    detalhe: 'Defeso',
    tipo: TipoPeriodo.fechado,
    de: 101,
    ate: 331,
    onde: 'Rio Grande do Sul, Santa Catarina, Paraná e São Paulo',
    norma: 'Portaria SUDEPE nº N-42, de 18 de outubro de 1984',
    artigo: 'art. 1º',
    confirmado: true,
  ),
  Periodo(
    especie: 'Sardinha-verdadeira',
    detalhe: 'Defeso',
    tipo: TipoPeriodo.fechado,
    de: 1001,
    ate: 228,
    onde: 'Entre os paralelos 22º00\' S (Cabo de São Tomé, RJ) e 28º36\' S (Cabo de Santa Marta, SC) — não alcança o litoral sul de SC',
    norma: 'IN SAP/MAPA nº 18, de 10 de junho de 2020, que deu nova redação ao art. 4º da IN IBAMA nº 15/2009',
    artigo: 'art. 4º',
  ),
  Periodo(
    especie: 'Sardinha-verdadeira',
    detalhe: 'Captura para isca-viva, frota de atum de vara',
    tipo: TipoPeriodo.fechado,
    de: 615,
    ate: 731,
    onde: 'Embarcações permissionadas para atuns pelo sistema de vara e anzol com isca-viva. A permissão do art. 1º vale entre os paralelos 22 S e 28 36 S, faixa que alcança Santa Catarina',
    norma: 'IN IBAMA nº 16, de 21 de maio de 2009',
    artigo: 'art. 2º',
  ),
  Periodo(
    especie: 'Caranguejo-uçá',
    detalhe: 'Defeso, machos e fêmeas',
    tipo: TipoPeriodo.fechado,
    de: 1001,
    ate: 1130,
    onde: 'Espírito Santo, Rio de Janeiro, São Paulo, Paraná e Santa Catarina',
    norma: 'Portaria IBAMA nº 52, de 30 de setembro de 2003',
    artigo: 'art. 1º, I',
  ),
  Periodo(
    especie: 'Caranguejo-uçá',
    detalhe: 'Defeso, somente fêmeas',
    tipo: TipoPeriodo.fechado,
    de: 1201,
    ate: 1231,
    onde: 'Espírito Santo, Rio de Janeiro, São Paulo, Paraná e Santa Catarina',
    norma: 'Portaria IBAMA nº 52, de 30 de setembro de 2003',
    artigo: 'art. 1º, II',
  ),
  Periodo(
    especie: 'Mexilhão ou marisco da pedra',
    detalhe: 'Defeso',
    tipo: TipoPeriodo.fechado,
    de: 901,
    ate: 1231,
    onde: 'ES, RJ, SP, PR, Santa Catarina e RS — somente o estoque NATURAL; o cultivo segue permitido com nota fiscal',
    norma: 'IN IBAMA nº 105, de 20 de julho de 2006',
    artigo: 'art. 3º',
  ),
  Periodo(
    especie: 'Lulas',
    detalhe: 'Janela de pesca permitida em Santa Catarina',
    tipo: TipoPeriodo.permitido,
    de: 1101,
    ate: 331,
    onde: 'Somente Santa Catarina, para pescadores profissionais artesanais',
    norma: 'Portaria Interministerial MPA/MMA nº 14, de 1º de novembro de 2024',
    artigo: 'art. 1º',
  ),

  Periodo(
    especie: 'Camarões na Baía da Babitonga',
    detalhe: 'Camarão-rosa e camarão-branco',
    tipo: TipoPeriodo.fechado,
    de: 1101,
    ate: 131,
    onde: 'Somente o interior da Baía da Babitonga, em Santa Catarina',
    norma: 'Portaria IBAMA nº 70, de 30 de outubro de 2003',
    artigo: 'art. 1º',
    confirmado: true,
  ),
  Periodo(
    especie: 'Águas continentais — bacia do rio Uruguai',
    detalhe: 'Todas as espécies ocorrentes na bacia, pesca desembarcada',
    tipo: TipoPeriodo.fechado,
    de: 1001,
    ate: 131,
    onde: 'Bacia hidrográfica do rio Uruguai, em Santa Catarina e no '
        'Rio Grande do Sul',
    norma: 'IN IBAMA nº 193, de 2 de outubro de 2008',
    artigo: 'norma a obter',
    confirmado: false,
  ),
  Periodo(
    especie: 'Águas continentais — demais bacias',
    detalhe: 'Todas as espécies ocorrentes na bacia, pesca desembarcada',
    tipo: TipoPeriodo.fechado,
    de: 1101,
    ate: 131,
    onde: 'Bacias de Santa Catarina e do Rio Grande do Sul, exceto a do '
        'rio Uruguai e as lagoas costeiras que a norma excepciona',
    norma: 'IN IBAMA nº 197, de 2 de outubro de 2008',
    artigo: 'norma a obter',
    confirmado: false,
  ),
  Periodo(
    especie: 'Águas continentais — bacia do rio Paraná',
    detalhe: 'Todas as espécies ocorrentes na bacia, pesca desembarcada',
    tipo: TipoPeriodo.fechado,
    de: 1101,
    ate: 228,
    onde: 'Bacia do rio Paraná — MG, GO, SP, PR, MS e Santa Catarina',
    norma: 'IN IBAMA nº 25, de 1º de setembro de 2009',
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

/// A data MMDD de um dia do ano. Inverso de [diaDoAno].
int mmddDoDia(int n) {
  const dias = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  var d = ((n - 1) % 365) + 1;
  for (var m = 0; m < 12; m++) {
    if (d <= dias[m]) return (m + 1) * 100 + d;
    d -= dias[m];
  }
  return 1231;
}

const _mesesPorExtenso = [
  'janeiro',
  'fevereiro',
  'março',
  'abril',
  'maio',
  'junho',
  'julho',
  'agosto',
  'setembro',
  'outubro',
  'novembro',
  'dezembro',
];

/// Uma virada: o dia em que um período começa ou termina.
///
/// O calendário responde "como é o ano". Isto responde outra pergunta,
/// que em serviço aparece tanto quanto: o que muda a seguir, e em
/// quantos dias. Quem sabe que o cherne fecha em três dias avisa o
/// pescador antes, em vez de autuar depois.
class Virada {
  final int mmdd;
  final bool fecha;
  final Periodo periodo;
  final int emDias;

  const Virada({
    required this.mmdd,
    required this.fecha,
    required this.periodo,
    required this.emDias,
  });

  String get data {
    final dia = mmdd % 100;
    return '${dia == 1 ? "1º" : "$dia"} de '
        '${_mesesPorExtenso[mmdd ~/ 100 - 1]}';
  }

  String get quando => emDias == 0
      ? 'hoje'
      : emDias == 1
          ? 'amanhã'
          : 'em $emDias dias';

  /// O verbo descreve a REGRA, não a pescaria.
  ///
  /// Dizer "abre a tainha" quando o que termina é o fechamento de uma
  /// área seria falso e perigoso: em 16 de setembro acaba a proibição
  /// nas desembocaduras, mas a temporada de cerco fechou em 31 de julho
  /// e outras áreas seguem proibidas até 31 de dezembro. Uma regra que
  /// termina não é uma pescaria que abre.
  String get verbo {
    if (periodo.tipo == TipoPeriodo.fechado) {
      return fecha ? 'COMEÇA A PROIBIÇÃO' : 'TERMINA A PROIBIÇÃO';
    }
    return fecha ? 'ENCERRA A TEMPORADA' : 'ABRE A TEMPORADA';
  }

  /// O nome da espécie sem o sufixo do grupo.
  String get especie => periodo.especie.split(' — ').first;

  /// A espécie continua com alguma outra restrição no dia seguinte à
  /// virada? Se sim, a tela avisa — para que ninguém leia o fim de uma
  /// regra como liberação da pescaria.
  bool get aindaRestrita {
    final dia = DateTime(2026, mmdd ~/ 100, mmdd % 100);
    return periodos.any((o) =>
        o != periodo &&
        o.confirmado &&
        o.especie.split(' — ').first == especie &&
        o.fechadoEm(dia));
  }

  /// Quantas outras regras da mesma espécie seguem fechando no dia.
  int get quantasOutras {
    final dia = DateTime(2026, mmdd ~/ 100, mmdd % 100);
    return periodos
        .where((o) =>
            o != periodo &&
            o.confirmado &&
            o.especie.split(' — ').first == especie &&
            o.fechadoEm(dia))
        .length;
  }
}

/// As próximas viradas, a partir de uma data, só entre as normas
/// conferidas. Não inclui a camada a confirmar: uma data que não saiu
/// de norma não serve para avisar ninguém de nada.
List<Virada> proximasViradas(DateTime hoje, {int quantas = 8}) {
  final h = diaDoAno(hoje.month * 100 + hoje.day);
  final todas = <Virada>[];

  void juntar(int mmdd, bool fecha, Periodo p) {
    final d = (diaDoAno(mmdd) - h) % 365;
    todas.add(Virada(mmdd: mmdd, fecha: fecha, periodo: p, emDias: d));
  }

  for (final p in periodos) {
    if (!p.confirmado) continue;
    final abreEm = p.tipo == TipoPeriodo.permitido;
    juntar(p.de, !abreEm, p);
    juntar(mmddDoDia(diaDoAno(p.ate) + 1), abreEm, p);
  }

  todas.sort((a, b) => a.emDias.compareTo(b.emDias));

  // sem repetir a mesma virada da mesma linha
  final saida = <Virada>[];
  final vistas = <String>{};
  for (final v in todas) {
    final chave = '${v.mmdd}|${v.fecha}|${v.periodo.especie}|'
        '${v.periodo.detalhe}';
    if (vistas.contains(chave)) continue;
    vistas.add(chave);
    saida.add(v);
    if (saida.length >= quantas) break;
  }
  return saida;
}
