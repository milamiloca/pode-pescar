// GERADO POR ferramentas/fotos.py — NÃO EDITAR À MÃO.
//
// A lista abaixo sai de um pareamento GEOMÉTRICO entre o nome científico
// e a imagem da mesma linha do guia, feito pelo ferramentas/fotos.py.
// Onde o pareamento foi ambíguo — célula com quatro nomes e três fotos,
// por exemplo — o script RECUSOU e a espécie ficou sem foto. Ficha sem
// foto é melhor que foto do bicho errado.

// =====================================================================
// AS FOTOS DAS ESPÉCIES
//
// Uma foto num aplicativo de fiscalização não é ilustração: é uma
// AFIRMAÇÃO de que aquele peixe é aquela espécie. Se a identificação
// estiver errada, o erro sai daqui e vira identificação errada no campo
// — e decide autuação.
//
// Por isso toda foto carrega a origem, e o aplicativo mostra a origem
// junto com a imagem. Quando a origem não foi declarada, ele DIZ que não
// foi declarada, em vez de calar. É a mesma regra das normas: o
// aplicativo não afirma o que não pode sustentar.
//
// Nenhuma foto é identificada por este aplicativo. Quem identifica é
// quem fotografou ou o catálogo de onde ela veio.
// =====================================================================

/// De onde a foto veio, e quem respondeu pela identificação da espécie.
enum OrigemDaFoto {
  /// Acervo do órgão: fotografada em fiscalização ou em atividade
  /// institucional, identificada por quem a produziu.
  orgao,

  /// Catálogo de órgão ou instituição de pesquisa — ICMBio, IBAMA, MPA,
  /// universidade. A `fonte` diz qual, e é o que se cita.
  catalogo,

  /// A figura veio dentro do texto de uma norma. É a origem mais forte
  /// que existe aqui: a própria norma mostra o bicho ou a medida.
  norma,

  /// A foto está no aplicativo e ninguém declarou de onde veio. O
  /// aplicativo mostra a imagem E mostra este aviso — não some com ele.
  naoDeclarada,
}

const avisoDeOrigem = <OrigemDaFoto, String>{
  OrigemDaFoto.orgao: '',
  OrigemDaFoto.catalogo: '',
  OrigemDaFoto.norma: '',
  OrigemDaFoto.naoDeclarada:
      'ORIGEM NÃO DECLARADA. Não se sabe quem fotografou nem quem '
      'identificou a espécie nesta imagem. Use a foto como apoio, nunca '
      'como prova de identificação: confirme pelo nome científico e, na '
      'dúvida, consulte a norma nos sites oficiais.',
};

/// Uma foto de espécie, com a procedência dela.
class Foto {
  /// O nome científico, como o aplicativo escreve nas fichas.
  final String cientifico;

  /// O arquivo em assets/especies/.
  final String arquivo;

  /// De onde veio.
  final OrigemDaFoto origem;

  /// Quem se cita: o órgão, o catálogo, a norma. Vazio só quando a
  /// origem é naoDeclarada.
  final String fonte;

  /// Quem respondeu pela identificação da espécie, quando se sabe.
  final String identificacao;

  /// Uma observação sobre a imagem, quando ela precisa de uma — a fase
  /// do bicho, a parte mostrada, o que a foto não permite distinguir.
  final String observacao;

  const Foto({
    required this.cientifico,
    required this.arquivo,
    required this.origem,
    this.fonte = '',
    this.identificacao = '',
    this.observacao = '',
  });

  String get caminho => 'assets/especies/$arquivo';

  /// A linha de crédito que aparece sob a imagem.
  String get credito {
    switch (origem) {
      case OrigemDaFoto.orgao:
        return fonte.isEmpty ? 'Acervo do órgão' : fonte;
      case OrigemDaFoto.catalogo:
        return fonte;
      case OrigemDaFoto.norma:
        return 'Figura da própria norma: $fonte';
      case OrigemDaFoto.naoDeclarada:
        return 'Origem não declarada';
    }
  }

  bool get precisaDeAviso => origem == OrigemDaFoto.naoDeclarada;
}



/// De onde vieram todas as fotos que estão hoje no aplicativo.
///
/// É o mesmo documento para todas: um guia de identificação de peixes
/// da Polícia Militar Ambiental, em 23 páginas, que reúne os Anexos I e
/// II da IN MMA nº 53/2005, um quadro de tamanhos e defesos, cinco
/// normas de moratória e o anexo do Decreto Estadual nº 63.853/2018, do
/// Estado de São Paulo.
const guiaDaPMA = 'Guia de identificação de peixes - PMA';

/// O segundo documento de fotos: o pôster da Secretaria Executiva da
/// Aquicultura e Pesca do Estado de Santa Catarina.
///
/// Ele declara a própria fonte dos NOMES na margem: Instrução Normativa
/// MAPA nº 53, de 01/09/2020, com o anexo na redação da Portaria MAPA
/// nº 570/2023. As duas foram revogadas pelo art. 5º da Portaria MPA nº
/// 532/2025, que é a tabela de nomes que este aplicativo usa. O pôster
/// vale aqui como fonte de IMAGEM, não de nome nem de regra.
const posterDaSAQ = 'Espécies do mar e da aquicultura catarinense - SAQ/SC';




// ---------------------------------------------------------------------
// AS FOTOS
//
// Todas vêm do mesmo guia, e a ficha mostra a fonte junto com a imagem.
// Servem de apoio para reconhecer o bicho; a identificação de campo se
// confirma pelo nome científico.
//
// Onde a grafia do nome científico no guia diverge da que as normas
// usam, a ficha registra as duas.
// ---------------------------------------------------------------------
const fotos = <Foto>[
  Foto(
    cientifico: 'Adelomelon beckii',
    arquivo: 'adelomelon_beckii.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Aliger costatus',
    arquivo: 'aliger_costatus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Alopias superciliosus',
    arquivo: 'alopias_superciliosus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    identificacao: 'O guia escreve "Alopias supeciliosus". O aplicativo usa '
        '"Alopias superciliosus", que é a grafia das normas que ele '
        'carrega.',
  ),
  Foto(
    cientifico: 'Alopias vulpinus',
    arquivo: 'alopias_vulpinus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Anchoviella lepidentostole',
    arquivo: 'anchoviella_lepidentostole.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Aristaeomorpha foliacea',
    arquivo: 'aristaeomorpha_foliacea.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Aristeus antillensis',
    arquivo: 'aristeus_antillensis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Artemesia longinaris',
    arquivo: 'artemesia_longinaris.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Asterina stellifera',
    arquivo: 'asterina_stellifera.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Atlantoraja castelnaui',
    arquivo: 'atlantoraja_castelnaui.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Atlantoraja cyclophora',
    arquivo: 'atlantoraja_cyclophora.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    observacao: 'Imagem de baixa resolução (162x121): serve para uma '
        'conferência grosseira, não para distinguir espécies parecidas.',
  ),
  Foto(
    cientifico: 'Atlantoraja platana',
    arquivo: 'atlantoraja_platana.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    observacao: 'Imagem de baixa resolução (153x121): serve para uma conferência grosseira, não para distinguir espécies parecidas.',
  ),
  Foto(
    cientifico: 'Bagre marinus',
    arquivo: 'bagre_marinus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Balistes capriscus',
    arquivo: 'balistes_capriscus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Balistes spp.',
    arquivo: 'balistes_spp.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Balistes vetula',
    arquivo: 'balistes_vetula.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    identificacao: 'O guia escreve "Balistes veluta". O aplicativo usa "Balistes '
        'vetula", que é a grafia das normas que ele carrega.',
  ),
  Foto(
    cientifico: 'Callinectes danae',
    arquivo: 'callinectes_danae_sapidus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    observacao: 'O guia rotula ESTA MESMA IMAGEM com dois nomes científicos: Callinectes danae e C. sapidus. Não se sabe qual das duas está na foto. Use a imagem para reconhecer o grupo, não para separar as duas espécies.',
  ),
  Foto(
    cientifico: 'Callinectes sapidus',
    arquivo: 'callinectes_danae_sapidus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    observacao: 'O guia rotula ESTA MESMA IMAGEM com dois nomes científicos: Callinectes danae e C. sapidus. Não se sabe qual das duas está na foto. Use a imagem para reconhecer o grupo, não para separar as duas espécies.',
  ),
  Foto(
    cientifico: 'Callinectes spp.',
    arquivo: 'callinectes_spp.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Caranx crysos',
    arquivo: 'caranx_crysos.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Caranx hippos',
    arquivo: 'caranx_hippos.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Caranx latus',
    arquivo: 'caranx_latus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Carcharhinus longimanus',
    arquivo: 'carcharhinus_longimanus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Carcharias taurus',
    arquivo: 'carcharias_taurus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Carcharodon carcharias',
    arquivo: 'carcharodon_carcharias.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Cardisoma guanhumi',
    arquivo: 'cardisoma_guanhumi.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Cathorops spixii',
    arquivo: 'cathorops_spixii.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Centropomus parallelus',
    arquivo: 'centropomus_parallelus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Centropomus spp.',
    arquivo: 'centropomus_spp.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Centropomus undecimalis',
    arquivo: 'centropomus_undecimalis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Centropyge aurantonotus',
    arquivo: 'centropyge_aurantonotus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Cetorhinus maximus',
    arquivo: 'cetorhinus_maximus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Charonia lampas',
    arquivo: 'charonia_lampas.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Chloroscombrus chrysurus',
    arquivo: 'chloroscombrus_chrysurus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Coryphaena hippurus',
    arquivo: 'coryphaena_hippurus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Coscinasterias tenuispina',
    arquivo: 'coscinasterias_tenuispina.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Crassostrea gasar',
    arquivo: 'crassostrea_gasar.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Crassostrea gigas',
    arquivo: 'crassostrea_gigas.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Ctenopharyngodon idella',
    arquivo: 'ctenopharyngodon_idella.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Cynoscion acoupa',
    arquivo: 'cynoscion_acoupa.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Cynoscion guatucupa',
    arquivo: 'cynoscion_guatucupa.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Cynoscion jamaicensis',
    arquivo: 'cynoscion_jamaicensis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    observacao: 'Imagem de baixa resolução (291x103): serve para uma '
        'conferência grosseira, não para distinguir espécies parecidas.',
  ),
  Foto(
    cientifico: 'Cynoscion striatus',
    arquivo: 'cynoscion_striatus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    observacao: 'Imagem de baixa resolução (274x100): serve para uma '
        'conferência grosseira, não para distinguir espécies parecidas.',
  ),
  Foto(
    cientifico: 'Cynoscion virescens',
    arquivo: 'cynoscion_virescens.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Cyprinus carpio',
    arquivo: 'cyprinus_carpio.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Cyrtopleura costata',
    arquivo: 'cyrtopleura_costata.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Diapterus rhombeus',
    arquivo: 'diapterus_rhombeus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
    identificacao: 'O pôster escreve \"Diapterus rhombeus / Diapterus olisthostomus\"; o aplicativo escreve \"Diapterus rhombeus\".',
  ),
  Foto(
    cientifico: 'Echinaster brasiliensis',
    arquivo: 'echinaster_brasiliensis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    observacao: 'Imagem de baixa resolução (247x225): serve para uma conferência grosseira, não para distinguir espécies parecidas.',
  ),
  Foto(
    cientifico: 'Epinephelus itajara',
    arquivo: 'epinephelus_itajara.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Epinephelus marginatus',
    arquivo: 'epinephelus_marginatus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Eucinostomus spp.',
    arquivo: 'eucinostomus_spp.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Eurytellina punicea',
    arquivo: 'eurytellina_punicea.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Euvola ziczac',
    arquivo: 'euvola_ziczac.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Farfantepenaeus brasiliensis',
    arquivo: 'farfantepenaeus_brasiliensis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Farfantepenaeus paulensis',
    arquivo: 'farfantepenaeus_paulensis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Farfantepenaeus subtilis',
    arquivo: 'farfantepenaeus_subtilis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Genidens barbus',
    arquivo: 'genidens_barbus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    identificacao: 'O guia escreve "Genindes barbus". O aplicativo usa "Genidens '
        'barbus", que é a grafia das normas que ele carrega.',
  ),
  Foto(
    cientifico: 'Genidens genidens',
    arquivo: 'genidens_genidens.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    identificacao: 'O guia escreve "Genindes genides". O aplicativo usa "Genidens '
        'genidens", que é a grafia das normas que ele carrega.',
  ),
  Foto(
    cientifico: 'Genidens spp.',
    arquivo: 'genidens_spp.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Ginglymostoma cirratum',
    arquivo: 'ginglymostoma_cirratum.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    identificacao: 'O guia escreve "Gimglymostoma cirratum". O aplicativo usa '
        '"Ginglymostoma cirratum", que é a grafia das normas que ele '
        'carrega.',
  ),
  Foto(
    cientifico: 'Gramma brasiliensis',
    arquivo: 'gramma_brasiliensis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Gymnura altavela',
    arquivo: 'gymnura_altavela.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Haemulon spp.',
    arquivo: 'haemulon_spp.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Hastula cinerea',
    arquivo: 'hastula_cinerea.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Heteroconger longissimus',
    arquivo: 'heteroconger_longissimus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    observacao: 'Imagem de baixa resolução (243x134): serve para uma conferência grosseira, não para distinguir espécies parecidas.',
  ),
  Foto(
    cientifico: 'Holacanthus ciliaris',
    arquivo: 'holacanthus_ciliaris.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Holacanthus tricolor',
    arquivo: 'holacanthus_tricolor.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Hypophthalmichthys molitrix',
    arquivo: 'hypophthalmichthys_molitrix.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Hypophthalmichthys nobilis',
    arquivo: 'hypophthalmichthys_nobilis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Hyporthodus nigritus',
    arquivo: 'hyporthodus_nigritus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Hyporthodus niveatus',
    arquivo: 'hyporthodus_niveatus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Kappaphycus alvarezii',
    arquivo: 'kappaphycus_alvarezii.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Katsuwonus pelamis',
    arquivo: 'katsuwonus_pelamis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Litopenaeus schmitti',
    arquivo: 'litopenaeus_schmitti.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Litopenaeus vannamei',
    arquivo: 'litopenaeus_vannamei.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Littoraria angulifera',
    arquivo: 'littoraria_angulifera.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Lopholatilus villarii',
    arquivo: 'lopholatilus_villarii.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Lutjanus cyanopterus',
    arquivo: 'lutjanus_cyanopterus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Lutjanus purpureus',
    arquivo: 'lutjanus_purpureus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Macrodon ancylodon',
    arquivo: 'macrodon_ancylodon.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Melampus coffeus',
    arquivo: 'melampus_coffeus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Menticirrhus americanus',
    arquivo: 'menticirrhus_americanus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Menticirrhus littoralis',
    arquivo: 'menticirrhus_littoralis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Mesodesma mactroides',
    arquivo: 'mesodesma_mactroides.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Metanephrops rubellus',
    arquivo: 'metanephrops_rubellus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Micropogonias furnieri',
    arquivo: 'micropogonias_furnieri.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Mobula thurstoni',
    arquivo: 'mobula_thurstoni.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    observacao: 'ATENÇÃO AO QUE ESTA FOTO MOSTRA. A linha do guia é '
        'encabeçada por "raia-manta, raia-diabo, manta-diabo, '
        'jamanta-mirim ou diabo-do-mar — família Mobulidae", e o nome '
        'científico vem entre aspas: "Mobula thurstoni". Não se sabe se '
        'a imagem é dessa espécie ou de outra da mesma família. A '
        'família inteira está na Lista Nacional Oficial. Use a foto para '
        'reconhecer a família, não para separar as espécies dela.',
  ),
  Foto(
    cientifico: 'Mugil curema',
    arquivo: 'mugil_curema.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Mugil platanus / Mugil liza',
    arquivo: 'mugil_platanus_liza.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    identificacao: 'O guia escreve "Mugil platanus / Mugil Liza", com '
        'Liza em maiúscula. O aplicativo escreve "Mugil platanus / Mugil '
        'liza", que é a grafia do Anexo I da IN MMA nº 53/2005.',
  ),
  Foto(
    cientifico: 'Mullus argentinae',
    arquivo: 'mullus_argentinae.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Mustelus canis',
    arquivo: 'mustelus_canis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Mustelus fasciatus',
    arquivo: 'mustelus_fasciatus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Mustelus schmitti',
    arquivo: 'mustelus_schmitti.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Mycteroperca acutirostris',
    arquivo: 'mycteroperca_acutirostris.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Mycteroperca bonaci',
    arquivo: 'mycteroperca_bonaci.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Mycteroperca interstitialis',
    arquivo: 'mycteroperca_interstitialis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Mycteroperca microlepis',
    arquivo: 'mycteroperca_microlepis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    observacao: 'Imagem de baixa resolução (261x118): serve para uma '
        'conferência grosseira, não para distinguir espécies parecidas.',
  ),
  Foto(
    cientifico: 'Mycteroperca tigris',
    arquivo: 'mycteroperca_tigris.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Mycteroperca venenosa',
    arquivo: 'mycteroperca_venenosa.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    observacao: 'Imagem de baixa resolução (241x133): serve para uma conferência grosseira, não para distinguir espécies parecidas.',
  ),
  Foto(
    cientifico: 'Myliobatis goodei',
    arquivo: 'myliobatis_goodei.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    observacao: 'Imagem de baixa resolução (168x116): serve para uma '
        'conferência grosseira, não para distinguir espécies parecidas.',
  ),
  Foto(
    cientifico: 'Negaprion brevirostris',
    arquivo: 'negaprion_brevirostris.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Nodipecten nodosus',
    arquivo: 'nodipecten_nodosus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Octopus spp.',
    arquivo: 'octopus_spp.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Odonthestes bonariensis / Atherinella brasiliensis',
    arquivo: 'odonthestes_atherinella.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    observacao: 'O guia traz as duas espécies numa linha só, com uma '
        'imagem só — igual à IN 53, que também as junta. Não se sabe '
        'qual das duas está na foto.',
  ),
  Foto(
    cientifico: 'Oligoplites saurus / Oligoplites saliens',
    arquivo: 'oligoplites_saurus_oligoplites_saliens.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Oncorhynchus mykiss',
    arquivo: 'oncorhynchus_mykiss.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Ophidion holbrookii',
    arquivo: 'ophidion_holbrookii.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Opisthonema oglinum',
    arquivo: 'opisthonema_oglinum.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Oreochromis niloticus',
    arquivo: 'oreochromis_niloticus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Paralichthys patagonicus / P. brasiliensis',
    arquivo: 'paralichthys_patagonicus_p_brasiliensis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    identificacao: 'O guia escreve "Paralichthys patagonicus". O aplicativo usa '
        '"Paralichthys patagonicus / P. brasiliensis", que é a grafia '
        'das normas que ele carrega.',
    observacao: 'A ficha cobre duas espécies — Paralichthys patagonicus e P. '
        'brasiliensis — e esta imagem é a que o guia rotula como '
        'Paralichthys patagonicus. A imagem também é de baixa resolução '
        '(267x130).',
  ),
  Foto(
    cientifico: 'Paralichthys spp.',
    arquivo: 'paralichthys_spp.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Paralonchurus brasiliensis',
    arquivo: 'paralonchurus_brasiliensis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Parona signata',
    arquivo: 'parona_signata.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Penaeus paulensis / brasiliensis',
    arquivo: 'penaeus_paulensis_brasiliensis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Penaeus schmitti',
    arquivo: 'penaeus_schmitti.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    observacao: 'Imagem de baixa resolução (283x152): serve para uma '
        'conferência grosseira, não para distinguir espécies parecidas.',
  ),
  Foto(
    cientifico: 'Penaeus vannamei',
    arquivo: 'penaeus_vannamei.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Peprilus paru',
    arquivo: 'peprilus_paru.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Perna perna',
    arquivo: 'perna_perna.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Piaractus mesopotamicus',
    arquivo: 'piaractus_mesopotamicus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Pleoticus muelleri',
    arquivo: 'pleoticus_muelleri.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Plesionika edwardsii',
    arquivo: 'plesionika_edwardsii.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Polyprion americanus',
    arquivo: 'polyprion_americanus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Pomatomus saltatrix',
    arquivo: 'pomatomus_saltatrix.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Priacanthus arenatus',
    arquivo: 'priacanthus_arenatus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Prionace glauca',
    arquivo: 'prionace_glauca.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Prionotus punctatus',
    arquivo: 'prionotus_punctatus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    observacao: 'Imagem de baixa resolução (275x90): serve para uma conferência '
        'grosseira, não para distinguir espécies parecidas.',
  ),
  Foto(
    cientifico: 'Prionotus spp.',
    arquivo: 'prionotus_spp.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Pristis pectinata',
    arquivo: 'pristis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    observacao: 'O guia rotula ESTA MESMA IMAGEM com dois nomes científicos: Pristis pectinata e Pristis perotteti. Não se sabe qual das duas está na foto. Use a imagem para reconhecer o grupo, não para separar as duas espécies.',
  ),
  Foto(
    cientifico: 'Pristis perotteti',
    arquivo: 'pristis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    observacao: 'O guia rotula ESTA MESMA IMAGEM com dois nomes científicos: Pristis pectinata e Pristis perotteti. Não se sabe qual das duas está na foto. Use a imagem para reconhecer o grupo, não para separar as duas espécies.',
  ),
  Foto(
    cientifico: 'Psammobatis extenta',
    arquivo: 'psammobatis_extenta.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Rhamdia quelen',
    arquivo: 'rhamdia_quelen.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Rhincodon typus',
    arquivo: 'rhincodon_typus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Rhinobatos horkelii',
    arquivo: 'rhinobatos_horkelii.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Rhinobatos percellens',
    arquivo: 'rhinobatos_percellens.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Rhinoptera bonasus',
    arquivo: 'rhinoptera_bonasus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    observacao: 'Imagem de baixa resolução (177x117): serve para uma conferência grosseira, não para distinguir espécies parecidas.',
  ),
  Foto(
    cientifico: 'Rhinoptera brasiliensis',
    arquivo: 'rhinoptera_brasiliensis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    observacao: 'Imagem de baixa resolução (130x121): serve para uma '
        'conferência grosseira, não para distinguir espécies parecidas.',
  ),
  Foto(
    cientifico: 'Rimapenaeus constrictus',
    arquivo: 'rimapenaeus_constrictus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Rioraja agassizii',
    arquivo: 'rioraja_agassizii.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Sardinella brasiliensis',
    arquivo: 'sardinella_brasiliensis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Scarus quacamaia',
    arquivo: 'scarus_quacamaia.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Scarus trispinosus',
    arquivo: 'scarus_trispinosus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Scarus zelindae',
    arquivo: 'scarus_zelindae.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Scomber colias',
    arquivo: 'scomber_colias.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Scomberomorus brasiliensis',
    arquivo: 'scomberomorus_brasiliensis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Scomberomorus cavalla',
    arquivo: 'scomberomorus_cavalla.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Selene setapinnis / Selene vomer',
    arquivo: 'selene_setapinnis_selene_vomer.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Seriola lalandi',
    arquivo: 'seriola_lalandi.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Sicyonia dorsalis',
    arquivo: 'sicyonia_dorsalis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Sparisoma amplum',
    arquivo: 'sparisoma_amplum.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Sparisoma axillare',
    arquivo: 'sparisoma_axillare.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Sparisoma frondosum',
    arquivo: 'sparisoma_frondosum.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Sphyraena barracuda',
    arquivo: 'sphyraena_barracuda.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Sphyraena guachancho',
    arquivo: 'sphyraena_guachancho.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Sphyrna lewini',
    arquivo: 'sphyrna_lewini.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Sphyrna media',
    arquivo: 'sphyrna_media.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Sphyrna tiburo',
    arquivo: 'sphyrna_tiburo.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Sphyrna tudes',
    arquivo: 'sphyrna_tudes.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Sphyrna zygaena',
    arquivo: 'sphyrna_zygaena.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Squalus albicaudus',
    arquivo: 'squalus_albicaudus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Squatina argentina',
    arquivo: 'squatina_argentina.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Squatina guggenheim',
    arquivo: 'squatina_guggenheim.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Squatina occulta',
    arquivo: 'squatina_occulta.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Stellifer rastrifer',
    arquivo: 'stellifer_rastrifer.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Sympterygia acuta',
    arquivo: 'sympterygia_acuta.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Teuthida',
    arquivo: 'teuthida.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Thunnus spp.',
    arquivo: 'thunnus_spp.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Thunnus thynnus',
    arquivo: 'thunnus_thynnus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Tivela mactroides',
    arquivo: 'tivela_mactroides.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Tivela ventricosa',
    arquivo: 'tivela_ventricosa.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Tonna galea',
    arquivo: 'tonna_galea.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Trachinotus spp.',
    arquivo: 'trachinotus_spp.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Trichiurus lepturus',
    arquivo: 'trichiurus_lepturus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Ucides cordatus',
    arquivo: 'ucides_cordatus.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Umbrina canosai',
    arquivo: 'umbrina_canosai.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
    observacao: 'Imagem de baixa resolução (284x103): serve para uma '
        'conferência grosseira, não para distinguir espécies parecidas.',
  ),
  Foto(
    cientifico: 'Urophycis brasiliensis',
    arquivo: 'urophycis_brasiliensis.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: posterDaSAQ,
  ),
  Foto(
    cientifico: 'Xiphias gladius',
    arquivo: 'xiphias_gladius.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Xiphopenaeus kroyeri',
    arquivo: 'xiphopenaeus_kroyeri.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
  Foto(
    cientifico: 'Zapteryx brevirostris',
    arquivo: 'zapteryx_brevirostris.jpg',
    origem: OrigemDaFoto.orgao,
    fonte: guiaDaPMA,
  ),
];

// =====================================================================
// AS ESPÉCIES QUE ENTRAM SÓ PORQUE EXISTE FOTO DELAS
//
// A ficha do aplicativo nasce de norma: tamanho mínimo na IN MMA nº
// 53/2005, ou a Lista da Portaria GM/MMA nº 1.667/2026, ou o catálogo
// de nomes da Portaria MPA nº 532/2025 quando alguma norma carregada
// cita a espécie.
//
// Estas 37 não têm nada disso. Entram porque a compilação de fotos traz
// a imagem delas, e porque quem abre o aplicativo com o bicho na mão
// procura pela foto. Ficha que não existe some da busca, e busca que
// não acha parece dizer que não há regra.
//
// A PÁGINA QUE NASCE DAQUI NÃO AFIRMA REGRA NENHUMA. Ela mostra a foto,
// mostra que a origem da foto não foi declarada, e diz em voz alta que
// nenhuma norma carregada por este aplicativo alcança a espécie.
//
// A maior parte vem do bloco de São Paulo da compilação. Aquele decreto
// é norma do Estado de São Paulo: NÃO ALCANÇA SANTA CATARINA e não foi
// carregado aqui. A ficha diz isso com todas as letras, porque a foto
// sem essa frase sugere uma proteção que em Santa Catarina não se sabe
// se existe.
// =====================================================================
const especiesSoDaFoto = <String>[
  'Adelomelon beckii',
  'Aliger costatus',
  'Anchoviella lepidentostole',
  'Aristaeomorpha foliacea',
  'Aristeus antillensis',
  'Asterina stellifera',
  'Atlantoraja platana',
  'Balistes spp.',
  'Callinectes danae',
  'Callinectes sapidus',
  'Callinectes spp.',
  'Caranx crysos',
  'Centropyge aurantonotus',
  'Charonia lampas',
  'Coscinasterias tenuispina',
  'Crassostrea gasar',
  'Crassostrea gigas',
  'Ctenopharyngodon idella',
  'Cyprinus carpio',
  'Cyrtopleura costata',
  'Echinaster brasiliensis',
  'Eucinostomus spp.',
  'Eurytellina punicea',
  'Farfantepenaeus brasiliensis',
  'Farfantepenaeus subtilis',
  'Gramma brasiliensis',
  'Haemulon spp.',
  'Hastula cinerea',
  'Heteroconger longissimus',
  'Holacanthus ciliaris',
  'Holacanthus tricolor',
  'Hypophthalmichthys molitrix',
  'Hypophthalmichthys nobilis',
  'Kappaphycus alvarezii',
  'Litopenaeus vannamei',
  'Littoraria angulifera',
  'Melampus coffeus',
  'Menticirrhus americanus',
  'Mesodesma mactroides',
  'Metanephrops rubellus',
  'Mycteroperca tigris',
  'Mycteroperca venenosa',
  'Nodipecten nodosus',
  'Octopus spp.',
  'Oligoplites saurus / Oligoplites saliens',
  'Oncorhynchus mykiss',
  'Ophidion holbrookii',
  'Oreochromis niloticus',
  'Penaeus paulensis / brasiliensis',
  'Penaeus vannamei',
  'Plesionika edwardsii',
  'Prionotus spp.',
  'Psammobatis extenta',
  'Rhamdia quelen',
  'Rhinobatos horkelii',
  'Rhinobatos percellens',
  'Rhinoptera bonasus',
  'Rimapenaeus constrictus',
  'Scarus quacamaia',
  'Scomber colias',
  'Selene setapinnis / Selene vomer',
  'Seriola lalandi',
  'Sicyonia dorsalis',
  'Sphyraena barracuda',
  'Sphyraena guachancho',
  'Squalus albicaudus',
  'Stellifer rastrifer',
  'Teuthida',
  'Thunnus spp.',
  'Tivela mactroides',
  'Tivela ventricosa',
  'Tonna galea',
  'Urophycis brasiliensis',
];

/// As que entraram pelo pôster da SAQ/SC, e não pelo guia.
const _doPoster = <String>{
  'Anchoviella lepidentostole',
  'Balistes spp.',
  'Callinectes spp.',
  'Caranx crysos',
  'Crassostrea gasar',
  'Crassostrea gigas',
  'Ctenopharyngodon idella',
  'Cyprinus carpio',
  'Eucinostomus spp.',
  'Haemulon spp.',
  'Hypophthalmichthys molitrix',
  'Hypophthalmichthys nobilis',
  'Kappaphycus alvarezii',
  'Menticirrhus americanus',
  'Nodipecten nodosus',
  'Oligoplites saurus / Oligoplites saliens',
  'Oncorhynchus mykiss',
  'Oreochromis niloticus',
  'Penaeus paulensis / brasiliensis',
  'Penaeus vannamei',
  'Prionotus spp.',
  'Rhamdia quelen',
  'Scomber colias',
  'Selene setapinnis / Selene vomer',
  'Seriola lalandi',
  'Sphyraena barracuda',
  'Sphyraena guachancho',
  'Stellifer rastrifer',
  'Teuthida',
  'Thunnus spp.',
  'Urophycis brasiliensis',
};

const _decretoSP = 'o Decreto Estadual nº 63.853, de 27 de novembro de '
    '2018, do ESTADO DE SÃO PAULO';

/// Quando a Lista Nacional Oficial traz uma espécie de MESMO EPÍTETO
/// e gênero diferente.
///
/// O guia é de 2018 e a Lista é de 2026, e em três casos as duas
/// escrevem o mesmo epíteto sob gêneros distintos. O aplicativo NÃO
/// AFIRMA que sejam a mesma espécie — nomes diferentes são nomes
/// diferentes, e concluir recombinação de gênero seria opinião
/// taxonômica, não norma.
///
/// Mas calar seria pior: quem procurasse pelo nome do guia leria
/// "nenhuma norma regula" e passaria batido por uma espécie que está na
/// Lista como ameaçada. Então a ficha aponta a vizinha e manda conferir.
const mesmoEpitetoNaLista = <String, String>{
  'Aliger costatus':
      'Macrostrombus costatus, item 482 da Lista, Vulnerável',
  'Rhinobatos horkelii':
      'Pseudobatos horkelii, item 372 da Lista, Criticamente em Perigo',
  'Rhinobatos percellens':
      'Pseudobatos percellens, item 373 da Lista, Vulnerável',
};

/// Sob que norma a compilação lista cada uma delas.
///
/// NÃO É REGRA DO APLICATIVO: é procedência da imagem. Nenhuma dessas
/// normas foi lida nem carregada aqui.
const listadaNoGuiaSob = <String, String>{
  'Adelomelon beckii': _decretoSP,
  'Aristaeomorpha foliacea': _decretoSP,
  'Aristeus antillensis': _decretoSP,
  'Asterina stellifera': _decretoSP,
  'Atlantoraja platana': _decretoSP,
  'Callinectes danae': 
      'a Portaria N-24, de 26 de julho de 1983',
  'Callinectes sapidus':
      'a Portaria N-24, de 26 de julho de 1983',
  'Octopus spp.':
      'a Instrução Normativa nº 26, de 19 de dezembro de 2008',
  'Centropyge aurantonotus': _decretoSP,
  'Charonia lampas': _decretoSP,
  'Coscinasterias tenuispina': _decretoSP,
  'Cyrtopleura costata': _decretoSP,
  'Echinaster brasiliensis': _decretoSP,
  'Eurytellina punicea': _decretoSP,
  'Farfantepenaeus brasiliensis': _decretoSP,
  'Farfantepenaeus subtilis': _decretoSP,
  'Gramma brasiliensis': _decretoSP,
  'Hastula cinerea': _decretoSP,
  'Heteroconger longissimus': _decretoSP,
  'Holacanthus ciliaris': _decretoSP,
  'Holacanthus tricolor': _decretoSP,
  'Litopenaeus vannamei': _decretoSP,
  'Littoraria angulifera': _decretoSP,
  'Melampus coffeus': _decretoSP,
  'Mesodesma mactroides': _decretoSP,
  'Metanephrops rubellus': _decretoSP,
  'Mycteroperca tigris': _decretoSP,
  'Mycteroperca venenosa': _decretoSP,
  'Ophidion holbrookii': _decretoSP,
  'Plesionika edwardsii': _decretoSP,
  'Psammobatis extenta': _decretoSP,
  'Rhinoptera bonasus': _decretoSP,
  'Rimapenaeus constrictus': _decretoSP,
  'Scarus quacamaia': _decretoSP,
  'Sicyonia dorsalis': _decretoSP,
  'Squalus albicaudus': _decretoSP,
  'Tivela mactroides': _decretoSP,
  'Tivela ventricosa': _decretoSP,
  'Tonna galea': _decretoSP,
};

/// O parágrafo que a ficha de uma espécie só-da-foto exibe.
String porQueSoTemFoto(String cientifico) {
  final sob = listadaNoGuiaSob[cientifico];
  final base = 'Esta espécie está no aplicativo porque existe foto dela '
      'na compilação de imagens. NENHUMA NORMA CARREGADA POR ESTE '
      'APLICATIVO REGULA ESTA ESPÉCIE — não há tamanho mínimo, defeso, '
      'área nem proibição de captura a apurar aqui.';
  if (_doPoster.contains(cientifico)) {
    return 'Esta espécie está no aplicativo porque existe foto dela no '
        'pôster de espécies da pesca e da aquicultura de Santa Catarina. '
        'NENHUMA NORMA CARREGADA POR ESTE APLICATIVO REGULA ESTA ESPÉCIE '
        '— não há tamanho mínimo, defeso, área nem proibição de captura a '
        'apurar aqui.\n\n'
        'O pôster não é norma: ele nomeia as espécies pela Instrução '
        'Normativa MAPA nº 53, de 1º de setembro de 2020, com o anexo na '
        'redação da Portaria MAPA nº 570, de 23 de março de 2023 — as '
        'duas revogadas pelo art. 5º da Portaria MPA nº 532, de 23 de '
        'setembro de 2025, que é a tabela de nomes deste aplicativo.\n\n'
        'Para saber se há regra em Santa Catarina, consulte a legislação '
        'correspondente nos sites oficiais.';
  }
  final vizinha = mesmoEpitetoNaLista[cientifico];
  final aviso = vizinha == null
      ? ''
      : '\n\nCUIDADO ANTES DE CONCLUIR QUE PODE. A Lista Nacional '
          'Oficial traz $vizinha — mesmo epíteto, gênero diferente. Este '
          'aplicativo NÃO AFIRMA que sejam a mesma espécie: o nome que a '
          'norma escreve é o outro, e a compilação de fotos é de 2018. '
          'Confira qual dos dois nomes descreve o exemplar que está na '
          'sua frente antes de qualquer decisão.';
  if (sob == null) return base + aviso;
  final fecho = sob == _decretoSP
      ? '\n\nA compilação a lista sob $sob. Norma estadual de outro '
          'estado NÃO ALCANÇA SANTA CATARINA, e ela não foi carregada '
          'neste aplicativo.\n\nPara saber se há regra em Santa '
          'Catarina, consulte a legislação correspondente nos sites '
          'oficiais.'
      : '\n\nA compilação a lista sob $sob. Este aplicativo não '
          'carrega essa norma: não se sabe o texto dela nem se continua '
          'em vigor. É preciso procurar a norma nos sites oficiais.';
  return base + fecho + aviso;
}

Map<String, Foto>? _porCientifico;

/// A foto de uma espécie, quando há.
Foto? fotoDe(String cientifico) {
  _porCientifico ??= {for (final f in fotos) f.cientifico: f};
  return _porCientifico![cientifico];
}

int get quantasFotos => fotos.length;

int get quantasFotosSemOrigem =>
    fotos.where((f) => f.origem == OrigemDaFoto.naoDeclarada).length;

/// Quantas espécies entram no aplicativo só pela foto.
int get quantasSoDaFoto => especiesSoDaFoto.length;

