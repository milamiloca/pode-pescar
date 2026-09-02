// =====================================================================
// PLANOS DE RECUPERAÇÃO — O QUE A LISTA NÃO DIZ
//
// Estar na Lista Nacional Oficial não quer dizer que a captura seja
// proibida. Este arquivo existe porque o aplicativo dizia que sim, e
// estava errado.
//
// O caminho está dentro da própria Portaria GM/MMA nº 1.666/2026:
//
//   Art. 3º, caput  proteção integral. É o PADRÃO, não a regra única.
//   Art. 4º         o uso PODE ser permitido, em bases sustentáveis,
//                   por Plano de Recuperação, com três condições
//                   cumulativas: o Plano reconhecer a possibilidade de
//                   uso (I), um ato normativo do MMA reconhecer o uso
//                   sustentável (II), e os órgãos federais
//                   regulamentarem as medidas de manejo (III).
//   Art. 4º, § 1º   o Plano PODE manter a moratória. Ter plano não é
//                   sinônimo de liberação.
//   Art. 6º         em EN e CR o uso só em casos excepcionais. Em VU é
//                   o caso comum.
//   Art. 11, § ún.  os Planos e as regras já estabelecidas continuam em
//                   vigor durante a revisão prevista no caput.
//
// Cada Portaria Interministerial aqui reproduzida amarra a própria
// vigência ao ato do MMA que oficializou o Plano e declarou a espécie
// passível de uso. Esses atos NÃO foram obtidos, e por isso cada
// entrada carrega o aviso: sei o que a regra diz, não sei se ela ainda
// vige.
//
// Para as espécies em que não localizei plano, o aplicativo não afirma
// nem nega: diz que a vedação do art. 3º se aplica por padrão e que
// esta espécie não foi conferida. É a diferença entre "não pode" e
// "não conferi" — e num aplicativo de consulta, essa
// diferença é a coisa mais importante da tela.
// =====================================================================

enum Regime {
  /// Há Plano de Recuperação, ato do MMA e norma de ordenamento. A
  /// pesca é regulada — com tamanho, defeso e frota definidos.
  regulada,

  /// Está na Lista e o aplicativo não conferiu se existe plano. A
  /// vedação do art. 3º se aplica por padrão, mas não é resposta
  /// fechada.
  naoVerificado,
}

class Plano {
  /// Como a norma nomeia a espécie.
  final String especie;

  /// Nomes científicos alcançados, para cruzar com a ficha.
  final List<String> cientificos;

  /// A Portaria Interministerial que ordena a pesca.
  final String ordenamento;

  /// O ato do MMA que oficializou o Plano e declarou a espécie
  /// passível de uso. É dele que depende a vigência do ordenamento.
  final String atoDoMMA;

  /// Restrição geográfica, quando a norma impõe uma.
  final String ondePode;

  /// Para que estados a norma vale, sempre dito. Este aplicativo é para
  /// Santa Catarina: a primeira coisa que quem consulta precisa saber de
  /// uma norma é se ela alcança o lugar onde ela está.
  final String abrangencia;

  /// Falso quando se sabe que o Plano existe mas o texto da norma de
  /// ordenamento não foi obtido. Nesse caso o aplicativo não dá regra
  /// nenhuma: manda consultar a norma, pelo nome.
  final bool normaObtida;

  /// A faixa de tamanho permitida, como a norma a define.
  final String tamanho;

  /// O mínimo em centímetros, para comparar com a IN 53 sem depender
  /// de ler a frase. Onde os dois números diferem, a ficha avisa.
  final int cmMinimo;

  /// O teto, quando a norma fixa um. Zero quando não há. A garoupa é o
  /// caso que obriga esse campo: o art. 3º da Portaria 41 permite de
  /// 47 a 73 cm, e a IN 53 não tem teto nenhum. Um exemplar grande
  /// demais é irregular por uma norma e regular pela outra.
  final int cmMaximo;

  /// O período fechado, quando houver.
  final String defeso;

  /// Que frota e que modalidade podem capturar.
  final String quemPode;

  /// O que fazer com o exemplar capturado incidentalmente.
  final String incidental;

  /// O texto dos artigos, para quem precisa citar.
  final String detalhe;

  /// Prova de que a norma segue sendo aplicada, quando houver.
  /// Vale mais que qualquer inferência: é o órgão fiscalizador
  /// agindo sob ela, com data.
  final String emVigor;

  const Plano({
    required this.especie,
    required this.cientificos,
    required this.ordenamento,
    required this.atoDoMMA,
    required this.abrangencia,
    this.tamanho = '',
    this.cmMinimo = 0,
    this.quemPode = '',
    this.incidental = '',
    this.detalhe = '',
    this.ondePode = '',
    this.defeso = '',
    this.cmMaximo = 0,
    this.normaObtida = true,
    this.emVigor = '',
  });

  bool alcanca(String nomeCientifico) {
    final n = nomeCientifico.toLowerCase();
    return cientificos.any(
        (c) => n.contains(c.toLowerCase()) || c.toLowerCase().contains(n));
  }
}

/// O aviso que vale para todos: a vigência do ordenamento está
/// amarrada ao ato do MMA, e nenhum desses atos foi obtido.
const avisoVigencia =
    'Cada uma destas Portarias Interministeriais declara, no seu art. 1º, '
    'que a própria vigência está vinculada à vigência do ato do Ministério '
    'do Meio Ambiente que oficializou o Plano de Recuperação e declarou a '
    'espécie passível de uso. Três dos quatro foram obtidos e lidos — as '
    'Portarias MMA nº 127, nº 227 e nº 229, todas de 2018. Falta a nº '
    '292/2018, dos peixes recifais.\n\n'
    'Cada um traz um art. 6º que permite ao Ministério SUSPENDER OU '
    'REVOGAR seus efeitos ao identificar deficiências na implementação, '
    'por ato próprio. Ter o texto de 2018 não é o mesmo que saber que '
    'ele segue em vigor.\n\n'
    'A Portaria 1.666/2026, art. 11, submeteu os Planos vigentes a revisão '
    'em até noventa dias da publicação — prazo vencido em 27 de julho de '
    '2026 — e o parágrafo único manteve os Planos e as regras anteriores '
    'em vigor durante essa revisão.';

const planos = <Plano>[
  // ------------------------------------------- garoupa-verdadeira
  Plano(
    especie: 'Garoupa-verdadeira',
    cientificos: ['Epinephelus marginatus'],
    ordenamento:
        'Portaria Interministerial nº 41, de 27 de julho de 2018',
    atoDoMMA: 'Portaria MMA nº 229, de 14 de junho de 2018 — texto '
        'obtido e lido (DOU de 15/06/2018, edição 114, página 74)',
    abrangencia: 'Águas jurisdicionais brasileiras. Alcança Santa Catarina.',
    tamanho: 'Comprimento total de 47 cm a 73 cm',
    defeso: '1º de novembro a 28 de fevereiro',
    cmMinimo: 47,
    cmMaximo: 73,
    quemPode: 'Pesca comercial apenas por embarcações de até 20 AB '
        'permissionadas em espinhel de fundo horizontal ou linha de mão '
        'de fundo',
    incidental: 'Liberar vivo ou descartar no ato da captura, registrando '
        'a captura e a liberação ou o descarte',
    detalhe: 'TAMANHO (art. 3º)\n'
        'Permitidos a captura, retenção, transporte, beneficiamento e '
        'comercialização apenas de indivíduos com comprimento total maior '
        'ou igual a 47 cm e menor ou igual a 73 cm. É uma FAIXA: o '
        'exemplar grande demais também está fora.\n'
        'Parágrafo único: devem ser desembarcados inteiros, podendo ser '
        'eviscerados.\n\n'
        'DEFESO (art. 2º)\n'
        'Proibidos a pesca direcionada, o transporte, o desembarque e a '
        'comercialização, anualmente, de 1º de novembro a 28 de '
        'fevereiro, para todos os métodos de captura e todas as '
        'embarcações.\n'
        '§ 1º Quem armazena, transporta, beneficia, industrializa ou '
        'comercializa só pode seguir durante o defeso se entregar, até 10 '
        'de novembro de cada ano, a declaração de estoques do Anexo I nas '
        'Superintendências do IBAMA.\n'
        '§ 2º Durante o defeso, qualquer volume só circula se vier de '
        'estoque declarado e estiver acompanhado da cópia da '
        'declaração.\n'
        '§ 3º A retenção a bordo e o desembarque são tolerados até 5 de '
        'novembro de cada ano.\n\n'
        'FROTA (art. 4º)\n'
        'A partir de 1º de março de 2019, a captura direcionada, o '
        'transporte, o armazenamento a bordo e o desembarque pela pesca '
        'comercial só são permitidos a embarcações de pequeno porte, com '
        'arqueação bruta menor ou igual a 20, permissionadas às pescarias '
        'de espinhel de fundo horizontal e linha de mão de fundo.\n\n'
        'RASTREAMENTO (art. 5º)\n'
        'Embarcações com 8 m ou mais inscritas na modalidade 1.7 '
        '(espinhel horizontal de fundo) devem manter o PREPS em '
        'funcionamento e entregar os mapas de bordo.\n\n'
        'CAPTURA INCIDENTAL (art. 1º, § 2º)\n'
        'Os exemplares capturados incidentalmente em desacordo com esta '
        'norma devem ser liberados vivos ou descartados no ato da '
        'captura, registrando-se a captura e a liberação ou o descarte.\n\n'
        'SANÇÃO (art. 8º)\n'
        'Penalidades da Lei nº 9.605, de 1998, e do Decreto nº 6.514, de '
        '2008. A embarcação em desacordo tem a autorização de pesca '
        'cancelada ou suspensa por prazo não inferior a seis meses.',
  ),

  // ------------------- sirigado, badejo-amarelo, garoupa-de-São-Tomé
  // ------------------- e caranha
  Plano(
    especie: 'Sirigado ou badejo-quadrado',
    cientificos: ['Mycteroperca bonaci'],
    ordenamento:
        'Portaria Interministerial nº 59-C, de 9 de novembro de 2018',
    atoDoMMA: 'Portaria MMA nº 292, de 18 de julho de 2018 — texto '
        'obtido e lido (DOU de 19/07/2018, edição 138, página 42)',
    abrangencia: 'Águas jurisdicionais brasileiras. Alcança Santa Catarina.',
    tamanho: 'Comprimento total igual ou maior que 60 cm',
    defeso: '1º de agosto a 30 de setembro',
    cmMinimo: 60,
    quemPode: 'Pesca amadora e esportiva somente na categoria pesque e '
        'solte (art. 2º, § 2º)',
    incidental: 'Liberar vivo ou descartar no ato da captura, com registro',
    emVigor: 'O IBAMA divulgou, no início de agosto de 2026, informe aplicando este regime: defeso de 1º de agosto a 30 de setembro para as quatro espécies, tamanhos mínimos de 60 cm (sirigado), 45 cm (garoupa-de-São-Tomé), 45 cm (badejo-amarelo) e 50 cm (caranha), comercialização durante o defeso apenas para pescado capturado antes de 1º de agosto e com estoque declarado, e prazo de declaração até 10 de agosto — presencialmente ou pelo SEI-Ibama. O informe registra que as quatro integram a Lista atualizada pela Portaria GM/MMA nº 1.667/2026 e que a medida vale em toda a área de ocorrência das espécies.\n\nIsto importa por duas razões. Primeira: o órgão fiscalizador está aplicando a Portaria 59-C/2018 em agosto de 2026, quatro meses depois das Portarias 1.666 e 1.667 — o regime do Plano de Recuperação sobreviveu à Lista nova. Segunda: o informe é posterior a 27 de julho de 2026, prazo da revisão do art. 11 da Portaria 1.666, e reproduz as regras de 2018 sem alteração.',
    detalhe: _texto59c,
  ),
  Plano(
    especie: 'Badejo-amarelo',
    cientificos: ['Mycteroperca interstitialis'],
    ordenamento:
        'Portaria Interministerial nº 59-C, de 9 de novembro de 2018',
    atoDoMMA: 'Portaria MMA nº 292, de 18 de julho de 2018 — texto '
        'obtido e lido (DOU de 19/07/2018, edição 138, página 42)',
    abrangencia: 'Águas jurisdicionais brasileiras. Alcança Santa Catarina.',
    tamanho: 'Comprimento total igual ou maior que 45 cm',
    defeso: '1º de agosto a 30 de setembro',
    cmMinimo: 45,
    quemPode: 'Pesca amadora e esportiva somente na categoria pesque e '
        'solte (art. 2º, § 2º)',
    incidental: 'Liberar vivo ou descartar no ato da captura, com registro',
    emVigor: 'O IBAMA divulgou, no início de agosto de 2026, informe aplicando este regime: defeso de 1º de agosto a 30 de setembro para as quatro espécies, tamanhos mínimos de 60 cm (sirigado), 45 cm (garoupa-de-São-Tomé), 45 cm (badejo-amarelo) e 50 cm (caranha), comercialização durante o defeso apenas para pescado capturado antes de 1º de agosto e com estoque declarado, e prazo de declaração até 10 de agosto — presencialmente ou pelo SEI-Ibama. O informe registra que as quatro integram a Lista atualizada pela Portaria GM/MMA nº 1.667/2026 e que a medida vale em toda a área de ocorrência das espécies.\n\nIsto importa por duas razões. Primeira: o órgão fiscalizador está aplicando a Portaria 59-C/2018 em agosto de 2026, quatro meses depois das Portarias 1.666 e 1.667 — o regime do Plano de Recuperação sobreviveu à Lista nova. Segunda: o informe é posterior a 27 de julho de 2026, prazo da revisão do art. 11 da Portaria 1.666, e reproduz as regras de 2018 sem alteração.',
    detalhe: _texto59c,
  ),
  Plano(
    especie: 'Garoupa-de-São-Tomé',
    cientificos: ['Epinephelus morio'],
    ordenamento:
        'Portaria Interministerial nº 59-C, de 9 de novembro de 2018',
    atoDoMMA: 'Portaria MMA nº 292, de 18 de julho de 2018 — texto '
        'obtido e lido (DOU de 19/07/2018, edição 138, página 42)',
    abrangencia: 'Águas jurisdicionais brasileiras. Alcança Santa Catarina.',
    tamanho: 'Comprimento total igual ou maior que 45 cm',
    defeso: '1º de agosto a 30 de setembro',
    cmMinimo: 45,
    quemPode: 'Pesca amadora e esportiva somente na categoria pesque e '
        'solte (art. 2º, § 2º)',
    incidental: 'Liberar vivo ou descartar no ato da captura, com registro',
    emVigor: 'O IBAMA divulgou, no início de agosto de 2026, informe aplicando este regime: defeso de 1º de agosto a 30 de setembro para as quatro espécies, tamanhos mínimos de 60 cm (sirigado), 45 cm (garoupa-de-São-Tomé), 45 cm (badejo-amarelo) e 50 cm (caranha), comercialização durante o defeso apenas para pescado capturado antes de 1º de agosto e com estoque declarado, e prazo de declaração até 10 de agosto — presencialmente ou pelo SEI-Ibama. O informe registra que as quatro integram a Lista atualizada pela Portaria GM/MMA nº 1.667/2026 e que a medida vale em toda a área de ocorrência das espécies.\n\nIsto importa por duas razões. Primeira: o órgão fiscalizador está aplicando a Portaria 59-C/2018 em agosto de 2026, quatro meses depois das Portarias 1.666 e 1.667 — o regime do Plano de Recuperação sobreviveu à Lista nova. Segunda: o informe é posterior a 27 de julho de 2026, prazo da revisão do art. 11 da Portaria 1.666, e reproduz as regras de 2018 sem alteração.',
    detalhe: _texto59c,
  ),
  Plano(
    especie: 'Caranha',
    cientificos: ['Lutjanus cyanopterus'],
    ordenamento:
        'Portaria Interministerial nº 59-C, de 9 de novembro de 2018',
    atoDoMMA: 'Portaria MMA nº 292, de 18 de julho de 2018 — texto '
        'obtido e lido (DOU de 19/07/2018, edição 138, página 42)',
    abrangencia: 'Águas jurisdicionais brasileiras. Alcança Santa Catarina.',
    tamanho: 'Comprimento total igual ou maior que 50 cm',
    defeso: '1º de agosto a 30 de setembro',
    cmMinimo: 50,
    quemPode: 'Pesca amadora e esportiva somente na categoria pesque e '
        'solte (art. 2º, § 2º)',
    incidental: 'Liberar vivo ou descartar no ato da captura, com registro',
    emVigor: 'O IBAMA divulgou, no início de agosto de 2026, informe aplicando este regime: defeso de 1º de agosto a 30 de setembro para as quatro espécies, tamanhos mínimos de 60 cm (sirigado), 45 cm (garoupa-de-São-Tomé), 45 cm (badejo-amarelo) e 50 cm (caranha), comercialização durante o defeso apenas para pescado capturado antes de 1º de agosto e com estoque declarado, e prazo de declaração até 10 de agosto — presencialmente ou pelo SEI-Ibama. O informe registra que as quatro integram a Lista atualizada pela Portaria GM/MMA nº 1.667/2026 e que a medida vale em toda a área de ocorrência das espécies.\n\nIsto importa por duas razões. Primeira: o órgão fiscalizador está aplicando a Portaria 59-C/2018 em agosto de 2026, quatro meses depois das Portarias 1.666 e 1.667 — o regime do Plano de Recuperação sobreviveu à Lista nova. Segunda: o informe é posterior a 27 de julho de 2026, prazo da revisão do art. 11 da Portaria 1.666, e reproduz as regras de 2018 sem alteração.',
    detalhe: _texto59c,
  ),

  // ------------------------------ cherne-verdadeiro e peixe-batata
  Plano(
    especie: 'Cherne-verdadeiro',
    cientificos: ['Hyporthodus niveatus', 'Epinephelus niveatus'],
    ordenamento:
        'Portaria Interministerial nº 40, de 27 de julho de 2018',
    atoDoMMA: 'Portaria MMA nº 227, de 14 de junho de 2018 — texto '
        'obtido e lido (DOU de 15/06/2018, edição 114, página 74)',
    abrangencia: 'Águas jurisdicionais brasileiras; o defeso do art. 6º é do litoral Sudeste e Sul. Alcança Santa Catarina.',
    tamanho: 'Comprimento total igual ou maior que 45 cm',
    defeso: '1º de setembro a 31 de outubro, entre 100 e 600 m de '
        'profundidade, no litoral Sudeste e Sul',
    cmMinimo: 45,
    quemPode: 'Frota de espinhel de fundo do Sudeste e Sul limitada ao '
        'número de embarcações já registradas — sem novas autorizações',
    incidental: 'Liberar vivo ou descartar no ato da captura, com registro',
    detalhe: _texto40,
  ),
  Plano(
    especie: 'Peixe-batata',
    cientificos: ['Lopholatilus villarii'],
    ordenamento:
        'Portaria Interministerial nº 40, de 27 de julho de 2018',
    atoDoMMA: 'Portaria MMA nº 227, de 14 de junho de 2018 — texto '
        'obtido e lido (DOU de 15/06/2018, edição 114, página 74)',
    abrangencia: 'Águas jurisdicionais brasileiras; o defeso do art. 6º é do litoral Sudeste e Sul. Alcança Santa Catarina.',
    tamanho: 'Comprimento total igual ou maior que 40 cm',
    defeso: '1º de setembro a 31 de outubro, entre 100 e 600 m de '
        'profundidade, no litoral Sudeste e Sul',
    cmMinimo: 40,
    quemPode: 'Frota de espinhel de fundo do Sudeste e Sul limitada ao '
        'número de embarcações já registradas — sem novas autorizações',
    incidental: 'Liberar vivo ou descartar no ato da captura, com registro',
    detalhe: _texto40,
  ),

  // ------------------------------------------------- bagre-branco
  Plano(
    especie: 'Bagre-branco',
    cientificos: ['Genidens barbus'],
    ordenamento:
        'Portaria Interministerial nº 39, de 26 de julho de 2018',
    atoDoMMA: 'Portaria MMA nº 127, de 27 de abril de 2018 — texto '
        'obtido e lido (DOU de 30/04/2018, página 107)',
    ondePode: 'Somente nas águas jurisdicionais brasileiras adjacentes a '
        'São Paulo e ao Paraná. Em Santa Catarina, a pesca direcionada é '
        'proibida.',
    abrangencia: 'Proibição em todas as águas jurisdicionais brasileiras. A captura só é permitida nas águas adjacentes a São Paulo e ao Paraná — em Santa Catarina, não.',
    tamanho: 'Comprimento total mínimo de 45 cm — onde a captura é '
        'permitida',
    defeso: '1º de janeiro a 31 de março, no RS, em SC, no PR e em SP — '
        'Portaria SUDEPE nº N-42, de 18 de outubro de 1984, art. 1º',
    cmMinimo: 45,
    quemPode: 'Pesca comercial artesanal com embarcações de até 20 AB, e '
        'pesca não comercial. Vedada a pesca comercial industrial.',
    incidental: 'Liberar vivo ou descartar no ato da captura, com registro',
    detalhe: 'ONDE PODE (art. 2º, § 1º)\n'
        'A captura é permitida SOMENTE nas águas jurisdicionais '
        'brasileiras adjacentes aos Estados de São Paulo e do Paraná. '
        'Fora dessa faixa — e Santa Catarina está fora — a pesca '
        'direcionada, o transporte, o desembarque e a comercialização são '
        'proibidos (art. 2º, caput).\n\n'
        'CONDIÇÕES ONDE É PERMITIDA (art. 2º, § 1º)\n'
        'I - comprimento total mínimo de 45 cm para pescar, transportar, '
        'beneficiar e comercializar.\n'
        'II - pesca comercial artesanal com embarcações de até 20 AB, e '
        'pesca não comercial. Vedada a pesca comercial industrial.\n\n'
        'FAUNA ACOMPANHANTE (art. 2º, § 2º)\n'
        'As embarcações acima de 20 AB autorizadas a operar em '
        'modalidades que tenham o bagre-branco como fauna acompanhante '
        'previsível podem transportar e desembarcar a espécie no limite '
        'de até 5% do peso total da produção.\n\n'
        'CAPTURA INCIDENTAL (art. 2º, §§ 3º e 4º)\n'
        'Os animais devem ser liberados vivos ou descartados no ato da '
        'captura, e a captura, a liberação ou o descarte registrados '
        'conforme regulamentação específica.\n\n'
        'DEFESO (art. 2º, §§ 5º e 6º)\n'
        'A captura respeita as restrições da Portaria SUDEPE nº N-42, de '
        '18 de outubro de 1984 — texto obtido e lido. Aquela portaria '
        'proíbe a captura DE 1º DE JANEIRO A 31 DE MARÇO nas águas que '
        'banham o RS, SC, o PR e SP, e fixa 30 cm de comprimento total '
        'mínimo no período permitido, com tolerância de 10% sobre o peso '
        'total.\n'
        'Durante esse prazo ficam proibidos o transporte, o desembarque, a '
        'retenção e a comercialização em TODO o território nacional — não '
        'só onde a pesca é permitida.\n\n'
        'REVISÃO (arts. 3º e 5º)\n'
        'A implementação seria analisada em 18 meses da publicação, sob '
        'coordenação do MMA com o Instituto Chico Mendes e o IBAMA. Ato '
        'do Ministro do Meio Ambiente suspende o uso da espécie se '
        'faltarem dados ou a população perder estabilidade (art. 3º, '
        '§ 4º). A restrição geográfica pode ser revista com novos dados '
        'de monitoramento (art. 5º).\n\n'
        'SANÇÃO (art. 6º)\n'
        'Penalidades da Lei nº 9.605, de 1998, e do Decreto nº 6.514, de '
        '2008. Autorização de pesca cancelada ou suspensa por prazo não '
        'inferior a seis meses, sem redistribuição para outras '
        'embarcações.',
  ),

  // =================================================================
  // PLANOS QUE EXISTEM, CUJA NORMA DE ORDENAMENTO NÃO FOI OBTIDA
  //
  // A página de Planos de Recuperação do Ministério do Meio Ambiente
  // lista dez planos para espécies aquáticas. Os quatro de cima estão
  // reproduzidos com o texto conferido. Estes cinco não: sabe-se que
  // existem, sabe-se o nome da norma, e é só isso que o aplicativo
  // diz. Nenhuma regra é inventada para preencher a lacuna.
  //
  // Dois deles foram refeitos em julho de 2026, dentro do prazo de
  // revisão do art. 11 da Portaria 1.666 — o que mostra que a revisão
  // aconteceu, e que as normas de 2018 destas espécies podem já não
  // valer.
  // =================================================================
  Plano(
    especie: 'Pargo',
    cientificos: ['Lutjanus purpureus'],
    normaObtida: true,
    ordenamento:
        'Portaria Interministerial MPA/MMA nº 66, de 27 de julho de 2026',
    atoDoMMA: 'Portaria GM/MMA nº 1.742, de 24 de julho de 2026 — texto '
        'obtido e lido por inteiro. O art. 7º dela revogou a Portaria MMA '
        'nº 228, de 14 de junho de 2018',
    abrangencia: 'NÃO ALCANÇA Santa Catarina. O art. 4º, § 1º limita a '
        'operação de pesca ao polígono do Anexo I, "entre os limites do '
        'norte do estado do Amapá e a divisa dos estados do Maranhão e do '
        'Piauí" — é a costa Norte. Santa Catarina fica fora dele.',
    ondePode: 'Polígono do Anexo I: do norte do Amapá até a divisa '
        'Maranhão/Piauí. Os dados georreferenciados são publicados no '
        'sítio do Ministério da Pesca e Aquicultura (art. 4º, § 2º). A '
        'delimitação NÃO se aplica à pesca com autorização complementar '
        'das modalidades 1.8, 1.9 e 1.10 (art. 4º, § 3º).',
    tamanho: 'Comprimento furcal mínimo de 35 cm',
    cmMinimo: 35,
    defeso: '15 de dezembro a 30 de abril, anualmente',
    quemPode: 'Só embarcações autorizadas nas modalidades 1.8, 1.9 e 1.10 '
        'do Anexo I da IN Interministerial nº 10/2011, e a frota é '
        'limitada a 150 embarcações — dessas, até 25 com comprimento '
        'superior a 15 metros.',
    incidental: 'Exemplares capturados incidentalmente em desacordo com a '
        'Portaria devem ser LIBERADOS VIVOS ou descartados no ato da '
        'captura, registrando-se no Mapa de Bordo a captura e a liberação '
        'ou o descarte (art. 28). As demais modalidades devem devolver ao '
        'mar todos os pargos capturados e registrar no campo "descarte" o '
        'número de indivíduos devolvidos (art. 6º, § 1º).',
    detalhe: 'QUEM PODE PESCAR (art. 2º)\n'
        'Só as embarcações autorizadas nas modalidades 1.8, 1.9 e 1.10 do '
        'Anexo I da IN Interministerial nº 10, de 10 de junho de 2011. O '
        'art. 6º proíbe captura, retenção a bordo e desembarque por '
        'qualquer outra modalidade.\n\n'
        'TEMPORADA (art. 3º)\n'
        'Proibida a pesca de 15 de dezembro a 30 de abril, anualmente. A '
        'largada das embarcações permissionadas é liberada a partir das '
        'zero horas de 1º de maio de cada ano.\n\n'
        'LIMITE DE CAPTURA (arts. 4º, 5º, 19 a 21)\n'
        'Limite anual de 2.750 toneladas. A partir da safra de 2027, o '
        'excedente é deduzido integralmente do limite da safra seguinte. A '
        'temporada é encerrada ao atingir 90% do limite, com aviso nos '
        'canais oficiais aos 80%. Encerrada, as embarcações no mar têm 10 '
        'dias corridos para retornar e desembarcar; depois disso ficam '
        'proibidos captura, retenção a bordo e desembarque. Se o gatilho '
        'não for atingido, tolera-se o desembarque até 18 de dezembro.\n\n'
        'PETRECHOS (art. 7º)\n'
        'I - espinhel vertical tipo pargueira, com anzóis nº 6, 5 e 4, '
        'aberturas iguais ou superiores a 1,6 cm; e\n'
        'II - armadilha tipo covo ou manzuá, malha fixa em losango, '
        'hexágono ou outra, com a menor diagonal (losango) ou a menor '
        'mediana (hexágono) entre nós opostos igual ou superior a 13 cm, '
        'em todas as seções do covo.\n'
        'Pescar com petrecho fora disso é atividade de pesca ILEGAL (§ '
        '2º).\n\n'
        'TAMANHO MÍNIMO (arts. 11 e 12, e Anexo III)\n'
        'Proibidos captura, transporte, armazenamento, processamento e '
        'comercialização de pargo com comprimento furcal inferior a 35 '
        'cm. O Anexo III define: o comprimento furcal, em centímetros, '
        'tem origem na ponta externa da boca (focinho) até a extremidade '
        'da furca da nadadeira caudal aberta.\n'
        'Para a safra de 2026 tolera-se o desembarque de até 5% em peso '
        'abaixo de 35 cm, PROIBIDA a comercialização desses exemplares, '
        'que devem ser doados a órgãos e entidades públicas de caráter '
        'científico, cultural, educacional, hospitalar, penal, militar e '
        'social, ou a entidades sem fins lucrativos de caráter '
        'beneficente, com documento fiscal.\n\n'
        'NO DEFESO (art. 22)\n'
        'Transporte, armazenamento, processamento e comercialização só '
        'com Declaração de Estoque, enviada ao IBAMA até 22 de dezembro '
        'de cada ano. E o § 4º é categórico: de 16 DE FEVEREIRO A 30 DE '
        'ABRIL ficam proibidos o transporte, o beneficiamento, a '
        'industrialização e a comercialização de QUALQUER VOLUME de '
        'pargo.\n\n'
        'MONITORAMENTO (arts. 13 a 18)\n'
        'PREPS por satélite em funcionamento; Mapa de Bordo entregue em 7 '
        'dias corridos pelo Sistema PesqBrasil; Declaração de Entrada em '
        'Empresa Pesqueira a partir de 1º de maio de 2027; painel de '
        'acompanhamento do limite; e observadores de bordo ou '
        'científicos.\n\n'
        'SANÇÃO (arts. 25, 26, 29 e 30)\n'
        'A embarcação em desconformidade tem a Autorização de Pesca '
        'SUSPENSA POR 60 DIAS. A empresa pesqueira que descumprir fica '
        'proibida de adquirir, comercializar ou transportar pargo por 7 '
        'dias, e 30 dias na reincidência. Cruzeiro em desconformidade é '
        'atividade de pesca ilegal. Somam-se as penalidades da Lei nº '
        '9.605/1998 e do Decreto nº 6.514/2008.\n\n'
        'VIGÊNCIA AMARRADA (art. 27)\n'
        'A vigência desta Portaria está DIRETAMENTE VINCULADA à vigência '
        'da Portaria MMA nº 1.742, de 24 de julho de 2026, ou de outra '
        'que a substitua. Se a 1.742 cair, esta cai junto.\n\n'
        'REVOGAÇÃO (art. 32)\n'
        'Revogou a Portaria Interministerial nº 42, de 27 de julho de '
        '2018, da SEAP-PR e do MMA.\n\n'
        'ALTERA A MATRIZ DE MODALIDADES (art. 6º, § 2º, e Anexo II)\n'
        'Os Anexos I e III da IN Interministerial nº 10/2011 passam a '
        'vigorar com as alterações do Anexo II desta Portaria, que '
        'reescreve as modalidades 1.6, 1.8, 1.9, 1.10, 1.11 e 1.14. É a '
        'terceira alteração da matriz que o aplicativo conhece, ao lado '
        'da IN MPA nº 14/2014 e da IN MPA/MMA nº 01/2015.\n\n'
        'PUBLICAÇÃO\n'
        'DOU de 27/07/2026, edição 139-C, seção 1 - Extra C, página 1. '
        'Assinaram Rivetla Edipo Araujo Cruz, Ministro de Estado da '
        'Pesca, e João Paulo Ribeiro Capobianco, do Meio Ambiente.',
  ),
  // Os budiões eram UM plano com seis espécies. A Portaria GM/MMA nº
  // 1.749, de 27 de julho de 2026, separou os regimes, e um plano só
  // para os seis daria a mesma resposta a bichos com regimes
  // diferentes — o budião-azul, o mais protegido dos seis, ficaria com
  // a resposta dos outros. São três.
  Plano(
    especie: 'Budião-azul',
    cientificos: ['Scarus trispinosus'],
    normaObtida: true,
    ordenamento: 'Portaria Interministerial nº 59-B, de 9 de novembro de '
        '2018 — texto obtido e lido por inteiro. VER A RESSALVA: ela foi '
        'escrita quando a espécie era passível de uso.',
    atoDoMMA: 'Portaria GM/MMA nº 1.749, de 27 de julho de 2026 — texto '
        'obtido e lido por inteiro',
    abrangencia: 'A norma não impõe recorte geográfico: a proteção '
        'integral vale em toda a área de ocorrência da espécie, e portanto '
        'também em Santa Catarina.',
    tamanho: 'Não se aplica — a captura é proibida em qualquer tamanho. '
        'A faixa de 39 a 63 cm da Portaria Interministerial nº 59-B/2018 '
        'foi escrita quando a espécie era passível de uso. Ver a '
        'ressalva.',
    quemPode: 'Ninguém, pela Portaria GM/MMA nº 1.749/2026. A proteção é '
        'integral.',
    emVigor: 'ATENÇÃO — A PORTARIA 59-B/2018 AINDA EXISTE, E ELA PERMITE '
        'PESCAR ESTE PEIXE. Quem a ler sozinha vai encontrar regra '
        'permissiva: captura entre 39 e 63 cm de comprimento total, em '
        'mergulho livre de apneia, durante o dia, com espingarda de '
        'mergulho ou arbalete, por pescador profissional, para pesca '
        'comercial artesanal e de subsistência, e somente em áreas de '
        'manejo vinculadas a planos de gestão locais (arts. 3º e 4º).\n\n'
        'MAS O PARÁGRAFO ÚNICO DO ART. 1º DA PRÓPRIA 59-B DIZ: "Enquanto '
        'vigorar a classificação oficial do budião-azul como espécie '
        'ameaçada de extinção em nível nacional, a vigência desta Portaria '
        'Interministerial está diretamente vinculada à vigência da Portaria '
        'MMA nº 129, de 26 de abril de 2018 ou outra norma que vier a '
        'substituí-la, OFICIALIZANDO O PLANO DE RECUPERAÇÃO NACIONAL E '
        'DECLARANDO A ESPÉCIE PASSÍVEL DE USO SUSTENTÁVEL."\n\n'
        'E é exatamente essa condição que caiu: a Portaria GM/MMA nº '
        '1.749, de 27 de julho de 2026, retirou o Scarus trispinosus da '
        'lista de espécies passíveis de uso da Portaria 129/2018 (arts. 4º '
        'e 5º) e o pôs sob proteção integral (art. 2º).\n\n'
        'O aplicativo NÃO afirma que a 59-B está revogada — ela não foi '
        'revogada expressamente. Afirma o que os dois textos dizem, com as '
        'datas, e que a norma de 2026 é posterior. Confirme nos sites '
        'oficiais antes de qualquer decisão.',
    detalhe: 'PROTEÇÃO INTEGRAL (art. 2º)\n'
        'A espécie budião-azul (Scarus trispinosus) fica protegida de modo '
        'integral, nos termos do art. 3º, caput, da Portaria GM/MMA nº '
        '1.666, de 27 de abril de 2026, e das recomendações do Plano de '
        'Recuperação Nacional.\n'
        '§ 1º A proteção integral inclui, entre outras medidas, a '
        'proibição de CAPTURA, TRANSPORTE, ARMAZENAMENTO, GUARDA, MANEJO, '
        'BENEFICIAMENTO e COMERCIALIZAÇÃO.\n'
        '§ 2º O Plano de Recuperação Nacional poderá avaliar e reconhecer '
        'as condições de uso e manejo sustentável da espécie, conforme o '
        'art. 6º da Portaria GM/MMA nº 1.666/2026 — ou seja, a porta não '
        'está fechada para sempre, mas hoje está fechada.\n\n'
        'O PLANO (art. 1º)\n'
        'Aprovado o Plano de Recuperação Nacional da espécie, classificada '
        'como CR — Criticamente em Perigo — na Lista, em atendimento ao '
        'art. 11 da Portaria GM/MMA nº 1.666/2026. O texto do Plano é '
        'publicado no sítio do MMA, na aba Composição/SBC/DPES/Planos de '
        'Recuperação para Espécies Aquáticas Ameaçadas de Extinção.\n\n'
        'MONITORAMENTO (art. 3º)\n'
        'O MMA, com apoio do ICMBio e do IBAMA, monitora periodicamente, '
        'avalia a efetividade das medidas e revisa o Plano.\n\n'
        'PUBLICAÇÃO\n'
        'DOU de 27/07/2026, edição 139-C, seção 1 - Extra C, página 1. '
        'Assinou João Paulo Ribeiro Capobianco.',
  ),
  Plano(
    especie: 'Budião-palhaço, budião-ferrugem e budião-batata',
    cientificos: [
      'Scarus zelindae',
      'Sparisoma axillare',
      'Sparisoma frondosum',
    ],
    normaObtida: false,
    ordenamento: '',
    quemPode: 'NÃO HÁ NORMA DE ORDENAMENTO LOCALIZADA para estas três '
        'espécies, e sem ela o aplicativo não dá regra.\n\n'
        'A Portaria Interministerial nº 59-B, de 9 de novembro de 2018, '
        'que já foi atribuída aos budiões em geral, é o ordenamento do '
        'BUDIÃO-AZUL apenas: a ementa dela diz "espécie Scarus '
        'trispinosus (budião-azul)".\n\n'
        'Consulte a Portaria MMA nº 129/2018, na redação da Portaria '
        'GM/MMA nº 1.749/2026, e o Plano de Recuperação, nos sites '
        'oficiais.',
    atoDoMMA: 'Portaria MMA nº 129, de 27 de abril de 2018 — com a '
        'redação dada pelos arts. 4º e 5º da Portaria GM/MMA nº 1.749, de '
        '27 de julho de 2026. As duas com texto obtido e lido por inteiro',
    abrangencia: 'A Portaria MMA nº 129/2018 foi lida e NÃO IMPÕE '
        'recorte geográfico — vale onde as espécies ocorrem, Santa '
        'Catarina inclusive. Ela também não traz condição operacional '
        'própria: remete ao Plano de Recuperação e a normas específicas '
        'de ordenamento, e é essa norma de ordenamento que falta.',
    detalhe: 'O QUE A PORTARIA 129/2018 DIZ, LIDA POR INTEIRO\n'
        'Art. 1º: reconhece a possibilidade de uso e manejo sustentável '
        'das espécies, "atendendo ao disposto no Art. 3º da Portaria nº '
        '445, de 17 dezembro de 2014, e mediante as condições '
        'estabelecidas nesta Portaria".\n'
        'Art. 2º: o uso "deverá atender às medidas propostas no Plano de '
        'Recuperação Nacional das espécies de Budiões Ameaçadas de '
        'Extinção e à regulamentação de medidas a serem estabelecidas por '
        'normas específicas de ordenamento".\n'
        'Art. 5º: o MMA "deverá suspender ou revogar os efeitos da '
        'presente Portaria" quando identificar deficiências na '
        'implementação.\n\n'
        'REPARE: apesar de dizer "mediante as condições estabelecidas '
        'nesta Portaria", a 129/2018 NÃO TRAZ NENHUMA condição '
        'operacional — nem tamanho, nem petrecho, nem área, nem cota, nem '
        'período. Ela remete ao Plano e a normas de ordenamento. Por isso '
        'o aplicativo não tem regra para estas três espécies: a norma que '
        'a traria não foi localizada.\n\n'
        'O QUE A PORTARIA 1.749/2026 FEZ (arts. 4º e 5º)\n'
        'Ela NÃO revogou a Portaria MMA nº 129/2018 — ALTEROU. A ementa e '
        'o art. 1º da 129/2018 passaram a valer com esta redação:\n\n'
        '"Art. 1º Fica reconhecida a possibilidade de uso e manejo '
        'sustentável das espécies budião-palhaço, peixe-papagaio-banana '
        '(Scarus zelindae), budião-ferrugem, peixe-papagaio-cinza '
        '(Sparisoma axillare) e budião-batata, peixe-papagaio-cinza '
        '(Sparisoma frondosum), atendendo ao disposto na Portaria GM/MMA '
        'nº 1.666, de 27 de Abril de 2026, e mediante as condições '
        'estabelecidas nesta Portaria." (NR)\n\n'
        'O QUE ISSO SIGNIFICA. Estas três seguem passíveis de uso e '
        'manejo sustentável, mas SOB AS CONDIÇÕES da Portaria 129/2018 — '
        'e é justamente esse texto que o aplicativo não tem. Sem ele, o '
        'aplicativo não dá regra: consulte a Portaria MMA nº 129/2018, na '
        'redação da Portaria GM/MMA nº 1.749/2026, e a Portaria '
        'Interministerial SEAP-PR/MMA nº 59-B/2018, nos sites oficiais.\n\n'
        'REPARE NO QUE SAIU DA LISTA. A redação anterior falava em '
        '"Budiões", no plural, e o Plano de 2018 reunia seis espécies. A '
        'nova redação nomeia TRÊS. O budião-azul (Scarus trispinosus) '
        'saiu para a proteção integral do art. 2º. E duas — Sparisoma '
        'amplum e Sparisoma rocha — simplesmente não aparecem na redação '
        'nova.',
  ),
  Plano(
    especie: 'Budião-batata-verde e budião de Rocha',
    cientificos: [
      'Sparisoma amplum',
      'Sparisoma rocha',
    ],
    normaObtida: false,
    ordenamento: '',
    atoDoMMA: 'Portaria MMA nº 129, de 27 de abril de 2018 — na redação '
        'dada pela Portaria GM/MMA nº 1.749, de 27 de julho de 2026. '
        'Texto obtido: NENHUMA das duas redações nomeia estas espécies',
    abrangencia: 'A Lista Nacional Oficial não impõe recorte geográfico, e '
        'portanto alcança Santa Catarina.',
    quemPode: 'O aplicativo não localizou norma de ordenamento nem ato '
        'que reconheça uso destas duas espécies depois da Portaria GM/MMA '
        'nº 1.749/2026. Consulte a Portaria MMA nº 129/2018, na redação da '
        'Portaria GM/MMA nº 1.749/2026, e a Lista, nos sites oficiais.',
    detalhe: 'POR QUE ESTAS DUAS ESTÃO SEPARADAS\n'
        'Elas não aparecem em nenhuma das duas redações da Portaria MMA '
        'nº 129/2018.\n\n'
        'A redação ORIGINAL do art. 1º da Portaria 129/2018 nomeava '
        'QUATRO espécies: Scarus trispinosus (budião-azul), Scarus '
        'zelindae (budião-palhaço, peixe-papagaio-banana), Sparisoma '
        'axillare (budião-ferrugem, peixe-papagaio-cinza) e Sparisoma '
        'frondosum (budião-batata, peixe-papagaio-cinza). Não seis.\n\n'
        'A Portaria GM/MMA nº 1.749/2026 reescreveu esse artigo e deixou '
        'TRÊS, tirando o budião-azul para a proteção integral do art. 2º. '
        'Sparisoma amplum e Sparisoma rocha ficaram de fora das duas '
        'redações — a de 2018 e a de 2026.\n\n'
        'O QUE O APLICATIVO NÃO AFIRMA. Ele não afirma que estas duas '
        'foram deliberadamente excluídas, nem que houve esquecimento. '
        'Afirma o que está escrito: a redação vigente da Portaria '
        '129/2018 não as nomeia. O efeito prático de não constar de um '
        'ato que reconhece uso é matéria para quem aplica a norma — o '
        'art. 3º da Portaria GM/MMA nº 1.666/2026 veda a captura das '
        'espécies da Lista, e o art. 4º admite o uso onde há Plano, ato '
        'do MMA e norma de ordenamento.\n\n'
        'CONFIRMAR COM O TEXTO DA PORTARIA MMA Nº 129/2018 e com o Plano '
        'de Recuperação publicado no sítio do MMA.',
  ),
  Plano(
    especie: 'Guaiamum',
    cientificos: ['Cardisoma guanhumi'],
    normaObtida: false,
    ordenamento: 'Portaria Interministerial SEAP-PR/MMA nº 38, de 26 de '
        'julho de 2018',
    atoDoMMA: 'Portaria MMA nº 128, de 27 de abril de 2018',
    abrangencia: 'NÃO SE SABE se alcança Santa Catarina. É preciso '
        'procurar a norma: nem a Portaria MMA nº 128/2018 nem a Portaria '
        'Interministerial SEAP-PR/MMA nº 38/2018 foram obtidas, e é o '
        'texto delas que define a área. Consulte-as nos sites oficiais.',
  ),
  Plano(
    especie: 'Gurijuba',
    cientificos: ['Sciades parkeri'],
    normaObtida: false,
    ordenamento: 'Portaria Interministerial SEAP-PR/MMA nº 43, de 27 de '
        'julho de 2018',
    atoDoMMA: 'Portaria MMA nº 230, de 14 de junho de 2018',
    abrangencia: 'NÃO SE SABE se alcança Santa Catarina. É preciso '
        'procurar a norma: nem a Portaria MMA nº 230/2018 nem a Portaria '
        'Interministerial SEAP-PR/MMA nº 43/2018 foram obtidas, e é o '
        'texto delas que define a área. Consulte-as nos sites oficiais.',
  ),
  Plano(
    especie: 'Pintado ou surubim',
    cientificos: ['Pseudoplatystoma corruscans'],
    normaObtida: false,
    ordenamento: 'Portaria Interministerial MPA/MMA nº 15, de 6 de '
        'dezembro de 2024',
    atoDoMMA: 'Portaria MMA nº 355, de 27 de janeiro de 2023',
    abrangencia: 'NÃO SE SABE se alcança Santa Catarina. É preciso '
        'procurar a norma: nem a Portaria MMA nº 355/2023 nem a Portaria '
        'Interministerial MPA/MMA nº 15/2024 foram obtidas, e é o texto '
        'delas que define a área. Consulte-as nos sites oficiais.',
  ),
];

const _texto59c = 'ESPÉCIES ALCANÇADAS (art. 1º)\n'
    'Badejo-amarelo (Mycteroperca interstitialis), sirigado (Mycteroperca '
    'bonaci), garoupa-de-São-Tomé (Epinephelus morio) e caranha (Lutjanus '
    'cyanopterus), nas águas jurisdicionais brasileiras.\n\n'
    'A REGRA (art. 2º)\n'
    'Proibidos a pesca direcionada, o transporte, o desembarque e a '
    'comercialização de qualquer indivíduo dessas espécies FORA dos '
    'limites desta Portaria.\n'
    '§ 1º Os exemplares capturados incidentalmente em desacordo devem ser '
    'liberados vivos ou descartados no ato da captura, com registro da '
    'captura e da liberação ou descarte.\n'
    '§ 2º Fica permitida a pesca amadora e esportiva apenas na categoria '
    'pesque e solte.\n\n'
    'TAMANHO (art. 3º)\n'
    'Permitidos a captura, retenção, transporte, beneficiamento e '
    'comercialização para indivíduos com comprimento total maior ou igual '
    'a:\n'
    'a) 60 cm para o sirigado (Mycteroperca bonaci);\n'
    'b) 45 cm para o badejo-amarelo (Mycteroperca interstitialis);\n'
    'c) 45 cm para a garoupa-de-São-Tomé (Epinephelus morio);\n'
    'd) 50 cm para a caranha (Lutjanus cyanopterus).\n\n'
    'DEFESO (art. 5º)\n'
    'A partir de 2019, período de defeso de 1º de agosto a 30 de setembro '
    'para as quatro espécies.\n'
    '§ 1º Quem armazena, transporta, beneficia, industrializa ou '
    'comercializa só pode seguir durante o defeso se entregar, até 10 de '
    'agosto de cada ano, a declaração de estoques do Anexo I nas '
    'Superintendências do IBAMA.\n'
    '§ 2º Durante o defeso, qualquer volume só circula se vier de estoque '
    'declarado e estiver acompanhado da cópia da declaração.\n'
    '§ 3º A retenção a bordo e o desembarque são tolerados até 3 de agosto '
    'de cada ano.\n\n'
    'RASTREAMENTO (art. 4º)\n'
    'As embarcações autorizadas inscritas nas modalidades 1.6, 1.7, 3.10 e '
    '3.11 da IN MPA/MMA nº 10/2011 devem usar o PREPS e entregar os mapas '
    'de bordo. § 3º: capturando em outras modalidades, valem as normas de '
    'ordenamento específicas.\n\n'
    'SANÇÃO (art. 6º)\n'
    'Penalidades da Lei nº 9.605, de 1998, e do Decreto nº 6.514, de 2008. '
    'Autorização de pesca cancelada ou suspensa por prazo não inferior a '
    'seis meses, sem redistribuição para outras embarcações.\n\n'
    '——————————\n\n'
    'O ATO DO MMA QUE SUSTENTA ESTE PLANO\n'
    'Portaria MMA nº 292, de 18 de julho de 2018 (DOU de 19/07/2018, '
    'edição 138, página 42).\n\n'
    'Art. 1º Reconhece as quatro espécies como PASSÍVEIS DE EXPLORAÇÃO, '
    'estudo ou pesquisa pela pesca — é este o dispositivo que tira a '
    'espécie da vedação simples por estar na Lista.\n\n'
    'Art. 2º O uso e o manejo sustentável devem atender às medidas do '
    'Plano de Recuperação Nacional, "que deverão ser regulamentadas por '
    'norma específica de ordenamento pelos órgãos competentes". Essa norma '
    'específica é a Portaria Interministerial nº 59-C/2018, acima.\n\n'
    'Art. 3º, parágrafo único: publicada a norma de ordenamento, as '
    'atividades pesqueiras "só poderão ocorrer nos termos especificados '
    'pela nova norma".\n\n'
    'Art. 4º O Plano de Recuperação Nacional fica disponível no sítio '
    'eletrônico do Ministério do Meio Ambiente.\n\n'
    'Arts. 5º e 6º O MMA, com o Instituto Chico Mendes e o IBAMA, avalia a '
    'implementação do Plano e deve SUSPENDER OU REVOGAR os efeitos desta '
    'Portaria ao identificar deficiências que comprometam a recuperação da '
    'espécie. É por isso que a vigência precisa ser conferida: o ato pode '
    'cair sem que a Portaria Interministerial seja alterada.';

const _texto40 = 'ESPÉCIES ALCANÇADAS (art. 1º)\n'
    'Cherne-verdadeiro (Hyporthodus niveatus) e peixe-batata (Lopholatilus '
    'villarii), nas águas jurisdicionais brasileiras.\n\n'
    'A REGRA (art. 2º)\n'
    'Proibidos a pesca direcionada, o transporte, o desembarque e a '
    'comercialização de qualquer indivíduo FORA dos limites desta '
    'Portaria. Parágrafo único: os exemplares capturados incidentalmente '
    'em desacordo devem ser liberados vivos ou descartados no ato da '
    'captura, com registro.\n\n'
    'FROTA E PROFUNDIDADE (art. 3º)\n'
    'I - a frota de espinhel de fundo registrada no Sudeste e Sul fica '
    'limitada ao número de embarcações hoje registradas, sem novas '
    'autorizações.\n'
    'II - as embarcações das modalidades 3.6 (arrasto de fundo duplo) e '
    '3.9 (arrasto de fundo duplo ou simples) só podem pescar em '
    'profundidades menores ou iguais a 100 m.\n\n'
    'TAMANHO (art. 4º)\n'
    'Permitidos a captura, retenção, transporte, beneficiamento e '
    'comercialização apenas de indivíduos com comprimento total maior ou '
    'igual a:\n'
    'a) 45 cm para o cherne-verdadeiro (Hyporthodus niveatus);\n'
    'b) 40 cm para o peixe-batata (Lopholatilus villarii).\n\n'
    'DEFESO (art. 6º)\n'
    'A partir de 2019, defeso de 1º de setembro a 31 de outubro para a '
    'pesca realizada ENTRE 100 E 600 M DE PROFUNDIDADE, no litoral '
    'Sudeste e Sul, para as modalidades 1.6, 1.7, 3.10, 3.11 e 3.12 da IN '
    'MPA/MMA nº 10/2011.\n'
    '§ 1º Declaração de estoques ao IBAMA até 10 de setembro de cada '
    'ano.\n'
    '§ 2º Durante o defeso, qualquer volume só circula se vier de estoque '
    'declarado e acompanhado da cópia da declaração.\n'
    '§ 3º A retenção a bordo e o desembarque são tolerados até 5 de '
    'setembro de cada ano.\n\n'
    'RASTREAMENTO (art. 5º)\n'
    'As embarcações inscritas nas modalidades 1.6, 1.7, 3.10, 3.11 e 3.12 '
    'devem usar o PREPS e entregar os mapas de bordo.\n\n'
    'SANÇÃO (art. 7º)\n'
    'Penalidades da Lei nº 9.605, de 1998, e do Decreto nº 6.514, de 2008. '
    'Autorização de pesca cancelada ou suspensa por prazo não inferior a '
    'seis meses, sem redistribuição para outras embarcações.';

/// O que a ficha diz quando o Plano existe e a norma não foi obtida.
const remissao =
    'O aplicativo não reproduz regra nenhuma para esta espécie porque não '
    'obteve o texto da norma de ordenamento. Consulte a legislação '
    'correspondente e o Plano de Recuperação, indicados acima, antes de '
    'qualquer medida. A vedação do art. 3º da Portaria 1.666 não se aplica '
    'automaticamente onde existe Plano: é o Plano e a norma de ordenamento '
    'que dizem o que pode.';

/// O plano que alcança uma espécie, se houver.
Plano? planoDe(String nomeCientifico) {
  final partes = nomeCientifico.split(RegExp(r'\s*/\s*'));
  for (final p in planos) {
    if (partes.any((x) => p.alcanca(x.trim()))) return p;
  }
  return null;
}

/// O regime de uma espécie da Lista.
Regime regimeDe(String nomeCientifico) =>
    planoDe(nomeCientifico) != null ? Regime.regulada : Regime.naoVerificado;

/// Quantas espécies da Lista têm plano com a norma conferida.
int get quantosPlanos => planos.where((p) => p.normaObtida).length;

/// Quantos planos existem no registro, conferidos ou não.
int get quantosPlanosConhecidos => planos.length;
