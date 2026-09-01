// =====================================================================
// PONTOS EM VERIFICAÇÃO
//
// Onde o aplicativo dá uma resposta e existe indício de que ela pode
// estar errada, o ponto entra aqui e a ficha da espécie avisa.
//
// Isso não é excesso de zelo. O app é usado para decidir. Uma resposta
// errada custa caro nos dois sentidos: dar por permitido o que a norma
// proíbe, ou dar por proibido o que ela permite. Enquanto a dúvida
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
    titulo: 'Lula com arrasto de fundo dentro do defeso do camarão — '
        'RESOLVIDO',
    desde: '01/09/2026',
    cientificos: [
      'Loligo plei',
      'Loligo sanpaulensis',
      'Lolliguncula brevis',
    ],
    tambemAlcanca: 'Alcança quem pesca lula em Santa Catarina entre 28 de '
        'janeiro e 31 de março, que é onde as duas janelas se cruzam.',
    appDiz: 'Que NÃO pode arrastar de fundo para pegar lula durante o '
        'defeso do camarão, mesmo que a Portaria da lula liste o arrasto '
        'de fundo entre as modalidades autorizadas.\n\n'
        'POR QUE A DÚVIDA APARECE. A Portaria Interministerial MPA/MMA nº '
        '14, de 1º de novembro de 2024, permite a pesca de lula em Santa '
        'Catarina de 1º DE NOVEMBRO A 31 DE MARÇO (art. 1º) e lista, '
        'entre as modalidades autorizadas, a 3.8 e a 3.9 — arrasto de '
        'fundo (art. 2º, II). O defeso do camarão da Portaria SAP/MAPA nº '
        '656/2022 vai de 28 DE JANEIRO A 30 DE ABRIL. As duas janelas se '
        'cruzam em fevereiro e março.\n\n'
        'Lendo só a Portaria da lula, alguém concluiria que arrastar de '
        'fundo em fevereiro está liberado. É a leitura errada, e é a '
        'leitura permissiva.',
    indicio: 'ESTE PONTO ESTÁ DECIDIDO, e por duas fontes.\n\n'
        'PRIMEIRA — a posição do órgão. Em nota de 23 de abril de 2026, o '
        'IBAMA afirma textualmente que "a Portaria MPA/MMA nº 14/2024 não '
        'autoriza o uso de arrasto de fundo durante o defeso do camarão, '
        'devendo a captura de lula ocorrer exclusivamente por métodos '
        'permitidos e de menor impacto ambiental".\n\n'
        'SEGUNDA — a decisão judicial. Na Ação Civil Pública nº '
        '5010379-83.2026.4.04.7200/SC, o Estado de Santa Catarina pediu '
        'liminar para autorizar a pesca de lula por arrasto de fundo '
        'durante o defeso do camarão. Em 20 de abril de 2026 o Juiz '
        'Federal Marcelo Krás Borges INDEFERIU o pedido, registrando que '
        'o arrasto de fundo compromete a reprodução das espécies, tem '
        'baixa seletividade, com elevado descarte de fauna acompanhante, '
        'e causa impactos severos ao habitat marinho.\n\n'
        'A mesma nota informa a Operação Decapoda, em curso no RJ, SP, '
        'PR, SC e RS, com mais de 3 toneladas de camarão apreendidas '
        'desde o início do defeso, em 28 de janeiro de 2026.',
    falta: 'Nada para resolver a dúvida — ela está resolvida. O que falta '
        'é acompanhar o desfecho da Ação Civil Pública, porque a liminar '
        'foi indeferida mas o processo segue. Se a decisão final mudar, '
        'este ponto muda com ela.\n\n'
        'Falta também o Anexo I da Portaria 14/2024, que altera os Anexos '
        'II, III e VI da IN MPA/MMA nº 10/2011 — o aplicativo cita a '
        'alteração e não tem o texto dela.',
  ),
  Conflito(
    titulo: 'Arrasto na Babitonga: a de 1983 proíbe, a de 2002 abre exceção',
    desde: '29/08/2026',
    cientificos: [],
    tambemAlcanca: 'Não é um ponto de espécie: é de ÁREA E PETRECHO. '
        'Alcança qualquer arrasto dentro da Baía da Babitonga.',
    appDiz: 'Mostra as duas regras, e diz que na Babitonga vale a de '
        '2002.\n\n'
        'A Portaria SUDEPE nº N-51, de 26 de outubro de 1983, art. 1º, '
        'proíbe a pesca de arrasto SOB QUALQUER DENOMINAÇÃO em baías e '
        'lagoas costeiras, canais e desembocaduras de rios de todo o '
        'Estado de Santa Catarina. Sem exceção nenhuma.\n\n'
        'A Portaria IBAMA nº 84, de 15 de julho de 2002, art. 1º, II, '
        'proíbe o arrasto de qualquer natureza no interior da Baía da '
        'Babitonga "COM EXCEÇÃO do uso da rede de gerival especificada '
        'nesta Portaria" — e o art. 2º dela detalha malha, tubo expansor, '
        'potência de motor, número de petrechos e peso.\n\n'
        'O gerival é arrasto. A de 1983 o proíbe; a de 2002 o permite '
        'naquela baía, sob condições.',
    indicio: 'A LEITURA QUE O APLICATIVO ADOTA: na Baía da Babitonga vale '
        'a Portaria 84/2002. Ela é dezenove anos posterior, é específica '
        'daquela baía e daquele petrecho, e foi editada pelo IBAMA, que é '
        'o sucessor legal da SUDEPE — extinta pela Lei nº 7.735, de 22 de '
        'fevereiro de 1989, que criou o IBAMA. Norma posterior e especial '
        'afasta a anterior e geral no ponto em que trata.\n\n'
        'O QUE ISSO NÃO SIGNIFICA: a Portaria 84/2002 não revogou a de '
        '1983 — não há artigo revogador, e ela revogou expressamente '
        'outra coisa (a Portaria IBAMA nº 13, de 28 de fevereiro de '
        '2000). Fora da Babitonga, e dentro da Babitonga para qualquer '
        'arrasto que não seja o gerival do art. 2º, a de 1983 segue '
        'inteira.\n\n'
        'NA PRÁTICA: gerival na Babitonga, dentro das '
        'condições do art. 2º e por pescador profissional registrado, '
        'não é infração. Gerival fora daquelas condições, ou arrasto de '
        'outra natureza, ou gerival em qualquer outra baía catarinense, é '
        'infração pelas duas normas.',
    falta: 'Confirmação, junto ao IBAMA/SC, de que a Portaria SUDEPE nº '
        'N-51/1983 segue vigente e de que a leitura acima é a que o órgão '
        'aplica.\n\n'
        'Fica em aberto, ao lado disto, qual norma fixa hoje a DISTÂNCIA '
        'MÍNIMA DA COSTA para o arrasto motorizado na costa aberta de '
        'Santa Catarina. A Portaria IBAMA nº 107/1992 foi esvaziada do '
        'aplicativo em 01/09/2026 e a IN IBAMA nº 189/2008, cujo texto foi '
        'lido, não fixa distância nenhuma nem revoga aquela. Veja o item '
        '"Distância mínima da costa" na tela Onde não pode.',
  ),
  Conflito(
    titulo: 'A vigência dos Planos de Recuperação, e a revisão de 2026',
    desde: '29/08/2026',
    cientificos: [
      'Epinephelus marginatus',
      'Mycteroperca bonaci',
      'Mycteroperca interstitialis',
      'Epinephelus morio',
      'Lutjanus cyanopterus',
      'Hyporthodus niveatus',
      'Lopholatilus villarii',
      'Genidens barbus',
    ],
    tambemAlcanca: 'Alcança as oito espécies para as quais o aplicativo '
        'responde "pesca regulada" em vez de "vedada".',
    appDiz: 'Que a pesca destas oito é regulada por Plano de Recuperação, '
        'com o tamanho, o defeso e a frota das Portarias Interministeriais '
        'nº 39, 40, 41 e 59-C, todas de 2018. Os quatro textos foram lidos '
        'por inteiro, e AGORA TAMBÉM OS QUATRO ATOS DO MMA que as '
        'sustentam: nº 127, de 27/04/2018 (bagre-branco), nº 227, de '
        '14/06/2018 (cherne e batata), nº 229, de 14/06/2018 (garoupa) e '
        'nº 292, de 18/07/2018 (peixes recifais), esta última obtida em '
        '29/08/2026, no DOU de 19/07/2018, edição 138, página 42.',
    indicio: 'Cada Portaria Interministerial declara, no art. 1º, que a '
        'própria vigência está vinculada à vigência do ato do MMA que '
        'oficializou o Plano. E cada ato do MMA traz um art. 6º que '
        'permite ao Ministério SUSPENDER OU REVOGAR seus efeitos ao '
        'identificar deficiências na implementação — por ato próprio, sem '
        'alterar a Portaria Interministerial.\n\n'
        'A revisão do art. 11 da Portaria 1.666 aconteceu, ao menos em '
        'parte. A página de Planos de Recuperação do Ministério do Meio '
        'Ambiente mostra dois planos refeitos em julho de 2026, dentro do '
        'prazo, que vencia em 27/07/2026: o do pargo (Portaria MMA nº '
        '1.742, de 24/07/2026) e o do budião-azul (Portaria MMA nº 1.749, '
        'de 27/07/2026).\n\n'
        'Se dois foram refeitos, os outros podem ter sido — ou podem ter '
        'ficado para trás. A mesma página segue apresentando os planos '
        'destas oito espécies com as normas de 2018.\n\n'
        'PARA OS PEIXES RECIFAIS, A DÚVIDA FECHOU: o IBAMA divulgou em '
        'agosto de 2026 informe aplicando a Portaria 59-C/2018 ao pé da '
        'letra — defeso de 1º de agosto a 30 de setembro, tamanhos de 60, '
        '45, 45 e 50 cm, declaração de estoque até 10 de agosto — e '
        'registrando que as quatro espécies integram a Lista da Portaria '
        '1.667/2026. É posterior ao prazo da revisão do art. 11, que '
        'venceu em 27 de julho. O órgão fiscalizador aplicando a norma é a '
        'melhor prova de vigência que existe.\n\n'
        'Segue em aberto para o bagre-branco, o cherne-verdadeiro, o '
        'peixe-batata e a garoupa-verdadeira.\n\n'
        'PARA O BAGRE-BRANCO HÁ UM INDÍCIO A MAIS, e ele é forte: a '
        'Portaria Interministerial nº 39/2018 manda cumprir a Portaria '
        'SUDEPE nº N-42, de 1984 (art. 2º, §§ 5º e 6º). O texto da '
        'portaria de 1984 foi obtido em 29/08/2026 e está no aplicativo. '
        'Isso não prova que a Portaria 39 siga em vigor — prova que, '
        'enquanto seguir, o defeso de 1º de janeiro a 31 de março vale '
        'junto com ela.',
    falta: 'A confirmação de que os Planos do bagre-branco, do cherne e '
        'peixe-batata e da garoupa-verdadeira seguem na redação de 2018 '
        'depois da revisão do art. 11. Para os peixes recifais a dúvida já '
        'fechou pelo informe do IBAMA de agosto de 2026.\n\n'
        'Os quatro textos do MMA que faltavam foram todos obtidos. O que '
        'resta não é texto de norma: é saber se o Ministério exerceu, '
        'depois de abril de 2026, o poder do art. 6º de suspender ou '
        'revogar algum desses atos.',
  ),
  Conflito(
    titulo: 'Onde a IN 53 e o Plano de Recuperação dão números diferentes',
    desde: '29/08/2026',
    cientificos: ['Genidens barbus', 'Mycteroperca bonaci'],
    appDiz: 'Mostra os números lado a lado, sem escolher.\n\n'
        'Bagre-branco (Genidens barbus): TRÊS números, não dois. 30 cm '
        'pelo art. 2º da Portaria SUDEPE nº N-42, de 18 de outubro de '
        '1984, com tolerância de 10% sobre o peso total; 40 cm pela IN MMA '
        'nº 53/2005; e 45 cm pelo art. 2º, § 1º, I, da Portaria '
        'Interministerial nº 39, de 26 de julho de 2018.\n\n'
        'Badejo quadrado ou sirigado (Mycteroperca bonaci): 45 cm pela '
        'IN 53, 60 cm pelo art. 3º, "a", da Portaria Interministerial nº '
        '59-C, de 9 de novembro de 2018.\n\n'
        'Nas outras duas espécies que estão nas duas normas os números '
        'batem, e o aplicativo não alarma: garoupa-verdadeira 47 cm em '
        'ambas, peixe-batata 40 cm em ambas. Na garoupa, porém, o Plano '
        'acrescenta um TETO de 73 cm que a IN 53 não tem.',
    indicio: 'O TERCEIRO NÚMERO DO BAGRE, os 30 cm de 1984, é o caso mais '
        'fácil dos três, e por uma razão que o próprio texto dá: a '
        'Portaria 39/2018 manda respeitar as restrições da portaria de '
        '1984 (art. 2º, § 5º) — não manda aplicar o tamanho dela em lugar '
        'do seu. Quem cumpre 45 cm cumpre 30 cm no mesmo ato. O piso menor '
        'não libera nada que o maior proíba. Os 30 cm importam para o '
        'período, não para a régua: é a portaria de 1984 que fixa o defeso '
        'de 1º de janeiro a 31 de março.\n\n'
        'A dúvida real, então, continua sendo entre 40 cm e 45 cm.\n\n'
        'A FAVOR DO NÚMERO MAIOR: as normas do Plano são de 2018, '
        'treze anos posteriores à IN 53; são específicas de uma espécie, '
        'contra as 35 da IN 53; e são Portarias Interministeriais, '
        'assinadas por dois ministros. Pelo art. 2º, § 1º da LINDB, a '
        'norma posterior que regula inteiramente a matéria revoga a '
        'anterior.\n\n'
        'A FAVOR DO NÚMERO MENOR: o art. 5º da IN 53 preserva as regras de '
        'portarias específicas apenas "para espécies que NÃO constam nos '
        'Anexos I e II" — e estas constam. Lido a contrario, sugere que '
        'para as espécies dos anexos valem os números dela. E, em matéria '
        'sancionadora, dúvida real não se resolve contra quem é '
        'fiscalizado.\n\n'
        'No bagre-branco a questão é secundária em Santa Catarina: o art. '
        '2º, § 1º da Portaria 39 só permite a captura nas águas adjacentes '
        'a São Paulo e ao Paraná. No badejo quadrado não há restrição '
        'geográfica, e a dúvida vale para o litoral inteiro.',
    falta: 'A definição de qual número aplicar onde a captura é '
        'permitida. Enquanto não houver, consulte as duas normas nos '
        'sites oficiais.',
  ),
  Conflito(
    titulo: 'O asterisco da Lista — leitura adotada em 29/08/2026',
    desde: '27/08/2026',
    cientificos: [],
    tambemAlcanca: 'Alcança 94 dos 490 itens da Lista, e portanto a data '
        'em que a vedação passa a valer para cada uma das 490.',
    appDiz: 'ADOTOU a leitura: espécie com asterisco é nova na Lista e '
        'tem o prazo do art. 12, até 25/10/2026; espécie sem asterisco já '
        'constava e está vedada desde já. Isso define a data para as 490 '
        'espécies — 94 com prazo, 396 vedadas hoje.\n\n'
        'Leitura adotada em 29/08/2026, com base nas cinco verificações '
        'abaixo. Cada ficha traz o bloco "de onde sai esta data" com as '
        'cinco, para que possa ser auditada e, se for o caso, revertida — '
        'é uma linha de código.',
    indicio: 'A Portaria MMA nº 148/2022 usa o mesmo asterisco e PUBLICA a '
        'legenda: "* Espécies constantes na Lista anterior (2014)". Testado '
        'contra o texto de 2014: 88% das marcadas constavam, e 0% das não '
        'marcadas. A legenda funciona e o método de comparação está '
        'aferido.\n\n'
        'Aplicado à Portaria 1.667/2026, comparando com a lista anterior '
        'CORRETA — a 445/2014 já substituída pela 148/2022 e acrescida das '
        'cinco espécies da 354/2023 — o resultado se inverte:\n\n'
        'Das 94 com asterisco, NENHUMA consta da lista anterior.\n'
        'Das 396 sem asterisco, 343 constam (87%).\n'
        'Das 115 espécies que a 148/2022 acrescentou em 2022, nenhuma tem '
        'asterisco em 2026.\n'
        'E nas 11 espécies da IN 53 conferidas à mão contra a lista '
        'anterior correta, a leitura acertou 11 de 11.\n\n'
        'Os quatro testes apontam para o mesmo lado: na Portaria 1.667 o '
        'asterisco marca as espécies NOVAS na Lista. Se for isso, as 94 '
        'marcadas têm o prazo do art. 12 e só ficam vedadas em 25/10/2026; '
        'as 396 sem marca já estão vedadas.\n\n'
        'A QUINTA VERIFICAÇÃO, e a mais direta: a publicação dos '
        'Conquiliologistas do Brasil de 29 de abril de 2026, um dia depois '
        'da Lista sair, afirma em letras que "as espécies marcadas com '
        'asterisco são inclusões novas em relação à lista anterior — para '
        'essas, as proibições entram em vigor após 180 dias" e que as sem '
        'asterisco "já constavam de listas anteriores e estão '
        'imediatamente sujeitas às restrições". A publicação apresenta os '
        '23 moluscos aquáticos da Lista com suas marcas. Os 23 foram '
        'conferidos contra o aplicativo, um a um: nome, categoria e '
        'asterisco. Os 23 batem, e os 13 asteriscos são os mesmos.\n\n'
        'Contra: o mesmo Ministério usou a convenção oposta quatro anos '
        'antes, na Portaria 148/2022 — mas ali a legenda estava publicada, '
        'e aqui não está. E os Conquiliologistas são entidade '
        'especializada, não órgão normativo.\n\n'
        'E o texto pode não existir. Foram obtidas as páginas 96 e 101 do '
        'Diário Oficial de 28/04/2026, que são as duas pontas da Lista: a '
        '96 traz a Portaria 1.666 inteira, a 1.667 e os itens 1 a 9; a 101 '
        'traz os itens 395 a 490 e encerra o Anexo I. NENHUMA DAS DUAS TEM '
        'LEGENDA — nem para o asterisco, nem para as siglas de categoria. '
        'A 148/2022 repetia a legenda ao fim de cada seção, então ela '
        'ainda pode estar nas páginas 97 a 100. Se não estiver em nenhuma, '
        'a marca foi publicada sem explicação e nunca poderá ser resolvida '
        'pelo texto da norma.\n\n'
        'As siglas de categoria, ao menos, têm definição: não na 1.667, '
        'mas no art. 3º da Portaria 1.666 — "Extintas na Natureza - EW, '
        'Criticamente em Perigo - CR, Em Perigo - EN e Vulnerável - VU".\n\n'
        'De positivo: as duas páginas serviram para conferir os dados do '
        'aplicativo contra a fonte primária. Os 105 itens delas foram '
        'comparados um a um — número, asterisco, grupo, classe, ordem, '
        'família, espécie e categoria. Zero divergências.',
    falta: 'A legenda, se existir: as páginas 97 a 100 do Diário Oficial '
        'de 28/04/2026, edição 78, seção 1 — o miolo da Lista, e as únicas '
        'em que ela ainda pode estar. O ponto fica registrado não porque a '
        'leitura esteja em dúvida, mas para que quem vier depois saiba de '
        'onde a data saiu.',
  ),
  Conflito(
    titulo: 'Cinco Planos de Recuperação cuja norma não foi obtida',
    desde: '29/08/2026',
    cientificos: [
      'Lutjanus purpureus',
      'Scarus trispinosus',
      'Scarus zelindae',
      'Sparisoma amplum',
      'Sparisoma axillare',
      'Sparisoma frondosum',
      'Sparisoma rocha',
      'Cardisoma guanhumi',
      'Sciades parkeri',
      'Pseudoplatystoma corruscans',
    ],
    tambemAlcanca: 'Alcança dez espécies da Lista: o pargo, os seis '
        'budiões, o guaiamum, a gurijuba e o pintado.',
    appDiz: 'Para estas dez, o aplicativo NÃO diz "captura vedada". Diz '
        'que há Plano de Recuperação, dá o nome da norma de ordenamento e '
        'do ato do MMA, e manda consultar antes de qualquer medida.',
    indicio: 'A página de Planos de Recuperação do Ministério do Meio '
        'Ambiente lista dez planos para espécies aquáticas. Quatro estão '
        'reproduzidos no aplicativo com o texto conferido. Estes cinco '
        'não: sabe-se que existem e sabe-se o nome da norma, e o '
        'aplicativo não vai além disso.\n\n'
        'Dois deles foram refeitos em julho de 2026 — o do pargo e o do '
        'budião. No caso do budião o nome do plano mudou de "Budiões", no '
        'plural, para "Budião-azul", no singular, o que sugere que o '
        'alcance encolheu. Não se sabe quais das seis espécies o novo '
        'plano cobre.\n\n'
        'Para nenhum dos cinco se sabe se a norma alcança Santa Catarina: '
        'quem responde isso é o texto, não a distribuição do bicho.',
    falta: 'Portaria Interministerial MPA/MMA nº 66, de 27/07/2026, e '
        'Portaria MMA nº 1.742, de 24/07/2026 (pargo). Portaria MMA nº '
        '1.749, de 27/07/2026, e a norma de ordenamento do novo plano do '
        'budião-azul. Portarias Interministeriais SEAP-PR/MMA nº 38 '
        '(guaiamum) e nº 43 (gurijuba), de 2018. Portaria '
        'Interministerial MPA/MMA nº 15, de 06/12/2024 (pintado).',
  ),
];

/// Os pontos em verificação que alcançam uma espécie.
List<Conflito> conflitosDe(String cientifico) {
  final partes = cientifico.split(RegExp(r'\s*/\s*'));
  return conflitos
      .where((c) => partes.any((p) => c.alcanca(p.trim())))
      .toList();
}
