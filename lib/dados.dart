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

class Especie {
  final String nome;
  final String cientifico;
  final int tamanho; // em centímetros
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
  });

  /// Art. 4º: o Anexo I tolera 10% da captura abaixo do tamanho,
  /// o Anexo II tolera 20%.
  int get tolerancia => anexo == 1 ? 10 : 20;

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
      observacao: 'A IN 53 traz o nome antigo, Pogonias cromis. '
          'A Portaria 445/2014 já a listava com o nome comum Miragaia.'),
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
  Especie('Tainha', 'Mugil platanus / Mugil liza', 35,
      regras: 'TEMPORADA, POR MODALIDADE (art. 2º)\n'
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
          'autorizações são fixados a cada safra, em norma própria. O '
          'art. 25 remete as medidas dos exercícios seguintes à revisão '
          'do Plano de Gestão da Tainha.\n\n'
          'O que está acima é o Capítulo I: temporada por modalidade e '
          'áreas fechadas. É a parte que segue valendo.',
      regrasNorma: 'Portaria Interministerial nº 24, de 15 de maio de 2018'),
  Especie('Parati ou saúba', 'Mugil curema', 20),
  Especie('Trilha', 'Mullus argentinae', 13),
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
    alvo: 'Garoupa, cherne pintado, cherne verdadeiro (Epinephelus niveatus), Garoupa- vermelha-de-abrolhos (Epinephelus morio), Sirigado, badejo-quadrado (Mycteroperca bonaci), Badejomira (Mycteroperca acutirostris), Badejo-da-areia (Mycteroperca microlepis), Xaréu, garacimbora, xarelete (Caranx latus), Garaximpora, xaréu (Caranx hippos), Arabaiana, olho- de-boi (Seriola dumerili), Garajuba (Caranx crysus), Xaréu (Caranx latus), Garajuba amarela (Carangoides bartholomaei), Garaximbora (Caranx hippos), Palombeta (Chloroscombrus chrysurus), Peixe-rei (Elagatis bipinnulata), Timbira (Oligoplites saliens), Galo (Selene setapinnis), Galo-de-penacho (Selene vomer), Galo-do-alto (Alectis ciliaris), Xixarro (Trachurus lathami), Arabaiana (Seriola dumerili), (Seriola fasciata), Olhete (Seriola lalandi), Pampo (Trachinotus carolinus, Trachinotus falcatus, Trachinotus goodie), Pampo malhado (Trachinotus marginatus)',
    incidental: 'Mero (Epinephelus itajara), Cherne-poveiro (Polyprion americanus)',
    acompanhante: 'Pargo (Lutjanus purpureus), Dentão (Lutjanus jocu), Caranha (Lutjanus cyanopterus), Ariacó (Lutjanus synagris), Guaiúba (Ocyurus chrysurus), Pargo-piranga (Rhomboplites aurorubens), Tubarão azul (Prionace glauca), Tubarão lombopreto, Cação-lombo-preto (Carcharhinus falciformis), Mako (Isurus oxyrinchus), Cambéua, bagre-branco (Arius grandicassis), Bagre-defita, (Bagre marinus); Bandeirado, bagre-de-penacho (Bagre bagre), Bagre (Genidens barbus, Genidens planifrons), Uricica, bagre-amarelo (Cathorops spixii), Bagre rosado (Genidens genidens, Genidens barbus), Raia santa (Rioraja agassizii), Raia carimbada (Atlantoraja cyclophora), Raia chita (Atlantoraja castelnaui), Raia emplasto (Atlantoraja platana, Sympterygia bonapartii, Sympterygia acuta), Raia (Breviraja spinosa, Rajella purpuriventralis) e Pescada amarela (Cynoscion acoupa)',
    complementar: 'Linha de mão (fundo), Espécies: Garoupa, cherne pintado, cherne verdadeiro (Epinephelus niveatus), Garoupa-vermelha-de-abrolhos (Epinephelus morio), Sirigado, badejo-quadrado (Mycteroperca bonaci), Badejo-mira (Mycteroperca acutirostris), Badejo-da-areia (Mycteroperca microlepis), Xaréu, garacimbora, xarelete (Caranx latus), Garaximpora, xaréu (Caranx hippos), Arabaiana, olho-de-boi (Seriola dumerili), Pargo (Lutjanus purpureus), Dentão (Lutjanus jocu), Caranha (Lutjanus cyanopterus), Ariacó (Lutjanus synagris), Guaiúba (Ocyurus chrysurus), Pargo-piranga (Rhomboplites aurorubens) Garajuba (Caranx crysus), Xaréu (Caranx latus), Garajuba amarela (Carangoides bartholomaei), Garaximbora (Caranx hippos), Palombeta (Chloroscombrus chrysurus), Peixe- rei (Elagatis bipinnulata), Timbira (Oligoplites saliens), Galo (Selene setapinnis), Galo-de- penacho (Selene vomer), Galo-do-alto (Alectis ciliaris), Xixarro (Trachurus lathami), Arabaiana (Seriola dumerili), (Seriola fasciata), Olhete (Seriola lalandi), Pampo (Trachinotus carolinus, Trachinotus falcatus, Trachinotus goodie), Pampo malhado (Trachinotus marginatus)',
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
    complementar: 'Espinhel Horizontal Pelágico, Espécies: Albacora laje (Thunnus albacares), Albacora branca (Thunnus alalunga), Albacora bandolim (Thunnus obesus), Tubarão azul (Prionace glauca), Tubarão lombo-preto, Cação-lombo-preto (Carcharhinus falciformis), Mako (Isurus oxyrinchus), Agulhão verde (Tetrapturus pfluegeri), Agulhão vela (Istiophorus albicans), Albacora azul (Thunnus thynnus), Albacorinha (Thunnus atlanticus), Espadarte (Xiphias gladius), Bonito listrado (Katsuwonus pelamis), Bonito cachorro (Auxis thazard), Sarda (Sarda sarda), Cavala empige (Acanthocybium solandri), Cavala (Scomberomorus cavalla), Serra (Scomberomorus brasiliensis), Dourado (Coryphaena hippurus)',
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
    complementar: 'Rede de emalhe de superfície, Espécies: Cavala (Scomberomorus cavalla), Serra (Scomberomorus brasiliensis), Curuca (Micropogonias furnieri), Timbira (Oligoplites saliens), Bonito (Katsuwonus pelamis), Tubarão azul (Prionace glauca), Tubarão lombo-preto, Cação-lombo-preto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação-bagre (Squalus acanthias, Squalus cubensis), Cação- espinho (Squalus blainville), Cação-malhado (Mustelus fasciatus), Uritinga (Arius proops)',
    area: 'Mar territorial N/NE (AP a AL); e ZEE N/NE (AP a AL) (IN SEAP Nº 001/2007)',
  ),
  Modalidade(
    '1.11',
    Metodo.linha,
    'Espinhel vertical',
    locais: 'Linha Pargueira, Caico e Bicicleta',
    alvo: 'Pargo (Lutjanus purpureus), Dentão (Lutjanus jocu), Caranha (Lutjanus cyanopterus), Ariacó (Lutjanus synagris), Guaiúba (Ocyurus chrysurus), Pargo-piranga (Rhomboplites aurorubens)',
    incidental: 'Cherne-poveiro (Polyprion americanus), Tubarão raposa (Alopias supercilliosus), Cação-bico-doce (Galeorhinus galeus), Cação-cola-fina, caçonete (Mustelus schmitti), Tubarão - peregrino (Cetorhinus maximus), Cação-lixa, tubarão-lixa, Lambaru (Ginglymostoma cirratum), Tubarão - baleia (Rhincodon typus), Cação-anjo-espinhoso (Squatina Guggenheim), Cação-anjo-liso (Squatina occulta), Cação bicudo, cação espátula, Quati (Isogomphodon oxyrhynchus)',
    acompanhante: 'Garoupa, cherne pintado, cherne verdadeiro (Epinephelus niveatus), Garoupa-vermelha-deabrolhos (Epinephelus morio) Batata (Lopholatilus villariii), Uricica, bagre-amarelo (Cathorops spixii), Bandeirado, bagre-de-penacho (Bagre bagre), Cambéua, bagre-branco (Arius grandicassis), Bagre (Genidens barbus, Genidens planifrons), Bagre-amarelo (Cathorops spixii), Bagre rosado (Genidens genidens, Genidens barbus), Congro (Conger orbignyanus), Congro rosa (Genypterus brasiliensis), Namorado (Pseudopercis numida), Abrótea de fundo (Urophycis cirrata)',
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
    alvo: 'Peroá (Balistes capriscus), Garoupa, cherne pintado, cherne verdadeiro (Epinephelus niveatus), Corvina (Micropogonias furnieri)',
    incidental: 'Raia Viola (Rhinobatus horkelii, Rinobatos percellens)',
    acompanhante: 'Baiacu (Lagocephalus laevigatus), Pargo (Lutjanus purpureus), Dentão(Lutjanus jocu), Caranha (Lutjanus cyanopterus), Ariacó (Lutjanus synagris), Guaiúba (Ocyurus chrysurus), Pargo-piranga (Rhomboplites aurorubens), Pargo- rosa (Pagrus pagrus), Bagre-branco (Arius grandicassis), Bagre-de-fita (Bagre marinus), Bagre-de-penacho (Bagre bagre), Bagre (Genidens barbus, Netuma planifrons), Bagre- amarelo (Cathorops spixii), Bagre rosado (Genidens genidens, Genidens barbus), Tubarão azul (Prionace glauca), Tubarão lombo-preto, Cação-lombo-preto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação-bagre (Squalus acanthias, Squalus cubensis), Cação- espinho (Squalus blainville), Cação-malhado (Mustelus fasciatus), Sargo (Archosargus probatocephalus), Pampo (Trachinotus carolinus, Trachinotus falcatus, Trachinotus goodie), Pampo malhado (Trachinotus marginatus), Goete (Cynoscion jamaicensis), Betara (Menticirrhus americanus)',
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
    complementar: 'Linha de mão (superfície), Espécies: Sororoca, serra (Scomberomorus brasiliensis), Cavala (Scomberomorus cavalla), Guaivira (Oligoplites saliens), Prejereba (Lobotes surinamensis), Robalo (Centropomus parallelus, Centropomus undecimalis, Centropomus ensiferus, Centropomus pectinatus), Anchova (Pomatomus saltatrix)',
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
    complementar: 'Garatéia com atração luminosa (vulgo zangarilho), Espécies: Lula (Loligo sanpaulensis, Loligo surinamensis, Lolliguncula brevis, Doryteuthis plei, Sepioteuthis sepioidea)',
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
    complementar: 'Rede de espera (superfície), Espécies: Tainha (Mugil platanus ou Mugil liza), Anchova (Pomatomus saltatrix), Sororoca, serra (Scomberomorus brasiliensis), Guavira (Oligoplites saliens)',
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
    alvo: 'Corvina (Micropogonias furnieri), Castanha (Umbrina canosai), Pescada, Maria- mole (Cynoscion striatus), Pescadinha real, Pescada foguete (Macrodon ancylodon)',
    incidental: 'Raia Viola (Rhinobatus horkelii, Rinobatos percellens)',
    acompanhante: 'Linguado (Paralichthys brasiliensis, Paralichthys isósceles, Paralichthys triocellatus, Paralichthys patagonicus), Trilha (Mullus argentinae), Abrotea (Urophycis brasiliensis), Lula (Loligo sanpaulensis, Loligo surinamensis, Lolliguncula brevis, Doryteuthis plei, Sepioteuthis sepioidea), Cabrinha (Prionotus punctatus), Congro rosa (Genypterus brasiliensis), Peixe-sapo (Lophius gastrophysus), Tira-vira (Percophis brasiliensis), Namorado (Pseudopercis numida), Batata (Lopholatilus villarii), Lacraia, Pitu (Metanephrops rubellus), Cavaca, carapau, xerelete (Caranx crysus), Pargo (Lutjanus purpureus), Dentão(Lutjanus jocu), Caranha (Lutjanus cyanopterus), Ariacó (Lutjanus synagris), Guaiúba (Ocyurus chrysurus), Pargo-piranga (Rhomboplites aurorubens), Garoupa, cherne pintado, cherne verdadeiro (Epinephelus niveatus), Garoupa-vermelha-de-abrolhos (Epinephelus morio), Sirigado, badejo-quadrado (Mycteroperca bonaci), Badejo-mira (Mycteroperca acutirostris), Badejo-da-areia (Mycteroperca microlepis), Olho de cão (Priacanthus arenatus), Peixe-espada (Trichiurus lepturus)',
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
    acompanhante: 'Calamar argentino (Illex argentinus), Calamar vermelho (Ommastrephes bartramii), Caranguejo real (Chaceon ramosae), Caranguejo vermelho (Chaceon notialis), Tubarão azul (Prionace glauca), Tubarão lombo-preto, Cação-lombopreto (Carcharhinus falciformis), Mako, cação anequim (Isurus oxyrinchus), Cação-bagre (Squalus acanthias, Squalus cubensis), Caçãoespinho (Squalus blainville), Cação-malhado (Mustelus fasciatus), Merluza (Merluccius hubbsi), Pargo (Lutjanus purpureus), Pargo Rosa (Pagrus pagrus), Abrótea de profundidade (Urophycis cirrata)',
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
    alvo: 'Peixes e crustáceos diversos não controlados por regulamentação específica',
    area: 'Mar territorial (SP ao RS)',
    valeEmSc: true,
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
