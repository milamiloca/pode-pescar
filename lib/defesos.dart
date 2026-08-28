// =====================================================================
// DEFESOS E TEMPORADAS
//
// Períodos em que a captura é proibida, ou só é permitida dentro de
// uma janela. Cada entrada diz de onde veio, e isso importa:
//
//   Origem.conferida — li o texto da norma inteiro e reproduzi aqui.
//                      É resposta do aplicativo.
//   Origem.pendente  — sei que a regra existe e sei qual norma procurar,
//                      mas não tenho o texto. NÃO é resposta do
//                      aplicativo: entra só para dizer o que falta obter.
//
// O que se sabe pelo levantamento da UNIVALI e não pela norma fica em
// `indicio`, separado do resto, e a tela deixa claro que não vale como
// resposta. Levantamento acadêmico é bom para achar a norma; não
// substitui a norma num aplicativo que serve para autuar.
// =====================================================================

/// De onde saiu o que está escrito na entrada.
///
/// Chama-se Origem, e não Fonte, porque `Fonte` já é o nome do
/// cartão de norma no tema.dart, e os dois são importados juntos.
enum Origem { conferida, pendente }

class Defeso {
  /// Nome pelo qual o defeso é conhecido.
  final String titulo;

  /// Nomes científicos alcançados, para cruzar com a ficha da espécie.
  final List<String> cientificos;

  /// O período, como a norma o define.
  final String periodo;

  /// A norma, com número e data.
  final String norma;

  /// Quando a origem é conferida, é o texto da norma. Quando é
  /// pendente, é o que o levantamento indica — e não vale como
  /// resposta do aplicativo.
  final String detalhe;

  /// De onde veio o que está escrito aqui.
  final Origem origem;

  /// Ressalva específica desta entrada, quando houver.
  final String ressalva;

  const Defeso({
    required this.titulo,
    required this.cientificos,
    required this.periodo,
    required this.norma,
    required this.origem,
    this.detalhe = '',
    this.ressalva = '',
  });

  bool alcanca(String nomeCientifico) {
    final n = nomeCientifico.toLowerCase();
    return cientificos.any((c) => n.contains(c.toLowerCase()) ||
        c.toLowerCase().contains(n));
  }
}

const compilacaoUnivali =
    'Compilação "Legislação Pesqueira em Santa Catarina", Prof. Roberto '
    'Wahrlich, Laboratório de Tecnologia e Extensão Pesqueira/UNIVALI, '
    'versão de 10 de junho de 2025.';

const defesos = <Defeso>[
  // ------------------------------------------------------------ tainha
  Defeso(
    titulo: 'Tainha',
    cientificos: ['Mugil liza', 'Mugil platanus'],
    periodo: 'Temporada anual, por modalidade — ver o detalhe',
    norma: 'Portaria Interministerial nº 24, de 15 de maio de 2018',
    origem: Origem.conferida,
    ressalva: 'As datas abaixo foram expressamente confirmadas para 2026 '
        'pelo art. 21 da Portaria Interministerial MPA/MMA nº 51, de 27 de '
        'fevereiro de 2026, que as define "com fundamento nos períodos '
        'estabelecidos na Portaria nº 24, de 2018". A quinta linha mudou '
        'de nome: onde 2018 dizia "desembarcada ou não motorizada", 2026 '
        'diz "arrasto de praia" — mesmas datas.\n\n'
        'A Portaria nº 57, de 12 de maio de 2026, alterou o art. 21 da '
        'Portaria 24/2018, sobre rastreamento por satélite no emalhe '
        'anilhado. Não tocou nas temporadas nem nas áreas.\n\n'
        'A compilação da UNIVALI registra ainda uma Portaria nº 75/2020, '
        'cujo texto não foi obtido.',
    detalhe: 'TEMPORADA, POR MODALIDADE (art. 2º)\n'
        'Cerco e traineira: 1º de junho a 31 de julho.\n'
        'Emalhe costeiro de superfície sem anilhas, até 10 AB: '
        '15 de maio a 15 de outubro.\n'
        'Emalhe costeiro de superfície sem anilhas, acima de 10 AB: '
        '15 de maio a 31 de julho.\n'
        'Emalhe anilhado: 15 de maio a 31 de julho.\n'
        'Desembarcada ou não motorizada: 1º de maio a 31 de dezembro.\n\n'
        'Fora desses períodos a pesca da tainha é proibida para a '
        'modalidade correspondente (§ 1º). A restrição de tempo não se '
        'aplica dentro das lagoas e estuários (§ 2º).\n\n'
        'ÁREAS FECHADAS (art. 3º)\n'
        'Todas as modalidades, exceto tarrafa, de 15 de março a 15 de '
        'setembro: proibido em todas as desembocaduras '
        'estuarino-lagunares.\n'
        'Redes de trolha, cercos flutuantes, redes de emalhe, faróis '
        'manuais, anzóis, fisgas e garatéias, de 1º de maio a 31 de '
        'dezembro, no litoral de Santa Catarina: proibido a menos de '
        '300 m dos costões rochosos e a menos de 1 milha náutica da '
        'costa, onde há a prática tradicional de arrastão de praia com '
        'canoas a remo.\n'
        'Captura de isca viva, de 1º de maio a 31 de julho, no litoral '
        'de Santa Catarina: mesmas distâncias.\n'
        'Cerco e traineira, de 1º de junho a 31 de julho: proibido até '
        '5 milhas náuticas da costa em SP, PR e SC.\n'
        'Pesca desembarcada em emalhe fixo ou de deriva: proibido no '
        'raio de 150 m de ilhas, lajes e costões rochosos.\n'
        'Emalhe costeiro de superfície e emalhe anilhado, com '
        'embarcação motorizada: proibido na faixa de 1 milha náutica '
        'medida da linha de costa.\n\n'
        'DESEMBOCADURA ESTUARINO-LAGUNAR (art. 3º, § 1º)\n'
        'A área compreendida a 1.000 m da boca da barra para fora, em '
        'direção ao oceano; 200 m para dentro do rio ou estuário; e '
        '1.000 m de extensão nas margens adjacentes.\n\n'
        'SANÇÕES (art. 26)\n'
        'Lei nº 9.605, de 12 de fevereiro de 1998, e Decreto nº 6.514, '
        'de 26 de julho de 2008.\n\n'
        'O QUE NÃO ESTÁ AQUI: AS COTAS\n'
        'O Capítulo II fixou a cota de captura da safra de 2018 '
        '(3.417 t) e o número de embarcações autorizadas naquele ano. '
        'Não está reproduzido, e não vale mais: cota e número de '
        'autorizações são fixados a cada safra, em norma própria. Para '
        '2026, a Portaria Interministerial MPA/MMA nº 51, de 27 de '
        'fevereiro de 2026, alterada pela nº 63, de 11 de junho de 2026. '
        'A de 2025 (nº 26/2025) foi revogada pelo art. 33 da nº 51.\n\n'
        'A TEMPORADA TAMBÉM ENCERRA POR COTA\n'
        'O art. 23 da Portaria 51/2026 encerra a captura antes do fim do '
        'período quando a cota é atingida: 90% da cota individual no '
        'cerco/traineira, 85% da cota coletiva no emalhe anilhado, 90% da '
        'cota coletiva no emalhe costeiro de superfície, no arrasto de '
        'praia e no estuário da Lagoa dos Patos. O encerramento é '
        'oficializado no Painel de Monitoramento da Temporada de Pesca da '
        'Tainha, no sítio do Ministério da Pesca e Aquicultura (art. 24).\n'
        'Estar dentro das datas não basta: a temporada pode já ter sido '
        'encerrada. O aplicativo não tem como saber — a consulta ao '
        'Painel é obrigatória.',
  ),

  // ----------------------------------------------------------- camarões
  Defeso(
    titulo: 'Camarões marinhos',
    cientificos: [
      'Penaeus paulensis',
      'Penaeus brasiliensis',
      'Penaeus subtilis',
      'Xiphopenaeus kroyeri',
      'Penaeus schmitti',
      'Litopenaeus schmitti',
      'Pleoticus muelleri',
      'Artemesia longinaris',
    ],
    periodo: '28 de janeiro a 30 de abril',
    norma: 'Portaria SAP/MAPA nº 656, de 30 de março de 2022',
    origem: Origem.conferida,
    ressalva: 'A Portaria Interministerial MPA/MMA nº 47, de 14 de '
        'janeiro de 2026, alterou o art. 18 da Portaria 656/2022, sobre '
        'rastreamento por satélite. Não tocou no defeso, nos tamanhos nem '
        'nos petrechos.\n\n'
        'A compilação da UNIVALI registra ainda uma alteração pela '
        'Portaria SAP/MAPA nº 695/2022, cujo texto não foi obtido.',
    detalhe: 'ESPÉCIES ALCANÇADAS (art. 1º)\n'
        'Camarão-rosa (Penaeus paulensis, Penaeus brasiliensis e Penaeus '
        'subtilis), sete-barbas (Xiphopenaeus kroyeri), branco (Penaeus '
        'schmitti), santana ou vermelho (Pleoticus muelleri) e barba-ruça '
        '(Artemesia longinaris).\n\n'
        'DEFESO (art. 2º)\n'
        'De 28 de janeiro a 30 de abril no Rio de Janeiro, São Paulo, '
        'Paraná, Santa Catarina e Rio Grande do Sul, no Mar territorial '
        'e na ZEE.\n'
        '§ 2º No período de defeso fica permitido o desembarque até o '
        'dia 30 de janeiro de cada ano.\n'
        '§ 3º No período de defeso fica permitida a pesca do '
        'camarão-branco (Penaeus subtilis) desde que não seja realizada '
        'por arrasto com tração motorizada.\n\n'
        'TAMANHO MÍNIMO (art. 6º)\n'
        '90 mm de comprimento total para o camarão-rosa e o '
        'camarão-branco. Comprimento total é a distância entre a '
        'extremidade do rostro e a ponta do telson (§ 1º). Tolerância de '
        'até 10% sobre o peso total de camarões por cruzeiro de pesca '
        '(§ 2º).\n\n'
        'PETRECHOS (arts. 4º e 5º)\n'
        'Sete-barbas: rede de arrasto de porta, comprimento máximo 12 m, '
        'com tralha superior e malha mínima de 24 mm entre nós opostos '
        'da malha esticada, inclusive no ensacador. Até duas redes por '
        'embarcação.\n'
        'Rosa e branco: aviãozinho, de saco e tarrafa, malha mínima 25 mm; '
        'rede de caceio, malha mínima 45 mm; redes de arrasto, malha '
        'mínima 30 mm.\n\n'
        'ÁGUAS INTERIORES (art. 19)\n'
        'As regras para águas interiores são definidas em atos '
        'normativos específicos, não nesta portaria.\n\n'
        'SANÇÃO (art. 20)\n'
        'Infração administrativa ambiental do art. 70 da Lei nº 9.605, '
        'de 12 de fevereiro de 1998.',
  ),

  // ------------------------------- camarões no Complexo Lagunar Sul
  Defeso(
    titulo: 'Camarões no Complexo Lagunar Sul de Santa Catarina',
    cientificos: [
      'Penaeus paulensis',
      'Penaeus brasiliensis',
      'Penaeus schmitti',
    ],
    periodo: 'Permitido de 16 de novembro a 14 de julho — fora disso, '
        'não pode',
    norma: 'Portaria Interministerial MPA/MMA nº 65, de 3 de julho de 2026',
    origem: Origem.conferida,
    ressalva: 'Esta é a norma das águas interiores a que se refere o art. 19 '
        'da Portaria SAP/MAPA nº 656/2022. O defeso do mar (28 de janeiro a '
        '30 de abril) e a janela do Complexo Lagunar são regras diferentes, '
        'de normas diferentes, e uma não vale pela outra.\n\n'
        'A janela permitida (16 de novembro a 14 de julho) equivale ao '
        'período fechado de 15 de julho a 15 de novembro que a compilação da '
        'UNIVALI atribui à Instrução Normativa IBAMA nº 21/2009 — que a '
        'Portaria 65 não revogou. As duas datas coincidem.\n\n'
        'ATENÇÃO AO QUE MUDOU: o art. 22 revogou a Portaria IBAMA nº 32, de '
        '30 de março de 1998, e a Portaria IBAMA nº 27, de 10 de março de '
        '1999. A compilação da UNIVALI, de junho de 2025, ainda traz as duas '
        'como vigentes, com números diferentes dos de agora — a tarrafa era '
        'de 26 mm pela 32/1998 e é de 25 mm pelo art. 3º, II. Confirmar se a '
        '"Portaria IBAMA nº 27-N/1999" da compilação, sobre a Lagoa do '
        'Camacho, é a mesma Portaria nº 27 revogada.',
    detalhe: 'ONDE VALE (art. 2º, I)\n'
        'Complexo Lagunar do Sul de Santa Catarina: Lagoas Mirim, Imaruí, '
        'Santo Antônio dos Anjos, Santa Marta Pequena, Camacho e Garopaba '
        'do Sul, e seus respectivos tributários.\n\n'
        'A QUEM SE APLICA (art. 2º, II)\n'
        'Pesca artesanal: pessoa física, com fins comerciais, de forma '
        'autônoma ou em regime de economia familiar, com meios de produção '
        'próprios ou por contrato de parceria, desembarcada ou com '
        'embarcação de Arqueação Bruta igual ou inferior a 20.\n\n'
        'QUANDO E COM O QUÊ (art. 3º)\n'
        'I - Só podem ser pescados de 16 de novembro a 14 de julho.\n'
        'II - Só com tarrafa de malha mínima de 25 mm, medidos entre nós '
        'opostos, com a malha totalmente esticada.\n'
        'III - Só com rede de aviãozinho de malha mínima de 24 mm, medidos '
        'entre nós opostos, com a malha totalmente esticada.\n\n'
        'AVIÃOZINHO (art. 4º)\n'
        'Permitido exclusivamente no interior das áreas balizadas, por '
        'pescador aprovado pelo Fórum de Pesca e licenciado. No máximo 36 '
        'redes por pescador; no máximo 6 unidades por ponto luminoso; no '
        'máximo 12 pontos, respeitado o limite de 36 redes. A tralha (manga '
        'e boca) não pode passar de 15 m e a distância entre calões não pode '
        'exceder 12 m. A rede deve ser içada para fora da água durante o '
        'dia. Cada ponto deve conter a identificação do número da licença '
        'especial. As áreas balizadas devem estar identificadas até 14 de '
        'novembro de 2026 (art. 20).\n\n'
        'TAMANHO MÍNIMO (art. 5º)\n'
        '80 mm de comprimento total, para o camarão-rosa (Penaeus paulensis '
        'e Penaeus brasiliensis) e o camarão-branco (Penaeus schmitti). '
        'Comprimento total é a distância entre a extremidade do rostro e a '
        'ponta do télson (§ 1º).\n'
        '§ 2º Tolerância de até 30% sobre o peso total de camarões com '
        'tamanho inferior ao mínimo.\n'
        '§ 3º Ultrapassado esse limite, os indivíduos abaixo do mínimo devem '
        'ser descartados, preferencialmente vivos.\n'
        '§ 4º Indivíduos de espécies da Lista da Fauna Brasileira Ameaçada '
        'de Extinção e de espécies não alvo, capturados incidentalmente, '
        'devem ser devolvidos vivos ao ambiente aquático.\n\n'
        'FAUNA ACOMPANHANTE (art. 6º)\n'
        'Tainha (Mugil liza), robalo (Centropomus spp.), corvina '
        '(Micropogonias furnieri), parati (Mugil curema), carapeba '
        '(Diapterus spp.), carapicu (Eucinostomus spp.), peixe-rei '
        '(Atherinella spp.), pampo (Trachinotus spp.), savelha (Brevoortia '
        'spp.), manjuba (Lycengraulis grossidens e Anchoviella '
        'lepidentostole), sardinha (Sardinella spp. e Harengula clupeola), '
        'siri (Callinectes spp.), bagre (Genidens spp.), anchova (Pomatomus '
        'saltatrix) e linguado (Citharichthys spp. e Paralichthys spp.).\n'
        'Parágrafo único: é permitida a captura e a comercialização de '
        'outras espécies não listadas, desde que se enquadrem no conceito '
        'de fauna acompanhante e não estejam sujeitas a proibição de '
        'captura, transporte, processamento e comercialização.\n\n'
        'PETRECHOS PROIBIDOS (art. 7º)\n'
        'Redes de arrasto; redes de porta (plancha); pauzinho; trolha; '
        'caracol; coca, sob qualquer outra denominação; e as redes '
        'denominadas gerival, berimbau, bernuça ou pata de vaca.\n'
        'Parágrafo único: é proibida a pesca, em qualquer modalidade, nos '
        'rios e canais de navegação definidos pela Marinha do Brasil.\n\n'
        'LICENÇA ESPECIAL (arts. 8º a 14)\n'
        'Individual, intransferível, válida por dois anos. Pedido '
        'presencial de 1º de junho a 31 de julho de cada ano, na '
        'Superintendência Federal de Pesca e Aquicultura em Santa Catarina, '
        'com requerimento, Licença de Pescador Profissional deferida no RGP '
        'e comprovante de residência. Emissão até 1º de novembro de cada '
        'ano. Não são concedidas licenças a quem exerça a pesca em caráter '
        'temporário, ocasional ou transitório (art. 13, § único).\n\n'
        'MONITORAMENTO (art. 15)\n'
        'Relatório de Exercício da Atividade Pesqueira (REAP), enviado pelo '
        'Sistema PesqBrasil-RGP, nos termos da Portaria MPA nº 127, de 29 de '
        'agosto de 2023.\n\n'
        'SANÇÃO (art. 18)\n'
        'Pescar sem regularização no RGP sujeita às penalidades da Lei nº '
        '9.605, de 1998, e do Decreto nº 6.514, de 2008, sem prejuízo da '
        'Lei nº 14.155, de 2021, e do Código Penal.\n\n'
        'REVOGAÇÕES (art. 22)\n'
        'Portaria IBAMA nº 32, de 30 de março de 1998, e Portaria IBAMA nº '
        '27, de 10 de março de 1999.',
  ),

  // ------------------------------------------ os que vêm da compilação
  Defeso(
    titulo: 'Enchova ou anchova',
    cientificos: ['Pomatomus saltatrix'],
    periodo: '1º de dezembro a 31 de março',
    norma: 'Instrução Normativa Interministerial MPA/MMA nº 02/2009',
    origem: Origem.pendente,
    detalhe: 'A mesma norma traz ainda, segundo a compilação: captura '
        'permissível de até 5% do total desembarcado para embarcações '
        'não autorizadas, como fauna acompanhante; e área interditada '
        'na faixa de 5 milhas náuticas da costa para embarcações com '
        'arqueação bruta superior a 20.',
  ),
  Defeso(
    titulo: 'Bagre rosado',
    cientificos: ['Genidens genidens', 'Genidens barbus', 'Cathorops agassizii'],
    periodo: '1º de janeiro a 31 de março',
    norma: 'Portaria SUDEPE N-42/1984',
    origem: Origem.pendente,
    ressalva: 'A compilação registra ainda a Portaria Interministerial nº '
        '39/2018, que proíbe a pesca direcionada, o transporte, o '
        'desembarque e a comercialização de Genidens barbus nas águas '
        'jurisdicionais brasileiras, exceto nas adjacentes a São Paulo e '
        'ao Paraná. Nenhuma das duas foi conferida no aplicativo.',
  ),
  Defeso(
    titulo: 'Sardinha-verdadeira',
    cientificos: ['Sardinella brasiliensis'],
    periodo: '1º de outubro a 28 de fevereiro',
    norma: 'Instrução Normativa SAP/MAPA nº 18/2020',
    origem: Origem.pendente,
    detalhe: 'Segundo a compilação, na área compreendida entre os '
        'paralelos 22°00\' Sul (Cabo de São Tomé, Rio de Janeiro) e '
        '28°36\' Sul (Cabo de Santa Marta, Santa Catarina).',
  ),
  Defeso(
    titulo: 'Sardinha-verdadeira para isca-viva',
    cientificos: ['Sardinella brasiliensis'],
    periodo: '15 de junho a 31 de julho',
    norma: 'Instrução Normativa IBAMA nº 16/2009',
    origem: Origem.pendente,
    detalhe: 'Segundo a compilação, proíbe a captura e a estocagem a '
        'bordo por parte das embarcações autorizadas à captura de atuns '
        'pelo sistema de vara e isca-viva.',
  ),
  Defeso(
    titulo: 'Garoupa-verdadeira',
    cientificos: ['Epinephelus marginatus'],
    periodo: '1º de novembro a 28 de fevereiro',
    norma: 'Portaria Interministerial nº 41/2018',
    origem: Origem.pendente,
    ressalva: 'Esta é uma das portarias que a compilação indica como '
        'permitindo pesca regulada de espécie que consta da Lista '
        'Nacional de ameaçadas. O texto não foi conferido no aplicativo, '
        'e a relação dela com a Portaria GM/MMA nº 1.666/2026 está em '
        'aberto.',
    detalhe: 'Segundo a compilação: pesca comercial permitida apenas a '
        'embarcações com arqueação bruta menor ou igual a 20, '
        'permissionadas a espinhel horizontal de fundo ou linha de mão '
        'de fundo; captura permitida apenas entre 47 cm e 73 cm de '
        'comprimento total.',
  ),
  Defeso(
    titulo: 'Cherne-verdadeiro e peixe-batata',
    cientificos: ['Hyporthodus niveatus', 'Lopholatilus villarii'],
    periodo: '1º de setembro a 31 de outubro',
    norma: 'Portaria Interministerial nº 40/2018',
    origem: Origem.pendente,
    ressalva: 'Também indicada pela compilação como norma que permite '
        'pesca regulada de espécie da Lista Nacional. Texto não '
        'conferido no aplicativo.',
    detalhe: 'Segundo a compilação: defeso para a pesca realizada entre '
        '100 e 600 metros de profundidade, nas modalidades 1.6, 1.7, '
        '3.10, 3.11 e 3.12 da IN MPA/MMA nº 10/2011. Tamanho mínimo de '
        '45 cm para o cherne-verdadeiro e 40 cm para o peixe-batata.',
  ),
  Defeso(
    titulo: 'Caranguejo-uçá',
    cientificos: ['Ucides cordatus'],
    periodo: '1º de outubro a 30 de novembro (machos e fêmeas) e '
        '1º de dezembro a 31 de dezembro (somente fêmeas)',
    norma: 'Portaria IBAMA nº 52/2003',
    origem: Origem.pendente,
    detalhe: 'Segundo a compilação: proibida a captura de fêmeas ovadas '
        'e a captura de indivíduos com largura de carapaça inferior a '
        'seis centímetros, bem como de partes separadas do corpo '
        '(quelas, pinças ou garras).',
  ),
  Defeso(
    titulo: 'Lagostas',
    cientificos: ['Panulirus argus', 'Panulirus laevicauda',
        'Panulirus echinatus'],
    periodo: '1º de novembro a 30 de abril',
    norma: 'Portaria SAP/MAPA nº 221/2021',
    origem: Origem.pendente,
  ),
  Defeso(
    titulo: 'Mexilhão ou marisco da pedra',
    cientificos: ['Perna perna'],
    periodo: '1º de setembro a 31 de dezembro',
    norma: 'Instrução Normativa IBAMA nº 105/2006',
    origem: Origem.pendente,
  ),
  Defeso(
    titulo: 'Lulas',
    cientificos: ['Loligo plei', 'Loligo sanpaulensis', 'Lolliguncula brevis'],
    periodo: 'Permitida de 1º de novembro a 31 de março, em Santa Catarina',
    norma: 'Portaria Interministerial MPA/MMA nº 14/2024',
    origem: Origem.pendente,
    ressalva: 'A norma define a janela em que a pesca é permitida, e não '
        'um período de proibição. Fora dela, a captura não é permitida.',
    detalhe: 'Segundo a compilação, a pesca é permitida a pescadores '
        'profissionais artesanais embarcados ou desembarcados, e a '
        'embarcações com arqueação bruta até 20 ou permissionadas nas '
        'modalidades 2.2, 2.4, 3.8, 3.9, 6.7, 6.8, 6.9, 6.10 e 6.11 da '
        'IN MPA/MMA nº 10/2011. Petrechos: arrasto de fundo (apenas como '
        'fauna acompanhante), arrasto de praia, linhas de mão com iscas '
        'artificiais ou naturais (zangarilhos, garatéias) e tarrafas com '
        'malha mínima de 1,5 cm entre nós opostos.',
  ),
];

/// Os defesos que alcançam uma espécie, pelo nome científico.
List<Defeso> defesosDe(String cientifico) {
  final partes = cientifico.split(RegExp(r'\s*/\s*'));
  return defesos
      .where((d) => partes.any((p) => d.alcanca(p.trim())))
      .toList();
}

int get quantosComTextoIntegral =>
    defesos.where((d) => d.origem == Origem.conferida).length;
