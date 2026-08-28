// =====================================================================
// PONTOS EM VERIFICAÇÃO
//
// Onde o aplicativo dá uma resposta e existe indício de que ela pode
// estar errada, o ponto entra aqui e a ficha da espécie avisa.
//
// Isso não é excesso de zelo. O app é usado para autuar. Uma resposta
// errada custa caro nos dois sentidos: deixar passar quem deveria ser
// autuado, ou autuar quem estava dentro da lei. Enquanto a dúvida
// existe, quem está com o aparelho na mão precisa saber que ela existe.
//
// Nada aqui é palpite: cada ponto tem o que o app diz hoje, o que a
// outra fonte indica, e qual norma falta para resolver. Quando a norma
// chegar, o ponto sai daqui e a resposta do app é corrigida.
// =====================================================================

class Conflito {
  /// Nome curto, para a lista.
  final String titulo;

  /// O que o aplicativo responde hoje.
  final String appDiz;

  /// O que a outra fonte indica, e qual é essa fonte.
  final String indicio;

  /// A norma que falta para resolver.
  final String falta;

  /// Nomes científicos das espécies alcançadas, para marcar as fichas.
  final List<String> cientificos;

  /// Espécies alcançadas que não estão no aplicativo, mas importam
  /// para entender o alcance do ponto.
  final String tambemAlcanca;

  /// Data em que o ponto foi registrado.
  final String desde;

  const Conflito({
    required this.titulo,
    required this.appDiz,
    required this.indicio,
    required this.falta,
    required this.cientificos,
    required this.desde,
    this.tambemAlcanca = '',
  });

  bool alcanca(String nomeCientifico) {
    final n = nomeCientifico.toLowerCase();
    return cientificos.any(
        (c) => n.contains(c.toLowerCase()) || c.toLowerCase().contains(n));
  }
}

const conflitos = <Conflito>[
  Conflito(
    titulo: 'Pesca regulada de espécies da Lista — Portaria 59-C/2018',
    desde: '27/08/2026',
    cientificos: ['Mycteroperca bonaci'],
    tambemAlcanca: 'Alcança também Epinephelus morio (garoupa-São-Tomé), '
        'Mycteroperca interstitialis (badejo-amarelo) e Lutjanus '
        'cyanopterus (caranha), que constam da Lista mas não da IN 53 e '
        'por isso não têm tamanho mínimo no aplicativo.',
    appDiz: 'Captura vedada em qualquer tamanho, o ano inteiro, pela '
        'proteção integral do art. 3º da Portaria GM/MMA nº 1.666/2026. '
        'Para o badejo quadrado, o aplicativo mostra o tamanho mínimo de '
        '45 cm da IN 53/2005, riscado.',
    indicio: 'O IBAMA publicou informe em 31 de julho de 2026 — três '
        'meses depois das Portarias 1.666 e 1.667 — aplicando a estas '
        'quatro espécies um defeso de 1º de agosto a 30 de setembro, com '
        'tamanhos mínimos: sirigado ou badejo-quadrado 60 cm, '
        'garoupa-São-Tomé 45 cm, badejo-amarelo 45 cm, caranha 50 cm. O '
        'mesmo informe reconhece que as quatro integram a Lista da '
        'Portaria 1.667/2026.\n\n'
        'Defeso e tamanho mínimo só existem onde a captura é permitida '
        'fora do período. Se valesse a proteção integral, não haveria o '
        'que fechar nem o que medir.\n\n'
        'A compilação da UNIVALI (junho de 2025) atribui exatamente '
        'estas quatro espécies à Portaria Interministerial nº 59-C/2018, '
        'como pesca permitida. Quatro em quatro.\n\n'
        'O art. 11, parágrafo único, da Portaria 1.666 mantém em vigor '
        '"o Plano de Recuperação e as regras previamente estabelecidas" '
        'durante a revisão prevista no caput.',
    falta: 'Portaria Interministerial nº 59-C, de 2018. Sem o texto, não '
        'dá para saber se a pesca segue permitida, em que condições, e '
        'se o tamanho mínimo é 45 cm da IN 53 ou 60 cm do informe.',
  ),
  Conflito(
    titulo: 'Pesca regulada de espécies da Lista — Portarias 39, 40 e '
        '41 de 2018',
    desde: '27/08/2026',
    cientificos: [
      'Genidens barbus',
      'Lopholatilus villarii',
      'Epinephelus marginatus',
    ],
    tambemAlcanca: 'Alcança também Hyporthodus niveatus '
        '(cherne-verdadeiro), que consta da Lista mas não da IN 53.',
    appDiz: 'Captura vedada em qualquer tamanho, pela proteção integral '
        'do art. 3º da Portaria 1.666/2026.',
    indicio: 'A compilação da UNIVALI registra, para estas espécies, '
        '"pesca permitida" conforme as Portarias Interministeriais nº '
        '39/2018 (bagre-branco, exceto nas águas adjacentes a São Paulo '
        'e ao Paraná), nº 40/2018 (cherne-verdadeiro, mínimo 45 cm, e '
        'peixe-batata, mínimo 40 cm, com defeso de 1º de setembro a 31 '
        'de outubro entre 100 e 600 m de profundidade) e nº 41/2018 '
        '(garoupa-verdadeira, entre 47 e 73 cm, defeso de 1º de novembro '
        'a 28 de fevereiro, só para embarcações até 20 AB em espinhel '
        'horizontal de fundo ou linha de mão de fundo).\n\n'
        'É a mesma situação da Portaria 59-C/2018, e naquele caso o '
        'IBAMA confirmou o regime na prática, em julho de 2026.',
    falta: 'Portarias Interministeriais nº 39, nº 40 e nº 41, de 2018.',
  ),
  Conflito(
    titulo: 'Tainha — a Portaria 24/2018 foi modificada em 2020',
    desde: '27/08/2026',
    cientificos: ['Mugil liza', 'Mugil platanus'],
    appDiz: 'O aplicativo reproduz o Capítulo I da Portaria '
        'Interministerial nº 24, de 15 de maio de 2018, na redação '
        'original: temporada por modalidade e áreas fechadas.',
    indicio: 'A compilação da UNIVALI cita a norma como "Portaria nº '
        '24/2018, modificada pela Portaria nº 75/2020". Não se sabe o '
        'que a modificação alterou — se datas de temporada, áreas, ou '
        'outra coisa.',
    falta: 'Portaria nº 75, de 2020.',
  ),
  Conflito(
    titulo: 'Camarões — a Portaria 656/2022 foi alterada no mesmo ano',
    desde: '27/08/2026',
    cientificos: [
      'Penaeus paulensis',
      'Penaeus brasiliensis',
      'Penaeus subtilis',
      'Xiphopenaeus kroyeri',
      'Penaeus schmitti',
      'Pleoticus muelleri',
      'Artemesia longinaris',
    ],
    appDiz: 'Defeso de 28 de janeiro a 30 de abril, tamanho mínimo de '
        '90 mm e as regras de petrecho da Portaria SAP/MAPA nº 656, de '
        '30 de março de 2022, com o texto conferido.',
    indicio: 'A compilação da UNIVALI cita a norma como "Portaria '
        'SAP/MAPA nº 656/2022, alterada pela Portaria SAP/MAPA nº '
        '695/2022".',
    falta: 'Portaria SAP/MAPA nº 695, de 2022.',
  ),
  Conflito(
    titulo: 'A Lista de ameaçadas pode ter mais normas que a 445/2014',
    desde: '27/08/2026',
    cientificos: [],
    tambemAlcanca: 'Alcança a Lista inteira, e portanto a data em que a '
        'vedação passa a valer para cada espécie.',
    appDiz: 'A conferência de quais espécies já constavam da lista '
        'anterior — que define se a vedação vale hoje ou só a partir de '
        '25 de outubro de 2026, pelo art. 12 da Portaria 1.666 — foi '
        'feita contra a Portaria MMA nº 445/2014, uma a uma, para as 35 '
        'espécies da IN 53.',
    indicio: 'A compilação da UNIVALI apresenta a Lista de ameaçadas '
        'como resultante das "Portarias MMA nº 445/2014, 73/2018, '
        '148/2022 e 354/2023". A Portaria 1.667/2026 revogou '
        'expressamente apenas a 445/2014. Não se sabe o que aconteceu '
        'com as outras três, nem se elas incluíam espécies que a 445 não '
        'trazia.',
    falta: 'Portarias MMA nº 73/2018, nº 148/2022 e nº 354/2023.',
  ),
  Conflito(
    titulo: 'O asterisco da Lista Nacional Oficial',
    desde: '27/08/2026',
    cientificos: [],
    tambemAlcanca: 'Alcança 94 dos 490 itens da Lista.',
    appDiz: 'O aplicativo mostra o asterisco ao lado do número do item, '
        'como a Lista o imprime, e informa que não há legenda no texto '
        'publicado. Não interpreta.',
    indicio: 'Nenhum dos 94 itens com asterisco consta da Portaria '
        '445/2014, enquanto 271 dos 396 sem asterisco constam. Nas 11 '
        'espécies da IN 53 conferidas à mão, o asterisco acertou 11 de '
        '11 sobre estar ou não na lista anterior.\n\n'
        'Se a marca significar "espécie nova na Lista", ela responde '
        'sozinha quais das 490 têm o prazo de 180 dias do art. 12 — e a '
        'data da vedação deixa de ser desconhecida para 479 espécies.\n\n'
        'Contra a hipótese: a própria Portaria 445/2014 usava asterisco, '
        'com legenda publicada, para marcar o oposto — as espécies que '
        'já constavam da lista anterior, a IN 05/2004. Símbolo igual, '
        'sentido invertido.',
    falta: 'A versão certificada do Diário Oficial de 28/04/2026 '
        '(edição 78, seção 1, página 96), que deve trazer a legenda.',
  ),
];

/// Os pontos em verificação que alcançam uma espécie.
List<Conflito> conflitosDe(String cientifico) {
  final partes = cientifico.split(RegExp(r'\s*/\s*'));
  return conflitos
      .where((c) => partes.any((p) => c.alcanca(p.trim())))
      .toList();
}
