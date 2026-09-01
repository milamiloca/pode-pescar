import 'periodos.dart' show porExtenso;

// =====================================================================
// ONDE NÃO PODE, EM SANTA CATARINA
//
// As outras telas respondem sobre a ESPÉCIE que está na mão: tamanho,
// defeso, ameaça de extinção. Esta responde sobre o LUGAR e o PETRECHO:
// onde a embarcação está, o que ela está usando, e se aquilo pode.
//
// É a primeira pergunta quando o que está em questão é uma baía, e até
// agora o aplicativo não tinha onde respondê-la. Uma traineira
// arrastando dentro da Baía Sul é infração mesmo que a espécie no porão
// esteja liberada e no tamanho.
//
// A granularidade é a da FISCALIZAÇÃO, não a da norma: cada item é uma
// regra que se confere em campo, com o artigo de onde ela sai. Uma
// portaria com três regras diferentes vira três itens.
//
// Regra de ouro deste arquivo: o que não foi lido no texto da norma
// aparece marcado como tal, e nunca é afirmado como se fosse.
// =====================================================================

/// Até onde a norma alcança.
enum Alcance {
  /// Um ponto certo do litoral catarinense: uma baía, um estuário, uma
  /// barra de rio.
  local,

  /// Todo o Estado de Santa Catarina.
  estado,

  /// As regiões Sudeste e Sul. Santa Catarina está dentro.
  regiao,
}

const nomesDeAlcance = <Alcance, String>{
  Alcance.local: 'Área determinada do litoral catarinense',
  Alcance.estado: 'Todo o Estado de Santa Catarina',
  Alcance.regiao: 'Regiões Sudeste e Sul — Santa Catarina incluída',
};

/// Se o texto da norma foi obtido e lido.
///
/// Não se chama "Fonte" porque tema.dart já tem uma classe Fonte —
/// o rodapé que cita a norma. Dois nomes iguais importados juntos
/// não compilam.
enum TextoDaNorma { lido, aObter }

class Restricao {
  /// O que a regra proíbe, em uma linha, sem rodeio.
  final String titulo;

  /// O lugar exato, nas palavras da norma.
  final String onde;

  /// A proibição.
  final String oQueProibe;

  /// O que escapa da proibição. Vazio quando não há exceção.
  final String excecao;

  final String norma;
  final String artigo;
  final Alcance alcance;
  final TextoDaNorma texto;

  /// Período do ano em que a regra vale, em MMDD. 0 e 0 = o ano inteiro.
  final int de;
  final int ate;

  /// O texto da regra, artigo por artigo.
  final String detalhe;

  /// O que ainda não se sabe, o que conflita, o que precisa de conferência.
  final String ressalva;

  const Restricao({
    required this.titulo,
    required this.onde,
    required this.oQueProibe,
    required this.norma,
    required this.artigo,
    required this.alcance,
    required this.texto,
    required this.detalhe,
    this.excecao = '',
    this.de = 0,
    this.ate = 0,
    this.ressalva = '',
  });

  bool get oAnoInteiro => de == 0 && ate == 0;

  bool get temExcecao => excecao.isNotEmpty;

  /// A regra vale neste dia?
  ///
  /// Uma regra sem período vale sempre. As com período seguem a mesma
  /// conta do calendário, inclusive a virada do ano.
  bool valeEm(DateTime dia) {
    if (oAnoInteiro) return true;
    final d = dia.month * 100 + dia.day;
    return de <= ate ? (d >= de && d <= ate) : (d >= de || d <= ate);
  }

  /// "O ano inteiro" ou "De 1º de maio a 30 de julho".
  String get quando => oAnoInteiro
      ? 'O ano inteiro'
      : 'De ${porExtenso(de)} a ${porExtenso(ate)}';
}

// =====================================================================
// O QUE VALE HOJE
// =====================================================================

/// As regras que valem no dia, na ordem em que aparecem na lista.
List<Restricao> restricoesEm(DateTime dia) =>
    restricoes.where((r) => r.valeEm(dia)).toList();

/// As que só valem em parte do ano — as que precisam ser checadas
/// contra a data, e não decoradas.
List<Restricao> get restricoesSazonais =>
    restricoes.where((r) => !r.oAnoInteiro).toList();

int get quantasRestricoes => restricoes.length;
int get quantasRestricoesLidas =>
    restricoes.where((r) => r.texto == TextoDaNorma.lido).length;

// =====================================================================
// AS REGRAS
// =====================================================================

const restricoes = <Restricao>[
  // -------------------------------------------------------------------
  // baías, lagoas costeiras, canais e estuários — o Estado inteiro
  // -------------------------------------------------------------------
  Restricao(
    titulo: 'Arrasto dentro de baía, lagoa costeira, canal ou barra de rio',
    onde: 'Baías e lagoas costeiras, canais e desembocaduras de rios '
        '(estuários), em todo o Estado de Santa Catarina.',
    oQueProibe: 'A pesca de arrasto, SOB QUALQUER DENOMINAÇÃO. A norma não '
        'distingue modalidade, porte de embarcação nem se há motor.',
    excecao: 'Na Baía da Babitonga, a Portaria IBAMA nº 84, de 15 de julho '
        'de 2002, permite a rede de gerival nas condições do art. 2º dela. '
        'É norma posterior e específica daquela baía.',
    norma: 'Portaria SUDEPE nº N-51, de 26 de outubro de 1983',
    artigo: 'art. 1º',
    alcance: Alcance.estado,
    texto: TextoDaNorma.lido,
    ressalva: 'ATENÇÃO À DATA. Esta portaria é de 26 DE OUTUBRO de 1983, '
        'publicada no Diário Oficial de 28/10/1983 e retificada em '
        '04/11/1983. Circula em compilações a data "18 de novembro de '
        '1983", que não confere com a publicação. Na hora de citar, use a '
        'do texto.\n\n'
        'A SUDEPE foi EXTINTA pela Lei nº 7.735, de 22 de fevereiro de '
        '1989, e substituída pelo IBAMA, criado pela mesma lei. A extinção '
        'do órgão não revoga a portaria.\n\n'
        'SANÇÃO: o art. 3º remete às penalidades do Decreto-Lei nº 221, de '
        '1967. Confira qual é o enquadramento sancionador de hoje — a Lei '
        'nº 9.605, de 1998, e o Decreto nº 6.514, de 2008, são muito '
        'posteriores.',
    detalhe: 'A PROIBIÇÃO (art. 1º)\n'
        'Proibir, no Estado de Santa Catarina, a pesca de arrasto, sob '
        'qualquer denominação, nas seguintes áreas: baías e lagoas '
        'costeiras, canais e desembocaduras de rios (estuários).\n\n'
        'O ENQUADRAMENTO QUE A PRÓPRIA NORMA DÁ (art. 2º)\n'
        'O exercício da pesca em desacordo com o art. 1º constitui DANO À '
        'FAUNA AQUÁTICA DE DOMÍNIO PÚBLICO, nos termos do art. 71 do '
        'Decreto-Lei nº 221, de 28 de fevereiro de 1967.\n\n'
        'AS MEDIDAS QUE A NORMA PREVÊ (art. 3º)\n'
        'Sanções do Decreto-Lei nº 221/1967, especialmente os arts. 6º, '
        '56, 64 e 71:\n'
        'a) apreensão dos equipamentos de pesca e do produto da pescaria, '
        'e medidas tendentes à interdição da embarcação infratora pela '
        'autoridade competente, até o cumprimento das exigências legais;\n'
        'b) cassação temporária das matrículas e licenças.\n'
        '§ 1º A indenização do art. 2º é calculada pela avaliação do dano, '
        'com base no valor venal do produto no mercado local.\n'
        '§ 2º As penalidades aplicadas devem ser comunicadas às Capitanias '
        'dos Portos ou suas agências, com pedido de lançamento na Caderneta '
        'de Inscrição e Registro (CIR) do infrator.\n\n'
        'PRODUTO APREENDIDO (art. 4º)\n'
        'Vai a leilão público. A norma citava a Portaria SUDEPE nº N-8, de '
        '12 de maio de 1980, revogada pela Portaria nº 44-N, de 12 de abril '
        'de 1994.\n\n'
        'DE ONDE SAIU\n'
        'Das recomendações da 4ª reunião do Grupo Permanente de Estudos '
        'sobre Camarões — GPE, em Santos, de 12 a 15 de setembro de 1983.\n\n'
        'REVOGAÇÃO (art. 5º)\n'
        'Revogou as Portarias nº 589, de 06/12/1973, nº 344, de 31/07/1975, '
        'e nº N-2, de 26/02/1976.\n\n'
        'PUBLICAÇÃO\n'
        'DOU de 28/10/1983, retificada em 04/11/1983. Assinou Roberto '
        'Ferreira do Amaral, Superintendente.',
  ),

  // -------------------------------------------------------------------
  // Baía da Babitonga
  // -------------------------------------------------------------------
  Restricao(
    titulo: 'Feiticeira e arrasto na Baía da Babitonga',
    onde: 'Interior da Baía da Babitonga, na região dos municípios de São '
        'Francisco do Sul, Joinville, Araquari, Garuva e Itapoá.',
    oQueProibe: 'Redes do tipo FEITICEIRA e ARRASTO DE QUALQUER NATUREZA.',
    excecao: 'A rede de gerival, nas condições do art. 2º desta mesma '
        'Portaria.',
    norma: 'Portaria IBAMA nº 84, de 15 de julho de 2002',
    artigo: 'art. 1º',
    alcance: Alcance.local,
    texto: TextoDaNorma.lido,
    ressalva: 'Esta portaria e a Portaria SUDEPE nº N-51/1983 tratam da '
        'mesma coisa dentro da Babitonga, e não dizem o mesmo: a de 1983 '
        'proíbe arrasto em toda baía catarinense sem exceção; esta, de '
        '2002, é posterior, é específica daquela baía e abre a exceção do '
        'gerival. Veja o registro de conflitos.',
    detalhe: 'A PROIBIÇÃO (art. 1º)\n'
        'Proibir, no interior da Baía da Babitonga, na região abrangida '
        'pelos municípios de São Francisco do Sul, Joinville, Araquari, '
        'Garuva e Itapoá, no Estado de Santa Catarina, a pesca com o uso '
        'dos seguintes métodos ou petrechos:\n'
        'I - redes tipo feiticeira; e\n'
        'II - arrasto de qualquer natureza, com exceção do uso da rede de '
        'gerival especificada nesta Portaria.\n\n'
        'SANÇÃO (art. 4º)\n'
        'Penalidades do Decreto nº 3.179, de 21 de setembro de 1999.\n\n'
        'REVOGAÇÃO (art. 6º)\n'
        'Revogou a Portaria IBAMA nº 13, de 28 de fevereiro de 2000.\n\n'
        'ASSINATURA\n'
        'Rômulo José Fernandes Barreto Mello, Presidente do IBAMA.',
  ),
  Restricao(
    titulo: 'Gerival e caceio na Babitonga: as condições exatas',
    onde: 'Interior da Baía da Babitonga (São Francisco do Sul, Joinville, '
        'Araquari, Garuva e Itapoá).',
    oQueProibe: 'Usar gerival ou caceio FORA das condições abaixo. Só é '
        'permitido a pescador profissional registrado no órgão competente, '
        'e só para camarão-rosa (Farfantepenaeus paulensis e F. '
        'brasiliensis) e camarão-branco (Litopenaeus schmitti).',
    norma: 'Portaria IBAMA nº 84, de 15 de julho de 2002',
    artigo: 'art. 2º',
    alcance: Alcance.local,
    texto: TextoDaNorma.lido,
    detalhe: 'REDE GERIVAL (art. 2º, I)\n'
        'a) malha mínima de 30,0 mm no corpo do petrecho e 28,0 mm na '
        'carapuça, medida entre nós opostos da malha esticada, com fio de '
        'espessura máxima de 0,30 mm;\n'
        'b) comprimento máximo do tubo expansor: 3,20 m;\n'
        'c) potência máxima do motor da embarcação: 15,0 HP;\n'
        'd) UM petrecho por embarcação, para transporte e uso;\n'
        'e) peso total máximo do gerival: 5,0 kg.\n\n'
        'REDE DE CACEIO (art. 2º, II)\n'
        'a) no máximo 240,0 m de comprimento por 3,0 m de altura, e não é '
        'permitido usá-la em duas partes;\n'
        'b) malha de 50 mm, medida entre nós opostos da malha esticada.\n\n'
        'ONDE O GERIVAL A MOTOR PODE (art. 2º, § 1º)\n'
        'Só na área entre a boca da barra, a leste, e a linha imaginária '
        'que passa pela Ponta do Cândido, pela Ilha Redonda e pela Ilha da '
        'Rita. As coordenadas estão no texto da Portaria — a extração do '
        'PDF as danificou e o aplicativo não as reproduz.\n\n'
        'ONDE NEM ASSIM (art. 2º, § 2º)\n'
        'A permissão do § 1º não vale no interior da Lagoa do Capivaru, até '
        'a linha imaginária entre a Ponta das Galinhas e a Ponta do '
        'Iperoba. O nome da lagoa saiu ilegível na extração; confira no '
        'texto.\n\n'
        'ONDE NEM GERIVAL NEM CACEIO, COM MOTOR OU SEM (art. 2º, § 3º)\n'
        '· no interior dos rios que desembocam na Baía da Babitonga;\n'
        '· a menos de 200 m das zonas de confluência desses rios;\n'
        '· a menos de 100 m do entorno de encostas rochosas, ilhas, '
        'parcéis e áreas de baixios.',
    ressalva: 'DUAS COORDENADAS E UM NOME saíram danificados na extração do '
        'PDF: as do § 1º e o nome da lagoa do § 2º. O aplicativo prefere '
        'dizer que não sabe a chutar. Antes de usar os limites em campo, '
        'leia o art. 2º, §§ 1º e 2º no texto da Portaria.',
  ),
  Restricao(
    titulo: 'Camarão da Babitonga abaixo de 90 mm',
    onde: 'Camarões provenientes da Baía da Babitonga.',
    oQueProibe: 'Capturar, comercializar e industrializar camarão com '
        'menos de 90 mm de comprimento total.',
    excecao: 'Tolerância de 20% sobre o PESO TOTAL — não sobre a medida de '
        'cada camarão.',
    norma: 'Portaria IBAMA nº 84, de 15 de julho de 2002',
    artigo: 'art. 3º',
    alcance: Alcance.local,
    texto: TextoDaNorma.lido,
    detalhe: 'O TAMANHO (art. 3º)\n'
        'Proibida a captura, a comercialização e a industrialização de '
        'camarões provenientes da Baía da Babitonga com tamanho inferior a '
        '90 mm de comprimento total.\n\n'
        'COMO MEDIR (§ 1º)\n'
        'Comprimento total é a distância entre a extremidade do rastro e a '
        'ponta do telso.\n\n'
        'TOLERÂNCIA (§ 2º)\n'
        'Para efeito de fiscalização, tolera-se, em relação ao peso total, '
        'o máximo de 20% de camarão com tamanho inferior ao estabelecido '
        'no caput.',
  ),

  // -------------------------------------------------------------------
  // barra do rio Itapocu — Araquari e Barra Velha
  // -------------------------------------------------------------------
  Restricao(
    titulo: 'Emalhar na boca da barra do rio Itapocu',
    onde: 'Barra do rio Itapocu, nos municípios de Araquari e Barra Velha. '
        'Dois trechos: 500 m ao norte e 500 m ao sul da boca da barra; e '
        '1.000 m da boca para fora, em direção ao oceano, mais 1.000 m a '
        'montante, para dentro do rio.',
    oQueProibe: 'Pesca com redes de emalhar ANCORADAS (fixas) ou '
        'DERIVANTES (caceia).',
    excecao: 'Tarrafa, das 18h às 6h, por pescador profissional habilitado '
        '(§ 1º). E, para robalo, rede de emalhar de dezembro a fevereiro, '
        'em forma de lance com recolhimento para a praia, malha mínima de '
        '180 mm (redes de robalão), nos 500 m de praia ao norte e ao sul '
        'da boca da barra (§ 2º).',
    norma: 'Instrução Normativa MMA nº 20, de 24 de junho de 2005',
    artigo: 'art. 1º',
    alcance: Alcance.local,
    texto: TextoDaNorma.lido,
    detalhe: 'A PROIBIÇÃO (art. 1º)\n'
        'Proibir, na barra do rio Itapocu, nos municípios de Araquari e '
        'Barra Velha, a pesca com redes de emalhar ancoradas (fixas) ou '
        'derivantes (caceia) nos seguintes trechos:\n'
        'I - nos 500 m ao norte e nos 500 m ao sul da boca da barra do rio '
        'Itapocu; e\n'
        'II - nos 1.000 m da boca da barra para fora, em direção ao '
        'oceano, e nos 1.000 m a montante da boca da barra para dentro do '
        'rio Itapocu.\n\n'
        'TARRAFA, SÓ À NOITE (§ 1º)\n'
        'Permitida aos pescadores profissionais devidamente habilitados a '
        'pesca com tarrafas, DAS 18 HORAS ÀS 6 HORAS, na área do caput.\n\n'
        'ROBALO (§ 2º)\n'
        'Permitida a pesca com redes de emalhar para captura de robalos:\n'
        'I - anualmente de dezembro a fevereiro;\n'
        'II - na forma de lance e com recolhimento para a praia;\n'
        'III - com malha mínima de 180 mm (redes de robalão); e\n'
        'IV - nos 500 m da praia, ao norte e ao sul da boca da barra.\n\n'
        'COMO MEDIR A MALHA (§ 3º)\n'
        'Entre ângulos opostos da malha esticada.\n\n'
        'PESQUISA (art. 4º)\n'
        'As proibições não alcançam a pesca de caráter científico '
        'previamente autorizada pelo IBAMA.\n\n'
        'SANÇÃO (art. 5º)\n'
        'Penalidades da Lei nº 9.605, de 12 de fevereiro de 1998, e do '
        'Decreto nº 3.179, de 21 de setembro de 1999.\n\n'
        'PUBLICAÇÃO\n'
        'DOU de 27/06/2005, edição nº 121, página 128. Assinou Marina '
        'Silva, Ministra de Estado do Meio Ambiente.',
  ),
  Restricao(
    titulo: 'Redes nas lagoas da Cruz e da Barra Velha',
    onde: 'Lagoas da Cruz e da Barra Velha, no Estado de Santa Catarina.',
    oQueProibe: 'Pesca com redes DE QUALQUER NATUREZA.',
    excecao: 'Tarrafa, e só para pescador profissional habilitado: malha '
        'de 25 mm para camarão e de 60 mm para peixe.',
    norma: 'Instrução Normativa MMA nº 20, de 24 de junho de 2005',
    artigo: 'art. 2º',
    alcance: Alcance.local,
    texto: TextoDaNorma.lido,
    detalhe: 'A PROIBIÇÃO (art. 2º)\n'
        'Proibir, nas lagoas da Cruz e da Barra Velha no Estado de Santa '
        'Catarina, a pesca com a utilização de redes de qualquer '
        'natureza.\n\n'
        'A EXCEÇÃO (parágrafo único)\n'
        'A proibição não se aplica à pesca com tarrafas com malhas de 25 mm '
        'para captura de camarões e de 60 mm para captura de peixes, e '
        'somente para pescadores profissionais devidamente habilitados.',
  ),
  Restricao(
    titulo: 'Emalhar fixas entre o rio Itapocu e o rio Piraí, na safra da '
        'tainha',
    onde: 'Trecho compreendido entre a foz do rio Itapocu e a foz do rio '
        'Piraí, em Santa Catarina.',
    oQueProibe: 'Pesca com o uso de redes de emalhar ANCORADAS (fixas).',
    norma: 'Instrução Normativa MMA nº 20, de 24 de junho de 2005',
    artigo: 'art. 3º',
    alcance: Alcance.local,
    texto: TextoDaNorma.lido,
    de: 501,
    ate: 730,
    ressalva: 'É "de 1º de maio a 30 de julho", e a norma diz para quê: '
        'DURANTE A SAFRA DA TAINHA. Some com a temporada da tainha da '
        'Portaria Interministerial nº 24/2018 — nesse trecho, as duas '
        'regras valem ao mesmo tempo.\n\n'
        'O trecho vai da foz do rio ITAPOCU à foz do rio PIRAÍ. Circulam '
        'resumos que trocam o Piraí por "rio Barra Velha"; o texto '
        'publicado no Diário Oficial de 27/06/2005 diz Piraí.',
    detalhe: 'A PROIBIÇÃO (art. 3º)\n'
        'Proibir, anualmente, no período de 1º de maio a 30 de julho, '
        'durante a safra da tainha, a pesca com o uso de redes de emalhar '
        'ancoradas (fixas), no trecho compreendido entre a foz do rio '
        'Itapocu até a foz do rio Piraí.',
  ),

  // -------------------------------------------------------------------
  // arrasto de praia — só Santa Catarina
  // -------------------------------------------------------------------
  Restricao(
    titulo: 'Rede de arrasto de praia: malha, comprimento e altura',
    onde: 'Mar territorial do Estado de Santa Catarina.',
    oQueProibe: 'Usar rede de arrasto de praia fora destas medidas: malha '
        'MENOR que 40 mm entre nós opostos da malha esticada, comprimento '
        'MAIOR que 1.600 m, ou altura MAIOR que 30 m.',
    norma: 'Portaria SAP/MAPA nº 617, de 8 de março de 2022',
    artigo: 'art. 3º',
    alcance: Alcance.estado,
    texto: TextoDaNorma.lido,
    detalhe: 'O QUE É ARRASTO DE PRAIA (art. 2º, I)\n'
        'A pesca feita por pescadores profissionais artesanais '
        'tradicionais que usam embarcação, a remo ou a motor, para lançar '
        'ao mar uma rede deixando na praia uma das extremidades — dela ou '
        'de um cabo ligado a ela — e voltando à praia com a outra. O '
        'recolhimento é MANUAL, por pescadores e auxiliares, puxando as '
        'duas pontas, e termina quando a parte central da rede chega à '
        'praia.\n\n'
        'AS MEDIDAS DA REDE (art. 3º)\n'
        'I - malha igual ou superior a 40 mm, entre nós opostos da malha '
        'esticada;\n'
        'II - comprimento máximo de 1.600 m;\n'
        'III - altura máxima de 30 m.\n\n'
        'SANÇÃO (art. 12)\n'
        'Penalidades da Lei nº 9.605, de 1998, e do Decreto nº 6.514, de '
        '2008.\n\n'
        'REVOGAÇÃO (art. 14)\n'
        'Revogou a Portaria IBAMA nº 112-N, de 19 de outubro de 1992, e a '
        'alínea "c" do art. 2º da Portaria IBAMA nº 54-N, de 9 de junho de '
        '1999.\n\n'
        'PUBLICAÇÃO\n'
        'DOU de 09/03/2022, edição 46, página 14. Assinou Jorge Seif '
        'Júnior, Secretário de Aquicultura e Pesca.',
  ),
  Restricao(
    titulo: 'Arrasto de praia a motor: só entre Passo de Torres e Imbituba',
    onde: 'Mar territorial de Santa Catarina. O uso de motor é permitido '
        'apenas para embarcações que operam ENTRE OS MUNICÍPIOS DE PASSO '
        'DE TORRES E IMBITUBA.',
    oQueProibe: 'Arrasto de praia com embarcação de comprimento MAIOR que '
        '12 m, em qualquer lugar. E arrasto de praia A MOTOR fora do '
        'trecho entre Passo de Torres e Imbituba, ou com motor de '
        'potência acima de 90 HP.',
    excecao: 'A remo, a embarcação de até 12 m pode operar em todo o mar '
        'territorial catarinense, o ano todo.',
    norma: 'Portaria SAP/MAPA nº 617, de 8 de março de 2022',
    artigo: 'art. 4º e § 1º',
    alcance: Alcance.estado,
    texto: TextoDaNorma.lido,
    ressalva: 'O art. 4º, § 2º manda expressamente observar "as regras '
        'específicas de ordenamento das espécies que constam na '
        'Autorização de Pesca de Arrasto de Praia, incluindo os períodos '
        'de proibição de pesca e os tamanhos mínimos definidos". Ou seja: '
        'poder arrastar na praia não afasta o defeso da tainha, o tamanho '
        'mínimo da corvina nem nenhuma outra regra de espécie. As duas '
        'coisas se somam.',
    detalhe: 'QUANDO E COM O QUÊ (art. 4º)\n'
        'O arrasto de praia pode ser realizado durante o ANO TODO, com '
        'embarcação de pesca de comprimento máximo de 12 m, a remo ou '
        'motorizada.\n'
        '§ 1º O uso de motor é permitido APENAS para embarcações que '
        'operam entre os municípios de Passo de Torres e Imbituba, e com '
        'potência máxima de 90 HP.\n'
        '§ 2º As regras específicas de ordenamento das espécies que '
        'constam na Autorização de Pesca de Arrasto de Praia, incluindo '
        'os períodos de proibição de pesca e os tamanhos mínimos '
        'definidos, deverão ser obedecidas.\n\n'
        'AS MODALIDADES (art. 5º e Anexo I)\n'
        'A Portaria acrescentou ao Anexo VI da IN MPA/MMA nº 10/2011 as '
        'modalidades 6.8, 6.9, 6.10 e 6.11 — todas "arrasto de praia", '
        'todas com área de operação no mar territorial de Santa Catarina. '
        'Elas estão na tela de modalidades.\n\n'
        'CONVERSÃO (art. 7º)\n'
        'Quem tinha a modalidade 2.2 converte para 6.8 ou 6.11; quem '
        'tinha 2.4 converte para 6.9 ou 6.11; quem tinha 6.7 converte '
        'para 6.10 ou 6.11. Quem não tinha nenhuma delas só pode obter a '
        '6.11. Na conversão, o registro anterior é cancelado.\n\n'
        'MAPA DE PRODUÇÃO (art. 9º)\n'
        'Um por dia, enviados até o quinto dia útil do mês seguinte, '
        'mesmo quando não houve captura da espécie-alvo e mesmo quando a '
        'embarcação não saiu.\n\n'
        'O QUE ACONTECE SE NÃO ENVIAR (arts. 10 e 11)\n'
        'Suspensão da Autorização por 30 dias corridos. Passados os 30 '
        'dias sem regularizar, a Autorização é cancelada até o fim da '
        'validade.',
  ),
  Restricao(
    titulo: 'Arrasto motorizado de camarão: não entra frota nova',
    onde: 'Mar territorial e Zona Econômica Exclusiva das regiões Sudeste '
        'e Sul. Alcança Santa Catarina.',
    oQueProibe: 'A CONCESSÃO de autorização de pesca para o ingresso de '
        'embarcação nas modalidades de arrasto com tração motorizada que '
        'tenham como alvo o camarão-rosa (Penaeus paulensis, P. '
        'brasiliensis e P. subtilis) e o sete-barbas (Xiphopenaeus '
        'kroyeri). A frota está fechada para novas entradas.',
    norma: 'Portaria SAP/MAPA nº 656, de 30 de março de 2022',
    artigo: 'art. 7º',
    alcance: Alcance.regiao,
    texto: TextoDaNorma.lido,
    ressalva: 'O QUE O ARTIGO ALCANÇA, E O QUE NÃO ALCANÇA. Ele proíbe '
        'a CONCESSÃO de autorização para o INGRESSO de embarcação na '
        'modalidade. Não fala de quem já tem a autorização, não fala de '
        'renovação, e não fecha a porta da substituição: os arts. 9º e 10 '
        'da mesma Portaria permitem expressamente substituir a embarcação '
        'em caso de naufrágio, destruição ou desativação, e transformá-la '
        '— desde que a nova tenha potência de motor, arqueação bruta e '
        'comprimento total iguais ou menores que a anterior.\n\n'
        'Ou seja: uma autorização com data posterior a 30 de março de '
        '2022 não é, por si, sinal de irregularidade — pode ser '
        'exatamente a substituição que o art. 9º autoriza. O que a norma '
        'veda é a entrada de barco novo na modalidade.\n\n'
        'O defeso, os petrechos e o tamanho mínimo desta mesma Portaria '
        'estão na tela de defesos, no camarão.',
    detalhe: 'A PROIBIÇÃO (art. 7º)\n'
        'Fica proibida a concessão de autorização de pesca para o '
        'ingresso de embarcação de pesca nas Modalidades de '
        'Permissionamento de arrasto com tração motorizada que têm como '
        'espécies-alvo os camarões rosa e o sete-barbas para operar no '
        'Mar Territorial e na Zona Econômica Exclusiva nas regiões '
        'Sudeste e Sul do Brasil.\n\n'
        'SUBSTITUIÇÃO DE EMBARCAÇÃO (arts. 9º e 10)\n'
        'É permitida em caso de naufrágio, destruição ou desativação, '
        'desde que do mesmo proprietário. A substituta deve ter potência '
        'de motor, arqueação bruta e comprimento total IGUAIS OU MENORES '
        'que a substituída (§ 3º). Acima disso, só para garantir a '
        'segurança da navegação e do trabalhador a bordo, com documento '
        'da autoridade marítima (§ 4º). A transformação da embarcação '
        'segue a mesma regra do menor ou igual (art. 10).',
  ),

  // -------------------------------------------------------------------
  // a costa catarinense — norma ainda não obtida
  // -------------------------------------------------------------------
  Restricao(
    titulo: 'Arrasto de camarão no defeso: a frota não pode trocar de alvo',
    onde: 'Regiões Sudeste e Sul. Alcança Santa Catarina inteira.',
    oQueProibe: 'Durante o período de defeso do camarão, as frotas '
        'permissionadas para o arrasto de camarão ficam proibidas de '
        'capturar OUTRAS espécies cujo esforço de pesca esteja sob '
        'controle, ou que constem do Anexo II da Instrução Normativa MMA '
        'nº 5, de 21 de maio de 2004, e da Instrução Normativa MMA nº 52, '
        'de 8 de novembro de 2005.',
    excecao: 'A captura de outras espécies NÃO alcançadas pelo caput, pela '
        'frota camaroeira permissionada para o camarão-rosa, depende de '
        'permissão de pesca específica do órgão competente (parágrafo '
        'único).',
    norma: 'Instrução Normativa IBAMA nº 189, de 23 de setembro de 2008',
    artigo: 'art. 6º',
    alcance: Alcance.regiao,
    texto: TextoDaNorma.lido,
    ressalva: 'ATENÇÃO ÀS DATAS DESTA NORMA. O art. 1º, I dela fixou o '
        'defeso do arrasto motorizado de camarão em 1º DE MARÇO A 31 DE '
        'MAIO, da divisa ES/RJ até a foz do Arroio Chuí. Não é esse o '
        'período que se aplica hoje no mar de Santa Catarina: a Portaria '
        'SAP/MAPA nº 656, de 30 de março de 2022, fixa 28 DE JANEIRO A 30 '
        'DE ABRIL para RJ, SP, PR, SC e RS, e é ela que a página de '
        'defesos marinhos do IBAMA, atualizada em 21 de janeiro de 2026, '
        'apresenta como vigente. Use o defeso da tela de temporadas, não '
        'as datas de 2008.\n\n'
        'O que segue útil desta norma é o art. 6º, acima, e o art. 5º: '
        '"nas áreas estuarinas e lagunares os períodos de defeso serão '
        'definidos em instruções normativas específicas". É esse artigo '
        'que sustenta os defesos próprios da Baía da Babitonga e do '
        'Complexo Lagunar Sul.',
    detalhe: 'DEFESO DE 2008 (art. 1º) — VER A RESSALVA ACIMA\n'
        'Proibiu o arrasto com tração motorizada para captura de '
        'camarão-rosa (Farfantepenaeus paulensis, F. brasiliensis e F. '
        'subtilis), sete-barbas (Xiphopenaeus kroyeri), branco '
        '(Litopenaeus schmitti), santana ou vermelho (Pleoticus muelleri) '
        'e barba-ruça (Artemesia longinaris):\n'
        'I - de 1º de março a 31 de maio, entre 21º18\'04,00"S (divisa '
        'ES/RJ) e 33º40\'33,00"S (foz do Arroio Chuí, RS) — a faixa que '
        'inclui Santa Catarina;\n'
        'II - entre 21º18\'04,00"S e 18º20\'45,80"S (divisa BA/ES): de 15 '
        'de novembro a 15 de janeiro, e de 1º de abril a 31 de maio.\n'
        '§ 2º Desembarque tolerado até o SEGUNDO DIA CORRIDO após o '
        'início do defeso.\n\n'
        'CAMARÃO-BRANCO (art. 2º)\n'
        'Fica permitida a pesca do camarão-branco (Litopenaeus schmitti) '
        'nas áreas e períodos do art. 1º, DESDE QUE NÃO POR ARRASTO COM '
        'TRAÇÃO MOTORIZADA.\n\n'
        'DECLARAÇÃO DE ESTOQUE (art. 3º)\n'
        'Às Superintendências Estaduais do IBAMA, até o SÉTIMO DIA '
        'CORRIDO a contar do início do defeso.\n\n'
        'PRODUTO SEM ORIGEM (art. 4º)\n'
        'Proibidos, durante o defeso, o transporte interestadual, a '
        'estocagem, o beneficiamento, a industrialização e a '
        'comercialização de QUALQUER VOLUME de camarão das espécies '
        'proibidas sem comprovação de origem, por guia obtida na unidade '
        'do IBAMA mais próxima, que acompanha o produto da origem ao '
        'destino final e vale até o 2º dia após a assinatura.\n\n'
        'ÁREAS ESTUARINAS E LAGUNARES (art. 5º)\n'
        'Os períodos de defeso serão definidos em instruções normativas '
        'específicas, de acordo com as características ambientais de cada '
        'região e as peculiaridades locais da atividade pesqueira.\n\n'
        'TROCA DE ALVO NO DEFESO (art. 6º)\n'
        'Proibido às frotas permissionadas para o arrasto de camarão '
        'capturar, durante o defeso, outras espécies sob controle de '
        'esforço ou listadas no Anexo II da IN MMA nº 5/2004 e na IN MMA '
        'nº 52/2005.\n\n'
        'SANÇÃO (art. 7º)\n'
        'Penalidades da Lei nº 9.605, de 12 de fevereiro de 1998, e do '
        'Decreto nº 6.514, de 22 de julho de 2008.\n\n'
        'REVOGAÇÃO (art. 8º)\n'
        'Revogou a Instrução Normativa IBAMA nº 91, de 06 de fevereiro de '
        '2006, e a Instrução Normativa IBAMA nº 92, de 07 de fevereiro de '
        '2006. E SOMENTE ESSAS DUAS.\n\n'
        'PUBLICAÇÃO\n'
        'DOU de 24 de setembro de 2008, edição nº 185, páginas 83 e 84. '
        'Assinou Roberto Messias Franco.',
  ),
  Restricao(
    titulo: 'Distância mínima da costa para o arrasto motorizado: o '
        'aplicativo NÃO tem esta regra',
    onde: 'Costa aberta de Santa Catarina — fora de baía, lagoa costeira, '
        'canal e estuário.',
    oQueProibe: 'NADA, AQUI. O aplicativo não afirma nenhuma distância '
        'mínima da costa para o arrasto de tração motorizada em Santa '
        'Catarina, porque não tem norma conferida que a fixe. Antes de '
        'aplicar qualquer distância da costa em arrasto, consulte nos '
        'sites oficiais a norma de ordenamento vigente do arrasto de '
        'camarão no Sudeste e Sul.',
    norma: 'Instrução Normativa IBAMA nº 189, de 23 de setembro de 2008',
    artigo: 'a norma de distância não foi identificada',
    alcance: Alcance.estado,
    texto: TextoDaNorma.lido,
    ressalva: 'DE ONDE VEIO ESTA LACUNA. A regra de milhas da costa para o '
        'arrasto motorizado em Santa Catarina era atribuída à Portaria '
        'IBAMA nº 107, de 29 de setembro de 1992. Em 01/09/2026 essa '
        'entrada foi ESVAZIADA: nenhum número dela permanece no '
        'aplicativo.\n\n'
        'O QUE SE SABE, E O QUE NÃO SE SABE. A pesquisa aponta a Portaria '
        '107/1992 como revogada pela Instrução Normativa IBAMA nº 189, de '
        '23 de setembro de 2008. O texto da IN 189/2008 foi obtido e lido, '
        'e ELE NÃO DIZ ISSO: o art. 8º revoga a IN IBAMA nº 91/2006 e a IN '
        'IBAMA nº 92/2006, e mais nenhuma. A IN 189/2008 também não fixa '
        'distância da costa nenhuma — ela fixa um defeso por faixa de '
        'latitude. Então ela não é a substituta da regra de milhas: é '
        'outra coisa.\n\n'
        'Pode ser que a 107/1992 tenha sido revogada por outra norma, ou '
        'tacitamente. O aplicativo não afirma nem uma coisa nem outra, e '
        'sobretudo não reproduz os números antigos.\n\n'
        'O QUE O APLICATIVO TEM E PODE APLICAR:\n'
        '· dentro de baía, lagoa costeira, canal ou estuário, a Portaria '
        'SUDEPE nº N-51/1983 proíbe o arrasto sob qualquer denominação — '
        'texto lido;\n'
        '· no mar, o defeso do camarão da Portaria SAP/MAPA nº 656/2022, '
        'de 28 de janeiro a 30 de abril — texto lido;\n'
        '· para o EMALHE, as distâncias da Instrução Normativa '
        'Interministerial MPA/MMA nº 12/2012 — 1 milha para motorizadas, '
        '4 milhas acima de 20 AB — texto lido. Emalhe não é arrasto: não '
        'transporte esses números de uma modalidade para a outra.',
    detalhe: 'Este item existe para que a lacuna não passe despercebida. '
        'Uma regra que o aplicativo não tem é diferente de uma regra que '
        'não existe, e a diferença importa na hora de aplicar: diante de '
        'arrasto motorizado na costa aberta, se a dúvida for a '
        'distância, a resposta não está aqui.',
  ),

  // -------------------------------------------------------------------
  // emalhe nas regiões Sudeste e Sul — alcança SC inteira
  // -------------------------------------------------------------------
  Restricao(
    titulo: 'Emalhe com motor a menos de 1 milha náutica da costa',
    onde: 'Águas jurisdicionais brasileiras das regiões Sudeste e Sul, do '
        'Espírito Santo ao Rio Grande do Sul. Alcança toda a costa de '
        'Santa Catarina.',
    oQueProibe: 'Pesca de emalhe por EMBARCAÇÕES MOTORIZADAS até 1 milha '
        'náutica a partir da linha de costa.',
    excecao: 'Embarcação NÃO motorizada pode, desde que a soma do '
        'comprimento das panagens ou redes não passe de 1.000 m dentro '
        'dessa faixa (§ 1º).',
    norma: 'Instrução Normativa Interministerial MPA/MMA nº 12, de 22 de '
        'agosto de 2012',
    artigo: 'art. 6º',
    alcance: Alcance.regiao,
    texto: TextoDaNorma.lido,
    detalhe: 'A PROIBIÇÃO (art. 6º)\n'
        'Proibir a pesca de emalhe por embarcações motorizadas até a '
        'distância de 1 (uma) milha náutica a partir da linha de costa.\n'
        '§ 1º Para as embarcações não motorizadas fica permitida a pesca '
        'com redes de emalhe, desde que a soma do comprimento das panagens '
        'ou redes não ultrapasse o total de 1.000 m na área do caput.\n'
        '§ 2º Esta regra entrou em vigor 12 meses após a publicação da '
        'Instrução Normativa, publicada em 24/08/2012.\n'
        '§ 3º Aquele prazo podia ser prorrogado, considerando a '
        'necessidade de normas de ordenamento específicas.\n\n'
        'PASSAGEM INOFENSIVA (art. 11)\n'
        'É permitida a navegação de passagem inofensiva nas áreas de '
        'exclusão, desde que contínua e rápida, conforme a Convenção das '
        'Nações Unidas sobre o Direito do Mar. Passar não é pescar.',
  ),
  Restricao(
    titulo: 'Emalhe por embarcação acima de 20 AB até 4 milhas da costa',
    onde: 'Do farol do Albardão, no Rio Grande do Sul, até a divisa do '
        'Paraná com São Paulo. Toda a costa de Santa Catarina está dentro '
        'desse trecho.',
    oQueProibe: 'Pesca de emalhe por embarcação com arqueação bruta MAIOR '
        'QUE 20, da linha de costa até 4 milhas náuticas.',
    norma: 'Instrução Normativa Interministerial MPA/MMA nº 12, de 22 de '
        'agosto de 2012',
    artigo: 'art. 10, I',
    alcance: Alcance.regiao,
    texto: TextoDaNorma.lido,
    detalhe: 'A PROIBIÇÃO (art. 10)\n'
        'Proibir a pesca de emalhe para embarcações com arqueação bruta '
        '(AB) maior que 20, a partir da linha de costa até a distância '
        'de:\n'
        'I - 4 milhas náuticas, do farol do Albardão/RS até a divisa dos '
        'Estados do Paraná e São Paulo;\n'
        'II - 3 milhas náuticas, da divisa do Paraná com São Paulo até a '
        'divisa do Espírito Santo com a Bahia.\n\n'
        'Em Santa Catarina vale o inciso I: 4 milhas.\n\n'
        'COMO SE PROVA A ARQUEAÇÃO (art. 3º, IV e V)\n'
        'A AB considerada é a do Título de Inscrição de Embarcação — TIE, '
        'emitido pela Autoridade Marítima. Se a embarcação NÃO tiver o '
        'documento comprobatório, a fiscalização admite o transporte e o '
        'uso de no máximo 3.000 m de rede, seja qual for a capacidade de '
        'armazenamento do barco.',
  ),
  Restricao(
    titulo: 'Emalhe de fundo por embarcação acima de 20 AB, em maio e junho',
    onde: 'Águas jurisdicionais brasileiras das regiões Sudeste e Sul. '
        'Alcança Santa Catarina inteira.',
    oQueProibe: 'A OPERAÇÃO das embarcações maiores que 20 AB com emprego '
        'de redes de emalhe DE FUNDO.',
    norma: 'Instrução Normativa Interministerial MPA/MMA nº 12, de 22 de '
        'agosto de 2012',
    artigo: 'art. 4º',
    alcance: Alcance.regiao,
    texto: TextoDaNorma.lido,
    de: 515,
    ate: 615,
    ressalva: 'É um mês fechado por ano, para uma frota inteira, e não '
        'aparece no calendário de defesos porque não é defeso de espécie: '
        'é proibição de operação por modalidade e porte.',
    detalhe: 'A PROIBIÇÃO (art. 4º)\n'
        'Proibir, anualmente, entre os dias 15 de maio e 15 de junho, a '
        'operação das embarcações maiores que 20 (vinte) AB com o emprego '
        'de redes de emalhe de fundo nas águas jurisdicionais brasileiras '
        'das regiões Sudeste e Sul.',
  ),
  Restricao(
    titulo: 'Comprimento máximo da rede de emalhe',
    onde: 'Águas jurisdicionais brasileiras adjacentes ao litoral de Santa '
        'Catarina, Paraná, São Paulo, Rio de Janeiro e Espírito Santo.',
    oQueProibe: 'Transportar, armazenar ou usar rede acima do limite do '
        'porte da embarcação. A soma do comprimento de TODAS as panagens '
        'conta como uma só medida.',
    norma: 'Instrução Normativa Interministerial MPA/MMA nº 12, de 22 de '
        'agosto de 2012',
    artigo: 'art. 2º, I, e art. 21',
    alcance: Alcance.regiao,
    texto: TextoDaNorma.lido,
    ressalva: 'ATENÇÃO: OS NÚMEROS MUDARAM DEPOIS. O art. 2º, I fixou '
        '15.000 m e 18.000 m para as duas faixas maiores; o art. 21, § 2º '
        'baixou esses dois para 10.000 m e 13.000 m A PARTIR DE 1º DE '
        'JANEIRO DE 2016. São os de 2016 que valem hoje. Um aplicativo que '
        'mostrasse o art. 2º sozinho estaria liberando 5.000 m a mais.\n\n'
        'O art. 21 se condiciona à "ausência de novas medidas de limitação '
        'do esforço de pesca que disponham em contrário". Se veio norma '
        'posterior mudando esses números, ela prevalece — e o aplicativo '
        'não a conhece.',
    detalhe: 'O QUE VALE HOJE, no litoral de SC (art. 2º, I, com a redução '
        'do art. 21, § 2º)\n'
        '· até 10 AB ......... 3.000 m\n'
        '· mais de 10 até 20 AB ... 7.000 m\n'
        '· mais de 20 até 50 AB ... 10.000 m\n'
        '· mais de 50 AB ......... 13.000 m\n\n'
        'EMALHE DE SUPERFÍCIE E MEIA-ÁGUA (art. 2º, § 2º)\n'
        'Comprimento total máximo de 2.500 m, somadas as panagens. A regra '
        'não alcança o emalhe de superfície oceânico, o "malhão", que é '
        'PROIBIDO pela Instrução Normativa Interministerial MPA/MMA nº 11, '
        'de 5 de julho de 2012.\n\n'
        'PEIXE-SAPO (art. 2º, § 3º)\n'
        'Estes critérios não se aplicam ao emalhe para peixe-sapo, que '
        'segue a Instrução Normativa Conjunta MPA/MMA nº 3, de 4 de '
        'setembro de 2009.\n\n'
        'SEM DOCUMENTO DE ARQUEAÇÃO (art. 3º, V)\n'
        'A fiscalização admite no máximo 3.000 m.\n\n'
        'O CAMINHO DOS NÚMEROS\n'
        'Art. 2º, I (2012): 3.000 / 7.000 / 15.000 / 18.000 m.\n'
        'Art. 21, caput (de 1º/01/2014 a 31/12/2015): 13.000 e 16.000 m '
        'para as duas faixas acima de 20 AB.\n'
        'Art. 21, § 2º (desde 1º/01/2016): 10.000 e 13.000 m.\n'
        'Art. 21, § 3º: para até 20 AB seguem valendo os números do art. '
        '2º, I.',
  ),
  Restricao(
    titulo: 'Como a rede de emalhe tem que ser',
    onde: 'Regiões Sudeste e Sul, do Espírito Santo ao Rio Grande do Sul.',
    oQueProibe: 'Usar, transportar ou armazenar rede de emalhe fora destas '
        'características. Rede fora do padrão caracteriza EXERCÍCIO '
        'IRREGULAR DA PESCA COM PETRECHO NÃO PERMITIDO (art. 3º, III).',
    norma: 'Instrução Normativa Interministerial MPA/MMA nº 12, de 22 de '
        'agosto de 2012',
    artigo: 'art. 2º, III a VI, e art. 3º',
    alcance: Alcance.regiao,
    texto: TextoDaNorma.lido,
    detalhe: 'O PANO (art. 2º, III)\n'
        'Exclusivamente nailon MONOFILAMENTO. Multifilamento é proibido. '
        'Não é permitido transportar panos reserva a bordo. Panos '
        'danificados não podem ser jogados no mar: ficam a bordo para '
        'destinação em terra.\n\n'
        'ALTURA (art. 2º, IV)\n'
        'Até 4 metros.\n\n'
        'ENTRALHE (art. 2º, V)\n'
        'Coeficiente igual ou superior a 0,5. Não é permitido levar a '
        'bordo panos de rede não entralhados.\n\n'
        'MALHA (art. 2º, VI)\n'
        'De 70 mm a 140 mm, medida entre nós opostos. NÃO se aplica às '
        'redes feiticeira ou três-malhe, cuja malha é definida em norma '
        'específica (§ 4º).\n\n'
        'IDENTIFICAÇÃO DA REDE (art. 3º, II)\n'
        'A rede deve ser identificada NA TRALHA SUPERIOR, no mínimo a cada '
        '1.000 m, com o número do RGP da embarcação autorizada a operar '
        'com aquele petrecho. Redes de até 3.000 m podem ser identificadas '
        'com o RGP do pescador.\n\n'
        'O QUE A FALTA DISSO CONFIGURA (art. 3º, III)\n'
        'Rede sem as características ou sem a identificação desta norma '
        'caracteriza o exercício irregular da pesca com petrecho não '
        'permitido.\n\n'
        'ELASMOBRÂNQUIOS (art. 12)\n'
        'Quando não constarem das listas oficiais de espécies ameaçadas, '
        'tubarões e raias capturados no emalhe do Sudeste e Sul só podem '
        'ser desembarcados com as NADADEIRAS NATURALMENTE ADERIDAS AO '
        'CORPO. É permitido o corte parcial que permita dobrá-las sobre o '
        'corpo, e a retirada da cabeça e das vísceras.\n\n'
        'RASTREAMENTO (art. 17)\n'
        'Embarcações acima de 15 AB no emalhe do Sudeste e Sul são '
        'obrigadas, desde 1º de agosto de 2013, a aderir e manter em '
        'funcionamento equipamento vinculado ao PREPS.\n\n'
        'OBSERVADOR DE BORDO (art. 18)\n'
        'Embarcações acima de 20 AB devem manter a bordo acomodação e '
        'alimentação para observador de bordo ou cientista, quando '
        'determinado pelos Ministérios.\n\n'
        'SANÇÃO (art. 23)\n'
        'Penalidades da Lei nº 9.605, de 1998, e do Decreto nº 6.514, de '
        '2008. Além delas, a embarcação que atuar em desacordo TEM A '
        'AUTORIZAÇÃO DE PESCA CANCELADA, e a autorização cancelada não é '
        'redistribuída para outra embarcação.',
  ),
  Restricao(
    titulo: 'Áreas de exclusão do emalhe (Anexo I)',
    onde: 'Áreas delimitadas por coordenadas no Anexo I da própria norma, '
        'nas regiões Sudeste e Sul.',
    oQueProibe: 'Toda e qualquer pesca de emalhe dentro das áreas do Anexo '
        'I. Na "Área 1", a proibição é anual, de 15 de julho a 15 de '
        'outubro.',
    norma: 'Instrução Normativa Interministerial MPA/MMA nº 12, de 22 de '
        'agosto de 2012',
    artigo: 'art. 5º',
    alcance: Alcance.regiao,
    texto: TextoDaNorma.lido,
    ressalva: 'AS COORDENADAS NÃO ESTÃO AQUI DE PROPÓSITO. A extração do '
        'Anexo I saiu corrompida — uma das longitudes veio como -19, que '
        'não existe naquela costa, e a Área 3 apareceu duas vezes com '
        'pontos diferentes. Coordenada errada leva a conclusão errada. '
        'Leia o Anexo I e o mapa do Anexo II no texto publicado da '
        'Instrução Normativa, nos sites oficiais.\n\n'
        'O aplicativo registra que as áreas EXISTEM, para que se saiba '
        'que elas precisam ser conferidas, e não reproduz números que '
        'não conferiu.',
    detalhe: 'A PROIBIÇÃO (art. 5º)\n'
        'Proibir toda e qualquer pesca de emalhe nas áreas de exclusão '
        'correspondentes aos espaços geográficos definidos pelas '
        'coordenadas do Anexo I e do mapa do Anexo II.\n'
        '§ 1º Na "Área 1", fica proibida toda e qualquer pesca de emalhe '
        'ANUALMENTE DE 15 DE JULHO A 15 DE OUTUBRO.\n'
        '§ 2º A proibição entrou em vigor imediatamente para as Áreas 1, 2 '
        'e 4, e a partir de 1º de agosto de 2014 para a Área 3.\n\n'
        'OUTRAS ÁREAS FECHADAS PELA MESMA NORMA, fora de Santa '
        'Catarina:\n'
        '· art. 7º — até 5 milhas náuticas da costa, do farol do '
        'Albardão/RS ao limite sul do Rio Grande do Sul, exceto rede de '
        'lance de praia;\n'
        '· art. 8º — área de proteção do boto na Barra do Rio Grande/RS;\n'
        '· art. 9º — desde 1º de julho de 2014, até 15 milhas náuticas da '
        'costa entre os limites norte e sul do Parque Nacional da Restinga '
        'de Jurubatiba/RJ.\n\n'
        'PASSAGEM INOFENSIVA (art. 11)\n'
        'Permitida nas áreas de exclusão, desde que contínua e rápida.',
  ),
];
