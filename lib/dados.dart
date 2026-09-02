// =====================================================================
// OS DADOS
//
// Duas normas, transcritas dos PDFs oficiais:
//
//   IN MMA nº 53/2005  tamanho mínimo de captura (34 espécies)
//   IN MPA/MMA nº 10/2011  permissionamento: método, apetrecho,
//                          espécie-alvo e área (67 modalidades)
//
// Nada aqui é inventado. Mas a IN 10 foi alterada pela IN MPA nº
// 14/2014 e pela IN MPA/MMA nº 01/2015, e a IN 53 é de 2005 — a
// vigência precisa ser conferida antes de qualquer uso real.
// =====================================================================

// ------------------------------------------------- IN 53: tamanho mínimo

/// Formato do corpo, só para dar uma silhueta reconhecível na lista.
enum Forma { comum, robusto, fita, chato, tubarao }

/// Qual norma fixa o tamanho mínimo da espécie.
///
/// São duas, e elas não são intercambiáveis: a IN 53/2005 é de espécies
/// MARINHAS E ESTUARINAS do Sudeste e Sul; a Portaria IBAMA nº 25-N, de
/// 9 de março de 1993, é de espécies de ÁGUA DOCE e proíbe nos Estados
/// do Rio Grande do Sul, Santa Catarina, Paraná, São Paulo, Rio de
/// Janeiro e Espírito Santo.
///
/// A tolerância das duas se conta de maneira diferente — ver
/// `toleranciaEmPeso`.
enum NormaDeTamanho { in53, p25n1993 }

class Especie {
  final String nome;
  final String cientifico;
  final int tamanho; // em centímetros

  /// De qual norma sai este tamanho mínimo.
  final NormaDeTamanho norma;
  final int anexo; // 1 ou 2 da IN 53/2005
  final bool furcal; // mede até a forquilha, não até a ponta do rabo
  final Forma forma;

  /// Vazio se a espécie não consta da Lista Nacional Oficial. Se constar,
  /// traz a categoria de risco: CR, EN ou VU.
  final String ameaca;

  /// Número do item na Lista da Portaria GM/MMA nº 1.667/2026.
  final int itemLista;

  /// True se a espécie já constava da Portaria MMA nº 445/2014, revogada.
  /// Nesse caso a proibição já está em vigor. Se for false, vale o prazo
  /// do art. 12 da Portaria 1.666: 180 dias da publicação, ou seja,
  /// 25 de outubro de 2026.
  final bool jaConstava;

  /// Aviso curto exibido junto do nome, quando a espécie precisa de
  /// distinção que o nome popular não dá.
  final String observacao;

  /// Regras próprias da espécie que não vêm da IN 53 — temporada,
  /// áreas fechadas — trazidas por norma específica.
  final String regras;

  /// A norma de onde as regras acima saíram, com a data. Fica visível
  /// na tela: quanto mais antiga, mais precisa ser conferida.
  final String regrasNorma;

  const Especie(
    this.nome,
    this.cientifico,
    this.tamanho, {
    this.anexo = 2,
    this.furcal = false,
    this.forma = Forma.comum,
    this.ameaca = '',
    this.itemLista = 0,
    this.jaConstava = false,
    this.observacao = '',
    this.regras = '',
    this.regrasNorma = '',
    this.norma = NormaDeTamanho.in53,
  });

  /// Art. 4º da IN 53: o Anexo I tolera 10% da captura abaixo do
  /// tamanho, o Anexo II tolera 20%. A Portaria 25-N/1993 tolera 10%,
  /// mas contados de outro jeito — ver toleranciaEmPeso.
  int get tolerancia => norma == NormaDeTamanho.p25n1993
      ? 10
      : (anexo == 1 ? 10 : 20);

  /// A IN 53 mede a tolerância EM PESO sobre o total da captura. A
  /// Portaria 25-N/1993 mede EM NÚMERO DE INDIVÍDUOS e POR ESPÉCIE
  /// (art. 2º). Somar peso onde a norma conta indivíduo dá conta errada
  /// na abordagem.
  bool get toleranciaEmPeso => norma == NormaDeTamanho.in53;

  /// O nome da norma que fixa o tamanho desta espécie.
  String get normaDoTamanho => switch (norma) {
        NormaDeTamanho.in53 =>
          'Instrução Normativa MMA nº 53, de 22 de novembro de 2005',
        NormaDeTamanho.p25n1993 =>
          'Portaria IBAMA nº 25-N, de 9 de março de 1993',
      };

  bool get ameacada => ameaca.isNotEmpty;

  /// Captura proibida agora.
  bool get proibidaHoje => ameacada && jaConstava;

  /// Na lista, mas a proibição só começa em 25/10/2026.
  bool get proibidaDepois => ameacada && !jaConstava;

  String get categoriaPorExtenso => switch (ameaca) {
        'CR' => 'Criticamente em Perigo',
        'EN' => 'Em Perigo',
        'VU' => 'Vulnerável',
        _ => '',
      };
}

/// Art. 12 da Portaria GM/MMA nº 1.666: para as espécies que não
/// constavam da lista anterior, as proibições entram em vigor 180 dias
/// depois da publicação, que se deu em 28/04/2026.
final DateTime inicioDasNovasProibicoes = DateTime(2026, 10, 25);

int diasAteAsNovasProibicoes() {
  final hoje = DateTime.now();
  final d = inicioDasNovasProibicoes.difference(
    DateTime(hoje.year, hoje.month, hoje.day),
  );
  return d.inDays;
}

const List<Especie> especies = [
  // ---------- Anexo I ----------
  Especie('Badejo mira', 'Mycteroperca acutirostris', 23,
      anexo: 1, forma: Forma.robusto, ameaca: 'EN', itemLista: 300),
  Especie('Badejo quadrado', 'Mycteroperca bonaci', 45,
      anexo: 1,
      forma: Forma.robusto,
      ameaca: 'EN',
      itemLista: 301,
      jaConstava: true),
  Especie('Badejo de areia', 'Mycteroperca microlepis', 30,
      anexo: 1, forma: Forma.robusto),
  Especie('Garoupa', 'Epinephelus marginatus', 47,
      anexo: 1,
      forma: Forma.robusto,
      ameaca: 'VU',
      itemLista: 269,
      jaConstava: true),
  Especie('Miraguaia', 'Pogonias courbina', 65,
      anexo: 1,
      forma: Forma.robusto,
      ameaca: 'CR',
      itemLista: 294,
      jaConstava: true,
      observacao: 'TRÊS NORMAS, TRÊS NÚMEROS — ver o ponto em '
          'verificação. A IN 53 traz o nome antigo, Pogonias cromis, e '
          '65 cm. A Portaria SAQ nº 009/2025, do Estado de Santa '
          'Catarina, traz Pogonias courbina e 55 cm. A Portaria GM/MMA '
          'nº 1.667/2026 traz Pogonias courbina na Lista, como CR. A '
          'Portaria 445/2014 já a listava com o nome comum Miragaia.'),
  Especie('Cação anjo asa longa', 'Squatina argentina', 70,
      anexo: 1,
      forma: Forma.tubarao,
      ameaca: 'CR',
      itemLista: 375,
      jaConstava: true),
  Especie('Cação listrado ou malhado', 'Mustelus fasciatus', 100,
      anexo: 1,
      forma: Forma.tubarao,
      ameaca: 'CR',
      itemLista: 336,
      jaConstava: true),
  Especie('Tubarão martelo recortado', 'Sphyrna lewini', 60,
      anexo: 1,
      forma: Forma.tubarao,
      ameaca: 'CR',
      itemLista: 328,
      jaConstava: true),
  Especie('Tubarão martelo liso', 'Sphyrna zygaena', 60,
      anexo: 1,
      forma: Forma.tubarao,
      ameaca: 'CR',
      itemLista: 333,
      jaConstava: true),

  // ---------- Anexo II ----------
  Especie('Anchova', 'Pomatomus saltatrix', 35),
  Especie('Bagre branco', 'Genidens barbus', 40,
      ameaca: 'EN', itemLista: 307, jaConstava: true),
  Especie('Bagre', 'Cathorops spixii', 12),
  Especie('Bagre', 'Genidens genidens', 20),
  Especie('Batata', 'Lopholatilus villarii', 40,
      forma: Forma.robusto,
      ameaca: 'VU',
      itemLista: 280,
      jaConstava: true),
  Especie('Cabrinha', 'Prionotus punctatus', 18),
  Especie('Castanha', 'Umbrina canosai', 20),
  Especie('Corvina', 'Micropogonias furnieri', 25),
  Especie('Goete', 'Cynoscion jamaicensis', 16),
  Especie('Linguado', 'Paralichthys patagonicus / P. brasiliensis', 35,
      forma: Forma.chato),
  Especie('Palombeta', 'Chloroscombrus chrysurus', 12, forma: Forma.robusto),
  Especie('Pampo ou gordinho', 'Peprilus paru', 15, forma: Forma.robusto),
  Especie('Pampo viúva', 'Parona signata', 15, forma: Forma.robusto),
  Especie('Papa-terra branco ou betara', 'Menticirrhus littoralis', 20),
  Especie('Peixe-espada', 'Trichiurus lepturus', 70, forma: Forma.fita),

  // A IN 53 traz as duas espécies numa entrada só, com o mesmo nome
  // popular. Só uma delas está na lista de ameaçadas, então elas
  // precisam ser separadas — o app não consegue dar duas respostas
  // numa linha só.
  Especie('Peixe-porco, peroá ou cangulo', 'Balistes capriscus', 20,
      furcal: true,
      forma: Forma.robusto,
      ameaca: 'EN',
      itemLista: 313,
      observacao: 'A IN 53 usa o mesmo nome popular para duas espécies. '
          'Confira o nome científico: esta é a Balistes capriscus.'),
  Especie('Peixe-porco, peroá ou cangulo', 'Balistes vetula', 20,
      furcal: true,
      forma: Forma.robusto,
      observacao: 'A IN 53 usa o mesmo nome popular para duas espécies. '
          'Confira o nome científico: esta é a Balistes vetula, que não '
          'consta da lista de ameaçadas.'),

  Especie('Peixe-rei', 'Odonthestes bonariensis / Atherinella brasiliensis', 10),
  Especie('Pescada olhuda ou maria-mole', 'Cynoscion striatus', 30),
  Especie('Pescadinha', 'Macrodon ancylodon', 25),
  Especie('Robalo peba ou peva', 'Centropomus parallelus', 30),
  Especie('Robalo flecha', 'Centropomus undecimalis', 50),
  Especie('Sardinha-lage', 'Opisthonema oglinum', 15),
  Especie('Tainha', 'Mugil platanus / Mugil liza', 35),
  Especie('Parati ou saúba', 'Mugil curema', 20),
  Especie('Trilha', 'Mullus argentinae', 13),

// ------------------------------------- Portaria 25-N/1993: água doce
//
// Portaria IBAMA nº 25-N, de 9 de março de 1993, publicada no DOU de
// 10/03/1993. Art. 1º: proíbe, NOS ESTADOS DO RIO GRANDE DO SUL, SANTA
// CATARINA, PARANÁ, SÃO PAULO, RIO DE JANEIRO E ESPÍRITO SANTO, a
// captura, o transporte e a comercialização das espécies abaixo com
// comprimento total inferior ao da tabela.
//
// COMPRIMENTO TOTAL, no parágrafo único do art. 1º, é a distância entre
// a ponta do focinho e a extremidade da nadadeira caudal. Não é o
// comprimento furcal da IN 53.
//
// TOLERÂNCIA (art. 2º): até 10% de INDIVÍDUOS com tamanho inferior,
// sobre o total capturado POR ESPÉCIE. Não é percentual em peso, como
// na IN 53. Passando disso, o parágrafo único manda apreender TODO o
// pescado.
//
// TRANSPORTE (art. 3º): durante o transporte, somente o tamanho mínimo
// é fiscalizado.
//
// A norma revogou as Portarias SUDEPE nº 68/1985, N-50/1987 e
// N-52/1987.
  Especie('Piracanjuba', 'Brycon orbignyanus', 30,
      norma: NormaDeTamanho.p25n1993,
      ),
  Especie('Piracanjuba ou salmão', 'Brycon hilarii', 40,
      norma: NormaDeTamanho.p25n1993,
      ),
  Especie('Curimbatá', 'Prochilodus lineatus', 30,
      norma: NormaDeTamanho.p25n1993,
      ),
  Especie('Curimatá, curimbatá ou grumatá', 'Prochilodus affinis', 30,
      norma: NormaDeTamanho.p25n1993,
      ),
  Especie('Piapara ou piau-verdadeiro', 'Leporinus aff obtusidens', 25,
      norma: NormaDeTamanho.p25n1993,
      observacao: 'A norma escreve "Leporinus aff obtusidens", com o "aff" que '
          'a taxonomia usa para dizer "afim de", isto é, parecida com. '
          'Está reproduzido como o documento imprime.',
      ),
  Especie('Piapara ou piau-verdadeiro', 'Leporinus aff elongatus', 30,
      norma: NormaDeTamanho.p25n1993,
      observacao: 'A norma escreve "Leporinus aff elongatus". Mesmo nome '
          'popular da linha anterior, tamanho diferente: 30 cm, contra '
          '25 cm da aff obtusidens.',
      ),
  Especie('Pacu ou pacu-caranha', 'Piaractus mesopotamicus', 40,
      norma: NormaDeTamanho.p25n1993,
      ),
  Especie('Dourado', 'Salminus maxillosus', 55,
      norma: NormaDeTamanho.p25n1993,
      observacao: 'O texto da portaria que circula imprime "Salrninus '
          'maxillosus", com "rn" no lugar de "m" — defeito de '
          'digitalização. O nome correto é Salminus maxillosus, e é o '
          'que o aplicativo usa.\n\n'
          'A Portaria MPA nº 532/2025 nomeia "Dourado" outra espécie: '
          'Salminus brasiliensis, que tem página própria neste '
          'aplicativo. São dois nomes científicos diferentes e o '
          'aplicativo não afirma que sejam o mesmo peixe — confira o '
          'nome científico antes de aplicar os 55 cm.',
      ),
  Especie('Jaú', 'Paulicea luetkeni', 80,
      norma: NormaDeTamanho.p25n1993,
      ),
  Especie('Surubim ou pintado', 'Pseudoplatystoma coruscans', 80,
      norma: NormaDeTamanho.p25n1993,
      ),
  Especie('Surubim ou pintado', 'Pseudoplatystoma fasciatum', 80,
      norma: NormaDeTamanho.p25n1993,
      observacao: 'O texto da portaria que circula imprime '
          '"Pseudoplatystoma fasciaturn" — defeito de digitalização, '
          'porque "turn" não é terminação latina. O nome correto é '
          'Pseudoplatystoma fasciatum, e é o que o aplicativo usa.',
      ),
  Especie('Armado', 'Pterodoras granulosus', 35,
      norma: NormaDeTamanho.p25n1993,
      ),
  Especie('Pescada', 'Plagioscion squamosissimus', 25,
      norma: NormaDeTamanho.p25n1993,
      ),
  Especie('Mandi', 'Pimelodus maculatus', 18,
      norma: NormaDeTamanho.p25n1993,
      ),
];

// ------------------------------------------- IN 10: método e apetrecho

/// Os seis métodos de pesca do art. 3º da IN 10/2011.
enum Metodo { linha, emalhe, arrasto, cerco, armadilha, outros }

extension MetodoInfo on Metodo {
  String get nome => switch (this) {
        Metodo.linha => 'Linha',
        Metodo.emalhe => 'Emalhe',
        Metodo.arrasto => 'Arrasto',
        Metodo.cerco => 'Cerco',
        Metodo.armadilha => 'Armadilha',
        Metodo.outros => 'Outros',
      };

  /// Explicação em palavra de todo dia, não a da norma.
  String get explicacao => switch (this) {
        Metodo.linha => 'Pesca de anzol: linha de mão, vara, espinhel, corrico.',
        Metodo.emalhe =>
          'Rede de espera parada na água, fundeada ou à deriva. O peixe '
              'se enrosca na malha.',
        Metodo.arrasto => 'Rede puxada pelo barco, arrastando pelo fundo '
            'ou no meio da água.',
        Metodo.cerco => 'Rede que fecha em roda em volta do cardume.',
        Metodo.armadilha =>
          'Covos, potes e manzuás — o bicho entra e não sai.',
        Metodo.outros =>
          'Mergulho, coleta na mão, puçá, e a pesca costeira diversificada '
              'dos barcos pequenos.',
      };
}

class Modalidade {
  final String numero; // ex.: 2.4
  final Metodo metodo;
  final String petrecho;
  final String locais; // como o pescador chama na região
  final String alvo;
  final String incidental;
  final String acompanhante;
  final String complementar;
  final String area;
  final bool valeEmSc;

  /// Regras operacionais próprias da modalidade, quando a norma as traz
  /// (dimensão de rede, malha, restrições de equipamento).
  final String regras;

  /// Preenchido quando a modalidade não vem da IN 10, mas de norma
  /// posterior que a incluiu.
  final String norma;

  const Modalidade(
    this.numero,
    this.metodo,
    this.petrecho, {
    this.locais = '',
    required this.alvo,
    this.incidental = '',
    this.acompanhante = '',
    this.complementar = '',
    required this.area,
    this.valeEmSc = false,
    this.regras = '',
    this.norma = '',
  });
}

// =====================================================================
// AS MODALIDADES COM REDAÇÃO POSTERIOR A 2011
//
// A matriz abaixo nasceu no Anexo I da IN 10/2011. Quatro normas
// posteriores a alteraram, e de duas delas o aplicativo tem o texto — a
// Portaria Interministerial MPA/MMA nº 14/2024 (lulas) e a Portaria
// Interministerial MPA/MMA nº 66/2026 (pargo).
//
// PARA ESSAS, O QUE ESTÁ AQUI É A REDAÇÃO NOVA, não a de 2011. O texto
// foi extraído do Diário Oficial por script, campo a campo, sem
// redigitação — ver ferramentas/ e o registro do texto anterior.
//
// As duas normas alteram de formas diferentes, e confundi-las apagaria
// dado: a de 2024 troca UM campo de cada modalidade (o resto vem com a
// linha pontilhada do DOU, que significa "inalterado"); a de 2026
// reescreve a modalidade inteira.
//
// Falta ainda a Instrução Normativa MPA nº 14, de 2014, cujo texto não
// foi obtido — e por isso não se sabe quais modalidades ela alcançou.
// Por isso o aviso geral da tela continua.
// =====================================================================
const redacaoDe = <String, String>{
  // Portaria Interministerial MPA/MMA nº 14, de 1º de novembro de 2024
  '2.2': 'Portaria Interministerial MPA/MMA nº 14, de 1º de novembro de 2024',  // complementar
  '2.4': 'Portaria Interministerial MPA/MMA nº 14, de 1º de novembro de 2024',  // complementar
  '3.8': 'Portaria Interministerial MPA/MMA nº 14, de 1º de novembro de 2024',  // complementar
  '3.9': 'Portaria Interministerial MPA/MMA nº 14, de 1º de novembro de 2024',  // complementar
  '6.7': 'Portaria Interministerial MPA/MMA nº 14, de 1º de novembro de 2024',  // alvo
  '6.8': 'Portaria Interministerial MPA/MMA nº 14, de 1º de novembro de 2024',  // alvo
  '6.9': 'Portaria Interministerial MPA/MMA nº 14, de 1º de novembro de 2024',  // alvo
  '6.10': 'Portaria Interministerial MPA/MMA nº 14, de 1º de novembro de 2024',  // alvo
  '6.11': 'Portaria Interministerial MPA/MMA nº 14, de 1º de novembro de 2024',  // alvo
  // Portaria Interministerial MPA/MMA nº 66, de 27 de julho de 2026
  '1.6': 'Portaria Interministerial MPA/MMA nº 66, de 27 de julho de 2026',  // alvo, incidental, acompanhante, complementar, area
  '1.8': 'Portaria Interministerial MPA/MMA nº 66, de 27 de julho de 2026',  // locais, alvo, incidental, acompanhante, complementar, area
  '1.9': 'Portaria Interministerial MPA/MMA nº 66, de 27 de julho de 2026',  // locais, alvo, incidental, acompanhante, complementar, area
  '1.10': 'Portaria Interministerial MPA/MMA nº 66, de 27 de julho de 2026',  // locais, alvo, incidental, acompanhante, complementar, area
  '1.11': 'Portaria Interministerial MPA/MMA nº 66, de 27 de julho de 2026',  // locais, alvo, incidental, acompanhante, area
  '1.14': 'Portaria Interministerial MPA/MMA nº 66, de 27 de julho de 2026',  // alvo, incidental, acompanhante, area
  '3.11': 'Portaria Interministerial MPA/MMA nº 66, de 27 de julho de 2026',  // alvo, incidental, acompanhante, area
  '3.13': 'Portaria Interministerial MPA/MMA nº 66, de 27 de julho de 2026',  // alvo, incidental, acompanhante, area
};

/// A norma cuja redação está nesta modalidade, quando não é a de 2011.
String redacaoDaModalidade(String numero) => redacaoDe[numero] ?? '';

// =====================================================================
// AS MODALIDADES DE PORTA FECHADA
//
// A Portaria Interministerial MPA/MMA nº 19, de 24 de dezembro de 2024,
// não reescreve modalidade nenhuma: ela PROÍBE O REGISTRO DE NOVAS
// EMBARCAÇÕES em quatro delas. A modalidade continua existindo e quem
// já está dentro continua operando — o que fechou foi a entrada.
//
// Ler "proibido" sem os arts. 2º, 3º e 4º dá resposta errada: a
// substituição de embarcação, a transformação e a pesquisa seguem
// permitidas.
// =====================================================================
const registroFechado = <String>['1.2', '1.3', '1.4', '1.15'];

const normaDoRegistroFechado =
    'Portaria Interministerial MPA/MMA nº 19, de 24 de dezembro de 2024';

const textoDoRegistroFechado =
    'O REGISTRO DE NOVAS EMBARCAÇÕES NESTA MODALIDADE ESTÁ PROIBIDO.\n\n'
    'Art. 1º Fica proibido o registro de novas embarcações de pesca nas '
    'modalidades de permissionamento 1.2, 1.3, 1.4 e 1.15 do Anexo I da '
    'Instrução Normativa nº 10, de 10 de junho de 2011, do Ministério da '
    'Pesca e Aquicultura e do Ministério do Meio Ambiente.\n'
    'Parágrafo único. A proibição não se aplica ao Requerimento de '
    'Permissão Prévia de Pesca para Registro Inicial protocolado até a '
    'entrada em vigor desta Portaria Interministerial.\n\n'
    'O QUE CONTINUA PERMITIDO\n\n'
    'SUBSTITUIÇÃO (art. 2º). Permitida em caso de naufrágio, destruição '
    'ou desativação, desde que do mesmo proprietário. A substituta não '
    'pode ter capacidade de porão superior à substituída (§ 1º, I), e um '
    'mesmo proprietário pode substituir até três embarcações por uma só, '
    'desde que a nova não exceda a soma da capacidade de porão das '
    'substituídas (§ 1º, II). Naufrágio ou destruição pedem documento da '
    'autoridade marítima (§ 2º); desativação pede manifestação de '
    'interesse (§ 3º).\n\n'
    'TRANSFORMAÇÃO (art. 3º). Permitida desde que não se altere a '
    'capacidade de porão da embarcação.\n\n'
    'PESQUISA (art. 4º). A proibição não se aplica para fins de '
    'pesquisa, desde que autorizada pelos órgãos competentes.\n\n'
    'SANÇÃO (art. 5º). Lei nº 9.605, de 12 de fevereiro de 1998, e '
    'Decreto nº 6.514, de 22 de julho de 2008.\n\n'
    'Publicada no DOU de 27/12/2024, edição 249, seção 1, página 182. '
    'Em vigor na data da publicação (art. 7º).';

/// True quando a modalidade não aceita registro de embarcação nova.
bool temRegistroFechado(String numero) => registroFechado.contains(numero);

int get quantasComRedacaoNova => redacaoDe.length;

const List<Modalidade> modalidades = [
  Modalidade(
    '1.1',
    Metodo.linha,
    'Espinhel horizontal (superfície)',
    locais: 'Espinhel boiado e Long-line',
    alvo: 'Albacora laje (Thunnus albacares); Albacora branca (Thunnus alalunga); Albacora bandolim (Thunnus obesus)',
    incidental: 'Agulhão branco (Tetrapturus albidus); Agulhão negro (Makaira nigricans), Cação-bico-doce (Galeorhinus galeus); Cação-cola-fina, caçonete (Mustelus schmitti) Tubarão - peregrino (Cetorhinus maximus) Cação-lixa, tubarão-lixa, Lambaru (Ginglymostoma cirratum) Tubarão - baleia (Rhincodon typus) Cação-anjo-espinhoso (Squatina Guggenheim) Cação-anjo-liso (Squatina occulta) Cação bicudo, cação espátula, Quati (Isogomphodon oxyrhynchus) Tubarão Raposa (Alopias supercilliosus), Peixe-serra, espadarte (Pristis pectinata, P. perotteti), Tubarão-limão, papa-areia (Negaprion brevirostris), Albatroz-de- sobrancelha-negra (Thalassarche melanophrys), Albatroz-de-nariz-amarelo-do-atlântico (Thalassarche chlororhynchos), Albatroz-errante (Diomedea exulans), Albatrozde-Tristão (Diomedea dabbenena), Pardela-preta (Procellaria aequinoctialis), Pardela-de-óculos (Procellaria conspicillata), Pardelão-prateado (Fulmarus glacialoides), Bobo-grande-de-sobre- branco (Puffinus gravis), Tartaruga-verde (Chelonia mydas), Tartaruga-cabeçuda (Caretta caretta), Tartaruga-de-pente (Eretmochelys imbricata), Tartaruga-oliva (Lepidochelys olivacea) e Tartaruga-gigante (Dermochelys coriacea)',
    acompanhante: 'Tubarão azul (Prionace glauca), Tubarão lombo-preto, cação lombo-preto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação- bagre (Squalus acanthias, Squalus cubensis), Cação-espinho (Squalus blainville), Cação- malhado (Mustelus fasciatus), Agulhão verde (Tetrapturus pfluegeri), Agulhão vela (Istiophorus albicans), Albacora azul (Thunnus thynnus), Albacorinha (Thunnus atlanticus), Espadarte (Xiphias gladius), Bonito listrado (Katsuwonus pelamis), Bonito cachorro (Auxis thazard), Sarda (Sarda sarda), Cavala empige (Acantho-cybium solandri), Cavala (Scomberomorus cavalla), Serra (Scomberomorus brasiliensis), Peixe-lua (Mola mola), Dourado (Coryphaena hippurus), Peixe prego (Lepidocybium flavobrunneum, Ruvettus pretiosus), Cavalinha (Scomber japonicus), Raia santa (Rioraja agassizii), Raia carimbada (Atlantoraja cyclophora), Raia chita (Atlantoraja castelnaui), Raia emplasto (Atlantoraja platana, Sympterygia bonapartii, Sympterygia acuta), Raia (Breviraja spinosa, Rajella purpuriventralis)',
    complementar: 'Linha de mão (superfície), Espécies: Albacora laje (Thunnus albacares), Albacora branca (Thunnus alalunga), Albacora bandolim (Thunnus obesus), Tubarão azul (Prionace glauca), Tubarão lombo-preto, cação lombo-preto (Carcharhinus falciformis), Mako (Isurus oxyrinchus), Agulhão verde (Tetrapturus pfluegeri), Agulhão vela (Istiophorus albicans), Albacora azul (Thunnus thynnus), Albacorinha (Thunnus atlanticus), Espadarte (Xiphias gladius), Bonito listrado (Katsuwonus pelamis), Bonito cachorro (Auxis thazard), Sarda (Sarda sarda), Cavala empige (Acanthocybium solandri), Cavala (Scomberomorus cavalla), Serra (Scomberomorus brasiliensis), Dourado (Coryphaena hippurus)',
    area: 'Mar territorial; ZEE; e Águas internacionais',
    valeEmSc: true,
  ),
  Modalidade(
    '1.2',
    Metodo.linha,
    'Espinhel horizontal (superfície)',
    locais: 'Espinhel boiado e Long-line',
    alvo: 'Espadarte (Xiphias gladius)',
    incidental: 'Agulhão branco (Tetrapturus albidus), Agulhão negro (Makaira nigricans), Cação-bico-doce (Galeorhinus galeus), Cação-cola-fina, caçonete (Mustelus schmitti), Tubarão - peregrino (Cetorhinus maximus), Cação-lixa, tubarão-lixa, Lambaru (Ginglymostoma cirratum), Tubarão - baleia (Rhincodon typus), Cação-anjo-espinhoso (Squatina Guggenheim), Cação-anjo-liso (Squatina occulta), Cação bicudo, cação espátula, Quati (Isogomphodon oxyrhynchus), Tubarão Raposa (Alopias supercilliosus), Peixe-serra, espadarte (Pristis pectinata, P. perotteti), Tubarão-limão, papa-areia (Negaprion brevirostris), Albatroz-de-sobrancelha-negra (Thalassarche melanophrys), Albatroz-de-nariz-amarelo-do- atlântico (Thalassarche chlororhynchos), Albatroz-errante (Diomedea exulans), Albatrozde- Tristão (Diomedea dabbenena), Pardela-preta (Procellaria aequinoctialis), Pardela-de-óculos (Procellaria conspicillata), Pardelão-prateado (Fulmarus glacialoides), Bobo-grande-de-sobre- branco (Puffinus gravis), Tartaruga-verde (Chelonia mydas), Tartaruga-cabeçuda (Caretta caretta), Tartaruga-de-pente (Eretmochelys imbricata), Tartaruga-oliva (Lepidochelys olivacea) e Tartaruga-gigante (Dermochelys coriacea)',
    acompanhante: 'Tubarão azul (Prionace glauca), Tubarão lombo-preto, cação lombo-preto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação- bagre (Squalus acanthias, Squalus cubensis), Cação-espinho (Squalus blainville), Cação- malhado (Mustelus fasciatus), Agulhão verde, agulhãoestilete (Tetrapturus pfluegeri), Agulhão vela, agulhão bandeira (Istiophorus albicans), Albacora azul (Thunnus thynnus), Albacorinha (Thunnus atlanticus), Bonito listrado (Katsuwonus pelamis), Bonito cachorro (Auxis thazard), Sarda (Sarda sarda), Cavala empige (Acanthocybium solandri), Cavala (Scomberomorus cavalla), Serra (Scomberomorus brasiliensis), Peixe-lua (Mola mola), Dourado (Coryphaena hippurus), Peixe prego (Lepidocybium flavobrunneum, Ruvettus pretiosus), Cavalinha (Scomber japonicus), Raia santa (Rioraja agassizii), Raia carimbada (Atlantoraja cyclophora), Raia chita (Atlantoraja castelnaui), Raia emplasto (Atlantoraja platana, Sympterygia bonapartii, Sympterygia acuta), Raia (Breviraja spinosa, Rajella purpuriventralis)',
    complementar: 'Linha de mão (superfície), Espécies: Albacora laje (Thunnus albacares), Albacora branca (Thunnus alalunga), Albacora bandolim (Thunnus obesus), Tubarão azul (Prionace glauca), Tubarão lombo-preto, cação lombo-preto (Carcharhinus falciformis), Mako (Isurus oxyrinchus), Agulhão verde (Tetrapturus pfluegeri), Agulhão vela (Istiophorus albicans), Albacora azul (Thunnus thynnus), Albacorinha (Thunnus atlanticus), Espadarte ( Xiphias gladius), Bonito listrado (Katsuwonus pelamis), Bonito cachorro (Auxis thazard), Sarda (Sarda sarda), Cavala empige (Acanthocybium solandri), Cavala (Scomberomorus cavalla), Serra (Scomberomorus brasiliensis), Dourado (Coryphaena hippurus)',
    area: 'Mar territorial; ZEE; e Águas internacionais',
    valeEmSc: true,
  ),
  Modalidade(
    '1.3',
    Metodo.linha,
    'Espinhel horizontal (superfície) - com isca-viva',
    locais: 'Espinhel de Itaipava',
    alvo: 'Dourado (Coryphaena hippurus)',
    incidental: 'Agulhão branco (Tetrapturus albidus), Agulhão negro (Makaira nigricans), Cação-bico-doce (Galeorhinus galeus), Cação-cola-fina, caçonete (Mustelus schmitti), Tubarão - peregrino (Cetorhinus maximus), Cação-lixa, tubarão-lixa, Lambaru (Ginglymostoma cirratum), Tubarão - baleia (Rhincodon typus), Tubarão Raposa (Alopias supercilliosus), Peixe-serra, espadarte (Pristis pectinata, P. perotteti), Tubarão-limão, papa- areia (Negaprion brevirostris), Cação-anjo-espinhoso (Squatina guggenheim), Cação-anjoliso (Squatina occulta), Cação bicudo, cação espátula, Quati (Isogomphodon oxyrhynchus), Albatroz-de-sobrancelha-negra (Thalassarche melanophrys), Albatroz-de-nariz-amarelo-do- atlântico (Thalassarche chlororhynchos), Albatroz-errante (Diomedea exulans), Albatrozde- Tristão (Diomedea dabbenena), Pardela-preta (Procellaria aequinoctialis), Pardela-de-óculos (Procellaria conspicillata), Pardelão-prateado (Fulmarus glacialoides), Bobo-grande-de-sobre- branco (Puffinus gravis), Tartaruga-verde (Chelonia mydas), Tartaruga-cabeçuda (Caretta caretta), Tartaruga-de-pente (Eretmochelys imbricata), Tartaruga-oliva (Lepidochelys olivacea) e Tartaruga-gigante (Dermochelys coriacea)',
    acompanhante: 'Tubarão azul (Prionace glauca), Tubarão lombo-preto, Cação-lombo-preto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação-bagre (Squalus acanthias, Squalus cubensis), Cação-espinho (Squalus blainville), Cação-malhado (Mustelus fasciatus), Agulhão verde, agulhãoestilete (Tetrapturus pfluegeri), Agulhão vela, agulhão bandeira (Istiophorus albicans), Albacora azul (Thunnus thynnus), Albacorinha (Thunnus atlanticus), Espadarte (Xiphias gladius), Bonito listrado (Katsuwonus pelamis), Bonito cachorro (Auxis thazard), Sarda (Sarda sarda), Cavala empige (Acanthocybium solandri), Cavala (Scomberomorus cavalla), Serra (Scomberomorus brasiliensis), Peixe-lua (Mola mola), Peixe prego (Lepidocybium flavobrunneum, Ruvettus pretiosus), Cavalinha (Scomber japonicus), Raia santa (Rioraja agassizii), Raia carimbada (Atlantoraja cyclophora), Raia chita (Atlantoraja castelnaui), Raia emplasto (Atlantoraja platana, Sympterygia bonapartii, Sympterygia acuta), Raia (Breviraja spinosa, Rajella purpuriventralis)',
    complementar: 'Linha de mão (superfície), Espécies: Albacora laje (Thunnus albacares), Albacora branca (Thunnus alalunga), Albacora bandolim (Thunnus obesus), Tubarão azul (Prionace glauca), Tubarão lombo-preto (Carcharhinus falsiformis), Mako (Isurus oxyrinchus), Agulhão verde (Tetrapturus pfluegeri), Agulhão vela (Istiophorus albicans), Albacora azul (Thunnus thynnus), Albacorinha (Thunnus atlanticus), Espadarte (Xiphias gladius), Bonito listrado (Katsuwonus pelamis), Bonito cachorro (Auxis thazard), Sarda (Sarda sarda), Cavala empige (Acanthocybium solandri), Cavala (Scomberomorus cavalla), Serra (Scomberomorus brasiliensis), Dourado (Coryphaena hippurus)',
    area: 'Mar territorial S/SE; ZEE S/SE; e Águas internacionais',
    valeEmSc: true,
  ),
  Modalidade(
    '1.4',
    Metodo.linha,
    'Espinhel horizontal (superfície)',
    locais: 'Espinhel Boiado',
    alvo: 'Dourado (Coryphaena hippurus)',
    incidental: 'Agulhão branco (Tetrapturus albidus), Agulhão negro (Makaira nigricans), Tubarão raposa (Alopias supercilliosus), Cação-bico-doce (Galeorhinus galeus), Cação-cola- fina, caçonete (Mustelus schmitti), Tubarão - peregrino (Cetorhinus maximus), Cação-lixa, tubarão-lixa, Lambaru (Ginglymostoma cirratum), Tubarão - baleia (Rhincodon typus), Cação- anjo-espinhoso (Squatina Guggenheim), Cação-anjo-liso (Squatina occulta), Cação bicudo, cação espátula, Quati (Isogomphodon oxyrhynchus), Tubarão Raposa (Alopias supercilliosus), Peixe-serra, espadarte (Pristis pectinata, P. perotteti), Tubarão-limão, papa-areia (Negaprion brevirostris), Albatroz-de-sobrancelha-negra (Thalassarche melanophrys), Albatroz-de-nariz-amarelo-do-atlântico (Thalassarche chlororhynchos), Albatrozerrante (Diomedea exulans), Albatroz-de-Tristão (Diomedea dabbenena), Pardela- preta (Procellaria aequinoctialis), Pardela-de-óculos (Procellaria conspicillata), Pardelão- prateado (Fulmarus glacialoides), Bobo-grande-de-sobre-branco (Puffinus gravis), Tartaruga- verde (Chelonia mydas), Tartaruga-cabeçuda (Caretta caretta), Tartaruga-depente (Eretmochelys imbricata), Tartaruga-oliva (Lepidochelys olivacea) e Tartaruga-gigante (Dermochelys coriacea)',
    acompanhante: 'Tubarão azul (Prionace glauca), Tubarão lombo-preto, Cação-lombo-preto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação-bagre (Squalus acanthias, Squalus cubensis), Cação-espinho (Squalus blainville), Cação-malhado (Mustelus fasciatus), Agulhão verde, agulhãoestilete (Tetrapturus pfluegeri), Agulhão vela, agulhão bandeira (Istiophorus albicans), Albacora azul (Thunnus thynnus), Albacorinha (Thunnus atlanticus), Espadarte (Xiphias gladius), Bonito listrado (Katsuwonus pelamis), Bonito cachorro (Auxis thazard), Sarda (Sarda sarda), Cavala empige (Acanthocybium solandri), Cavala (Scomberomorus cavalla), Serra (Scomberomorus brasiliensis), Peixe-lua (Mola mola), Peixe prego (Lepidocybium flavobrunneum, Ruvettus pretiosus), Cavalinha (Scomber japonicus), Raia santa (Rioraja agassizii), Raia carimbada (Atlantoraja cyclophora), Raia chita (Atlantoraja castelnaui), Raia emplasto (Atlantoraja platana, Sympterygia bonapartii, Sympterygia acuta), Raia (Breviraja spinosa, Rajella purpuriventralis)',
    complementar: 'Linha de mão (superfície), Espécies: Albacora laje (Thunnus albacares), Albacora branca (Thunnus alalunga), Albacora bandolim (Thunnus obesus), Tubarão azul (Prionace glauca), Tubarão lombo-preto (Carcharhinus falsiformis), Mako (Isurus oxyrinchus), Agulhão verde (Tetrapturus pfluegeri), Agulhão vela (Istiophorus albicans), Albacora azul (Thunnus thynnus), Albacorinha (Thunnus atlanticus), Espadarte (Xiphias gladius), Bonito listrado (Katsuwonus pelamis), Bonito cachorro (Auxis thazard), Sarda (Sarda sarda), Cavala empige (Acanthocybium solandri), Cavala (Scomberomorus cavalla), Serra (Scomberomorus brasiliensis), Dourado (Coryphaena hippurus)',
    area: 'Mar territorial N/NE; ZEE N/NE; e Águas internacionais',
  ),
  Modalidade(
    '1.5',
    Metodo.linha,
    'Espinhel horizontal (fundo)',
    alvo: 'Dourada (Brachyplatystoma rousseauxii), Piramutaba (Brachyplatystoma vaillantii) Gurijuba (Arius parkeri)',
    incidental: 'Mero (Epinephelus itajara)',
    acompanhante: 'Tubarão azul (Prionace glauca), Tubarão lombo-preto, Cação-lombo-preto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação-bagre (Squalus acanthias, Squalus cubensis), Cação-espinho (Squalus blainville), Cação-malhado (Mustelus fasciatus), Bandeirado, bagre-de-penacho (Bagre bagre), Uricica, bagre-amarelo (Cathorops spixii), Cambéua, bagre-branco (Arius grandicassis), Raia santa (Rioraja agassizii), Raia carimbada (Atlantoraja cyclophora), Raia chita (Atlantoraja castelnaui), Raia emplasto (Atlantoraja platana, Sympterygia bonapartii, Sympterygia acuta), Raia (Breviraja spinosa, Rajella purpuriventralis), Pescada amarela (Cynoscion acoupa), Bagre-de-fita, (Bagre marinus), Bagre (Genidens barbus, Netuma planifrons); Bagre rosado (Genidens genidens, Genidens barbus)',
    complementar: 'Rede de espera (fundo), Espécies: Dourada (Brachyplatystoma rousseauxii), Piramutaba (Brachyplatystoma vaillantii) Gurijuba (Arius parkeri), Pescada amarela (Cynoscion acoupa), Camurim (Centropomus spp.)',
    area: 'Mar territorial N (AP ao PA); e ZEE N (AP ao PA)',
  ),
  Modalidade(
    '1.6',
    Metodo.linha,
    'Espinhel horizontal (fundo)',
    alvo: 'Garoupa, cherne pintado, cherne verdadeiro (Epinephelus niveatus), Garoupa vermelha-de-abrolhos (Epinephelus morio), Sirigado, badejo-quadrado (Mycteroperca bonaci), Badejo-da- areia (Mycteroperca microlepis), Xaréu, garacimbora, xarelete (Caranx latus), Garaximpora, xaréu (Caranx hippos), Arabaiana, olho de-boi (Seriola dumerili), Garajuba (Caranx crysus), Xaréu (Caranx latus), Garajuba amarela (Carangoides bartholomaei), Garaximbora (Caranx hippos), Palombeta (Chloroscombrus chrysurus), Peixe- rei (Elagatis bipinnulata), Timbira (Oligoplites saliens), Galo (Selene setapinnis), Galo-de- penacho (Selene vomer), Galo-do-alto (Alectis ciliaris), Xixarro (Trachurus lathami), Arabaiana (Seriola dumerili), (Seriola fasciata), Olhete (Seriola lalandi), Pampo (Trachinotus carolinus, Trachinotus falcatus, Trachinotus goodie), Pampo malhado (Trachinotus marginatus)',
    incidental: 'Mero (Epinephelus itajara), Cherne-poveiro (Polyprion americanus), Badejomira (Mycteroperca acutirostris), Tubarão lombopreto, Cação-lombo-preto (Carcharhinus falciformis), Mako (Isurus oxyrinchus), Raia santa (Rioraja agassizii), Raia carimbada (Atlantoraja cyclophora), Raia chita (Atlantoraja castelnaui), raia emplasto (Sympterygia bonapartii, Sympterygia acuta)',
    acompanhante: 'Dentão (Lutjanus jocu), Caranha (Lutjanus cyanopterus), Ariacó (Lutjanus synagris), Guaiúba (Ocyurus chrysurus), Pargo-piranga (Rhomboplites aurorubens), Tubarão azul (Prionace glauca), Cambéua, bagre-branco (Arius grandicassis), Bagre-defita, (Bagre marinus); Bandeirado, bagre-de-penacho (Bagre bagre), Bagre (Genidens barbus, Genidens planifrons), Uricica, bagre-amarelo (Cathorops spixii), Bagre rosado (Genidens genidens, Genidens barbus), Raia emplasto (Atlantoraja platana, Raia (Breviraja spinosa, Rajella purpuriventralis) e Pescada amarela (Cynoscion acoupa)',
    complementar: 'Linha de mão (fundo), Espécies: Garoupa, cherne pintado, cherne verdadeiro (Epinephelus niveatus), Garoupa- vermelha-de-abrolhos (Epinephelus morio), Sirigado, badejo-quadrado (Mycteroperca bonaci), Badejo-da- areia (Mycteroperca microlepis), Xaréu, garacimbora, xarelete (Caranx latus), Garaximpora, xaréu (Caranx hippos), Arabaiana, olho-de-boi (Seriola dumerili), Dentão (Lutjanus jocu), Caranha (Lutjanus cyanopterus), Ariacó (Lutjanus synagris), Guaiúba (Ocyurus chrysurus), Pargo-piranga (Rhomboplites aurorubens) Garajuba (Caranx crysus), Xaréu (Caranx latus), Garajuba amarela (Carangoides bartholomaei), Garaximbora (Caranx hippos), Palombeta (Chloroscombrus chrysurus), Peixe rei (Elagatis bipinnulata), Timbira (Oligoplites saliens), Galo (Selene setapinnis), Galo-de-penacho (Selene vomer), Galo-do-alto (Alectis ciliaris), Xixarro (Trachurus lathami), Arabaiana (Seriola dumerili), (Seriola fasciata), Olhete (Seriola lalandi), Pampo (Trachinotus carolinus, Trachinotus falcatus, Trachinotus goodie), Pampo malhado (Trachinotus marginatus)',
    area: 'Mar territorial NE; e ZEE NE',
  ),
  Modalidade(
    '1.7',
    Metodo.linha,
    'Espinhel horizontal (fundo)',
    alvo: 'Batata (Lopholatilus villarii), Abrótea de profundidade (Urophycis cirrata), Namorado (Pseudopercis numida), Garoupa, cherne pintado, cherne verdadeiro (Epinephelus niveatus), Bagre-branco, (Arius grandicassis), Bagre-de-fita, (Bagre marinus); Bagre-de- penacho (Bagre bagre), Bagre (Genidens barbus, Genidens planifrons), Bagre-amarelo (Cathorops spixii)',
    incidental: 'Cherne-poveiro (Polyprion americanus), Tubarão raposa (Alopias supercilliosus), Cação-bico-doce (Galeorhinus galeus), Cação-cola-fina, caçonete (Mustelus schmitti), Tubarão - peregrino (Cetorhinus maximus), Cação-lixa, tubarão-lixa, Lambaru (Ginglymostoma cirratum), Tubarão - baleia (Rhincodon typus), Cação-anjo-espinhoso (Squatina Guggenheim), Cação-anjo-liso (Squatina occulta), Cação bicudo, cação espátula, Quati (Isogomphodon oxyrhynchus), Tubarão raposa (Alopias supercilliosus), Peixe-serra, espadarte (Pristis pectinata, P. perotteti), Tubarão-limão, papa-areia (Negaprion brevirostris)',
    acompanhante: 'Tubarão azul (Prionace glauca), Tubarão lombo-preto, Cação-lombo-preto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação-bagre (Squalus acanthias, Squalus cubensis), Cação-espinho (Squalus blainville), Cação-malhado (Mustelus fasciatus), Sarrão (Helicolenus dactylopterus, Helicolenus lahillei), Pargo-rosa (Pagrus pagrus), Olho-decão (Priacanthus arenatus), Congro rosa (Genypterus brasiliensis), Congro-preto (Conger orbignianus, Myrophis punctatus, Raneya brasiliensis)',
    area: 'Mar territorial S/SE; e ZEE S/SE',
    valeEmSc: true,
  ),
  Modalidade(
    '1.8',
    Metodo.linha,
    'Espinhel vertical/covos',
    locais: 'Linha Pargueira, Caico e Bicicleta',
    alvo: 'Pargo (Lutjanus purpureus)',
    incidental: 'Mero (Epinephelus itajara)',
    acompanhante: 'Garoupa, cherne pintado, cherne verdadeiro (Epinephelus niveatus), Dentão (Lutjanus jocu), Caranha (Lutjanus cyanopterus), Ariacó (Lutjanus synagris), Guaiúba (Ocyurus chrysurus), Pargo-piranga (Rhomboplites aurorubens), Sirigado (Mycteroperca bonaci), Arabaiana (Seriola dumerili), Bejupira (Rachycentron canadum)',
    complementar: 'Linha de mão (superfície), Espécies: Cavala (Scomberomorus cavalla), Albacorinha (Thunnus atlanticus)',
    area: 'Mar territorial N/NE (AP a AL); e ZEE N/NE (AP a AL)',
  ),
  Modalidade(
    '1.9',
    Metodo.linha,
    'Espinhel vertical/Covos',
    locais: 'Linha Pargueira, Caico e Bicicleta',
    alvo: 'Pargo (Lutjanus purpureus)',
    incidental: 'Mero (Epinephelus itajara)',
    acompanhante: 'Garoupa, cherne pintado, cherne verdadeiro (Epinephelus niveatus), Dentão (Lutjanus jocu), Caranha (Lutjanus cyanopterus), Ariacó (Lutjanus synagris), Guaiúba (Ocyurus chrysurus), Pargo-piranga (Rhomboplites aurorubens), Sirigado (Mycteroperca bonaci), Arabaiana (Seriola dumerili), Bejupira (Rachycentron canadum)',
    complementar: 'Espinhel Horizontal Pelágico, Espécies: Albacora laje (Thunnus albacares), Albacora branca (Thunnus alalunga), Albacora bandolim (Thunnus obesus), Tubarão azul (Prionace glauca), Agulhão verde (Tetrapturus pfluegeri), Agulhão vela (Istiophorus albicans), Albacorinha (Thunnus atlanticus), Espadarte (Xiphias gladius), Bonito listrado (Katsuwonus pelamis), Bonito cachorro (Auxis thazard), Sarda (Sarda sarda), Cavala empige (Acanthocybium solandri), Cavala (Scomberomorus cavalla), Serra (Scomberomorus brasiliensis), Dourado (Coryphaena hippurus)',
    area: 'Mar territorial N/NE (AP a AL); e ZEE N/NE (AP a AL)',
  ),
  Modalidade(
    '1.10',
    Metodo.linha,
    'Espinhel vertical/Covos',
    locais: 'Linha Pargueira, Caico e Bicicleta',
    alvo: 'Pargo (Lutjanus purpureus)',
    incidental: 'Mero (Epinephelus itajara)',
    acompanhante: 'Garoupa, cherne pintado, cherne verdadeiro (Epinephelus niveatus), Dentão (Lutjanus jocu), Caranha (Lutjanus cyanopterus), Ariacó (Lutjanus synagris), Guaiúba (Ocyurus chrysurus), Pargo-piranga (Rhomboplites aurorubens), Sirigado (Mycteroperca bonaci), Arabaiana (Seriola dumerili), Bejupira (Rachycentron canadum)',
    complementar: 'Rede de emalhe de superfície, Espécies: Cavala (Scomberomorus cavalla), Serra (Scomberomorus brasiliensis), Curuca (Micropogonias furnieri), Timbira (Oligoplites saliens), Bonito (Katsuwonus pelamis), Tubarão azul (Prionace glauca), Cação- bagre (Squalus acanthias, Squalus cubensis), Cação espinho (Squalus blainville), Uritinga (Arius proops)',
    area: 'Mar territorial N/NE (AP a AL); e ZEE N/NE (AP a AL) (IN SEAP Nº 001/2007)',
  ),
  Modalidade(
    '1.11',
    Metodo.linha,
    'Espinhel vertical',
    locais: 'Linha Pargueira, Caico e Bicicleta',
    alvo: 'Dentão (Lutjanus jocu), Caranha (Lutjanus cyanopterus), Ariacó (Lutjanus synagris), Guaiúba (Ocyurus chrysurus), Pargo-piranga (Rhomboplites aurorubens)',
    incidental: 'Cherne-poveiro (Polyprion americanus), Tubarão raposa (Alopias supercilliosus), Cação-bico-doce (Galeorhinus galeus), Cação-cola-fina, caçonete (Mustelus schmitti), Tubarão - peregrino (Cetorhinus maximus), Cação-lixa, tubarão-lixa, Lambaru (Ginglymostoma cirratum), Tubarão - baleia (Rhincodon typus), Cação-anjo-espinhoso (Squatina Guggenheim), Cação-anjo-liso (Squatina occulta), Cação bicudo, cação espátula, Quati (Isogomphodon oxyrhynchus)',
    acompanhante: 'Garoupa, cherne pintado, cherne verdadeiro (Epinephelus niveatus), Garoupa-vermelha-deabrolhos (Epinephelus morio) Batata (Lopholatilus villariii), Uricica, bagre- amarelo (Cathorops spixii), Bandeirado, bagre-de-penacho (Bagre bagre), Cambéua, bagre-branco (Arius grandicassis), Bagre (Genidens barbus, Genidens planifrons), Bagre-amarelo (Cathorops spixii), Bagre rosado (Genidens genidens, Genidens barbus), Congro (Conger orbignyanus), Congro rosa (Genypterus brasiliensis), Namorado (Pseudopercis numida), Abrótea de fundo (Urophycis cirrata)',
    area: 'Mar territorial S/SE; e ZEE S/SE',
    valeEmSc: true,
  ),
  Modalidade(
    '1.12',
    Metodo.linha,
    'Linha de mão (fundo)',
    locais: 'Linha de mão',
    alvo: 'Bonito listrado (Katsuwonus pelamis), Bonito pintado (Euthynnus alletteratus), Bonito cachorro (Auxis thazard), Albacora bandolim (Thunnus obesus), Albacorinha (Thunnus atlanticus), Albacora branca (Thunnus albacares), Albacora laje (Thunnus alalunga), Cavala (Scomberomorus cavalla), Serra (Scomberomorus brasiliensis), Cavalinha (Scomber japonicus), Dentão (Lutjanus jocu), Caranha (Lutjanus cyanopterus), Ariacó (Lutjanus synagris), Guaiúba (Ocyurus chrysurus), Pargo-piranga (Rhomboplites aurorubens), Garoupa, cherne pintado, cherne verdadeiro (Epinephelus niveatus), Garoupa-vermelha-de-abrolhos (Epinephelus morio), Sirigado, badejoquadrado (Mycteroperca bonaci), Badejo-mira (Mycteroperca acutirostris), Badejo-da-areia (Mycteroperca microlepis), Xaréu, garacimbora, xarelete (Caranx latus), Garaximpora, xaréu (Caranx hippos), Arabaiana, olho-de-boi (Seriola dumerili, Seriola fasciata), Garajuba (Caranx crysus), Garajuba amarela (Carangoides bartholomaei), Garaximbora (Caranx hippos), Palombeta (Chloroscombrus chrysurus), Peixe- rei (Elagatis bipinnulata), Timbira, guaivira (Oligoplites saliens), Galo (Selene setapinnis), Galo-de-penacho (Selene vomer), Galo-do-alto (Alectis ciliaris), Xixarro (Trachurus lathami), Olhete (Seriola lalandi), Pampo (Trachinotus carolinus, Trachinotus falcatus, Trachinotus goodie), Pampo malhado (Trachinotus marginatus)',
    acompanhante: 'Cangulo, peroá (Balistes capriscus), Garoupa, Cherne pintado, Cherne verdadeiro (Epinephelus niveatus), Sirigado, badejo-quadrado (Mycteroperca bonaci), Arabaiana, olho-de-boi (Seriola dumerili)',
    complementar: 'Linha de mão (superfície), Espécie: Cavala (Scomberomorus cavalla)',
    area: 'Mar territorial NE',
  ),
  Modalidade(
    '1.13',
    Metodo.linha,
    'Linha/vara - com isca viva',
    alvo: 'Bonito listrado (Katsuwonus pelamis)',
    acompanhante: 'Albacora laje (Thunnus albacares), Albacora branca (Thunnus alalunga), Albacora bandolim (Thunnus obesus), Tubarão azul (Prionace glauca), Tubarão lombopreto, Cação-lombo-preto (Carcharhinus falciformis), Mako (Isurus oxyrinchus), Agulhão verde (Tetrapturus pfluegeri), Agulhão vela (Istiophorus albicans), Albacora azul (Thunnus thynnus), Albacorinha (Thunnus atlanticus), Espadarte (Xiphias gladius), Bonito cachorro (Auxis thazard), Sarda (Sarda sarda), Cavala empige (Acanthocybium solandri), Cavala (Scomberomorus cavalla), Serra (Scomberomorus brasiliensis), Dourado (Coryphaena hippurus)',
    complementar: 'Redes de cerco para captura de isca-viva: Espécies: sardinha verdadeira (Sardinella brasiliensis) (juvenil), Sardinha-cascuda (Harengula clupeola), Manjuba (Anchoa tricolor, Anchoa lyolepis ou Anchoa marinii), Manjubão (Lycengraulis grossidens), Anchoíta (Engraulis anchoita)',
    area: 'Mar territorial S/SE; e ZEE S/SE',
    valeEmSc: true,
  ),
  Modalidade(
    '1.14',
    Metodo.linha,
    'Linha de mão (fundo)',
    alvo: 'Garoupa, cherne pintado, cherne verdadeiro (Epinephelus niveatus), Corvina (Micropogonias furnieri)',
    incidental: 'Peroá (Balistes capriscus), Raia Viola (Rhinobatus horkelii, Rhinobatos percellens), Tubarão lombo-preto, Cação-lombo-preto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação-malhado (Mustelus fasciatus)',
    acompanhante: 'Baiacu (Lagocephalus laevigatus), Dentão(Lutjanus jocu), Caranha (Lutjanus cyanopterus), Ariacó (Lutjanus synagris), Guaiúba (Ocyurus chrysurus), Pargo-piranga (Rhomboplites aurorubens), Pargo rosa (Pagrus pagrus), Bagre-branco (Arius grandicassis), Bagre-de-fita (Bagre marinus), Bagre-de-penacho (Bagre bagre), Bagre (Genidens barbus, Netuma planifrons), Bagre amarelo (Cathorops spixii), Bagre rosado (Genidens genidens, Genidens barbus), Tubarão azul (Prionace glauca), Cação-bagre (Squalus acanthias, Squalus cubensis), Cação espinho (Squalus blainville), Sargo (Archosargus probatocephalus), Pampo (Trachinotus carolinus, Trachinotus falcatus, Trachinotus goodie), Pampo malhado (Trachinotus marginatus), Goete (Cynoscion jamaicensis), Betara (Menticirrhus americanus)',
    area: 'Mar territorial SE; e ZEE SE',
  ),
  Modalidade(
    '1.15',
    Metodo.linha,
    'Linha de mão (superfície)',
    locais: 'Corrico, Linha de Corso',
    alvo: 'Cavala (Scomberomorus cavalla), Albacorinhas (Thunnus atlanticus)',
    acompanhante: 'Dourado (Coryphaena hippurus), Agulhão vela (Istiophorus albicans), Albacora laje (Thunnus albacares), Albacora branca (Thunnus alalunga), Albacora bandolim (Thunnus obesus), Bonito listrado (Katsuwonus pelamis)',
    complementar: 'Rede de espera (superfície), Espécies: Serra (Scomberomorus brasiliensis), Bonito listrado (Katsuwonus pelamis), Tubarão azul (Prionace glauca), Tubarão lombopreto, Cação-lombo-preto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação-bagre (Squalus acanthias, Squalus cubensis), Cação-espinho (Squalus blainville), Cação-malhado (Mustelus fasciatus), Sardinha-laje (Opisthonema oglinum), Agulha (Hyporamphus unifasciatus, Hemiramphus brasiliensis), Tainha (Mugil platanus ou Mugil liza) (Mugil platanus), Mugil liza), Anchova (Pomatomus saltatrix), Coruruca, Corvina (MIcropogonias furnieri), Timbira (Oligoplites saliens), Uritinga (Arius proops), Cavala (Scomberomorus cavalla)',
    area: 'Mar territorial N/NE (AP a BA); e ZEE N/NE (AP a BA)',
  ),
  Modalidade(
    '1.16',
    Metodo.linha,
    'Linha-garatéia com atração luminosa',
    locais: 'Jigging machine, Iscador automático',
    alvo: 'Calamar Argentino (Illex argentinus), Calamar Vermelho (Ommastrephes bartramii)',
    acompanhante: 'Lula (Loligo sanpaulensis, Loligo surinamensis, Lolliguncula brevis, Doryteuthis plei, Sepioteuthis sepioidea)',
    area: 'ZEE S/SE',
    valeEmSc: true,
  ),
  Modalidade(
    '2.1',
    Metodo.emalhe,
    'Emalhe oceânico (superfície) - à deriva',
    locais: 'Malhão',
    alvo: 'Tubarão azul (Prionace glauca), Tubarão lombo-preto, Cação-lombo-preto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação-noturno (Carcharhinus signatus), Cação-bagre (Squalus acanthias, Squalus cubensis), Cação-espinho (Squalus blainville), Cação-malhado (Mustelus fasciatus)',
    incidental: 'Albatroz-de-sobrancelha-negra (Thalassarche melanophrys), Albatroz-de- nariz-amarelo-do-atlântico (Thalassarche chlororhynchos), Albatroz-errante (Diomedea exulans), Albatroz-de-Tristão (Diomedea dabbenena), Pardela-preta (Procellaria aequinoctialis), Pardela-de-óculos (Procellaria conspicillata), Pardelãoprateado (Fulmarus glacialoides), Bobo-grande-de-sobre-branco (Puffinus gravis), Tartaruga-verde (Chelonia mydas), Tartaruga-cabeçuda (Caretta caretta), Tartaruga-de-pente (Eretmochelys imbricata) Tartaruga-oliva (Lepidochelys olivacea ), Tartaruga-gigante (Dermochelys coriacea), Peixe-boi marinho (Trichechus manatus), Boto-cinza (Sotalia guianensis), Golfinho-de-dentes-rugosos (Steno bredanensis), Golfinho-rotador (Stenella longirostris), Golfinho-pintado-do-Atlântico (Stenella frontalis), Golfinho-comum (Delphinus delphis), Golfinho-nariz-de-garrafa (Tursiops truncatus), Toninha (Pontoporia blainvillei), Baleia-jubarte (Megaptera novaeangliae), Baleia- cachalote (Physeter macrocephalus)',
    acompanhante: 'Albacora laje (Thunnus albacares), Albacora branca (Thunnus alalunga), Albacora bandolim (Thunnus obesus), Agulhão verde (Tetrapturus pfluegeri), Agulhão vela (Istiophorus albicans), Albacora azul (Thunnus thynnus), Albacorinha (Thunnus atlanticus), Espadarte (Xiphias gladius), Bonito listrado (Katsuwonus pelamis), Bonito cachorro (Auxis thazard), Sarda (Sarda sarda), Cavala empige (Acanthocybium solandri), Cavala (Scomberomorus cavalla), Serra (Scomberomorus brasiliensis), Dourado (Coryphaena hippurus)',
    area: 'ZEE S/SE; e Águas internacionais',
    valeEmSc: true,
  ),
  Modalidade(
    '2.2',
    Metodo.emalhe,
    'Emalhe costeiro (superfície)',
    locais: 'Caceio',
    alvo: 'Tainha (Mugil platanus ou Mugil liza), Anchova (Pomatomus saltatrix), Sororoca, serra (Scomberomorus brasiliensis)',
    incidental: 'Tartaruga-verde (Chelonia mydas), Tartaruga-cabeçuda (Caretta caretta), Tartaruga-de-pente (Eretmochelys imbricata) Tartaruga-oliva (Lepidochelys olivacea ), Tartaruga-gigante (Dermochelys coriacea), Peixe-boi marinho (Trichechus manatus), Boto- cinza (Sotalia guianensis), Golfinho-de-dentes-rugosos (Steno bredanensis), Golfinho-rotador (Stenella longirostris), Golfinho-pintado-do-Atlântico (Stenella frontalis), Golfinho-comum (Delphinus delphis), Golfinho-nariz-de-garrafa (Tursiops truncatus), Toninha (Pontoporia blainvillei), Baleia-jubarte (Megaptera novaeangliae), Baleia-cachalote (Physeter macrocephalus)',
    acompanhante: 'Tubarão azul (Prionace glauca), Tubarão lombo-preto, Cação-lombo-preto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação-noturno (Carcharhinus signatus), Cação-bagre (Squalus acanthias, Squalus cubensis), Cação-espinho (Squalus blainville), Cação-malhado (Mustelus fasciatus), Peixe-espada (Trichiurus lepturus), Serrinha, Cavala Pintada (Scomberomorus maculatus), Prejereba (Lobotes surinamensis), Guaivira (Oligoplites saliens) Pampo (Trachinotus falcatus) Pampo- verdadeiro (Trachinotus carolinus), Pampo-listrado (Trachinotus goodei), Pampo-malhado (Trachinotus marginatus), Paru-branco (Chaetodipterus faber)',
    complementar: 'Linha de mão (superfície), Espécies: Sororoca, serra (Scomberomorus brasiliensis), Cavala (Scomberomorus cavalla), Guaivira (Oligoplites saliens), Prejereba (Lobotes surinamensis), Robalo (Centropomus parallelus, Centropomus undecimalis, Centropomus ensiferus, Centropomus pectinatus), Anchova (Pomatomus saltatrix); Lulas (Loligo plei, Loligo sanpaulensis, Loligo sp., Lolliguncula brevis) com o emprego de linha de mão com isca artificial ou natural denominada zangarilho, garateias ou outras denominações regionais e/ou tarrafas com auxílio de atração luminosa (apenas no mar territorial adjacente ao estado de Santa Catarina)',
    area: 'Mar territorial S/SE',
    valeEmSc: true,
  ),
  Modalidade(
    '2.3',
    Metodo.emalhe,
    'Emalhe oceânico (fundo)',
    alvo: 'Peixe sapo (Lophius gastrophysus)',
    incidental: 'Raia Viola (Rhinobatus horkelii, Rinobatos percellens), Agulhão branco (Tetrapturus albidus) e negro (Makaira nigricans), Tubarão raposa (Alopias supercilliosus), Cação-bicodoce (Galeorhinus galeus), Cação-cola-fina, caçonete (Mustelus schmitti), Tubarão - peregrino (Cetorhinus maximus), Cação-lixa, tubarão-lixa, Lambaru (Ginglymostoma cirratum), Tubarão - baleia (Rhincodon typus), Cação-anjo-espinhoso (Squatina Guggenheim), Cação-anjo-liso (Squatina occulta), Cação bicudo, cação espátula, Quati (Isogomphodon oxyrhynchus), Tartaruga-verde (Chelonia mydas), Tartaruga-cabeçuda (Caretta caretta), Tartaruga-de-pente (Eretmochelys imbricata) Tartaruga-oliva (Lepidochelys olivacea ), Tartaruga- gigante (Dermochelys coriacea)',
    acompanhante: 'Abrótea de profundidade (Urophycis cirrata), Merluza (Merluccius hubbsi), Batata (Lopholatilus villarii), Namorado (Pseudopercis numida), Congro rosa (Genypterus brasiliensis), Caranguejo-real (Chaceon ramosae), Caranguejo-vermelho (Chaceon notialis), Tubarão azul (Prionace glauca), Tubarão lombo-preto, Cação-lombo-preto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação-noturno (Carcharhinus signatus), Cação-bagre (Squalus acanthias, Squalus cubensis), Cação-espinho (Squalus blainville), Cação-malhado (Mustelus fasciatus), Garoupa, cherne pintado, cherne verdadeiro (Epinephelus niveatus)',
    area: 'Mar territorial S/SE (profundidades superiores a 250 metros); e ZEE S/SE (profundidades superiores a 250 metros)',
    valeEmSc: true,
  ),
  Modalidade(
    '2.4',
    Metodo.emalhe,
    'Emalhe costeiro (fundo)',
    alvo: 'Corvina (Micropogonias furnieri), Castanha (Umbrina canosai), Pescada (Cynoscion striatus), Abrotea (Urophycis brasiliensis)',
    complementar: 'Lulas (Loligo plei, Loligo sanpaulensis, Loligo sp., Lolliguncula brevis) com o emprego de linha de mão com isca artificial ou natural denominada zangarilho, garateias ou outras denominações regionais e/ou tarrafas com auxílio de atração luminosa (apenas no mar territorial adjacente ao estado de Santa Catarina)." (NR) - O Anexo III da Instrução Normativa MPA/MMA nº 10, de 10 de junho de 2011, do Ministério da Pesca e Aquicultura e do Ministério do Meio Ambiente e Mudança do Clima passa a vigorar com a seguinte redação: "',
    incidental: 'Raia Viola (Rhinobatus horkelii, Rinobatos percellens), Cação-anjo- espinhoso (Squatina Guggenheim), Cação-anjo-liso (Squatina occulta), Boto-cinza (Sotalia guianensis), Golfinho-de-dentes-rugosos (Steno bredanensis), Golfinho-rotador (Stenella longirostris), Golfinho-pintado-do-Atlântico (Stenella frontalis), Golfinho-comum (Delphinus delphis), Golfinho-nariz-de-garrafa (Tursiops truncatus), Toninha (Pontoporia blainvillei), Tartaruga-verde (Chelonia mydas), Tartaruga-cabeçuda (Caretta caretta), Tartarugade-pente (Eretmochelys imbricata) Tartaruga-oliva (Lepidochelys olivacea), Tartaruga-gigante (Dermochelys coriacea)',
    acompanhante: 'Savelha (Brevoortia pectinata), Cabrinha (Prionotus punctatus) Tubarão azul (Prionace glauca), Tubarão lombo-preto, Cação-lombo-preto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação-bagre (Squalus acanthias, Squalus cubensis), Cação-espinho (Squalus blainville), Cação-malhado (Mustelus fasciatus), Peixe-espada (Trichiurus lepturus, Trichiurus lepturus), Guavira (Oligoplites saliens), Linguado (Paralichthys brasiliensis, Paralichthys isósceles, Paralichthys triocellatus, Paralichthys patagonicus), Maria-luiza (Paralonchurus brasiliensis), Papa-terra, Betara (Menticirrhus americanus), Pescada amarela (Cynoscion acoupa), Pescada branca (Cynoscion leiarchus), Pescada bicuda (Cynoscion microlepidotus), Pescada cambucu (Cynoscion virescen), Pescadinha (Macrodon ancylodon), Raia santa (Rioraja agassizii), Raia carimbada (Atlantoraja cyclophora), Raia chita (Atlantoraja castelnaui), Raia emplasto (Atlantoraja platana, Sympterygia bonapartii, Sympterygia acuta), Raia (Breviraja spinosa, Rajella purpuriventralis), Anchova (Pomatomus saltatrix), Gordinho (Peprilus paru) (Peprilus paru) miracel, Merluza (Merluccius hubbsi), Tira-vira (Percophis brasiliensis), Congro rosa (Genypterus brasiliensis), Congro-preto (Conger orbignianus, Myrophis punctatus, Raneya brasiliensis), Namorado (Pseudopercis numida), Pargo rosa (Pagrus pagrus), Batata (Lopholatilus villarii), Bagre-branco, (Arius grandicassis); Bagre-de-fita, (Bagre marinus); Bagre-de-penacho (Bagre bagre), Bagre (Genidens barbus, Netuma planifrons); Bagre- amarelo (Cathorops spixii), Bagre rosado (Genidens genidens, Genidens barbus), Camarão branco (Litopenaeus schmitti), Robalo (Centropomus parallelus, Centropomus undecimalis, Centropomus ensiferus, Centropomus pectinatus), Prejereba (Lobotes surinamensis), Vermelho (Lutjanus jocu, Ocyurus chrysurus), Sororoca, serra (Scomberomorus brasiliensis), Siri-mangue (Callinectes exasperatus), Siri-azul (Callinectes sapidus), Siri nema (Callinectes bocourti), Siri (Callinectes danae, Callinectes ornatus), Goete (Cynoscion jamaicensis)',
    area: 'Mar territorial S/SE; e ZEE S/SE',
    valeEmSc: true,
  ),
  Modalidade(
    '2.5',
    Metodo.emalhe,
    'Emalhe costeiro (superfície)',
    alvo: 'Serra (Scomberomorus brasiliensis)',
    incidental: 'Tartaruga-verde (Chelonia mydas), Tartaruga-cabeçuda (Caretta caretta), Tartaruga-de-pente (Eretmochelys imbricata) Tartaruga-oliva (Lepidochelys olivacea ), Tartaruga-gigante (Dermochelys coriacea), Peixe-boi marinho (Trichechus manatus), Boto- cinza (Sotalia guianensis), Golfinho-de-dentes-rugosos (Steno bredanensis), Golfinho-rotador (Stenella longirostris), Golfinho-pintado-do-Atlântico (Stenella frontalis), Golfinho-comum (Delphinus delphis), Golfinho-nariz-de-garrafa (Tursiops truncatus), Baleia-jubarte (Megaptera novaeangliae), Baleia-cachalote (Physeter macrocephalus)',
    acompanhante: 'Bonito-listrado (Katsuwonus pelamis), Tubarão azul (Prionace glauca), Tubarão lombo-preto, Cação-lombo-preto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação-bagre (Squalus acanthias, Squalus cubensis), Cação-espinho (Squalus blainville), Cação-malhado (Mustelus fasciatus), Beijuperá (Rachycentron canadum), Sardinha-laje (Opisthonema oglinum), Camurim, Robalo (Centropomus parallelus, Centropomus undecimalis, Centropomus ensiferus, Centropomus pectinatus), Camurupim (Megalops atlanticus), Cavala (Scomberomorus cavalla), Cururuca, corvina (Micropogonias furnieri), Uritinga (Arius proops)',
    complementar: 'Linha de mão (superfície), Espécies: Cavala (Scomberomorus cavalla), Dourado (Coryphaena hippurus), Albacora laje (Thunnus albacares), Albacora bandolim (Thunnus obesus)',
    area: 'Mar territorial N/NE; e ZEE N/NE',
  ),
  Modalidade(
    '2.6',
    Metodo.emalhe,
    'Emalhe costeiro (superfície)',
    alvo: 'Sardinha-laje (Opisthonema oglinum)',
    incidental: 'Tartaruga-verde (Chelonia mydas), Tartaruga-cabeçuda (Caretta caretta), Tartaruga-de-pente (Eretmochelys imbricata) Tartaruga-oliva (Lepidochelys olivacea ), Tartaruga-gigante (Dermochelys coriacea)',
    acompanhante: 'Bonito-listrado (Katsuwonus pelamis), Tubarão azul (Prionace glauca), Tubarão lombo-preto, Cação-lombo-preto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação-bagre (Squalus acanthias, Squalus cubensis), Cação-espinho (Squalus blainville), Cação-malhado (Mustelus fasciatus)',
    complementar: 'Linha de mão (superfície), Espécies: Cavala (Scomberomorus cavalla), Dourado (Coryphaena hippurus), Albacora laje (Thunnus albacares), Albacora bandolim (Thunnus obesus)',
    area: 'Mar territorial NE; e ZEE NE',
  ),
  Modalidade(
    '2.7',
    Metodo.emalhe,
    'Emalhe costeiro (superfície)',
    alvo: 'Agulha (Hyporamphus unifasciatus, Hemiramphus brasiliensis)',
    incidental: 'Tartaruga-verde (Chelonia mydas), Tartaruga-cabeçuda (Caretta caretta), Tartaruga-de-pente (Eretmochelys imbricata) Tartaruga-oliva (Lepidochelys olivacea ), Tartaruga-gigante (Dermochelys coriacea)',
    acompanhante: 'Sardinha-laje (Opisthonema oglinum)',
    complementar: 'Linha de mão (superfície), Espécies: Cavala (Scomberomorus cavalla), Dourado (Coryphaena hippurus), Albacora laje (Thunnus albacares), Albacora bandolim (Thunnus obesus)',
    area: 'Mar territorial NE; e ZEE NE',
  ),
  Modalidade(
    '2.8',
    Metodo.emalhe,
    'Emalhe costeiro (superfície)',
    alvo: 'Tainha, pratiqueira, saúna, parati, parati-caraamarela (Mugil curema, M. Liza)',
    incidental: 'Tartaruga-verde (Chelonia mydas), Tartaruga-cabeçuda (Caretta caretta), Tartaruga-de-pente (Eretmochelys imbricata) Tartaruga-oliva (Lepidochelys olivacea ), Tartaruga-gigante (Dermochelys coriacea), Peixe-boi marinho (Trichechus manatus), Boto- cinza (Sotalia guianensis), Golfinho-de-dentes-rugosos (Steno bredanensis), Golfinho-rotador (Stenella longirostris), Golfinho-pintado-do-Atlântico (Stenella frontalis), Golfinho-comum (Delphinus delphis), Golfinho-nariz-de-garrafa (Tursiops truncatus), Baleia-jubarte (Megaptera novaeangliae), Baleia-cachalote (Physeter macrocephalus)',
    acompanhante: 'Sardinha-laje (Opisthonema oglinum), Camurim, robalo (Centropomus parallelus, Centropomus undecimalis, Centropomus ensiferus, Centropomus pectinatus)',
    complementar: 'Linha de mão (superfície), Espécies: Cavala (Scomberomorus cavalla), Dourado (Coryphaena hippurus), Albacora laje (Thunnus albacares), Albacora bandolim (Thunnus obesus)',
    area: 'Mar territorial N/NE; e ZEE N/NE',
  ),
  Modalidade(
    '2.9',
    Metodo.emalhe,
    'Emalhe oceânico (superfície)',
    alvo: 'Peixe voador (Hirundichthys affinis, Cheilopogon cyanopterus)',
    incidental: 'Tartaruga-verde (Chelonia mydas), Tartaruga-cabeçuda (Caretta caretta), Tartaruga-de-pente (Eretmochelys imbricata) Tartaruga-oliva (Lepidochelys olivacea ), Tartaruga-gigante (Dermochelys coriacea)',
    complementar: 'Linha de mão (superfície), Espécies: Cavala (Scomberomorus cavalla), Dourado (Coryphaena hippurus), Albacora laje (Thunnus albacares), Albacora bandolim (Thunnus obesus)',
    area: 'Mar territorial NE; e ZEE NE',
  ),
  Modalidade(
    '2.10',
    Metodo.emalhe,
    'Emalhe costeiro (fundo)',
    locais: 'Gozeira',
    alvo: 'Pescada gó (Macrodon ancylodon), Camurim, Robalo (Centropomus parallelus, Centropomus undecimalis, Centropomus ensiferus, Centropomus pectinatus), Cururuca, corvina (Micropogonias furnieri)',
    incidental: 'Mero (Epinephelus itajara), Tartarugaverde (Chelonia mydas), Tartaruga- cabeçuda (Caretta caretta), Tartaruga-de-pente (Eretmochelys imbricata) Tartaruga-oliva (Lepidochelys olivacea), Tartaruga-gigante (Dermochelys coriacea), Peixe-boi marinho (Trichechus manatus), Boto-cinza (Sotalia guianensis), Golfinho-de-dentes-rugosos (Steno bredanensis), Golfinho-rotador (Stenella longirostris), Golfinho-pintado-do-Atlântico (Stenella frontalis), Golfinho-comum (Delphinus delphis), Golfinho-nariz-de-garrafa (Tursiops truncatus), Baleia-jubarte (Megaptera novaeangliae), Baleia-cachalote (Physeter macrocephalus)',
    acompanhante: 'Tubarão azul (Prionace glauca), Tubarão lombo-preto, Cação-lombo-preto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação-bagre (Squalus acanthias, Squalus cubensis), Cação-espinho (Squalus blainville), Cação-malhado (Mustelus fasciatus), carapeba Xira (Haemulon aurolineatum, Haemulon melanurum), Budião (Sparisoma chrysopterum), Garajuba (Caranx crysus), Xaréu (Caranx latus), Garajuba amarela (Carangoides bartholomaei), Garaximbora (Caranx hippos), Palombeta (Chloroscombrus chrysurus), Peixe-rei (Elagatis bipinnulata), Timbira (Oligoplites saliens), Galo (Selene setapinnis), Galo-depenacho (Selene vomer), Galo-do-alto (Alectis ciliaris), Xixarro (Trachurus lathami), Arabaiana (Seriola dumerili), (Seriola fasciata), Olhete (Seriola lalandi), Pampo (Trachinotus carolinus, Trachinotus falcatus, Trachinotus goodie), Pampo malhado (Trachinotus marginatus), Cabeçudo vermelho (Stellifer stellifer), Pescada amarela (Cynoscion acoupa), Pescada, goete (Cynoscion jamaicensis), Pescada branca (Cynoscion leiarchus), Boca mole (Larimus breviceps), Pescada Gó, Pescadinha real (Macrodon ancylodon), Papa terra, Judeu, Betara (Menticirrhus americanus), Corvina, Cururuca (Micropogonias furnieri), Maria Luisa (Paralonchurus brasiliensis), Cabeçudo, Cangoá (Stellifer brasiliensis), Cabeçudo vermelho, Cangoá (Stellifer rastrifer), Cabeçudo Preto, Cangoá (Stellifer naso), Castanha, Cabeça de coco (Umbrina canosai), Miraguaia (Pogonias cromis), Bagre-de-fita, (Bagre marinus); Bagre (Genidens barbus, Netuma planifrons); Uricica, bagre-amarelo (Cathorops spixii), Bandeirado, bagre-de-penacho (Bagre bagre), Cambéua, bagre-branco (Arius grandicassis), Bagre rosado (Genidens genidens, Genidens barbus), Raia santa (Rioraja agassizii), Raia carimbada (Atlantoraja cyclophora), Raia chita (Atlantoraja castelnaui), Raia emplasto (Atlantoraja platana, Sympterygia bonapartii, Sympterygia acuta), Raia (Breviraja spinosa, Rajella purpuriventralis)',
    area: 'Mar territorial N/NE (AP a MA); e ZEE N/NE (AP a MA)',
  ),
  Modalidade(
    '2.11',
    Metodo.emalhe,
    'Emalhe costeiro (fundo)',
    locais: 'Pescadeira',
    alvo: 'Pescada amarela (Cynoscion acoupa), Gurijuba (Arius parkeri), Camurim, Robalo (Centropomus parallelus, Centropomus undecimalis, Centropomus ensiferus, Centropomus pectinatus)',
    incidental: 'Mero (Epinephelus itajara), Tartarugaverde (Chelonia mydas), Tartaruga- cabeçuda (Caretta caretta), Tartaruga-de-pente (Eretmochelys imbricata) Tartaruga-oliva (Lepidochelys olivacea ), Tartaruga-gigante (Dermochelys coriacea), Peixe-boi marinho (Trichechus manatus), Boto-cinza (Sotalia guianensis), Golfinho-de-dentes-rugosos (Steno bredanensis), Golfinho-rotador (Stenella longirostris), Golfinho-pintado-do-Atlântico (Stenella frontalis), Golfinho-comum (Delphinus delphis), Golfinho-nariz-de-garrafa (Tursiops truncatus), Baleia-jubarte (Megaptera novaeangliae), Baleia-cachalote (Physeter macrocephalus)',
    acompanhante: 'Tubarão azul (Prionace glauca), Tubarão lombo-preto, Cação-lombo-preto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação-bagre (Squalus acanthias, Squalus cubensis), Cação-espinho (Squalus blainville), Cação-malhado (Mustelus fasciatus), Carapeba (Diapterus auratus), Xira (Haemulon aurolineatum, Haemulon melanurum), Budião (Sparisoma chrysopterum), Garajuba (Caranx crysus), Xaréu (Caranx latus), Garajuba amarela (Carangoides bartholomaei), Garaximbora (Caranx hippos), Palombeta (Chloroscombrus chrysurus), Peixe-rei (Elagatis bipinnulata), Timbira (Oligoplites saliens), Galo (Selene setapinnis), Galo-de-penacho (Selene vomer), Galo-do-alto (Alectis ciliaris), Xixarro (Trachurus lathami), Arabaiana (Seriola dumerili), (Seriola fasciata), Olhete (Seriola lalandi), Pampo (Trachinotus carolinus, Trachinotus falcatus, Trachinotus goodie), Pampo malhado (Trachinotus marginatus), Cabeçudo vermelho (Stellifer stellifer), Pescada amarela (Cynoscion acoupa), Pescada, goete (Cynoscion jamaicensis), Pescada branca (Cynoscion leiarchus), Boca mole (Larimus breviceps), Pescada Gó, Pescadinha real (Macrodon ancylodon), Papa terra, Judeu, Betara (Menticirrhus americanus), Corvina, Cururuca (Micropogonias furnieri), Maria Luisa (Paralonchurus brasiliensis), Cabeçudo, Cangoá (Stellifer brasiliensis), Cabeçudo vermelho, Cangoá (Stellifer rastrifer), Cabeçudo Preto, Cangoá (Stellifer naso), Castanha, Cabeça de coco (Umbrina canosai), Miraguaia (Pogonias cromis)',
    complementar: 'Rede de espera (superfície), Espécies: Serra (Scomberomorus brasiliensis), Agulha (Hyporamphus unifasciatus, Hemiramphus brasiliensis), Peixe-voador (Hirundichthys affinis, Cheilopogon cyanopterus), Tainha, pratiqueira, saúna, parati, parati- cara-amarela (Mugil curema), Sardinha-laje (Opisthonema oglinum)',
    area: 'Mar territorial N/NE (AP a MA); e ZEE N/NE (AP a MA)',
  ),
  Modalidade(
    '2.12',
    Metodo.emalhe,
    'Emalhe costeiro (fundo)',
    locais: 'Douradeira',
    alvo: 'Piramutaba (Brachyplatystoma vaillantii), Dourada (Brachyplatystoma rousseauxii)',
    incidental: 'Mero (Epinephelus itajara), Tartarugaverde (Chelonia mydas), Tartaruga- cabeçuda (Caretta caretta), Tartaruga-de-pente (Eretmochelys imbricata) Tartaruga-oliva (Lepidochelys olivacea ), Tartaruga-gigante (Dermochelys coriacea), Peixe-boi marinho (Trichechus manatus), Boto-cinza (Sotalia guianensis), Golfinho-de-dentes-rugosos (Steno bredanensis), Golfinho-rotador (Stenella longirostris), Golfinho-pintado-do-Atlântico (Stenella frontalis), Golfinho-comum (Delphinus delphis), Golfinho-nariz-de-garrafa (Tursiops truncatus), Baleia-jubarte (Megaptera novaeangliae), Baleia-cachalote (Physeter macrocephalus)',
    acompanhante: 'Bagre-de-fita, (Bagre marinus); Bagre (Genidens barbus, Netuma planifrons); Uricica, bagreamarelo (Cathorops spixii), Bandeirado, bagre-de-penacho (Bagre bagre), Cambéua, bagre-branco (Arius grandicassis), Bagre rosado (Genidens genidens, Genidens barbus), Cabeçudo vermelho (Stellifer stellifer), Pescada amarela (Cynoscion acoupa), Pescada, goete (Cynoscion jamaicensis), Pescada branca (Cynoscion leiarchus), Boca mole (Larimus breviceps), Pescada Gó, Pescadinha real (Macrodon ancylodon), Papa terra, Judeu, Betara (Menticirrhus americanus), Corvina, Cururuca (Micropogonias furnieri), Maria Luisa (Paralonchurus brasiliensis), Cabeçudo, Cangoá (Stellifer brasiliensis, Stellifer rastrifer, Stellifer naso), Castanha, Cabeça de coco (Umbrina canosai), Miraguaia (Pogonias cromis)',
    area: 'Mar territorial N; e Estuário da Bacia Amazônica',
  ),
  Modalidade(
    '2.2-A',
    Metodo.emalhe,
    'Emalhe anilhado',
    locais: 'rede anilhada',
    alvo: 'Tainha (Mugil liza), exclusivamente',
    area: 'Mar territorial S/SE. Proibido operar com embarcação motorizada '
        'na faixa de 1 milha náutica medida da linha de costa (art. 3º, VI). '
        'Em Santa Catarina, toda a produção deve ser desembarcada no próprio '
        'estado (art. 13, § 3º).',
    valeEmSc: true,
    regras: 'Autorização complementar ao emalhe costeiro de superfície, '
        'item 2.2 do Anexo II da IN 10, incluída pelo art. 18 da Portaria '
        'Interministerial nº 24/2018.\n\n'
        'Temporada: de 15 de maio a 31 de julho (art. 2º, III).\n\n'
        'Panagens exclusivamente de fio de náilon; fio de seda só no '
        'ensacador e no calço. Comprimento máximo de 800 m e altura máxima '
        'de 60 m, com as malhas esticadas. Malha do corpo da rede entre 7 e '
        '12 cm, medida entre nós opostos. Proibido caíco motorizado, power '
        'block e sonar de varredura.\n\n'
        'Embarcações com Arqueação Bruta menor ou igual a 10 AB. Uma '
        'autorização por proprietário. Desde 1º de janeiro de 2020, exige '
        'rastreamento por satélite pelo PREPS. Não há concessão de novas '
        'autorizações (art. 22).',
    norma: 'Portaria Interministerial nº 24, de 15 de maio de 2018',
  ),
  Modalidade(
    '3.1',
    Metodo.arrasto,
    'Arrasto (fundo), parelha ou trilheira (*)',
    alvo: 'Piramutaba (Brachyplatystoma vaillantii)',
    incidental: 'Peixe-serra, tubarão-serra (Pristis perotteti, Pristis pectinata)',
    acompanhante: 'Bagre-branco, (Arius grandicassis); Bagre-de-fita, (Bagre marinus); Bagre-de-penacho (Bagre bagre), Bagre (Genidens barbus, Netuma planifrons); Bagre-amarelo (Cathorops spixii), Bagre rosado (Genidens genidens, Genidens barbus), Dourada (Brachyplatystoma rousseauxii), Pescada branca (Cynoscion leiarchus), Raia santa (Rioraja agassizii), Raia carimbada (Atlantoraja cyclophora), Raia chita (Atlantoraja castelnaui), Raia emplasto (Atlantoraja platana, Sympterygia bonapartii, Sympterygia acuta), Raia (Breviraja spinosa, Rajella purpuriventralis)',
    complementar: 'Arrasto (fundo) - Simples ou parelha, Espécies: Bagre-branco, (Arius grandicassis); Bagre-de-fita, (Bagre marinus); Bagre-de-penacho (Bagre bagre), Bagre (Genidens barbus, Genidens planifrons), Bagre-amarelo (Cathorops spixii), Bagre rosado (Genidens genidens, Genidens barbus), Dourada (Brachyplatystoma rousseauxii), Pescada branca (Cynoscion leiarchus), Raia santa (Rioraja agassizii), Raia carimbada (Atlantoraja cyclophora), Raia chita (Atlantoraja castelnaui), Raia emplasto (Atlantoraja platana, Sympterygia bonapartii, Sympterygia acuta), Raia (Breviraja spinosa, Rajella purpuriventralis), Pescada amarela (Cynoscion acoupa), Pescada gó (Macrodon ancylodon), Corvina, Cururuca (Micropogonias furnieri), Tainha, pratiqueira, saúna, parati, parati-cara-amarela (Mugil curema, Mugil liza)',
    area: 'Mar territorial N; e ZEE N',
  ),
  Modalidade(
    '3.2',
    Metodo.arrasto,
    'Arrasto (fundo) - Simples ou parelha',
    alvo: 'Uricica, bagre-amarelo (Cathorops spixii), Bandeirado, bagre-de-penacho (Bagre bagre), Cambéua, bagre-branco (Arius grandicassis), Bagre-de-fita, (Bagre marinus), Bagre (Genidens barbus, Netuma planifrons); Bagre rosado (Genidens genidens, Genidens barbus), Dourada (Brachyplatystoma rousseauxii), Pescada branca (Cynoscion leiarchus), Raia santa (Rioraja agassizii), Raia carimbada (Atlantoraja cyclophora), Raia chita (Atlantoraja castelnaui), Raia emplasto (Atlantoraja platana, Sympterygia bonapartii, Sympterygia acuta), Raia (Breviraja spinosa, Rajella purpuriventralis), Pescada amarela (Cynoscion acoupa), Corvina, Cururuca (Micropogonias furnieri), Pescada gó (Macrodon ancylodon), Tainha, pratiqueira, saúna, parati, parati-cara-amarela (Mugil curema, Mugil liza)',
    area: 'Mar Territorial N; e ZEE N. (Polígono definido no Anexo I da INI MPA/MMA nº 02/2010)',
  ),
  Modalidade(
    '3.3',
    Metodo.arrasto,
    'Arrasto (fundo) - duplo ou simples (**)',
    locais: 'Tagones e popa',
    alvo: 'Camarão rosa (Farfantepenaeus brasiliensis, Farfantepenaeus subtilis) Camarão sete-barbas (Xiphopenaeus kroyeri), Camarão branco (Litopenaeus schmitti)',
    incidental: 'Tartaruga-verde (Chelonia mydas), Tartaruga-cabeçuda (Caretta caretta), Tartaruga-de-pente (Eretmochelys imbricata) Tartaruga-oliva (Lepidochelys olivacea ), Tartaruga-gigante (Dermochelys coriacea)',
    acompanhante: 'Pescada gó (Macrodon ancylodon), Boca-mole (Larimus breviceps), Pescada, goete (Cynoscion jamaicensis), Trilha (Mullus argentinae), Palombeta (Chloroscombrus chrysurus), Xaréu (Caranx latus), Cururuca, corvina (Micropogonias furnieri), Camarão sete-barbas, Camarão espigão (Xiphopenaeus kroyeri)',
    complementar: 'Arrasto (fundo) - Simples ou parelha, Espécies: Uricica, bagre- amarelo (Cathorops spixii), Bandeirado, bagre-de-penacho (Bagre bagre), Cambéua, bagre- branco (Arius grandicassis), Bagre-de-fita, (Bagre marinus); Bagre (Genidens barbus, Genidens planifrons), Bagre rosado (Genidens genidens, Genidens barbus), Dourada (Brachyplatystoma rousseauxii), Pescada branca (Cynoscion leiarchus), Raia santa (Rioraja agassizii), Raia carimbada (Atlantoraja cyclophora), Raia chita (Atlantoraja castelnaui), Raia emplasto (Atlantoraja platana, Sympterygia bonapartii, Sympterygia acuta), Raia (Breviraja spinosa, Rajella purpuriventralis), Pescada amarela (Cynoscion acoupa), Pescada gó (Macrodon ancylodon), Cururuca, corvina (Micropogonias furnieri), Tainha, pratiqueira, saúna, parati, parati-cara-amarela (Mugil curema, Mugil liza)',
    area: 'Mar territorial N/NE (AP ao PI); e ZEE N/NE (AP ao PI). Autorização Complementar: Polígono definido no Anexo I da INI MPA/MMA nº 02/2010',
  ),
  Modalidade(
    '3.4',
    Metodo.arrasto,
    'Arrasto (fundo) - duplo ou simples',
    locais: 'Tagones e popa',
    alvo: 'Camarão rosa (Farfantepenaeus brasiliensis, Farfantepenaeus subtilis) Camarão sete-barbas (Xiphopenaeus kroyeri), Camarão branco (Litopenaeus schmitti)',
    incidental: 'Tartaruga-verde (Chelonia mydas), Tartaruga-cabeçuda (Caretta caretta), Tartaruga-de-pente (Eretmochelys imbricata) Tartaruga-oliva (Lepidochelys olivacea ), Tartaruga-gigante (Dermochelys coriacea)',
    acompanhante: 'Pescada gó (Macrodon ancylodon), Boca-mole (Larimus breviceps), Pescada, goete (Cynoscion jamaicensis), Trilha (Mullus argentinae), Palombeta (Chloroscombrus chrysurus), Xaréu (Caranx latus), Cururuca, corvina (Micropogonias furnieri), Camarão sete-barbas, Camarão espigão (Xiphopenaeus kroyeri)',
    complementar: 'Emalhe costeiro (superfície), Espécies: Serra (Scomberomorus brasiliensis), Albacora laje (Thunnus albacares), Albacora branca (Thunnus alalunga), Albacora bandolim (Thunnus obesus)',
    area: 'Mar territorial N/NE (MA ao PI); e ZEE N/NE (MA ao PI)',
  ),
  Modalidade(
    '3.5',
    Metodo.arrasto,
    'Arrasto (fundo) - duplo ou simples',
    locais: 'Tangones',
    alvo: 'Camarão rosa (Farfantepenaeus brasiliensis, Farfantepenaeus subtilis) Camarão sete-barbas (Xiphopenaeus kroyeri), Camarão branco (Litopenaeus schmitti)',
    incidental: 'Tartaruga-verde (Chelonia mydas), Tartaruga-cabeçuda (Caretta caretta), Tartaruga-de-pente (Eretmochelys imbricata) Tartaruga-oliva (Lepidochelys olivacea ), Tartaruga-gigante (Dermochelys coriacea)',
    acompanhante: 'Pescada amarela (Cynoscion acoupa), Pescada, goete (Cynoscion jamaicensis), Pescada branca (Cynoscion leiarchus), Boca mole (Larimus breviceps), Pescada GO (Macrodon ancylodon), Pescadinha real (Macrodon ancylodon), Papa terra, Judeu, Betara (Menticirrhus americanus), Corvina, Cururuca (Micropogonias furnieri), Maria Luisa (Paralonchurus brasiliensis), Cabeçudo, Cangoá (Stellifer brasiliensis), Cabeçudo vermelho, Cangoá (Stellifer rastrifer), Cabeçudo Preto, Cangoá (Stellifer naso), Castanha, Cabeça de coco (Umbrina canosai), Miraguaia (Pogonias cromis), Coró (Genyatremus luteus)',
    complementar: 'Linha de mão (fundo), Espécies: Cioba (Lutjanus analis), Guaiúba (Ocyurus chrysurus), Dentão (Lutjanus jocu)',
    area: 'Mar territorial NE (CE a BA)',
  ),
  Modalidade(
    '3.6',
    Metodo.arrasto,
    'Arrasto (fundo) - duplo',
    locais: 'Tangones',
    alvo: 'Camarão rosa (Farfantepenaeus brasiliensis, Farfantepenaeus subtilis, Farfantepenaeus paulensis), Camarão Santana (Pleoticus muelleri), Camarão barba ruça (Artemesia longinaris)',
    incidental: 'Tartaruga-verde (Chelonia mydas), Tartaruga-cabeçuda (Caretta caretta), Tartaruga-de-pente (Eretmochelys imbricata) Tartaruga-oliva (Lepidochelys olivacea ), Tartaruga-gigante (Dermochelys coriacea), Cherne poveiro (Polyprion americanus), Mero (Epinephelus itajara), Raia Viola (Rhinobatus horkelii, Rinobatos percellens), Agulhão branco (Tetrapturus albidus), Agulhão negro (Makaira nigricans), Cação-bico-doce (Galeorhinus galeus), Caçãocola-fina, caçonete, Boca de velho (Mustelus schmitti), Tubarão - peregrino (Cetorhinus maximus), Cação-lixa, tubarão-lixa, Lambaru (Ginglymostoma cirratum), Tubarão - baleia (Rhincodon typus), Cação-anjo-espinhoso (Squatina Guggenheim), Cação-anjo-liso (Squatina occulta), Cação bicudo, cação espátula, Quati (Isogomphodon oxyrhynchus), Tubarão Raposa (Alopias supercilliosus), Peixe-serra, espadarte (Pristis pectinata, P. perotteti), Tubarão-limão, papa-areia (Negaprion brevirostris), Peixe-boi marinho (Trichechus manatus), Boto-cinza (Sotalia guianensis), Golfinho-de-dentes-rugosos (Steno bredanensis), Golfinho-rotador (Stenella longirostris), Golfinho-pintado-do-Atlântico (Stenella frontalis), Golfinho-comum (Delphinus delphis), Golfinho-nariz-de-garrafa (Tursiops truncatus), Toninha (Pontoporia blainvillei), Baleia-jubarte (Megaptera novaeangliae), Baleia-cachalote (Physeter macrocephalus)',
    acompanhante: 'Linguado (Paralichthys brasiliensis, Paralichthys isósceles, Paralichthys triocellatus, Paralichthys patagonicus), Trilha (Mullus argentinae), Abrotea (Urophycis brasiliensis), Lula (Loligo sanpaulensis, Loligo surinamensis, Lolliguncula brevis, Doryteuthis plei, Sepioteuthis sepioidea), Corvina (Micropogonias furnieri), Papa terra, Judeu, Betara (Menticirrhus americanus), Cabrinha (Prionotus punctatus), Castanha (Umbrina canosai), Pescada, Maria-mole (Cynoscion striatus), Pescadinha real, Pescada foguete (Macrodon ancylodon), Raia santa (Rioraja agassizii), Raia carimbada (Atlantoraja cyclophora), Raia chita (Atlantoraja castelnaui), Raia emplasto (Atlantoraja platana, Sympterygia bonapartii, Sympterygia acuta), Raia (Breviraja spinosa, Rajella purpuriventralis), Tubarão azul (Prionace glauca), Tubarão lombo-preto, Caçãolombo-preto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação-bagre (Squalus acanthias, Squalus cubensis), Cação-espinho (Squalus blainville), Cação-malhado (Mustelus fasciatus), Pargo-rosa (Pagrus pagrus), Congro rosa (Genypterus brasiliensis), Congro-preto (Conger orbignianus, Myrophis punctatus, Raneya brasiliensis), Polvo (Octopus vulgaris, Octopus insularis), Peixe-sapo (Lophius gastrophysus), Tira-vira (Percophis brasiliensis), Namorado (Pseudopercis numida), Batata (Lopholatilus villarii), Merluza (Merluccius hubbsi), Lagosta sapateira (Scyllarides deceptor, Scyllarides brasiliensis, Scyllarides delfosi), Pitu (Metanephrops rubellus), Cavaca, manezinho (Caranx crysus), Dentão (Lutjanus jocu), Caranha (Lutjanus cyanopterus), Ariacó (Lutjanus synagris), Guaiúba (Ocyurus chrysurus), Pargo-piranga (Rhomboplites aurorubens), Garoupa, cherne pintado, cherne verdadeiro (Epinephelus niveatus), Garoupa-vermelha-de-abrolhos (Epinephelus morio), Sirigado, badejo-quadrado (Mycteroperca bonaci), Badejo-mira (Mycteroperca acutirostris), Badejo-da- areia (Mycteroperca microlepis), Olho de cão (Priacanthus arenatus), Peixe-espada (Trichiurus lepturus), Xixarro (Trachurus lathami), trombeta, Porquinho, peroá (Balistes capriscus), siri-mangue (Callinectes exasperatus), siri-azul (Callinectes sapidus), Siri nema (Callinectes bocourti), Siri (Callinectes danae, Callinectes ornatus), Goete (Cynoscion jamaicensis)',
    complementar: 'Arrasto (fundo), Espécies: Camarão cristalino (Parapenaeus americanus, Plesionika spp.), Pitu (Metanephrops rubellus)',
    area: 'Mar territorial S/SE; e ZEE S/SE. (Autorização Complementar - fora da área do camarão rosa - acima de 100M)',
    valeEmSc: true,
  ),
  Modalidade(
    '3.7',
    Metodo.arrasto,
    'Arrasto (fundo) - duplo Otras definições regionais ou locais:',
    alvo: 'Camarão santana (Pleoticus muelleri), Camarão barba ruça (Artemesia longinaris)',
    incidental: 'Canejo, cação-bico-doce, cação-cola-fina, caçonete, Boca de velho (Mustelus schmitti)',
    acompanhante: 'Linguado (Paralichthys brasiliensis, Paralichthys isósceles, Paralichthys triocellatus, Paralichthys patagonicus), Abrotea (Urophycis brasiliensis), Savelha (Brevoortia pectinata), Tainha (Mugil platanus ou Mugil liza), Bagre-branco (Arius grandicassis); Bagre-de-fita (Bagre marinus); Bagre-de-penacho (Bagre bagre), Bagre (Genidens barbus, Netuma planifrons); Bagre-amarelo (Cathorops spixii), Bagre rosado (Genidens genidens, Genidens barbus), Pescada-olhuda (Cynoscion guatucupa), Pescadinha real, Pescada foguete, Pescada gó (Macrodon ancylodon), Corvina, curuca, cururuca, cascote (Micropogonias furnieri), Papa terra, Judeu, Betara (Menticirrhus americanus), Miraguaia (Pogonias cromis), Castanha, Cabeça de coco, corvina-riscada (Umbrina canosai), Anchova (Pomatomus saltatrix), Peixe-espada (Trichiurus lepturus)',
    area: 'Mar territorial RS; e ZEE RS',
  ),
  Modalidade(
    '3.8',
    Metodo.arrasto,
    'Arrasto (fundo) - duplo ou simples',
    locais: 'Tangones ou popa',
    alvo: 'Camarão sete-barbas (Xiphopenaeus kroyeri), Camarão santana (Pleoticus muelleri), Camarão barba ruça (Artemesia longinaris)',
    incidental: 'Cação-anjo liso (Squatina occulta)',
    acompanhante: 'Linguado (Paralichthys brasiliensis, Paralichthys isósceles, Paralichthys triocellatus, Paralichthys patagonicus), Trilha (Mullus argentinae), Abrotea (Urophycis brasiliensis), Lula (Loligo sanpaulensis, Loligo surinamensis, Lolliguncula brevis, Doryteuthis plei, Sepioteuthis sepioidea), Corvina (Micropogonias furnieri), Papa terra, Judeu, Betara (Menticirrhus americanus), Cabrinha (Prionotus punctatus), Castanha (Umbrina canosai), Pescada, Maria-mole (Cynoscion striatus), Pescadinha real, Pescada foguete (Macrodon ancylodon), Raia santa (Rioraja agassizii), Raia carimbada (Atlantoraja cyclophora), Raia chita (Atlantoraja castelnaui), Raia emplasto (Atlantoraja platana, Sympterygia bonapartii, Sympterygia acuta), Raia (Breviraja spinosa, Rajella purpuriventralis), Tubarão azul (Prionace glauca), Tubarão lombo-preto, Caçãolombo-preto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação-bagre (Squalus acanthias, Squalus cubensis), Cação-espinho (Squalus blainville), Cação-malhado (Mustelus fasciatus), Camarão branco (Litopenaeus schmitti), Maria-luiza (Paralonchurus brasiliensis), Porquinho, peroá (Balistes capriscus), siri-mangue (Callinectes exasperatus), siri-azul (Callinectes sapidus), Siri nema (Callinectes bocourti), Siri (Callinectes danae, Callinectes ornatus), Goete (Cynoscion jamaicensis), Peixe-sapo (Lophius gastrophysus)',
    complementar: 'Garatéia com atração luminosa (vulgo zangarilho), Espécies: Lula (Loligo sanpaulensis, Loligo surinamensis, Lolliguncula brevis, Doryteuthis plei, Sepioteuthis sepioidea); Lulas (Loligo plei, Loligo sanpaulensis, Loligo sp., Lolliguncula brevis) com o emprego de linha de mão com isca artificial ou natural denominada zangarilho, garateias ou outras denominações regionais e/ou tarrafas com auxílio de atração luminosa (apenas no mar territorial adjacente ao estado de Santa Catarina)',
    area: 'Mar territorial S/SE; e ZEE S/SE',
    valeEmSc: true,
  ),
  Modalidade(
    '3.9',
    Metodo.arrasto,
    'Arrasto (fundo) - duplo ou simples',
    locais: 'Tangones ou popa',
    alvo: 'Camarão sete-barbas (Xiphopenaeus kroyeri), Camarão santana (Pleoticus muelleri), Camarão barba ruça (Artemesia longinaris)',
    incidental: 'Cação-anjo liso (Squatina occulta)',
    acompanhante: 'Linguado (Paralichthys brasiliensis, Paralichthys isósceles, Paralichthys triocellatus, Paralichthys patagonicus), Trilha (Mullus argentinae), Abrotea (Urophycis brasiliensis), Lula (Loligo sanpaulensis, Loligo surinamensis, Lolliguncula brevis, Doryteuthis plei, Sepioteuthis sepioidea), Corvina (Micropogonias furnieri), Papa terra, Judeu, Betara (Menticirrhus americanus), Cabrinha (Prionotus punctatus), Castanha (Umbrina canosai), Pescada, Maria-mole (Cynoscion striatus), Pescadinha real, Pescada foguete (Macrodon ancylodon), Raia santa (Rioraja agassizii), Raia carimbada (Atlantoraja cyclophora), Raia chita (Atlantoraja castelnaui), Raia emplasto (Atlantoraja platana, Sympterygia bonapartii, Sympterygia acuta), Raia (Breviraja spinosa, Rajella purpuriventralis), Tubarão azul (Prionace glauca), Tubarão lombo-preto, Caçãolombo-preto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação-bagre (Squalus acanthias, Squalus cubensis), Cação-espinho (Squalus blainville), Cação-malhado (Mustelus fasciatus), Camarão branco (Litopenaeus schmitti), Maria-luiza (Paralonchurus brasiliensis), Porquinho, peroá (Balistes capriscus), Siri-mangue (Callinectes exasperatus), Siri-azul (Callinectes sapidus), Siri nema (Callinectes bocourti), Siri (Callinectes danae, Callinectes ornatus), Goete (Cynoscion jamaicensis), Peixe-sapo (Lophius gastrophysus)',
    complementar: 'Rede de espera (superície), Espécies: Tainha (Mugil platanus ou Mugil liza), Anchova (Pomatomus saltatrix), Sororoca, serra (Scomberomorus brasiliensis), Guavira (Oligoplites saliens); Lulas (Loligo plei, Loligo sanpaulensis, Loligo sp., Lolliguncula brevis) com o emprego de linha de mão com isca artificial ou natural denominada zangarilho, garateias ou outras denominações regionais e/ou tarrafas com auxílio de atração luminosa (apenas no mar territorial adjacente ao estado de Santa Catarina)." (NR) O Anexo VI da Instrução Normativa MPA/MMA nº 10, de 10 de junho de 2011, do Ministério da Pesca e Aquicultura e do Ministério do Meio Ambiente e Mudança do Clima, alterado pela Portaria nº 617, de 8 de março de 2022, da Secretaria de Aquicultura e Pesca do Ministério da Agricultura, Pecuária e Abastecimento, passa a vigorar com a seguinte redação: "',
    area: 'Mar territorial S/SE; e ZEE S/SE',
    valeEmSc: true,
  ),
  Modalidade(
    '3.10',
    Metodo.arrasto,
    'Arrasto costeiro (fundo) - duplo',
    locais: 'Tangones',
    alvo: 'Corvina (Micropogonias furnieri), Castanha (Umbrina canosai), Pescada, Maria- mole (Cynoscion striatus), Pescadinha real, Pescada foguete (Macrodon ancylodon), Linguado (Paralichthys brasiliensis, Paralichthys isósceles, Paralichthys triocellatus, Paralichthys patagonicus), Abrotea (Urophycis brasiliensis) Cabrinha (Prionotus punctatus)',
    incidental: 'Cação anjo espinhoso (Squatina guggenheim)',
    acompanhante: 'Trilha (Mullus argentinae), Lula (Loligo sanpaulensis, Loligo surinamensis, Lolliguncula brevis, Doryteuthis plei, Sepioteuthis sepioidea), Pescada amarela (Cynoscion acoupa), Pescada branca (Cynoscion leiarchus), Boca mole (Larimus breviceps), Papa terra, Judeu, Betara (Menticirrhus americanus), Maria Luisa (Paralonchurus brasiliensis), Cabeçudo, Cangoá (Stellifer brasiliensis), Cabeçudo vermelho, Cangoá (Stellifer rastrifer), Cabeçudo Preto, Cangoá (Stellifer naso), Miraguaia (Pogonias cromis), Pescada olhuda (Cynoscion guatucupa), Lagosta sapateira (Scyllarides deceptor, Scyllarides brasiliensis, Scyllarides delfosi), Raia santa (Rioraja agassizii), Raia carimbada (Atlantoraja cyclophora), Raia chita (Atlantoraja castelnaui), Raia emplasto (Atlantoraja platana, Sympterygia bonapartii, Sympterygia acuta), Raia (Breviraja spinosa, Rajella purpuriventralis), Congro rosa (Genypterus brasiliensis), Congro-preto (Conger orbignianus, Myrophis punctatus, Raneya brasiliensis), Peixe-sapo (Lophius gastrophysus), Tira-vira (Percophis brasiliensis), Namorado (Pseudopercis numida), Batata (Lopholatilus villarii), Lacraia, Pitu (Metanephrops rubellus), Cavaca, carapau, xerelete (Caranx crysus), Dentão(Lutjanus jocu), Caranha (Lutjanus cyanopterus), Ariacó (Lutjanus synagris), Guaiúba (Ocyurus chrysurus), Pargo-piranga (Rhomboplites aurorubens), Pargo- rosa (Pagrus pagrus), Garoupa, cherne pintado, cherne verdadeiro (Epinephelus niveatus), Garoupa-vermelha-de-abrolhos (Epinephelus morio), Sirigado, badejo-quadrado (Mycteroperca bonaci), Badejo-mira (Mycteroperca acutirostris), Badejo-da-areia (Mycteroperca microlepis), Olho de cão (Priacanthus arenatus), Peixe-espada (Trichiurus lepturus), Goete (Cynoscion jamaicensis)',
    area: 'Mar territorial S/SE (profundidades inferiores a 250 metros); e ZEE S/SE (profundidades inferiores a 250 metros)',
    valeEmSc: true,
  ),
  Modalidade(
    '3.11',
    Metodo.arrasto,
    'Arrasto costeiro (fundo simples e parelha)',
    alvo: 'Corvina (Micropogonias furnieri), Castanha (Umbrina canosai), Pescada, Maria mole (Cynoscion striatus), Pescadinha real, Pescada foguete (Macrodon ancylodon)',
    incidental: 'Raia Viola (Rhinobatus horkelii, Rhinobatos percellens), Badejo-mira (Mycteroperca acutirostris)',
    acompanhante: 'Linguado (Paralichthys brasiliensis, Paralichthys isósceles, Paralichthys triocellatus, Paralichthys patagonicus), Trilha (Mullus argentinae), Abrotea (Urophycis brasiliensis), Lula (Loligo sanpaulensis, Loligo surinamensis, Lolliguncula brevis, Doryteuthis plei, Sepioteuthis sepioidea), Cabrinha (Prionotus punctatus), Congro rosa (Genypterus brasiliensis), Peixe-sapo (Lophius gastrophysus), Tira-vira (Percophis brasiliensis), Namorado (Pseudopercis numida), Batata (Lopholatilus villarii), Lacraia, Pitu (Metanephrops rubellus), Cavaca, carapau, xerelete (Caranx crysus), Dentão(Lutjanus jocu), Caranha (Lutjanus cyanopterus), Ariacó (Lutjanus synagris), Guaiúba (Ocyurus chrysurus), Pargo-piranga (Rhomboplites aurorubens), Garoupa, cherne pintado, cherne verdadeiro - (Epinephelus niveatus), Garoupa-vermelha-de-abrolhos (Epinephelus morio), Sirigado, badejo- quadrado (Mycteroperca bonaci), Badejo-da-areia (Mycteroperca microlepis), Olho de cão (Priacanthus arenatus), Peixe-espada (Trichiurus lepturus)',
    area: 'Mar territorial S/SE (profundidades inferiores a 250metros); e ZEE S/SE (profundidades inferiores a 250 metros)',
    valeEmSc: true,
  ),
  Modalidade(
    '3.12',
    Metodo.arrasto,
    'Arrasto oceânico (fundo) - simples e duplo',
    alvo: 'Galo-de-fundo (Zenopsis conchifer), Abrótea de profundidade (Urophycis cirrata), Merluza (Merluccius hubbsi)',
    acompanhante: 'Cabrinha (Prionotus punctatus), Congro rosa (Genypterus brasiliensis), Peixe-sapo (Lophius gastrophysus), Sarrão (Helicolenus dactylopterus, Helicolenus lahillei), Trilha-branca (Polymixia lowei), Caranguejo real (Chaceon ramosae), Caranguejo vermelho (Chaceon notialis)',
    area: 'ZEE S/SE (profundidades superiores a 250 metros e inferiores a 500 metros)',
    valeEmSc: true,
  ),
  Modalidade(
    '3.13',
    Metodo.arrasto,
    'Arrasto oceânico (fundo) - simples e duplo',
    alvo: 'Camarão carabineiro (Aristaeopsis edwardsiana), Camarão alistado (Aristeus antillensis)',
    incidental: 'Tubarão lombo-preto, Cação-lombopreto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação-malhado (Mustelus fasciatus)',
    acompanhante: 'Calamar argentino (Illex argentinus), Calamar vermelho (Ommastrephes bartramii), Caranguejo real (Chaceon ramosae), Caranguejo vermelho (Chaceon notialis), Tubarão azul (Prionace glauca), Cação-bagre (Squalus acanthias, Squalus cubensis), Cação espinho (Squalus blainville), Merluza (Merluccius hubbsi), Pargo Rosa (Pagrus pagrus), Abrótea de profundidade (Urophycis cirrata)',
    area: 'ZEE (profundidades superiores a 500 metros e inferiores a 1000 metros)',
  ),
  Modalidade(
    '3.14',
    Metodo.arrasto,
    'Arrasto (meia água)',
    alvo: 'Anchoíta (Engraulis anchoita), Galo (Selene vomer), Calamar argentino (Illex argentinus), Calamar vermelho (Ommastrephes bartramii)',
    acompanhante: 'Xixarro (Trachurus lathami), Peixe-espada (Trichiurus lepturus), Manjuba (Anchoa tricolor, Anchoa lyolepis, Anchoa marinii)',
    area: 'Mar territorial S/SE; e ZEE S/SE',
    valeEmSc: true,
  ),
  Modalidade(
    '4.1',
    Metodo.cerco,
    'Cerco',
    locais: 'Traineira',
    alvo: 'Sardinha verdadeira (Sardinella brasiliensis)',
    acompanhante: 'Sardinha-laje (Opisthonema oglinum), Palombeta (Chloroscombrus chrysurus), Cavalinha (Scomber japonicus), Xixarro (Trachurus lathami) Anchoíta (Engraulis anchoita) Peixe-espada (Trichiurus lepturus), Manjuba (Anchoa tricolor, Anchoa lyolepis, Anchoa marinii), Sardinha-boca-torta (Cetengraulis edentulus) Savelha (Brevoortia pectinata) Gordinho (Peprilus paru), Carapau (Caranx crysus), Galo (Selene vomer), Peixe-galo (Selene setapinnis), Olhete (Seriola lalandi), Pampo (Trachinotus falcatus) Pampo-verdadeiro (Trachinotus carolinus), Pampo-listrado (Trachinotus goodei), Pampo- malhado (Trachinotus marginatus), Paru-branco (Chaetodipterus faber), Xarelete (Caranx latus), Sardinha-cascuda (Harengula clupeola)',
    complementar: 'Rede de cerco, Espécies: Tainha (Mugil platanus ou Mugil liza), Palombeta (Chloroscombrus chrysurus), Xixarro (Trachurus lathami), Anchoíta (Engraulis anchoita), Peixe-espada (Trichiurus lepturus), Savelha (Brevoortia pectinata), Gordinho (Peprilus paru), Carapau, xerelete (Caranx crysus), Galo (Selene vomer), Peixe-galo (Selene setapinnis), Olhete (Seriola lalandi), Pampo (Trachinotus falcatus), Pampo-verdadeiro (Trachinotus carolinus) Pampo-listrado (Trachinotus goodei), Pampo-malhado (Trachinotus marginatus) Paru-branco (Chaetodipterus faber), Xarelete (Caranx latus), Xaréu (Caranx hippos), Guaivira (Oligoplites saliens)',
    area: 'Mar territorial SE; e ZEE SE',
  ),
  Modalidade(
    '4.2',
    Metodo.cerco,
    'Cerco',
    locais: 'Traineira',
    alvo: 'Sardinha verdadeira (Sardinella brasiliensis)',
    acompanhante: 'Sardinha-laje (Opisthonema oglinum), Palombeta (Chloroscombrus chrysurus), Cavalinha (Scomber japonicus), Xixarro (Trachurus lathami), Anchoíta (Engraulis anchoita) Peixe-espada (Trichiurus lepturus), Manjuba (Anchoa tricolor, Anchoa lyolepis, Anchoa marinii), Sardinha-boca-torta (Cetengraulis edentulus) Savelha (Brevoortia pectinata) Gordinho (Peprilus paru) Carapau (Caranx crysus), Galo (Selene vomer), Peixe-galo (Selene setapinnis) Olhete (Seriola lalandi), Pampo (Trachinotus falcatus) Pampo-verdadeiro (Trachinotus carolinus), Pampo-listrado (Trachinotus goodei), Pampo- malhado (Trachinotus marginatus), Paru-branco (Chaetodipterus faber), Xarelete (Caranx latus), Sardinha-cascuda (Harengula clupeola)',
    complementar: 'Rede de cerco, Espécies: Anchova (Pomatomus saltatrix), Palombeta (Chloroscombrus chrysurus), Xixarro (Trachurus lathami), Anchoíta (Engraulis anchoita), Peixeespada (Trichiurus lepturus), Savelha (Brevoortia pectinata), Gordinho (Peprilus paru), Carapau, xerelete (Caranx crysus), Galo (Selene vomer), Peixe-galo (Selene setapinnis), Olhete (Seriola lalandi), Pampo (Trachinotus falcatus), Pampo-verdadeiro (Trachinotus carolinus), Pampo-listrado (Trachinotus goodei), Pampo-malhado (Trachinotus marginatus) Paru-branco (Chaetodipterus faber), Xarelete (Caranx latus), Xaréu (Caranx hippos), Guaivira (Oligoplites saliens)',
    area: 'Mar territorial SE; e ZEE SE',
  ),
  Modalidade(
    '4.3',
    Metodo.cerco,
    'Cerco',
    locais: 'Traineira',
    alvo: 'Sardinha verdadeira (Sardinella brasiliensis)',
    acompanhante: 'Sardinha-laje (Opisthonema oglinum), Palombeta (Chloroscombrus chrysurus), Cavalinha (Scomber japonicus) Xixarro (Trachurus lathami) Anchoveta (Engraulis anchoita) Peixe-espada (Trichiurus lepturus), Manjuba (Anchoa tricolor, Anchoa lyolepis ou Anchoa marinii), Sardinha-boca-torta (Cetengraulis edentulus) Savelha (Brevoortia pectinata) Gordinho (Peprilus paru) Carapau (Caranx crysus), Galo (Selene vomer), Peixe-galo (Selene setapinnis) Olhete (Seriola lalandi), Pampo (Trachinotus falcatus) Pampo-verdadeiro (Trachinotus carolinus), Pampo-listrado (Trachinotus goodei), Pampo- malhado (Trachinotus marginatus), Paru-branco (Chaetodipterus faber), Xarelete (Caranx latus), Sardinha-cascuda (Harengula clupeola)',
    complementar: 'Rede de cerco, Espécies: Bonito-listrado (Katsuwonus pelamis), Palombeta (Chloroscombrus chrysurus), Xixarro (Trachurus lathami), Anchoíta (Engraulis anchoita), Peixe-espada (Trichiurus lepturus), Savelha (Brevoortia pectinata), Gordinho (Peprilus paru), Carapau, xerelete (Caranx crysus), Galo (Selene vomer), Peixe-galo (Selene setapinnis), Olhete (Seriola lalandi), Pampo (Trachinotus falcatus), Pampo-verdadeiro (Trachinotus carolinus), Pampo-listrado (Trachinotus goodei), Pampo-malhado (Trachinotus marginatus) Paru-branco (Chaetodipterus faber), Xarelete (Caranx latus), Xaréu (Caranx hippos), Guaivira (Oligoplites saliens)',
    area: 'Mar territorial SE; e ZEE SE',
  ),
  Modalidade(
    '4.4',
    Metodo.cerco,
    'Cerco',
    locais: 'Traineira',
    alvo: 'Sardinha-laje (Opisthonema oglinum), Savelha (Brevoortia pectinata), Galo (Selene vomer), Peixe-galo (Selene setapinnis), Sardinha-cascuda (Harengula clupeola), Peixe-porco (Balistes capriscus), Sardinha-boca-torta (Cetengraulis edentulus), Xaréu (Caranx latus), Guaivira (Oligoplites saliens), Palombeta (Chloroscombrus chrysurus), Cavalinha (Scomber japonicus)',
    acompanhante: 'Garapau, xixarro (Trachurus lathami), Peixe-espada (Trichiurus lepturus), Manjuba (Anchoa tricolor, Anchoa lyolepis ou Anchoa marinii), Gordinho (Peprilus paru), Olhete (Seriola lalandi), Pampo (Trachinotus falcatus), Pampo-verdadeiro (Trachinotus carolinus), Pampo-listrado (Trachinotus goodei), Pampo-malhado (Trachinotus marginatus), Paru-branco (Chaetodipterus faber), Xarelete (Caranx latus)',
    area: 'Mar territorial SE/S; e ZEE SE/S, Identificar o perfil da frota para definir área de operação',
    valeEmSc: true,
  ),
  Modalidade(
    '4.5',
    Metodo.cerco,
    'Cerco',
    locais: 'Traineira',
    alvo: 'Anchoíta (Engraulis anchoita)',
    acompanhante: 'Xixarro (Trachurus lathami), Peixe-espada (Trichiurus lepturus), Manjuba (Anchoa tricolor, Anchoa lyolepis ou Anchoa marinii)',
    area: 'Mar territorial S/SE; e ZEE S/SE',
    valeEmSc: true,
  ),
  Modalidade(
    '4.6',
    Metodo.cerco,
    'Cerco',
    locais: 'Traineira',
    alvo: 'Bonito listrado (Katsuwonus pelamis)',
    acompanhante: 'Albacora laje (Thunnus albacares), Albacora branca (Thunnus alalunga), Albacora bandolim (Thunnus obesus), Tubarão azul (Prionace glauca), Tubarão lombopreto (Carcharhinus falsiformis), Mako (Isurus oxyrinchus), Agulhão verde (Tetrapturus pfluegeri), Agulhão vela (Istiophorus albicans), Albacora azul (Thunnus thynnus), Albacorinha (Thunnus atlanticus), Espadarte (Xiphias gladius), Bonito listrado (Katsuwonus pelamis), Bonito cachorro (Auxis thazard), Sarda (Sarda sarda), Cavala empige (Acanthocybium solandri), Cavala (Scomberomorus cavalla), Serra (Scomberomorus brasiliensis), Dourado (Coryphaena hippurus), Bonito-pintado (Euthynnus alletteratus), Olhete (Seriola lalandi)',
    area: 'Mar territorial S/SE; e ZEE S/SE',
    valeEmSc: true,
  ),
  Modalidade(
    '5.1',
    Metodo.armadilha,
    'Covos',
    locais: 'Manzuá',
    alvo: 'Lagosta verde (Panulirus laevicauda), Lagosta vermelha (Panulirus argus)',
    acompanhante: 'Lagosta pintada (Panulirus equinatus), Lagosta sapateira (Scyllarides deceptor, Scyllarides brasiliensis, Scyllarides delfosi), Polvo (Octopus vulgaris, Octopus insularis)',
    complementar: 'Espinhel vertical, Espécies: Garoupa, cherne pintado, cherne verdadeiro (Epinephelus niveatus), Pescada amarela (Cynoscion acoupa), Siri-mangue (Callinectes exasperatus), Siri-azul (Callinectes sapidus), Siri nema (Callinectes bocourti), Siri (Callinectes danae, Callinectes ornatus), Sirigado, badejoquadrado (Mycteroperca bonaci), Arabaiana, olho-de-boi (Seriola dumerili), Sirigado, badejo-quadrado (Mycteroperca bonaci), Garoupa, cherne pintado, cherne verdadeiro (Epinephelus niveatus), Garoupavermelha-de- abrolhos (Epinephelus morio), Badejo-mira (Mycteroperca acutirostris), Badejo-da-areia (Mycteroperca microlepis), Xaréu, garacimbora, xarelete (Caranx latus), Garaximpora, xaréu (Caranx hippos)',
    area: 'Mar territorial N/NE/SE (AP ao ES); e ZEE N/NE/SE (AP ao ES) (OBS: Área de operação da Autorização Complementar fora da área de ocorrência do pargo)',
  ),
  Modalidade(
    '5.2',
    Metodo.armadilha,
    'Covos',
    locais: 'Manzuá',
    alvo: 'Lagosta verde (Panulirus laevicauda), Lagosta vermelha (Panulirus argus)',
    acompanhante: 'Lagosta pintada (Panulirus equinatus), Lagosta sapateira (Scyllarides deceptor, Scyllarides brasiliensis, Scyllarides delfosi), Polvo (Octopus vulgaris, Octopus insularis)',
    complementar: 'Linha de mão (fundo), Espécies: Garoupa, cherne pintado, cherne verdadeiro (Epinephelus niveatus), Siri-mangue (Callinectes exasperatus), Siri-azul (Callinectes sapidus), Siri nema (Callinectes bocourti), Siri (Callinectes danae, Callinectes ornatus), Sirigado, badejo-quadrado (Mycteroperca bonaci), Guaiúba (Ocyurus chrysurus), Ariacó (Lutjanus synagris), Cioba (Lutjanus analis), Dentão, carapitanga (Lutjanus jocu), Arabaiana, olho-de-boi (Seriola dumerili), Camurim, Robalo (Centropomus parallelus, Centropomus undecimalis, Centropomus ensiferus, Centropomus pectinatus), Camurupim (Megalops atlanticus), Beijupirá (Rachycentron canadum), Galo-do-alto (Alectis ciliaris), Xaréu, garacimbora, xarelete (Caranx latus), Garajuba, carapau, xerelete (Caranx crysus), Raia santa (Rioraja agassizii), Raia carimbada (Atlantoraja cyclophora), Raia chita (Atlantoraja castelnaui), Raia emplasto (Atlantoraja platana, Sympterygia bonapartii, Sympterygia acuta), Raia (Breviraja spinosa, Rajella purpuriventralis), Budião (Sparisoma chrysopterum), Saramunete (Pseudupeneus maculatus), Pampo (Trachinotus falcatus), Piraúna (Cephalopholis fulva), Caraúna (Acanthurus bahianus, A. chirurgus, A. coeruleus), Biquara (Haemulon plumierii), Sapuruna (Haemulon melanurum), Serra (Scomberomorus brasiliensis), Cangulo, Peroá (Balistes capriscus)',
    area: 'Mar territorial N/NE/SE (AP ao ES); e ZEE N/NE/SE (AP ao ES)',
  ),
  Modalidade(
    '5.3',
    Metodo.armadilha,
    'Covos',
    locais: 'Manzuá',
    alvo: 'Lagosta verde (Panulirus laevicauda), Lagosta vermelha (Panulirus argus)',
    acompanhante: 'Lagosta pintada (Panulirus equinatus), Lagosta sapateira (Scyllarides deceptor, Scyllarides brasiliensis, Scyllarides delfosi), Polvo (Octopus vulgaris, Octopus insularis)',
    complementar: 'Linha de mão (superfície), Espécies: Cavala (Scomberomorus cavalla), Serra (Scomberomorus brasiliensis)',
    area: 'Mar territorial N/NE/SE (AP ao ES); e ZEE N/NE/SE (AP ao ES)',
  ),
  Modalidade(
    '5.4',
    Metodo.armadilha,
    'Covos',
    locais: 'Manzuá',
    alvo: 'Lagosta verde (Panulirus laevicauda), Lagosta vermelha (Panulirus argus)',
    acompanhante: 'Lagosta pintada (Panulirus equinatus), Lagosta sapateira (Scyllarides deceptor, Scyllarides brasiliensis, Scyllarides delfosi), Polvo (Octopus vulgaris, Octopus insularis)',
    complementar: 'Rede de Emalhe de Superfície, Espécie: Serra (Scomberomorus brasiliensis)',
    area: 'Mar territorial N/NE/SE (AP ao ES); e ZEE N/NE/SE (AP ao ES)',
  ),
  Modalidade(
    '5.5',
    Metodo.armadilha,
    'Covos',
    alvo: 'Pargo rosa (Pagrus pagrus)',
    acompanhante: 'Paru-branco (Chaetodipterus faber), Abrótea (Urophycis brasiliensis), Baiacu (Lagocephalus laevigatus)',
    area: 'Mar territorial S/SE; e ZEE S/SE',
    valeEmSc: true,
  ),
  Modalidade(
    '5.6',
    Metodo.armadilha,
    'Covos',
    alvo: 'Caranguejo vermelho (Chaceon notialis)',
    area: 'Mar territorial S (ao sul do paralelo de 32º00\'S, profundidades superiores as 200 metros); e ZEE S (ao sul do paralelo de 32º00\'S, profundidades superiores as 200 metros)',
    valeEmSc: true,
  ),
  Modalidade(
    '5.7',
    Metodo.armadilha,
    'Covos',
    alvo: 'Caranguejo real (Chaceon ramosae)',
    area: 'Mar territorial S/SE (ao sul do paralelo de 19º00S, norte do paralelo 30º00S, profundidades superiores a 500 metros); e ZEE S/SE (ao sul do paralelo de 19º00S, norte do paralelo 30º00s, profundidades superiores a 500 metros)',
    valeEmSc: true,
  ),
  Modalidade(
    '5.8',
    Metodo.armadilha,
    'Covos',
    alvo: 'Caranguejo de profundidade (Chaceon spp.)',
    complementar: 'Espinhel horizontal (superfície), Espécies: Albacora laje (Thunnus albacares), Albacora branca (Thunnus alalunga), Albacora bandolim (Thunnus obesus), Tubarão azul (Prionace glauca), Tubarão lombo-preto, cação lombo-preto (Carcharhinus falciformis), Mako (Isurus oxyrinchus), Agulhão verde (Tetrapturus pfluegeri), Agulhão vela (Istiophorus albicans), Albacora azul (Thunnus thynnus), Albacorinha (Thunnus atlanticus), Espadarte (Xiphias gladius), Bonito listrado (Katsuwonus pelamis), Bonito cachorro (Auxis thazard), Sarda (Sarda sarda), Cavala empige (Acanthocybium solandri), Cavala (Scomberomorus cavalla), Serra (Scomberomorus brasiliensis), Dourado (Coryphaena hippurus)',
    area: 'ZEE N/NE',
  ),
  Modalidade(
    '5.9',
    Metodo.armadilha,
    'Covos',
    locais: 'Manzuá',
    alvo: 'Saramunete (Pseudupeneus maculatus)',
    acompanhante: 'Budião (Sparisoma chrysopterum), Cioba (Lutjanus analis), Caraúna (Acanthurus bahianus, A. chirurgus, A. coeruleus), Guaiúba (Ocyurus chrysurus), Polvo (Octopus vulgaris, Octopus insularis)',
    complementar: 'Espinhel vertical e linha de mão (fundo), Espécies: Garoupa, cherne pintado, cherne verdadeiro (Epinephelus niveatus), Siri-mangue (Callinectes exasperatus), Siri-azul (Callinectes sapidus), Siri nema (Callinectes bocourti), Siri (Callinectes danae, Callinectes ornatus), Sirigado, badejo-quadrado (Mycteroperca bonaci), Cavala (Scomberomorus cavalla), Ariacó (Lutjanus synagris), Dentão, carapitanga (Lutjanus jocu), Arabaiana, olho-deboi (Seriola dumerili), Dourado (Coryphaena hippurus), Camurim, Robalo (Centropomus parallelus, Centropomus undecimalis, Centropomus ensiferus, Centropomus pectinatus), Camurupim (Megalops atlanticus), Beijupirá (Rachycentron canadum), Galo-do- alto (Alectis ciliaris), Xaréu, garacimbora, xarelete (Caranx latus), Garajuba, carapau, xerelete (Caranx crysus), Cangulo, Peroá (Balistes capriscus), Raia santa (Rioraja agassizii), Raia carimbada (Atlantoraja cyclophora), Raia chita (Atlantoraja castelnaui), Raia emplasto (Atlantoraja platana, Sympterygia bonapartii, Sympterygia acuta), Raia (Breviraja spinosa, Rajella purpuriventralis), Budião (Sparisoma chrysopterum), Bonito listrado (Katsuwonus pelamis), Pampo (Trachinotus falcatus), Piraúna (Cephalopholis fulva), Biquara (Haemulon plumierii), Sapuruna (Haemulon melanurum), Serra (Scomberomorus brasiliensis)',
    area: 'Mar territorial NE; e ZEE NE',
  ),
  Modalidade(
    '5.10',
    Metodo.armadilha,
    'Potes',
    alvo: 'Polvo (Octopus vulgaris, Octopus insularis)',
    area: 'Mar territorial S/SE (ES ao PR); e ZEE S/SE (ES ao PR)',
  ),
  Modalidade(
    '5.11',
    Metodo.armadilha,
    'Potes',
    alvo: 'Polvo (Octopus vulgaris, Octopus insularis)',
    area: 'Mar territorial S (SC ao RS); e ZEE S (SC ao RS)',
    valeEmSc: true,
  ),
  Modalidade(
    '5.12',
    Metodo.armadilha,
    'Potes',
    alvo: 'Polvo (Octopus vulgaris, Octopus insularis)',
    area: 'Mar territorial N/NE; e ZEE N/NE',
  ),
  Modalidade(
    '6.1',
    Metodo.outros,
    'Puçá - mergulho (livre e autônomo)',
    alvo: 'Peixes ornamentais VER IN',
    area: 'Mar territorial',
    valeEmSc: true,
  ),
  Modalidade(
    '6.2',
    Metodo.outros,
    'Coleta manual subaquática com auxilio de aparelho de mergulho livre',
    alvo: 'Algas VER IN',
    area: 'Mar territorial S/SE',
    valeEmSc: true,
  ),
  Modalidade(
    '6.3',
    Metodo.outros,
    'Coleta manual subaquática com auxilio de aparelho de mergulho autônomo',
    alvo: 'Algas VER IN',
    area: 'Mar territorial S/SE',
    valeEmSc: true,
  ),
  Modalidade(
    '6.4',
    Metodo.outros,
    'Diversificada costeira (embarcações de pequeno porte, com propulsão a remo ou a vela, e, quando motorizadas, com potência de motor até 18,0 hp, comprimento até 8,00 m e arqueação bruta até 2,0.)',
    alvo: 'Peixes e crustáceos diversos não controlados por regulamentação específica',
    area: 'Mar territorial N',
  ),
  Modalidade(
    '6.5',
    Metodo.outros,
    'Diversificada costeira) (embarcações de pequeno porte, com propulsão a remo ou a vela, e, quando motorizadas, com potência de motor até 18,0 hp, comprimento até 8,00 m e arqueação bruta até 2,0.)',
    alvo: 'Peixes e crustáceos diversos não controlados por regulamentação específica',
    area: 'Mar territorial NE (exceto BA)',
  ),
  Modalidade(
    '6.6',
    Metodo.outros,
    'Diversificada costeira (embarcações de pequeno porte, com propulsão a remo ou a vela, e, quando motorizadas, com potência de motor até 18,0 hp, comprimento até 8,00 m e arqueação bruta até 2,0.)',
    alvo: 'Peixes e crustáceos diversos não controlados por regulamentação específica',
    area: 'Mar territorial (BA ao RJ)',
  ),
  Modalidade(
    '6.7',
    Metodo.outros,
    'Diversficada costeira (embarcações de pequeno porte, com propulsão a remo ou a vela, e, quando motorizadas, com potência de motor até 18,0 hp, comprimento até 8,00 m e arqueação bruta até 2,0.)',
    alvo: 'Peixes, crustáceos e moluscos diversos',
    area: 'Mar territorial (SP ao RS)',
    valeEmSc: true,
  ),
  Modalidade(
    '6.8',
    Metodo.arrasto,
    'Arrasto de praia',
    alvo: 'Tainha (Mugil liza); Parati (Mugil curema) Betara (Menticirrhus littoralis); Pescada (Cynoscion striatus); Corvina (Micropogonias furnieri); Pampo ou Gordinho (Peprilus paru); Enchova ou Anchova (Pomatomus saltatrix); Espada (Trichiurus lepturus); e Maria-luiza (Paralonchurus brasiliensis); Xaréu (Caranx hippos); Sororoca (Scomberomorus brasiliensis); Savelha (Brevoortia pectinata); Pescadinha- real (Macrodon ancylodon); Peixerei (Odonthestes bonariensis /Atherinella brasiliensis); Goete (Cynoscion jamaicensis); Abrótea (Urophycis brasiliensis); Xerelete (Caranx crysus); Sardinha-lage (Opisthonema oglinum); Prejereba (Lobotes surinamensis); Pescada-branca (Cynoscion leiarchus); Pescada-amarela (Cynoscion acoupa); Cavala (Scomber japonicus); Peixe-porco (Balistes capriscus / B. vetula); Palombeta ou Carapau (Chloroscombrus chrysurus); Olho-de-cão (Priacanthus arenatus); Olho-de-boi (Seriola lalandi) Linguado (Paralichthys patagonicus /P. brasiliensis); Galo (Selene vômer); Paru (Chaetodipterus faber); Oveva (Larimus breviceps); Marimbá (Diplodus argenteus); Guaivira (Oligoplites saliens); Robalo (Centropomus parallelus, Centropomus undecimalis); Carapicu (Eucinostomus gula); Cangoá (Stellifer rastifer); Miracéu (Astrocopus sexspinosus); Caratinga (Eugerres brasilianus); Carapeba (Diapterus rhombeus), Lulas (Loligo plei, Loligo sanpaulensis, Loligo sp., Lolliguncula brevis)',
    incidental:
        'Tartaruga-verde (Chelonia mydas), Tartaruga-cabeçuda (Caretta caretta), Tartaruga-de-pente (Eretmochelys imbricata), Tartaruga-oliva (Lepidochelys olivacea), Tartaruga-gigante (Dermochelys coriacea), Peixe-boi marinho (Trichechus manatus), Boto-cinza (Sotalia guianensis), Golfinho-de-dentes-rugosos (Steno bredanensis), Golfinho-rotador (Stenella longirostris), Golfinho-pintado-do-Atlântico (Stenella frontalis), Golfinho-comum (Delphinus delphis), Golfinho-nariz-de-garrafa (Tursiops truncatus), Toninha (Pontoporia blainvillei), Baleia-jubarte (Megaptera novaeangliae), Baleia-cachalote (Physeter macrocephalus)',
    acompanhante:
        'Tubarão azul (Prionace glauca), Tubarão lombo-preto, Cação-lombo-preto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação-noturno (Carcharhinus signatus), Cação-bagre (Squalus acanthias, Squalus cubensis), Cação-espinho (Squalus blainville), Cação-malhado (Mustelus fasciatus), Peixe-espada (Trichiurus lepturus), Serrinha, Cavala Pintada (Scomberomorus maculatus), Prejereba (Lobotes surinamensis), Guaivira (Oligoplites saliens), Pampo (Trachinotus falcatus), Pampo-verdadeiro (Trachinotus carolinus), Pampo-listrado (Trachinotus goodei), Pampo-malhado (Trachinotus marginatus), Paru-branco (Chaetodipterus faber)',
    complementar:
        'Emalhe Costeiro (Superfície). Espécies-alvo: Tainha (Mugil platanus ou Mugil liza), Anchova (Pomatomus saltatrix), Sororoca, Serra (Scomberomorus brasiliensis)',
    area: 'Mar territorial do Estado de Santa Catarina',
    valeEmSc: true,
    regras:
        'DIMENSÕES DA REDE (art. 3º)\nMalha igual ou superior a 40 mm, entre nós opostos da malha esticada. Comprimento máximo de 1.600 m. Altura máxima de 30 m.\n\nEMBARCAÇÃO (art. 4º)\nPermitida o ano todo, com embarcação de comprimento máximo de 12 m, a remo ou motorizada. O uso de motor é permitido apenas para embarcações que operam entre os municípios de Passo de Torres e Imbituba, com potência máxima de 90 HP (§ 1º).\n\nREGRAS DAS ESPÉCIES (art. 4º, § 2º)\nAs regras específicas de ordenamento das espécies que constam na Autorização de Pesca de Arrasto de Praia, incluindo os períodos de proibição de pesca e os tamanhos mínimos definidos, deverão ser obedecidas.\n\nMONITORAMENTO (art. 9º)\nMapa de Produção, um por dia, enviado até o quinto dia útil do mês subsequente, mesmo sem captura e mesmo sem saída da embarcação. A não entrega enseja suspensão de 30 dias da Autorização (art. 10) e, persistindo, cancelamento (art. 11).\n\nSANÇÕES (art. 12)\nLei nº 9.605, de 12 de fevereiro de 1998, e Decreto nº 6.514, de 22 de julho de 2008.',
    norma:
        'Modalidade incluída no Anexo VI da IN MPA/MMA nº 10/2011 pela Portaria SAP/MAPA nº 617, de 8 de março de 2022, que ordena a pesca de arrasto de praia no Mar Territorial em Santa Catarina.',
  ),
  Modalidade(
    '6.9',
    Metodo.arrasto,
    'Arrasto de praia',
    alvo: 'Tainha (Mugil liza); Parati (Mugil curema) Betara (Menticirrhus littoralis); Pescada (Cynoscion striatus); Corvina (Micropogonias furnieri); Pampo ou Gordinho (Peprilus paru); Enchova ou Anchova (Pomatomus saltatrix); Espada (Trichiurus lepturus); e Maria- luiza (Paralonchurus brasiliensis); Xaréu (Caranx hippos); Sororoca (Scomberomorus brasiliensis); Savelha (Brevoortia pectinata); Pescadinha- real (Macrodon ancylodon); Peixerei (Odonthestes bonariensis /Atherinella brasiliensis); Goete (Cynoscion jamaicensis); Abrótea (Urophycis brasiliensis); Xerelete (Caranx crysus); Sardinha-lage (Opisthonema oglinum); Prejereba (Lobotes surinamensis); Pescada-branca (Cynoscion leiarchus); Pescada-amarela (Cynoscion acoupa); Cavala (Scomber japonicus); Peixe-porco (Balistes capriscus / B. vetula); Palombeta ou Carapau (Chloroscombrus chrysurus); Olho-de-cão (Priacanthus arenatus); Olho-de-boi (Seriola lalandi) Linguado (Paralichthys patagonicus /P. brasiliensis); Galo (Selene vômer); Paru (Chaetodipterus faber); Oveva (Larimus breviceps); Marimbá (Diplodus argenteus); Guaivira (Oligoplites saliens); Robalo (Centropomus parallelus, Centropomus undecimalis); Carapicu (Eucinostomus gula); Cangoá (Stellifer rastifer); Miracéu (Astrocopus sexspinosus); Caratinga (Eugerres brasilianus); Carapeba (Diapterus rhombeus), Lulas (Loligo plei, Loligo sanpaulensis, Loligo sp., Lolliguncula brevis)',
    incidental:
        'Raia Viola (Rhinobatus horkelii, Rinobatos percellens), Cação-anjo-espinhoso (Squatina guggenheim), Cação-anjo-liso (Squatina occulta), Boto-cinza (Sotalia guianensis), Golfinho-de-dentes-rugosos (Steno bredanensis), Golfinho-rotador (Stenella longirostris), Golfinho-pintado-do-Atlântico (Stenella frontalis), Golfinho-comum (Delphinus delphis), Golfinho-nariz-de-garrafa (Tursiops truncatus), Toninha (Pontoporia blainvillei), Tartaruga-verde (Chelonia mydas), Tartaruga-cabeçuda (Caretta caretta), Tartaruga-de-pente (Eretmochelys imbricata), Tartaruga-oliva (Lepidochelys olivacea), Tartaruga-gigante (Dermochelys coriacea)',
    acompanhante:
        'Savelha (Brevoortia pectinata), Cabrinha (Prionotus punctatus), Tubarão azul (Prionace glauca), Tubarão lombo-preto, Cação-lombo-preto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação-bagre (Squalus acanthias, Squalus cubensis), Cação-espinho (Squalus blainville), Cação-malhado (Mustelus fasciatus), Peixe-espada (Trichiurus lepturus), Guaivira (Oligoplites saliens), Linguado (Paralichthys brasiliensis, Paralichthys isosceles, Paralichthys triocellatus, Paralichthys patagonicus), Maria-luiza (Paralonchurus brasiliensis), Papa-terra, Betara (Menticirrhus americanus), Pescada amarela (Cynoscion acoupa), Pescada branca (Cynoscion leiarchus), Pescada bicuda (Cynoscion microlepidotus), Pescada cambucu (Cynoscion virescens), Pescadinha (Macrodon ancylodon), Raia santa (Rioraja agassizii), Raia carimbada (Atlantoraja cyclophora), Raia chita (Atlantoraja castelnaui), Raia emplasto (Atlantoraja platana, Sympterygia bonapartii, Sympterygia acuta), Raia (Breviraja spinosa, Rajella purpuriventralis), Anchova (Pomatomus saltatrix), Gordinho (Peprilus paru), Merluza (Merluccius hubbsi), Tira-vira (Percophis brasiliensis), Congro rosa (Genypterus brasiliensis), Congro-preto (Conger orbignianus, Myrophis punctatus, Raneya brasiliensis), Namorado (Pseudopercis numida), Pargo rosa (Pagrus pagrus), Batata (Lopholatilus villarii), Bagre-branco (Arius grandicassis), Bagre-de-fita (Bagre marinus), Bagre-de-penacho (Bagre bagre), Bagre (Genidens barbus, Netuma planifrons), Bagre-amarelo (Cathorops spixii), Bagre rosado (Genidens genidens, Genidens barbus), Camarão branco (Litopenaeus schmitti), Robalo (Centropomus parallelus, Centropomus undecimalis, Centropomus ensiferus, Centropomus pectinatus), Prejereba (Lobotes surinamensis), Vermelho (Lutjanus jocu, Ocyurus chrysurus), Sororoca, serra (Scomberomorus brasiliensis), Siri-mangue (Callinectes exasperatus), Siri-azul (Callinectes sapidus), Siri nema (Callinectes bocourti), Siri (Callinectes danae, Callinectes ornatus), Goete (Cynoscion jamaicensis)',
    complementar:
        'Emalhe Costeiro (fundo). Espécies-alvo: Corvina (Micropogonias furnieri), Castanha (Umbrina canosai), Pescada (Cynoscion striatus), Abrótea (Urophycis brasiliensis)',
    area: 'Mar territorial do Estado de Santa Catarina',
    valeEmSc: true,
    regras:
        'DIMENSÕES DA REDE (art. 3º)\nMalha igual ou superior a 40 mm, entre nós opostos da malha esticada. Comprimento máximo de 1.600 m. Altura máxima de 30 m.\n\nEMBARCAÇÃO (art. 4º)\nPermitida o ano todo, com embarcação de comprimento máximo de 12 m, a remo ou motorizada. O uso de motor é permitido apenas para embarcações que operam entre os municípios de Passo de Torres e Imbituba, com potência máxima de 90 HP (§ 1º).\n\nREGRAS DAS ESPÉCIES (art. 4º, § 2º)\nAs regras específicas de ordenamento das espécies que constam na Autorização de Pesca de Arrasto de Praia, incluindo os períodos de proibição de pesca e os tamanhos mínimos definidos, deverão ser obedecidas.\n\nMONITORAMENTO (art. 9º)\nMapa de Produção, um por dia, enviado até o quinto dia útil do mês subsequente, mesmo sem captura e mesmo sem saída da embarcação. A não entrega enseja suspensão de 30 dias da Autorização (art. 10) e, persistindo, cancelamento (art. 11).\n\nSANÇÕES (art. 12)\nLei nº 9.605, de 12 de fevereiro de 1998, e Decreto nº 6.514, de 22 de julho de 2008.',
    norma:
        'Modalidade incluída no Anexo VI da IN MPA/MMA nº 10/2011 pela Portaria SAP/MAPA nº 617, de 8 de março de 2022, que ordena a pesca de arrasto de praia no Mar Territorial em Santa Catarina.',
  ),
  Modalidade(
    '6.10',
    Metodo.arrasto,
    'Arrasto de praia',
    alvo: 'Tainha (Mugil liza); Parati (Mugil curema); Betara (Menticirrhus littoralis); Pescada (Cynoscion striatus); Corvina (Micropogonias furnieri); Pampo ou Gordinho (Peprilus paru); Enchova ou Anchova (Pomatomus saltatrix); Espada (Trichiurus lepturus); e Maria- luiza (Paralonchurus brasiliensis); Xaréu (Caranx hippos); Sororoca (Scomberomorus brasiliensis); Savelha (Brevoortia pectinata); Pescadinha- real (Macrodon ancylodon); Peixerei (Odonthestes bonariensis /Atherinella brasiliensis); Goete (Cynoscion jamaicensis); Abrótea (Urophycis brasiliensis); Xerelete (Caranx crysus); Sardinha-lage (Opisthonema oglinum); Prejereba (Lobotes surinamensis); Pescada-branca (Cynoscion leiarchus); Pescada-amarela (Cynoscion acoupa); Cavala (Scomber japonicus); Peixe-porco (Balistes capriscus / B. vetula); Palombeta ou Carapau (Chloroscombrus chrysurus); Olho-de-cão (Priacanthus arenatus); Olho-de-boi (Seriola lalandi) Linguado (Paralichthys patagonicus /P. brasiliensis); Galo (Selene vômer); Paru (Chaetodipterus faber); Oveva (Larimus breviceps); Marimbá (Diplodus argenteus); Guaivira (Oligoplites saliens); Robalo (Centropomus parallelus, Centropomus undecimalis); Carapicu (Eucinostomus gula); Cangoá (Stellifer rastifer); Miracéu (Astrocopus sexspinosus); Caratinga (Eugerres brasilianus); Carapeba (Diapterus rhombeus), Lulas (Loligo plei, Loligo sanpaulensis, Loligo sp., Lolliguncula brevis)',
    complementar:
        'Diversificada costeira (embarcações de pequeno porte, com propulsão a remo ou a vela, e, quando motorizadas, com potência de motor até 18,0 hp, comprimento até 8,00 m e arqueação bruta até 2,0). Espécie-alvo: peixes e crustáceos diversos',
    area: 'Mar territorial do Estado de Santa Catarina',
    valeEmSc: true,
    regras:
        'DIMENSÕES DA REDE (art. 3º)\nMalha igual ou superior a 40 mm, entre nós opostos da malha esticada. Comprimento máximo de 1.600 m. Altura máxima de 30 m.\n\nEMBARCAÇÃO (art. 4º)\nPermitida o ano todo, com embarcação de comprimento máximo de 12 m, a remo ou motorizada. O uso de motor é permitido apenas para embarcações que operam entre os municípios de Passo de Torres e Imbituba, com potência máxima de 90 HP (§ 1º).\n\nREGRAS DAS ESPÉCIES (art. 4º, § 2º)\nAs regras específicas de ordenamento das espécies que constam na Autorização de Pesca de Arrasto de Praia, incluindo os períodos de proibição de pesca e os tamanhos mínimos definidos, deverão ser obedecidas.\n\nMONITORAMENTO (art. 9º)\nMapa de Produção, um por dia, enviado até o quinto dia útil do mês subsequente, mesmo sem captura e mesmo sem saída da embarcação. A não entrega enseja suspensão de 30 dias da Autorização (art. 10) e, persistindo, cancelamento (art. 11).\n\nSANÇÕES (art. 12)\nLei nº 9.605, de 12 de fevereiro de 1998, e Decreto nº 6.514, de 22 de julho de 2008.',
    norma:
        'Modalidade incluída no Anexo VI da IN MPA/MMA nº 10/2011 pela Portaria SAP/MAPA nº 617, de 8 de março de 2022, que ordena a pesca de arrasto de praia no Mar Territorial em Santa Catarina.',
  ),
  Modalidade(
    '6.11',
    Metodo.arrasto,
    'Arrasto de praia',
    alvo: 'Tainha (Mugil liza); Parati (Mugil curema); Betara (Menticirrhus littoralis); Pescada (Cynoscion striatus); Corvina (Micropogonias furnieri); Pampo ou Gordinho (Peprilus paru); Enchova ou Anchova (Pomatomus saltatrix); Espada (Trichiurus lepturus); e Maria-luiza (Paralonchurus brasiliensis); Xaréu (Caranx hippos); Sororoca (Scomberomorus brasiliensis); Savelha (Brevoortia pectinata); Pescadinha- real (Macrodon ancylodon); Peixerei (Odonthestes bonariensis /Atherinella brasiliensis); Goete (Cynoscion jamaicensis); Abrótea (Urophycis brasiliensis); Xerelete (Caranx crysus); Sardinha-lage (Opisthonema oglinum); Prejereba (Lobotes surinamensis); Pescada-branca (Cynoscion leiarchus); Pescada-amarela (Cynoscion acoupa); Cavala (Scomber japonicus); Peixe-porco (Balistes capriscus / B. vetula); Palombeta ou Carapau (Chloroscombrus chrysurus); Olho-de-cão (Priacanthus arenatus); Olho-de-boi (Seriola lalandi) Linguado (Paralichthys patagonicus /P. brasiliensis); Galo (Selene vômer); Paru (Chaetodipterus faber); Oveva (Larimus breviceps); Marimbá (Diplodus argenteus); Guaivira (Oligoplites saliens); Robalo (Centropomus parallelus, Centropomus undecimalis); Carapicu (Eucinostomus gula); Cangoá (Stellifer rastifer); Miracéu (Astrocopus sexspinosus); Caratinga (Eugerres brasilianus); Carapeba (Diapterus rhombeus), Lulas (Loligo plei, Loligo sanpaulensis, Loligo sp., Lolliguncula brevis)',
    area: 'Mar territorial do Estado de Santa Catarina',
    valeEmSc: true,
    regras:
        'DIMENSÕES DA REDE (art. 3º)\nMalha igual ou superior a 40 mm, entre nós opostos da malha esticada. Comprimento máximo de 1.600 m. Altura máxima de 30 m.\n\nEMBARCAÇÃO (art. 4º)\nPermitida o ano todo, com embarcação de comprimento máximo de 12 m, a remo ou motorizada. O uso de motor é permitido apenas para embarcações que operam entre os municípios de Passo de Torres e Imbituba, com potência máxima de 90 HP (§ 1º).\n\nREGRAS DAS ESPÉCIES (art. 4º, § 2º)\nAs regras específicas de ordenamento das espécies que constam na Autorização de Pesca de Arrasto de Praia, incluindo os períodos de proibição de pesca e os tamanhos mínimos definidos, deverão ser obedecidas.\n\nMONITORAMENTO (art. 9º)\nMapa de Produção, um por dia, enviado até o quinto dia útil do mês subsequente, mesmo sem captura e mesmo sem saída da embarcação. A não entrega enseja suspensão de 30 dias da Autorização (art. 10) e, persistindo, cancelamento (art. 11).\n\nSANÇÕES (art. 12)\nLei nº 9.605, de 12 de fevereiro de 1998, e Decreto nº 6.514, de 22 de julho de 2008.',
    norma:
        'Modalidade incluída no Anexo VI da IN MPA/MMA nº 10/2011 pela Portaria SAP/MAPA nº 617, de 8 de março de 2022, que ordena a pesca de arrasto de praia no Mar Territorial em Santa Catarina.',
  ),
];

/// Tira acento e deixa minúsculo, pra busca achar mesmo quando a
/// pessoa digita "cacao", "malhao" ou "PEIXE ESPADA".
String semAcento(String texto) {
  const de = 'áàâãäéèêëíìîïóòôõöúùûüç';
  const para = 'aaaaaeeeeiiiiooooouuuuc';
  var resultado = texto.toLowerCase();
  for (var i = 0; i < de.length; i++) {
    resultado = resultado.replaceAll(de[i], para[i]);
  }
  return resultado;
}
