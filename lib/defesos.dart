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
// substitui a norma num aplicativo de consulta.
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

  /// Para quais estados a norma vale. Obrigatório: este aplicativo
  /// é de Santa Catarina, e a primeira coisa que quem consulta precisa
  /// saber de um defeso é se ele alcança o lugar onde ela está.
  final String abrangencia;

  const Defeso({
    required this.titulo,
    required this.cientificos,
    required this.periodo,
    required this.norma,
    required this.origem,
    required this.abrangencia,
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
    abrangencia: 'Regiões Sudeste e Sul. As áreas fechadas do art. 3º têm dispositivos próprios para Santa Catarina.',
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
        'A Portaria SAP/MAPA nº 75, de 3 de abril de 2020 — que a '
        'compilação da UNIVALI citava sem órgão nem data — foi obtida e '
        'lida. Ela NÃO tocou nas temporadas do art. 2º. Fez duas coisas: '
        'prorrogou até 31/12/2022 o prazo do art. 21 para o PREPS no '
        'emalhe anilhado, e mudou a redação do primeiro inciso V do art. '
        '3º. A mudança ESTREITOU a área fechada: antes valia "para '
        'qualquer operação de pesca da modalidade cerco/traineira"; agora '
        'vale para a modalidade "autorizada à captura de tainha". Uma '
        'traineira sem autorização para tainha deixou de ser alcançada '
        'por esse fechamento.',
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
        'Cerco e traineira AUTORIZADA À CAPTURA DE TAINHA (redação da '
        'Portaria SAP/MAPA nº 75/2020), de 1º de junho a 31 de julho: '
        'proibido a partir da linha de costa até 3 MN para embarcações '
        'acima de 4 AB no RJ; até 5 MN para as acima de 10 AB no RJ; até '
        '5 MN em SP, PR e SC; e até 10 MN no RS.\n'
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
    abrangencia: 'Rio de Janeiro, São Paulo, Paraná, Santa Catarina e Rio Grande do Sul, no mar territorial e na ZEE.',
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
    abrangencia: 'Somente Santa Catarina: Lagoas Mirim, Imaruí, Santo Antônio dos Anjos, Santa Marta Pequena, Camacho e Garopaba do Sul, e seus tributários.',
    norma: 'Portaria Interministerial MPA/MMA nº 65, de 3 de julho de 2026',
    origem: Origem.conferida,
    ressalva: 'Esta é a norma das águas interiores a que se refere o art. 19 '
        'da Portaria SAP/MAPA nº 656/2022. O defeso do mar (28 de janeiro a '
        '30 de abril) e a janela do Complexo Lagunar são regras diferentes, '
        'de normas diferentes, e uma não vale pela outra.\n\n'
        'A janela permitida (16 de novembro a 14 de julho) equivale ao '
        'período fechado de 15 de julho a 15 de novembro da Instrução '
        'Normativa IBAMA nº 21, de 7 de julho de 2009 — que a Portaria 65 '
        'não revogou. O TEXTO DA IN 21/2009 FOI LIDO e diz, no art. 1º: '
        '"Proibir a pesca do camarão-rosa (Farfantepenaeus brasiliensis e '
        'F. paulensis) e do camarão branco (Litopenaeus schimitti), '
        'anualmente, no período de 15 de julho a 15 de novembro, COM '
        'QUALQUER MODALIDADE E PETRECHO, na área do complexo lagunar sul '
        'do estado de Santa Catarina, compreendendo as lagoas do Camacho, '
        'Garopaba do Sul, Imaruí, Mirim, Santa Marta, Santo Antônio, '
        'OUTRAS LAGOAS MARGINAIS E TRIBUTÁRIOS".\n\n'
        'DOIS PONTOS QUE SÓ ESTÃO NA IN 21/2009:\n'
        '1. A área dela é mais larga que a lista nominal da Portaria 65 — '
        'inclui "outras lagoas marginais e tributários".\n'
        '2. O parágrafo único do art. 1º manda que, durante o período de '
        'proibição, OS PETRECHOS DESTINADOS AO CAMARÃO SEJAM RETIRADOS DOS '
        'PONTOS DE PESCA. Petrecho de camarão armado na lagoa entre 15 de '
        'julho e 15 de novembro contraria esse dispositivo, ainda que '
        'ninguém esteja pescando no momento.\n\n'
        'A IN 21/2009 foi editada com base no art. 5º da IN IBAMA nº '
        '189/2008, que manda definir por norma específica os defesos do '
        'camarão nas áreas estuarinas e lagunares. A página de defesos '
        'marinhos do IBAMA, atualizada em 21 de janeiro de 2026, traz a '
        'mesma coisa. Três fontes, o mesmo período.\n\n'
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
    abrangencia: 'Litoral sul: Paraná, Santa Catarina e Rio Grande do Sul.',
    norma: 'Instrução Normativa Interministerial MPA/MMA nº 02, de 27 '
        'de novembro de 2009',
    origem: Origem.conferida,
    detalhe: 'O DEFESO (art. 4º)\n'
        'Proibida, anualmente, de 1º de dezembro a 31 de março, a captura '
        'da anchova no litoral sul do país.\n'
        '§ 1º A largada das embarcações autorizadas é permitida a partir '
        'de 1º de abril de cada ano.\n'
        '§ 2º O desembarque é tolerado até o dia 3 de dezembro de cada '
        'ano.\n\n'
        'QUEM PODE PESCAR ANCHOVA (art. 2º)\n'
        'A embarcação precisa estar inscrita no RGP com autorização para '
        'pesca de anchova nas modalidades CERCO ou EMALHE DE SUPERFÍCIE '
        'COSTEIRO.\n'
        'Parágrafo único: a embarcação NÃO autorizada só pode capturar e '
        'desembarcar anchova como FAUNA ACOMPANHANTE de outra pescaria '
        'autorizada, na proporção de até 5% do total desembarcado.\n\n'
        'DISTÂNCIA DA COSTA (art. 3º)\n'
        'Embarcação com arqueação bruta SUPERIOR A 20 só pode capturar '
        'anchova:\n'
        'I - a partir de 5 MILHAS NÁUTICAS da costa, no litoral do Paraná '
        'e de SANTA CATARINA;\n'
        'II - a partir de 10 milhas náuticas da costa, no litoral do Rio '
        'Grande do Sul.\n\n'
        'DECLARAÇÃO DE ESTOQUE (art. 5º)\n'
        'Quem atua na captura, conservação, beneficiamento, '
        'industrialização ou comercialização deve entregar à '
        'Superintendência do IBAMA, ATÉ 7 DE DEZEMBRO de cada ano, a '
        'relação detalhada dos estoques existentes em 3 de dezembro.\n'
        'Parágrafo único: durante o defeso ficam vedados o transporte, a '
        'estocagem, a comercialização, o beneficiamento e a '
        'industrialização de qualquer volume de anchova que não venha do '
        'estoque declarado ou de fauna acompanhante, o que o interessado '
        'comprova no ato da fiscalização.\n\n'
        'MONITORAMENTO (art. 6º)\n'
        'A embarcação autorizada é obrigada a entregar mapas de bordo, '
        'manter o rastreamento por satélite em funcionamento e manter '
        'observador de bordo em 25% das operações de pesca.\n\n'
        'SANÇÃO (arts. 8º e 9º)\n'
        'A embarcação autuada pode ter a permissão de pesca cancelada, '
        'além das penalidades da Lei nº 9.605, de 1998, e do Decreto nº '
        '6.514, de 2008.\n\n'
        'REVOGAÇÃO (art. 11)\n'
        'Revogou a Portaria IBAMA nº 127-N, de 18 de novembro de 1994.\n\n'
        'PUBLICAÇÃO\n'
        'DOU de 30/11/2009. Assinaram Altemir Gregolin, Ministro da Pesca '
        'e Aquicultura, e Carlos Minc, Ministro do Meio Ambiente.',
  ),
  // --------------------------- piracema: bacia do rio Uruguai (SC/RS)
  Defeso(
    titulo: 'Piracema — bacia do rio Uruguai',
    cientificos: [],
    periodo: '1º de outubro a 31 de janeiro',
    abrangencia: 'Bacia hidrográfica do rio Uruguai, em Santa Catarina e '
        'no Rio Grande do Sul. A norma entende por bacia o rio principal, '
        'seus formadores, afluentes, lagos, lagoas marginais, '
        'reservatórios e demais coleções de água da bacia de contribuição '
        'do rio (art. 1º, parágrafo único).',
    norma: 'IN IBAMA nº 193, de 2 de outubro de 2008',
    origem: Origem.conferida,
    ressalva: 'O QUE SOBRA NÃO É POUCO, E NÃO É EM TODO LUGAR. O art. 6º '
        'deixa de fora da proibição a pesca profissional e amadora com '
        'linha de mão OU vara, linha e anzol — um só petrecho por '
        'pescador. Mas o § 1º exige que, se for embarcado, a embarcação '
        'seja NÃO MOTORIZADA; e o § 2º diz que essa liberação NÃO VALE '
        'nas áreas dos arts. 3º e 4º, onde a pesca está proibida para '
        'qualquer categoria, modalidade e petrecho.',
    detalhe: 'O DEFESO (art. 2º)\n'
        'Proibida a pesca, anualmente, de 1º de outubro a 31 de janeiro, '
        'na bacia hidrográfica do rio Uruguai, em Santa Catarina e no Rio '
        'Grande do Sul.\n\n'
        'ONDE NÃO PODE NADA (art. 3º)\n'
        'Proibida a pesca de qualquer categoria, modalidade e petrecho, '
        'durante o defeso, na bacia do rio Uruguai:\n'
        'I - nas lagoas marginais;\n'
        'II - até 1.500 m a montante e a jusante das barragens de '
        'reservatórios de usinas hidrelétricas, cachoeiras e '
        'corredeiras;\n'
        'III - em todo o trecho da saída de água da casa de força até a '
        'barragem do reservatório de usinas hidrelétricas que tenham essa '
        'característica construtiva;\n'
        'IV - a 1.500 m a jusante da saída de água da casa de força '
        'dessas usinas;\n'
        'V - no rio Uruguai, entre a foz do rio Macaco Branco '
        '(Itapiranga/SC) e o rio Lajeado São Francisco (Alto Uruguai/RS), '
        'incluindo os limites leste e oeste do Parque Estadual do '
        'Turvo/RS;\n'
        'VI - no rio Uruguai, da barragem do reservatório da UHE '
        'Machadinho até a foz do rio Ligeiro;\n'
        'VII - no rio Forquilha ou Inhandava, até 3.500 m a montante da '
        'foz com o rio Pelotas; e\n'
        'VIII - da confluência do rio Ibicuí com o rio Uruguai até o '
        'Parque Municipal de Uruguaiana, incluindo a Ilha de Japeju/RS.\n'
        'Parágrafo único: lagoas marginais são as áreas de alagados, '
        'alagadiços, lagos, banhados, canais ou poços naturais que recebam '
        'águas dos rios ou de outras lagoas, em caráter permanente ou '
        'temporário.\n\n'
        'OS 500 METROS DAS CONFLUÊNCIAS (art. 4º)\n'
        'Proibida a pesca, de qualquer categoria, modalidade e petrecho, '
        'até 500 m:\n'
        'I - no rio Uruguai, a montante e a jusante dos pontos de '
        'confluência de seus tributários diretos; e\n'
        'II - no interior dos tributários diretos do rio Uruguai, desde o '
        'ponto de confluência.\n\n'
        'COMPETIÇÕES (art. 5º)\n'
        'Proibida a realização de competições de pesca em águas da bacia '
        'durante o defeso.\n\n'
        'O QUE FICA DE FORA DA PROIBIÇÃO (art. 6º)\n'
        'I - a pesca de caráter científico, prévia e devidamente '
        'autorizada pelo IBAMA; e\n'
        'II - a pesca profissional e amadora, embarcada ou desembarcada, '
        'com linha de mão OU vara, linha e anzol, limitada a apenas UM '
        'destes petrechos por pescador.\n'
        '§ 1º A pesca embarcada do inciso II é permitida exclusivamente '
        'com embarcação NÃO MOTORIZADA.\n'
        '§ 2º Estas exclusões NÃO se aplicam ao disposto nos arts. 3º e '
        '4º.\n'
        '§ 3º Aparelhos, petrechos e métodos não mencionados na norma são '
        'considerados de uso proibido.\n\n'
        'QUANTO PODE LEVAR (art. 7º)\n'
        'Limite de captura e transporte de até 5 kg de peixes, por ato de '
        'fiscalização, para pescadores profissionais, amadores e '
        'dispensados de licença na forma do art. 29 do Decreto-lei nº '
        '221/1967, em atendimento ao art. 6º, II.\n'
        'Parágrafo único: para efeito de mensuração, na fiscalização o '
        'pescado deverá estar INTEIRO.\n\n'
        'TRANSPORTE (art. 8º)\n'
        'O produto vindo de local com defeso diferenciado deve estar '
        'acompanhado de comprovação de origem, sob pena de apreensão do '
        'pescado e dos petrechos, equipamentos e instrumentos usados na '
        'pesca. A comprovação é: nota de produtor, para o profissional; '
        'guia de transporte do órgão estadual, para o amador; pescado '
        'lacrado com certificação sanitária, para a indústria.\n\n'
        'PISCICULTURA E PESQUE-PAGUE (art. 9º)\n'
        'Transporte, comercialização, beneficiamento, industrialização e '
        'armazenamento só são permitidos se o empreendimento for '
        'registrado no órgão competente e houver nota fiscal.\n\n'
        'ESTOQUE (art. 10)\n'
        'Quinto dia útil após o início do defeso é o prazo máximo para a '
        'declaração dos estoques ao IBAMA.\n\n'
        'SANÇÃO (art. 11)\n'
        'Penalidades da Lei nº 9.605, de 1998, e do Decreto nº 6.514, de '
        '2008.\n\n'
        'PUBLICAÇÃO\n'
        'DOU nº 192, de 3 de outubro de 2008, seção 1, página 90. Assinou '
        'Roberto Messias Franco, Presidente do IBAMA.',
  ),

  // ------------------- piracema: demais bacias de SC e do RS (não o Uruguai)
  Defeso(
    titulo: 'Piracema — demais bacias de Santa Catarina',
    cientificos: [],
    periodo: '1º de novembro a 31 de janeiro',
    abrangencia: 'Bacias hidrográficas dos estados do Rio Grande do Sul e '
        'de Santa Catarina — menos a bacia do rio Uruguai, que tem norma '
        'própria, e menos as lagoas costeiras e baías catarinenses.',
    norma: 'IN IBAMA nº 197, de 2 de outubro de 2008',
    origem: Origem.conferida,
    ressalva: 'ATENÇÃO AO ALCANCE EM SANTA CATARINA. O art. 3º, VI diz '
        'que esta norma NÃO SE APLICA às lagoas costeiras e baías do '
        'Estado de Santa Catarina, "por tratar-se de ambientes estuarinos '
        'com normatização de pesca específica". Ou seja: no Complexo '
        'Lagunar Sul, na Baía da Babitonga e nas demais lagoas costeiras '
        'e baías do Estado, a regra é outra — não é esta. E o art. 3º, I '
        'tira também a bacia do rio Uruguai, que segue a IN IBAMA nº '
        '193/2008.\n\n'
        'Repare ainda que o art. 5º usa 1.500 m em volta das barragens, '
        'cachoeiras e corredeiras, e que nessas áreas — e nas lagoas '
        'marginais — não vale a liberação do anzol simples.',
    detalhe: 'O DEFESO (art. 4º)\n'
        'Proibida a pesca, anualmente, no período de 1º de novembro a 31 '
        'de janeiro, nas bacias hidrográficas dos estados do Rio Grande '
        'do Sul e de Santa Catarina.\n\n'
        'O QUE SOBRA (art. 4º, § 1º)\n'
        'A proibição não se aplica:\n'
        'I - à pesca de caráter científico, prévia e devidamente '
        'autorizada pelo IBAMA;\n'
        'II - à pesca exercida por pescadores profissionais ARTESANAIS e '
        'AMADORES, embarcada e desembarcada, por meio de ANZOL SIMPLES '
        'com os seguintes petrechos: linha de mão, caniço simples ou com '
        'molinete/carretilha, e vara com linha, com iscas artificiais ou '
        'naturais providas ou não de garatéia, que não utilizem o sistema '
        'de lambadas. A atividade condiciona-se à limitação de apenas UM '
        'dos petrechos por pescador.\n'
        '§ 2º Aparelhos, petrechos e métodos não mencionados na norma são '
        'considerados de uso proibido.\n\n'
        'ONDE NÃO PODE NADA (art. 5º)\n'
        'A pesca de qualquer categoria, modalidade e petrecho fica vedada '
        'durante o defeso nestas áreas das bacias de RS e SC:\n'
        'I - lagoas marginais;\n'
        'II - até 1.500 m a montante e a jusante das barragens de '
        'reservatórios de usinas hidrelétricas, cachoeiras e '
        'corredeiras.\n'
        'Parágrafo único: as exclusões do § 1º do art. 4º NÃO se estendem '
        'à pesca nas áreas deste artigo.\n\n'
        'ONDE A NORMA NÃO SE APLICA (art. 3º)\n'
        'I - bacia hidrográfica do rio Uruguai, por ter norma '
        'específica;\n'
        'II - os 2.000 m entre a barra do rio Mampituba e a baliza de '
        'Figueirinha, em Torres/RS, onde vale a Portaria SUDEPE nº N-006, '
        'de 30 de junho de 1984;\n'
        'III - Lagoa do Peixe (Tavares/RS), por estar em Parque '
        'Nacional;\n'
        'IV - lagoa dos Patos, da latitude 30º55\' até a latitude 32º10\', '
        'no Rio Grande do Sul, onde vale a IN Conjunta MMA/SEAP nº 3, de '
        '9 de fevereiro de 2004;\n'
        'V - lagoas costeiras de Tramandaí, Armazém, Custódia e Manoel '
        'Vicente (Tramandaí/RS), onde vale a IN nº 17, de 17 de outubro '
        'de 2004; e\n'
        'VI - às LAGOAS COSTEIRAS E BAÍAS DO ESTADO DE SANTA CATARINA, '
        'por tratar-se de ambientes estuarinos com normatização de pesca '
        'específica.\n\n'
        'COMPETIÇÕES (art. 6º)\n'
        'No período de defeso é proibida a realização de competições de '
        'pesca em águas das bacias hidrográficas de RS e SC.\n\n'
        'QUANTO PODE LEVAR (art. 7º)\n'
        'Limite de captura e transporte de até 5 kg de peixes, por ato de '
        'fiscalização, para pescadores profissionais, amadores e '
        'dispensados de licença na forma do art. 29 do Decreto-lei nº '
        '221/1967, nos termos do art. 4º, § 1º, II.\n'
        'Parágrafo único: para efeito de mensuração, no ato da '
        'fiscalização o pescado deverá estar INTEIRO.\n\n'
        'TRANSPORTE (art. 8º)\n'
        'O produto vindo de local com defeso diferenciado deve estar '
        'acompanhado de comprovação de origem, sob pena de apreensão do '
        'pescado e dos petrechos, equipamentos e instrumentos usados na '
        'pesca. O art. 2º define a comprovação: nota de produtor, para o '
        'profissional; guia de transporte do órgão estadual, para o '
        'amador; pescado lacrado com certificação sanitária, para a '
        'indústria; e Licença de Importação de Produto Animal do MAPA '
        'mais certificação sanitária, para o produto de outro país.\n\n'
        'PISCICULTURA E PESQUE-PAGUE (art. 9º)\n'
        'Transporte, comercialização, beneficiamento, industrialização e '
        'armazenamento só são permitidos se originários de '
        'empreendimentos devidamente registrados no órgão competente e '
        'acompanhados de nota fiscal.\n\n'
        'ESTOQUE (art. 10)\n'
        'Pescadores profissionais, frigoríficos, peixarias, entrepostos, '
        'postos de venda, hotéis, restaurantes, bares e similares devem '
        'entregar ao IBAMA a declaração dos estoques em até cinco dias '
        'úteis após a publicação da norma, em duas vias, para '
        'autenticação.\n\n'
        'SANÇÃO (art. 11)\n'
        'Penalidades da Lei nº 9.605, de 1998, e do Decreto nº 6.514, de '
        '2008.\n\n'
        'PUBLICAÇÃO\n'
        'DOU nº 192, de 3 de outubro de 2008, seção 1, página 92. Assinou '
        'Roberto Messias Franco, Presidente do IBAMA.',
  ),

  // ----------------------------- piracema: bacia do rio Paraná
  Defeso(
    titulo: 'Piracema — bacia do rio Paraná',
    cientificos: [],
    periodo: '1º de novembro a 28 de fevereiro',
    abrangencia: 'Bacia hidrográfica do rio Paraná. A norma delimita a '
        'área pela BACIA e não nomeia estados — não cita Santa Catarina '
        'em nenhum artigo. Ver a ressalva.',
    norma: 'IN IBAMA nº 25, de 1º de setembro de 2009',
    origem: Origem.conferida,
    ressalva: 'ESTA NORMA NÃO CITA SANTA CATARINA EM NENHUM ARTIGO. Ela '
        'define a área pela bacia hidrográfica do rio Paraná, e os '
        'trechos nomeados no art. 3º ficam em Minas Gerais, São Paulo, '
        'Goiás, Mato Grosso do Sul e Paraná. O aplicativo a mantém porque '
        'a delimitação é por bacia, não por estado. Para saber se um '
        'corpo d\'água catarinense está dentro da bacia do rio Paraná, '
        'consulte a norma e a delimitação de bacias nos sites oficiais.\n\n'
        'Repare também no art. 10, parágrafo único: normas estaduais ou '
        'regionais sobre petrechos, tamanhos, cotas, períodos e locais '
        'devem ser respeitadas DESDE QUE MAIS RESTRITIVAS.',
    detalhe: 'O DEFESO (art. 1º)\n'
        'Normas de pesca para o período de proteção à reprodução natural '
        'dos peixes, anualmente, de 1º de novembro a 28 de fevereiro, na '
        'bacia hidrográfica do rio Paraná.\n\n'
        'ESPÉCIES NATIVAS (art. 2º)\n'
        'Proibidos a captura, o transporte e o armazenamento de espécies '
        'nativas da bacia do rio Paraná, INCLUSIVE as usadas para fins '
        'ornamentais e de aquariofilia.\n'
        '§ 1º Espécie nativa é a de origem e ocorrência natural da bacia '
        'em questão.\n'
        '§ 2º Não se aplica à manutenção de espécies para aquariofilia em '
        'residências, sem finalidade comercial, nem a aquários públicos '
        'de exposição registrados no IBAMA como zoológicos e criadouros '
        'científicos.\n\n'
        'ONDE NÃO PODE, PARA TODAS AS CATEGORIAS (art. 3º)\n'
        'I - nas lagoas marginais;\n'
        'II - a menos de 500 m de confluências e desembocaduras de rios, '
        'lagoas, canais e tubulações de esgoto;\n'
        'III - até 1.500 m a montante e a jusante das barragens de '
        'reservatórios de empreendimento hidrelétrico e de mecanismos de '
        'transposição de peixes;\n'
        'IV - até 1.500 m a montante e a jusante de cachoeiras e '
        'corredeiras;\n'
        'V a XV - trechos nomeados nos rios Grande, Paranaíba, '
        'Mogi-Guaçu, Pardo, Paranapanema, Tietê, Bela Vista e outros, em '
        'MG, SP, GO, MS e PR, além do Parque da Piracema da UHE Itaipu;\n'
        'XVI - nos corpos d\'água de domínio dos estados em que a '
        'legislação estadual específica assim determinar;\n'
        'XVII - com o uso de aparelhos, petrechos e métodos não '
        'mencionados nesta norma;\n'
        'XVIII - nos entornos de unidades de conservação listadas, sendo '
        'o entorno o raio de 10 km ou a área definida no Plano de Manejo '
        '(§ 2º).\n\n'
        'COMPETIÇÕES (art. 4º)\n'
        'Proibidas competições de pesca — torneios, campeonatos, '
        'gincanas.\n'
        '§ 1º Não alcança competições em reservatórios que visem a '
        'captura de espécies NÃO NATIVAS (alóctones e exóticas) e '
        'híbridos.\n\n'
        'PESCA COMERCIAL NOS RESERVATÓRIOS (art. 5º)\n'
        'I - rede de emalhar de malha igual ou superior a 80 mm, com no '
        'máximo 350 m de comprimento, instaladas a pelo menos 150 m uma '
        'da outra, com plaqueta de identificação do pescador;\n'
        'II - tarrafa com malha igual ou superior a 70 mm;\n'
        'III - duas redes para captura de isca por pescador, até 2,5 m de '
        'altura e 30 m de comprimento, malha entre 15 mm e 30 mm, '
        'identificadas;\n'
        'IV - linha de mão, caniço simples, caniço com molinete ou '
        'carretilha, isca natural ou artificial com ou sem garatéia, nas '
        'modalidades arremesso e corrico;\n'
        'V - espinhel de fundo, no máximo 100 anzóis cada, instalados a '
        'pelo menos 150 m um do outro, identificados; e\n'
        'VI - linhão de fundo ou caçador.\n'
        'Parágrafo único: permitida a emenda de redes, mesmo com malhas '
        'diferentes, desde que permitidas e sem ultrapassar o comprimento '
        'máximo.\n\n'
        'COMO SE MEDE A MALHA (art. 6º)\n'
        'A distância tomada entre nós opostos da malha esticada.\n\n'
        'PESCA AMADORA (art. 7º)\n'
        'I - linha de mão, caniço simples, caniço com molinete ou '
        'carretilha, isca natural ou artificial com ou sem garatéia, nas '
        'modalidades arremesso e corrico; e\n'
        'II - arbalete ou espingarda de mergulho na pesca subaquática, '
        'APENAS para a captura de espécies exóticas e alóctones, vedado o '
        'uso de aparelhos de respiração e iluminação artificial.\n\n'
        'O RESTO É PROIBIDO (art. 8º)\n'
        'São de uso proibido os aparelhos, petrechos e métodos não '
        'mencionados nesta Instrução Normativa.\n\n'
        'TAMANHOS MÍNIMOS (art. 9º e Anexo)\n'
        'Proibidos a captura, o transporte, o armazenamento e a '
        'comercialização de indivíduos com comprimento total inferior a:\n'
        'papaterra, cará (Satenoperca pappaterra) 16 cm; tuvira, sarapó, '
        'morenita (Gymnotus carapo) 20 cm; traíra (Hoplias malabaricus) '
        '25 cm; cascudo-abacaxi (Megalancistrus aculeatus) 25 cm; mandi, '
        'mandi-amarelo (Pimelodus maculatus) 25 cm; cascudo-preto '
        '(Rinelepis aspera) 25 cm; piau-catingudo, piava (Schizodon '
        'borelli) 25 cm; taguara, timboré (Schizodon nasutus) 25 cm; '
        'acari, cascudo (Hypostomus spp.) 30 cm; cascudo-pantaneiro '
        '(Liposarcus anisitisi) 30 cm; curimbatá pioa (Prochilodus '
        'affinis) 30 cm; bagre-sapo (Pseudopimelodus zungaro) 30 cm; '
        'curimatá, curimbatá, papa-terra (Prochilodus lineatus) 38 cm; '
        'piapara, piau-verdadeiro, piavuçu (Leporinus aff. obtusidens e '
        'elongatus) 40 cm; armado, armal, abotoado (Pterodoras '
        'granulosus) 40 cm; pacu-caranha, pacu (Piaractus mesopotamicus) '
        '45 cm; barbado, mandi-alumínio (Pinirampus pirinampu) 50 cm; '
        'dourado (Salminus brasiliensis) 60 cm; surubim, cachara '
        '(Pseudoplatystoma fasciatum) 70 cm; surubim, pintado '
        '(Pseudoplatystoma corruscans) 90 cm; jaú (Zungaro zungaro) 90 '
        'cm.\n'
        'O Anexo lista ainda piau, piau-três-pintas (Leporinus friderici), '
        'cujo tamanho não saiu legível na cópia consultada — confira esse '
        'valor no texto oficial.\n'
        'Parágrafo único: comprimento total é a distância entre a ponta '
        'do focinho e a extremidade da nadadeira caudal.\n\n'
        'NORMA ESTADUAL MAIS RESTRITIVA PREVALECE (art. 10, parágrafo '
        'único)\n'
        'Normas de órgãos regionais ou estaduais sobre petrechos, '
        'tamanhos mínimos e máximos, cotas por pescador, períodos e '
        'locais permitidos DEVEM SER RESPEITADAS desde que mais '
        'restritivas.\n\n'
        'VIGÊNCIA E REVOGAÇÕES (arts. 11, 12 e 17)\n'
        'Entrou em vigor três meses após a publicação. Revogou a IN nº '
        '30, de 13 de setembro de 2005; e, pela retificação publicada na '
        'mesma edição, revogou também a IN nº 194, de 2 de outubro de '
        '2008.\n\n'
        'PUBLICAÇÃO\n'
        'DOU nº 168, de 2 de setembro de 2009, seção 1, página 88. '
        'Assinou Roberto Messias Franco, Presidente do IBAMA.',
  ),

  // ------------------------------- camarões na Baía da Babitonga (SC)
  Defeso(
    titulo: 'Camarões na Baía da Babitonga',
    cientificos: [
      'Litopenaeus schmitti',
      'Penaeus schmitti',
      'Farfantepenaeus paulensis',
      'Penaeus paulensis',
    ],
    periodo: '1º de novembro a 31 de janeiro',
    abrangencia: 'Somente o INTERIOR da Baía da Babitonga, em Santa Catarina. Fora dela, quem manda é outra norma.',
    norma: 'Portaria IBAMA nº 70, de 30 de outubro de 2003',
    origem: Origem.conferida,
    ressalva: 'SÃO TRÊS DEFESOS DE CAMARÃO DIFERENTES EM SANTA CATARINA, e '
        'um não vale pelo outro:\n'
        '· o interior da Baía da Babitonga, por esta Portaria — 1º de '
        'novembro a 31 de janeiro;\n'
        '· o Complexo Lagunar Sul, pela Portaria Interministerial MPA/MMA '
        'nº 65/2026 — permitido de 16 de novembro a 14 de julho;\n'
        '· o mar aberto, pela Portaria SAP/MAPA nº 656/2022.\n'
        'Antes de aplicar, veja em qual dos três a embarcação está.\n\n'
        'VIGÊNCIA: a página oficial de defesos marinhos do IBAMA, '
        'atualizada em 21 de janeiro de 2026, traz esta Portaria como a '
        'norma da Baía da Babitonga, com o mesmo período de 1º de novembro '
        'a 31 de janeiro, e disponibiliza o texto dela.',
    detalhe: 'DEFESO (art. 1º)\n'
        'Proibida, anualmente, de 1º de novembro a 31 de janeiro, a pesca '
        'de camarão-branco (Litopenaeus schmitti) e camarão-rosa '
        '(Farfantepenaeus paulensis) no interior da Baía da Babitonga, no '
        'Estado de Santa Catarina.\n'
        'Parágrafo único: tolera-se o desembarque dessas espécies até o '
        'TERCEIRO DIA ÚTIL após o início do defeso.\n\n'
        'DECLARAÇÃO DE ESTOQUE (art. 2º)\n'
        'Quem captura, conserva, beneficia ou comercializa essas espécies '
        'deve entregar ao IBAMA, até o SEXTO DIA ÚTIL a partir do início '
        'do defeso, a relação detalhada dos produtos estocados, indicando '
        'os locais de armazenamento.\n\n'
        'PRODUTO DE FORA (art. 3º)\n'
        'Vedados o transporte interestadual, a estocagem, o beneficiamento '
        'e a comercialização de camarão vindo de áreas NÃO abrangidas por '
        'este defeso sem comprovação da origem.\n'
        '§ 1º A comprovação é a Guia de Transporte mais a Nota Fiscal, que '
        'devem acompanhar o produto da origem até o destino final.\n'
        '§ 2º A Guia é obtida na unidade do IBAMA mais próxima. Ela vale '
        'só até o 2º dia após a assinatura, e só para o transporte até o '
        'destino.\n\n'
        'SANÇÃO (art. 4º)\n'
        'Penalidades da Lei nº 9.605, de 12 de fevereiro de 1998, e do '
        'Decreto nº 3.179, de 21 de setembro de 1999.\n\n'
        'REVOGAÇÃO (art. 6º)\n'
        'Revogou a Portaria IBAMA nº 134/02-N, de 11 de outubro de 2002.\n\n'
        'PUBLICAÇÃO\n'
        'DOU de 3 de novembro de 2003, edição nº 213. Assinou Marcus Luiz '
        'Barroso Barros, Presidente do IBAMA.',
  ),
  Defeso(
    titulo: 'Bagre rosado',
    cientificos: ['Genidens genidens', 'Genidens barbus'],
    periodo: '1º de janeiro a 31 de março',
    abrangencia: 'Rio Grande do Sul, Santa Catarina, Paraná e São Paulo (art. 1º). E mais: durante esse mesmo prazo, o transporte, o desembarque, a retenção e a comercialização do bagre-branco ficam proibidos em TODO o território nacional, pelo art. 2º, § 6º da Portaria Interministerial nº 39/2018.',
    norma: 'Portaria SUDEPE nº N-42, de 18 de outubro de 1984',
    origem: Origem.conferida,
    ressalva: 'ESTA NORMA DE 1984 SEGUE EM VIGOR, e não por presunção. O '
        'art. 2º, § 5º da Portaria Interministerial nº 39, de 26 de julho '
        'de 2018, determina que a captura do bagre-branco "respeitará as '
        'restrições estabelecidas pela Portaria nº N-42, de 18 de outubro '
        'de 1984, da Superintendência do Desenvolvimento da Pesca". Uma '
        'norma de 2018, assinada por dois ministros, manda cumprir a de '
        '1984.\n\n'
        'QUAIS PEIXES. A portaria de 1984 escreve "bagre rosado (Genidens '
        'genidens, Netuma barba ou Tachysurus barbus, T. upsulonophorus e '
        'T. agassisi)". Netuma barba e Tachysurus barbus são nomes antigos '
        'do Genidens barbus, o bagre-branco — e é por isso que a Portaria '
        '39/2018 remete a esta. A Instrução Normativa Interministerial '
        'MPA/MMA nº 10/2011, ao listar as espécies de cada modalidade, '
        'também escreve "Bagre rosado (Genidens genidens, Genidens '
        'barbus)".\n\n'
        'Os outros dois nomes de 1984 — T. upsulonophorus e T. agassisi — '
        'o aplicativo NÃO conseguiu corresponder a nomes atuais com '
        'segurança, e por isso não os afirma. Diante de outro bagre da '
        'região entre 1º de janeiro e 31 de março, consulte o texto da '
        'portaria.',
    detalhe: 'DEFESO (art. 1º)\n'
        'Proibida, anualmente, no período de 1º de janeiro a 31 de março, '
        'a captura do bagre rosado nas águas que banham os Estados do Rio '
        'Grande do Sul, Santa Catarina, Paraná e São Paulo.\n\n'
        'TAMANHO MÍNIMO (art. 2º)\n'
        '30 cm de comprimento total, no período permitido à pesca.\n'
        '§ 1º Comprimento total é a distância entre a ponta do focinho e a '
        'extremidade posterior da nadadeira caudal.\n'
        '§ 2º Admite-se tolerância de 10% sobre o PESO TOTAL dos '
        'indivíduos capturados com dimensão inferior à estabelecida — '
        'tolerância sobre o peso, não sobre a medida de cada peixe.\n\n'
        'ATENÇÃO AO NÚMERO. Para o bagre-branco (Genidens barbus) existem '
        'hoje três medidas em normas diferentes: 30 cm aqui, 40 cm na IN '
        'MMA nº 53/2005 e 45 cm no art. 2º, § 1º, I da Portaria '
        'Interministerial nº 39/2018. O aplicativo não escolhe por conta '
        'própria — veja o ponto "Onde a IN 53 e o Plano de Recuperação dão '
        'números diferentes".\n\n'
        'DECLARAÇÃO DE ESTOQUE (art. 3º)\n'
        'As pessoas jurídicas estabelecidas no RS, em SC, no PR e em SP '
        'que industrializam o rosado devem, anualmente, até 31 de '
        'dezembro, informar seus estoques aos Coordenadores Regionais da '
        'SUDEPE. A SUDEPE não existe mais; a quem essa declaração deve ser '
        'feita hoje, o aplicativo não afirma.\n\n'
        'SANÇÃO (art. 4º)\n'
        'Penalidades do Decreto-Lei nº 221, de 28 de fevereiro de 1967, e '
        'demais legislação complementar.\n\n'
        'REVOGAÇÃO (art. 5º)\n'
        'Revogou a Portaria nº N-27, de 28 de julho de 1983.\n\n'
        'PUBLICAÇÃO\n'
        'DOU de 23 de outubro de 1984. Assinou José Ubirajara Coelho de '
        'Souza Timm, Superintendente.',
  ),
  Defeso(
    titulo: 'Sardinha-verdadeira',
    cientificos: ['Sardinella brasiliensis'],
    periodo: '1º de outubro a 28 de fevereiro',
    abrangencia: 'Entre os paralelos 22 graus Sul (Cabo de São Tomé, RJ) '
        'e 28 graus e 36 minutos Sul (Cabo de Santa Marta, SC). ATENÇÃO: '
        'o limite sul fica dentro de Santa Catarina, na altura de Laguna '
        '— do Cabo de Santa Marta para o sul, este defeso não alcança.',
    norma: 'IN SAP/MAPA nº 18, de 10 de junho de 2020, que deu nova '
        'redação aos arts. 4º e 5º da IN IBAMA nº 15, de 21 de maio '
        'de 2009',
    origem: Origem.conferida,
    ressalva: 'O art. 2º da IN 18/2020 previa que o período fosse '
        'avaliado em junho de 2021 por um Comitê Científico coordenado '
        'pela SAP/MAPA. Não se obteve o resultado dessa avaliação.',
    detalhe: 'DEFESO (art. 4º, na redação de 2020)\n'
        'Proibida, anualmente, a captura da sardinha-verdadeira '
        '(Sardinella brasiliensis) na área compreendida entre os '
        'paralelos 22 graus Sul (Cabo de São Tomé, Rio de Janeiro) e 28 '
        'graus e 36 minutos Sul (Cabo de Santa Marta, Santa Catarina), '
        'de 1º de outubro a 28 de fevereiro.\n'
        'Parágrafo único: o desembarque só é permitido até o dia 3 de '
        'outubro de cada ano.\n\n'
        'DECLARAÇÃO DE ESTOQUE (art. 5º, na redação de 2020)\n'
        'Quem transporta, armazena, comercializa, beneficia ou '
        'industrializa deve declarar os estoques in natura existentes, '
        'congelados ou não, no dia 3 de outubro de cada ano.\n'
        '§ 1º A declaração é entregue até 9 de outubro nas '
        'Superintendências Federais de Agricultura do estado, ou em '
        'sistema eletrônico da SAP/MAPA.\n'
        '§ 2º A declaração deve acompanhar o produto até o destino '
        'final.\n\n'
        'AMOSTRAGEM (art. 3º da IN 18/2020)\n'
        'As empresas sob Serviço de Inspeção Federal que comprarem '
        'direto de produtores nacionais preenchem os Anexos II e III. O '
        'Anexo II é aplicado no desembarque, para toda embarcação de '
        'cerco/traineira que tenha a sardinha como espécie-alvo. Para o '
        'Anexo III, uma amostra de 250 a 300 indivíduos é medida e pesada '
        'semanalmente, e 60 deles congelados para recolhimento.',
  ),
  Defeso(
    titulo: 'Sardinha-verdadeira para isca-viva',
    cientificos: ['Sardinella brasiliensis'],
    periodo: '15 de junho a 31 de julho',
    abrangencia: 'Embarcações permissionadas para a captura de atuns e '
        'afins pelo sistema de vara e anzol com isca-viva. A permissão do '
        'art. 1º vale entre os paralelos 22 graus Sul (Cabo de São Tomé, '
        'RJ) e 28 graus e 36 minutos Sul (Cabo de Santa Marta, SC).',
    norma: 'IN IBAMA nº 16, de 21 de maio de 2009',
    origem: Origem.conferida,
    detalhe: 'A EXCEÇÃO (art. 1º)\n'
        'É permitida a captura de sardinha-verdadeira com comprimento '
        'total INFERIOR a 17 cm, exclusivamente às embarcações '
        'permissionadas para atuns e afins pelo sistema de vara e anzol '
        'com isca-viva, para uso próprio e unicamente como isca-viva, na '
        'área entre 22 graus Sul (Cabo de São Tomé, RJ) e 28 graus e 36 '
        'minutos Sul (Cabo de Santa Marta, SC).\n'
        '§ 1º Ainda assim, é proibido capturar exemplares com menos de '
        '5 cm de comprimento total.\n'
        '§ 2º Comprimento total é a medida entre a ponta do focinho e a '
        'extremidade da nadadeira caudal.\n\n'
        'O PERÍODO FECHADO (art. 2º)\n'
        'Proibidos, anualmente, de 15 de junho a 31 de julho, a captura, '
        'a estocagem em qualquer área, o armazenamento, o transporte em '
        'tinas e a comercialização da sardinha-verdadeira por essas '
        'embarcações.\n'
        'Parágrafo único: tolera-se no máximo 8% de sardinha-verdadeira, '
        'em número, em relação à captura total de espécies alternativas '
        'usadas como isca-viva e estocadas em tinas, por embarcação, no '
        'ato da fiscalização.\n\n'
        'PARA QUEM NÃO É DA FROTA DE VARA E ISCA-VIVA (art. 3º)\n'
        'Proibidos, em qualquer época e em qualquer área, a captura, a '
        'estocagem, o armazenamento, o transporte em tinas e a '
        'comercialização de sardinha-verdadeira ABAIXO DE 17 CM por '
        'qualquer embarcação não permissionada nos termos do art. 1º.\n'
        '§ 1º Acima de 17 cm, para uso como isca-viva por outras '
        'modalidades, só fora dos períodos de defeso e se adquirida de '
        'embarcações legalmente permissionadas.',
  ),
  Defeso(
    titulo: 'Garoupa-verdadeira',
    cientificos: ['Epinephelus marginatus'],
    periodo: '1º de novembro a 28 de fevereiro',
    abrangencia: 'Águas jurisdicionais brasileiras. Alcança Santa Catarina.',
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
    abrangencia: 'Litoral Sudeste e Sul. Alcança Santa Catarina.',
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
        '1º a 31 de dezembro (somente fêmeas)',
    abrangencia: 'Espírito Santo, Rio de Janeiro, São Paulo, Paraná e '
        'Santa Catarina.',
    norma: 'Portaria IBAMA nº 52, de 30 de setembro de 2003',
    origem: Origem.conferida,
    ressalva: 'Existe uma Portaria Interministerial MPA/MMA nº 45, de 12 '
        'de janeiro de 2026, também sobre o caranguejo-uçá, e ela NÃO '
        'substituiu esta. As duas convivem porque tratam de regiões '
        'diferentes: a de 2026 vale para o Amapá, o Pará, o Maranhão, o '
        'Piauí, o Ceará, o Rio Grande do Norte, a Paraíba, Pernambuco, '
        'Alagoas, Sergipe e a Bahia, e fixa o defeso da "andada" em '
        'janelas curtas de cinco ou seis dias. Não alcança Santa '
        'Catarina.\n\n'
        'Confirmado em 29/08/2026 na notícia do Ministério da Pesca e '
        'Aquicultura sobre a publicação da Portaria 45/2026. A tabela de '
        'defesos do MPA trazia "RJ, SP, PR e Santa Catarina" na linha '
        'dela — leitura errada da tabela, cujas colunas se embaralham.\n\n'
        'Em Santa Catarina, quem vale é esta Portaria de 2003.\n\n'
        'CONFIRMADO NA FONTE OFICIAL: a página de defesos marinhos do '
        'IBAMA, atualizada em 21 de janeiro de 2026, traz as duas normas '
        'lado a lado — a Portaria MPA/MMA nº 45/2026 para os estados do '
        'Norte e do Nordeste, em janelas de cinco ou seis dias, e ESTA '
        'Portaria IBAMA nº 52/2003 para o Espírito Santo, o Rio de '
        'Janeiro, São Paulo, o Paraná e Santa Catarina, com os períodos de '
        '1º de outubro a 30 de novembro e de 1º a 31 de dezembro.\n\n'
        'A mesma página mostra que esse regime do Norte e do Nordeste vem '
        'se renovando ano a ano em portaria própria — a de 2026 sucedeu a '
        'Portaria Interministerial MPA/MMA nº 22, de 30 de dezembro de '
        '2024, que por sua vez revogou a nº 325/2020. Nenhuma delas tocou '
        'na Portaria de 2003.',
    detalhe: 'DEFESO (art. 1º)\n'
        'Proibidos, anualmente, a captura, a manutenção em cativeiro, o '
        'transporte, o beneficiamento, a industrialização, o '
        'armazenamento e a comercialização do caranguejo-uçá (Ucides '
        'cordatus), também conhecido por caranguejo-do-mangue, '
        'caranguejo-verdadeiro ou catanhão, no Espírito Santo, Rio de '
        'Janeiro, São Paulo, Paraná e Santa Catarina:\n'
        'I - de 1º de outubro a 30 de novembro: todos os indivíduos, '
        'machos e fêmeas.\n'
        'II - de 1º a 31 de dezembro: somente as fêmeas.\n'
        '§ 1º Manutenção em cativeiro é o confinamento artificial de '
        'caranguejos vivos em qualquer ambiente.\n'
        '§ 2º Quem captura, conserva, beneficia, industrializa, armazena '
        'ou comercializa deve entregar ao IBAMA, até o 5º dia útil de '
        'outubro, a relação detalhada dos produtos estocados congelados '
        'ou pré-cozidos, indicando os locais de armazenamento.\n\n'
        'O QUE VALE O ANO INTEIRO (art. 4º)\n'
        'Proibidos, em qualquer época, em toda a região Sudeste e Sul, a '
        'captura, a coleta, o transporte, o beneficiamento, a '
        'industrialização, o armazenamento e a comercialização de:\n'
        'I - fêmeas ovadas;\n'
        'II - indivíduos com largura de carapaça inferior a 6,0 cm;\n'
        'III - partes isoladas (quelas, pinças ou garras).\n'
        'Parágrafo único: a largura de carapaça é medida sobre o dorso, '
        'na maior distância de uma margem lateral à outra.\n\n'
        'PETRECHOS (art. 5º)\n'
        'Proibidos, o ano inteiro, armadilhas, petrechos ou instrumentos '
        'cortantes e produtos químicos. Excetuam-se o "chuncho" — '
        'instrumento de madeira em forma de clave, afilado na ponta, que '
        'alarga as tocas — e o "gancho", haste com a ponta em ângulo que '
        'prolonga o braço do catador.\n\n'
        'TRANSPORTE ENTRE ESTADOS (art. 3º)\n'
        'Vedados o transporte interestadual e a comercialização sem '
        'comprovação de origem, por guia obtida junto ao IBAMA, que deve '
        'acompanhar o produto da origem ao destino final.\n\n'
        'REGRA LOCAL MAIS RESTRITIVA (art. 2º)\n'
        'Os gerentes executivos estaduais do IBAMA das regiões Sudeste e '
        'Sul podem, em portaria específica, estabelecer adequações MAIS '
        'restritivas, como a suspensão da captura nos dias de "andada" — '
        'o período reprodutivo em que os caranguejos saem das galerias e '
        'andam pelo manguezal.\n\n'
        'APREENSÃO (art. 6º)\n'
        'O produto apreendido, quando vivo, deve ser devolvido ao '
        'manguezal, preferencialmente ao local da captura, observado o '
        'Decreto nº 3.179, de 21 de setembro de 1999.\n\n'
        'SANÇÃO (art. 7º)\n'
        'Penalidades da Lei nº 9.605, de fevereiro de 1998, e do Decreto '
        'nº 3.179/99.\n\n'
        'REVOGAÇÃO (art. 8º)\n'
        'Revogou a Portaria IBAMA nº 124, de 25 de setembro de 2002.\n\n'
        'DE ONDE ELA SAIU\n'
        'Dos considerandos: o Decreto-Lei nº 221, de 28 de fevereiro de '
        '1967, e as recomendações da 4ª Reunião de Avaliação e Ordenamento '
        'do Caranguejo-Uçá das Regiões Sudeste e Sul do Brasil.\n\n'
        'PUBLICAÇÃO\n'
        'DOU de 2 de outubro de 2003, edição nº 191. Assinou Marcus Luiz '
        'Barroso Barros, Presidente do IBAMA.',
  ),
  Defeso(
    titulo: 'Lagostas',
    cientificos: [
      'Panulirus argus',
      'Panulirus laevicauda',
      'Panulirus echinatus',
    ],
    periodo: 'Pesca permitida de 1º de maio a 31 de outubro',
    abrangencia: 'NÃO ALCANÇA SANTA CATARINA. O art. 4º permite a pesca '
        'desde a fronteira da Guiana Francesa com o Amapá até a divisa do '
        'Espírito Santo com o Rio de Janeiro. A norma para no ES: em '
        'Santa Catarina ela não se aplica.',
    norma: 'Portaria SAP/MAPA nº 221, de 8 de junho de 2021',
    origem: Origem.conferida,
    ressalva: 'Esta entrada fica no aplicativo para registrar por que a '
        'lagosta NÃO aparece no calendário de Santa Catarina. O '
        'levantamento da UNIVALI indicava um defeso de 1º de novembro a '
        '30 de abril, e as datas batem com o art. 8º — mas a área da '
        'norma termina na divisa ES/RJ. Se houver norma de lagosta que '
        'alcance Santa Catarina, ela ainda não foi localizada.',
    detalhe: 'ONDE VALE (art. 4º)\n'
        'Permitida a pesca da lagosta vermelha (Panulirus argus), verde '
        '(Panulirus laevicauda) e pintada (Panulirus echinatus) desde a '
        'fronteira da Guiana Francesa com o Amapá até a divisa do '
        'Espírito Santo com o Rio de Janeiro. Parágrafo único: proibida a '
        'menos de 4 milhas náuticas da costa em parte dessa área.\n\n'
        'TEMPORADA (art. 8º)\n'
        'Pesca permitida das 00:00 de 1º de maio às 23h59 de 31 de '
        'outubro. O desembarque deve ocorrer até as 23h59 de 31 de '
        'outubro.\n\n'
        'PETRECHOS (arts. 5º e 6º)\n'
        'Somente armadilhas do tipo covo ou manzuá e cangalha, com malha '
        'quadrada de no mínimo 5 cm entre nós consecutivos, tolerância de '
        '2,5 cm. Proibidos rede de emalhe do tipo caçoeira e marambaia, '
        'entre outros.\n\n'
        'ESFORÇO (art. 3º)\n'
        'Proibido o aumento do esforço de pesca: sem novas Autorizações '
        'de Pesca para embarcações nas modalidades que capturam lagosta, '
        'e sem incremento na quantidade de armadilhas já autorizada.',
  ),
  Defeso(
    titulo: 'Mexilhão ou marisco da pedra',
    cientificos: ['Perna perna'],
    periodo: '1º de setembro a 31 de dezembro',
    abrangencia: 'Espírito Santo, Rio de Janeiro, São Paulo, Paraná, '
        'Santa Catarina e Rio Grande do Sul. ATENÇÃO: o defeso alcança '
        'apenas o mexilhão de ESTOQUE NATURAL. O de cultivo segue '
        'permitido, mediante nota fiscal e comprovação de origem.',
    norma: 'IN IBAMA nº 105, de 20 de julho de 2006',
    origem: Origem.conferida,
    detalhe: 'DEFESO (art. 3º)\n'
        'Proibidos, anualmente, de 1º de setembro a 31 de dezembro, a '
        'extração, o abastecimento dos cultivos, o transporte, o '
        'beneficiamento, a industrialização, o armazenamento e a '
        'comercialização de mexilhão (Perna perna), EM QUALQUER FASE DO '
        'CICLO DE VIDA, proveniente dos ESTOQUES NATURAIS, no Espírito '
        'Santo, Rio de Janeiro, São Paulo, Paraná, Santa Catarina e Rio '
        'Grande do Sul.\n\n'
        'O CULTIVO NÃO PARA (art. 5º)\n'
        'No período do art. 3º, a comercialização, o transporte e o '
        'beneficiamento podem ocorrer mediante apresentação de nota '
        'fiscal e comprovação de que o produto é oriundo de cultivo.\n\n'
        'TAMANHO (arts. 2º e 7º)\n'
        'Semente: indivíduo jovem, entre 2,0 e 3,0 cm de comprimento '
        'total, medido no maior eixo.\n'
        'Adulto: 5,0 cm ou mais de comprimento total, no maior eixo.\n'
        'Art. 7º: proibida a comercialização de mexilhões de estoque '
        'natural com comprimento total igual ou inferior a 5,0 cm. '
        'Parágrafo único: tolerância máxima de 20% em peso do total '
        'comercializado abaixo do mínimo; esse percentual não pode ser '
        'comercializado e, quando vivo, deve voltar ao ambiente '
        'natural.\n\n'
        'QUEM PODE EXTRAIR DO ESTOQUE NATURAL (art. 6º)\n'
        'Apenas pescadores profissionais cadastrados no RGP e pescadores '
        'amadores permissionados, estes observada a cota máxima de norma '
        'específica.\n\n'
        'SEMENTES (arts. 8º e 9º)\n'
        'A extração de sementes no estoque natural é autorizada apenas a '
        'malacocultores licenciados ou signatários de TAC, com uma única '
        'autorização anual por malacocultor e cota máxima de 3% da '
        'produção total declarada no Registro de Aquicultor. As sementes '
        'só podem ser retiradas acima da linha de baixa-mar, em faixas '
        'verticais alternadas de até 50 cm — ao retirar uma faixa, outra '
        'de igual tamanho deve ser preservada. O art. 9º proíbe a '
        'comercialização de sementes de estoque natural; a de coletores '
        'artificiais ou raspagem das estruturas de cultivo é permitida '
        'com comprovação de origem.\n\n'
        'DECLARAÇÃO DE ESTOQUE (art. 4º)\n'
        'Entregue às Superintendências do IBAMA até o terceiro dia útil a '
        'partir do início do defeso.',
  ),
  Defeso(
    titulo: 'Lulas',
    cientificos: [
      'Loligo plei',
      'Loligo sanpaulensis',
      'Lolliguncula brevis',
      'Doryteuthis plei',
      'Doryteuthis sanpaulensis',
    ],
    periodo: 'Permitida de 1º de novembro a 31 de março — fora disso, '
        'não pode',
    abrangencia: 'Somente Santa Catarina, para pescadores profissionais '
        'artesanais embarcados ou desembarcados.',
    norma: 'Portaria Interministerial MPA/MMA nº 14, de 1º de novembro '
        'de 2024',
    origem: Origem.conferida,
    ressalva: 'ATENÇÃO AO CRUZAMENTO COM O DEFESO DO CAMARÃO. Entre os '
        'apetrechos permitidos para a lula está o ARRASTO DE FUNDO (art. '
        '4º, I, e modalidades 3.8 e 3.9 do art. 2º). O defeso do camarão '
        'da Portaria SAP/MAPA nº 656/2022 vai de 28 de janeiro a 30 de '
        'abril, e cruza com a janela da lula em fevereiro e março.\n\n'
        'NESSE CRUZAMENTO NÃO PODE ARRASTAR DE FUNDO. Em nota de 23 de '
        'abril de 2026, o IBAMA afirma que "a Portaria MPA/MMA nº 14/2024 '
        'não autoriza o uso de arrasto de fundo durante o defeso do '
        'camarão, devendo a captura de lula ocorrer exclusivamente por '
        'métodos permitidos e de menor impacto ambiental". E a Justiça '
        'Federal em Santa Catarina indeferiu, em 20 de abril de 2026, a '
        'liminar do Estado de Santa Catarina que buscava justamente essa '
        'autorização — Ação Civil Pública nº 5010379-83.2026.4.04.7200/SC, '
        'decisão do Juiz Federal Marcelo Krás Borges.\n\n'
        'Nesse período seguem valendo os outros apetrechos do art. 4º: '
        'arrasto de praia, linha de mão com zangarilho ou garateia, e '
        'tarrafa.',
    detalhe: 'A JANELA (art. 1º)\n'
        'Permitida a pesca de lulas (Loligo plei, Loligo sanpaulensis, '
        'Loligo sp., Lolliguncula brevis) por pescadores profissionais '
        'artesanais, embarcados ou desembarcados, de 1º de novembro a 31 '
        'de março de cada ano, no estado de Santa Catarina.\n\n'
        'QUE EMBARCAÇÃO (art. 2º)\n'
        'Arqueação bruta até 20, E com Autorização de Pesca em uma destas '
        'modalidades da IN MPA/MMA nº 10/2011: 2.2 emalhe de superfície; '
        '2.4 emalhe de fundo; 3.8 e 3.9 arrasto de fundo; 6.7 '
        'diversificada costeira; 6.8, 6.9, 6.10 e 6.11 arrasto de '
        'praia.\n\n'
        'DESEMBARCADO (art. 3º)\n'
        'O pescador artesanal desembarcado deve ter RGP, ou protocolo '
        'registrado junto ao MPA, conforme a Portaria MPA nº 127, de 29 '
        'de agosto de 2023.\n\n'
        'PETRECHOS (art. 4º)\n'
        'I - arrasto de fundo;\n'
        'II - arrasto de praia;\n'
        'III - linhas de mão com iscas artificiais ou naturais, '
        'chamadas zangarilhos, garateias ou outros nomes regionais; e\n'
        'IV - tarrafas com malha mínima de 1,5 cm entre nós opostos.\n'
        'Parágrafo único: nos casos III e IV pode ser usada atração '
        'luminosa instalada na própria isca, em equipamento submerso, '
        'em terra firme ou na embarcação.\n\n'
        'AUTORIZAÇÃO (art. 5º)\n'
        'A captura por pescador profissional artesanal EMBARCADO '
        'independe da emissão imediata de nova Autorização de Pesca.\n\n'
        'NOTA DO PRODUTOR (arts. 6º e 7º)\n'
        'O pescador desembarcado comercializa inserindo o número do RGP '
        'na Nota do Produtor. A embarcação autorizada insere o RGP da '
        'embarcação e o número desta Portaria.\n\n'
        'ALTERAÇÃO DA MATRIZ (art. 8º)\n'
        'Os Anexos II, III e VI da IN MPA/MMA nº 10/2011 passam a vigorar '
        'com as alterações do Anexo I desta Portaria. O aplicativo não tem '
        'o texto desse Anexo I — é mais uma alteração da matriz de '
        'modalidades, ao lado das IN MPA nº 14/2014 e IN MPA/MMA nº '
        '01/2015.\n\n'
        'SANÇÃO (art. 9º)\n'
        'Penalidades da Lei nº 9.605, de 1998, e do Decreto nº 6.514, de '
        '2008.\n\n'
        'PUBLICAÇÃO\n'
        'DOU de 05/11/2024, edição 214, página 46. Assinaram André de '
        'Paula, Ministro da Pesca e Aquicultura, e Marina Silva, Ministra '
        'do Meio Ambiente e Mudança do Clima.',
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
