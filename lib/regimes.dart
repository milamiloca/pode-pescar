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
    normaObtida: false,
    ordenamento:
        'Portaria Interministerial MPA/MMA nº 66, de 27 de julho de 2026',
    atoDoMMA: 'Portaria MMA nº 1.742, de 24 de julho de 2026 — substituiu '
        'a Portaria MMA nº 228, de 14 de junho de 2018',
    abrangencia: 'Não se sabe. O texto da norma não foi obtido, e é ele '
        'que diz se alcança Santa Catarina.',
  ),
  Plano(
    especie: 'Budiões',
    cientificos: [
      'Scarus trispinosus',
      'Scarus zelindae',
      'Sparisoma amplum',
      'Sparisoma axillare',
      'Sparisoma frondosum',
      'Sparisoma rocha',
    ],
    normaObtida: false,
    ordenamento: 'Portaria Interministerial SEAP-PR/MMA nº 59-B, de 9 de '
        'novembro de 2018, para o Plano de 2018. Para o Plano de 2026, a '
        'norma de ordenamento não consta da página do Ministério.',
    atoDoMMA: 'Portaria MMA nº 1.749, de 27 de julho de 2026, que trata do '
        '"Budião-azul" — substituiu a Portaria MMA nº 129, de 27 de abril '
        'de 2018, que tratava dos "Budiões", no plural. Não se sabe quais '
        'destas seis espécies cada uma alcança.',
    abrangencia: 'Não se sabe. O texto da norma não foi obtido, e é ele '
        'que diz se alcança Santa Catarina.',
  ),
  Plano(
    especie: 'Guaiamum',
    cientificos: ['Cardisoma guanhumi'],
    normaObtida: false,
    ordenamento: 'Portaria Interministerial SEAP-PR/MMA nº 38, de 26 de '
        'julho de 2018',
    atoDoMMA: 'Portaria MMA nº 128, de 27 de abril de 2018',
    abrangencia: 'Não se sabe. O texto da norma não foi obtido, e é ele '
        'que diz se alcança Santa Catarina.',
  ),
  Plano(
    especie: 'Gurijuba',
    cientificos: ['Sciades parkeri'],
    normaObtida: false,
    ordenamento: 'Portaria Interministerial SEAP-PR/MMA nº 43, de 27 de '
        'julho de 2018',
    atoDoMMA: 'Portaria MMA nº 230, de 14 de junho de 2018',
    abrangencia: 'Não se sabe. O texto da norma não foi obtido. A espécie '
        'é do litoral Norte; provavelmente não alcança Santa Catarina, '
        'mas isso precisa sair da norma, não da distribuição do bicho.',
  ),
  Plano(
    especie: 'Pintado ou surubim',
    cientificos: ['Pseudoplatystoma corruscans'],
    normaObtida: false,
    ordenamento: 'Portaria Interministerial MPA/MMA nº 15, de 6 de '
        'dezembro de 2024',
    atoDoMMA: 'Portaria MMA nº 355, de 27 de janeiro de 2023',
    abrangencia: 'Não se sabe. Espécie continental; o texto da norma não '
        'foi obtido.',
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
