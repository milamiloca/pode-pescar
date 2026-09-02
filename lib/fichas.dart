import 'ameacadas.dart';
import 'catalogo.dart';
import 'conflitos.dart';
import 'dados.dart';
import 'defesos.dart';
import 'fotos.dart';
import 'nomes.dart';
import 'regimes.dart';

// =====================================================================
// A LISTA ÚNICA DE ESPÉCIES
//
// Duas normas falam de espécie, e falam de coisas diferentes:
//
//   IN MMA 53/2005      35 espécies, por nome popular, com tamanho
//                       mínimo de captura.
//   Portaria 1.667/2026 490 espécies, por nome científico, com
//                       proibição de captura.
//
// Onze estão nas duas. Enquanto elas moravam em telas separadas, quem
// procurasse um peixe na tela errada podia concluir que não havia
// regra — e o erro caía sempre para o lado permissivo, que é o pior.
//
// Aqui as duas viram uma lista só de 514 fichas. A ficha guarda os
// ponteiros para as duas fontes, sem copiar nem misturar nada: cada
// resposta continua saindo da norma dela, com a citação dela. O
// cruzamento é feito pelo item da Lista, que já estava conferido
// espécie por espécie.
// =====================================================================

/// Uma espécie, com tudo o que as normas dizem sobre ela.
class Ficha {
  /// A entrada da IN 53, quando a espécie tem tamanho mínimo.
  final Especie? in53;

  /// A linha da Lista Nacional Oficial, quando a espécie é ameaçada.
  final Ameacada? lista;

  /// O nome científico, quando a espécie entra só pelo catálogo de
  /// nomes: nenhuma das duas normas de ficha a alcança, mas alguma
  /// norma que o aplicativo carrega a nomeia, e a Portaria MPA nº
  /// 532/2025 dá os nomes comuns dela. Ver catalogo.dart.
  final String? soNome;

  const Ficha({this.in53, this.lista, this.soNome});

  /// A ficha não vem de norma de tamanho nem da Lista. Ela existe para
  /// que a busca tenha o que responder, e para dizer as ausências em
  /// voz alta em vez de ficar calada.
  bool get soDoCatalogo => in53 == null && lista == null;

  /// A ficha existe só porque há foto da espécie: nenhuma norma
  /// carregada por este aplicativo a alcança, nem para nomeá-la. A tela
  /// diz isso na página. Ver especiesSoDaFoto em fotos.dart.
  bool get soPelaFoto =>
      soDoCatalogo && especiesSoDaFoto.contains(soNome);

  /// O nome que se lê primeiro. Nome popular quando existe na IN 53;
  /// senão o nome científico, que é o que a Lista dá.
  String get titulo {
    if (in53 != null) return in53!.nome;
    if (lista != null) return lista!.especie;
    // Do catálogo: o nome comum oficial da Portaria 532 é melhor
    // manchete que o binômio, e é o que a pessoa digita.
    final c = nomesComuns;
    return c.isEmpty ? soNome! : c.first;
  }

  /// O nome científico, sempre.
  String get cientifico =>
      in53?.cientifico ?? lista?.especie ?? soNome!;

  /// O nome popular só aparece se vier de norma. Nunca inventado.
  bool get temNomePopular =>
      in53 != null ||
      (lista?.pop445.isNotEmpty ?? false) ||
      (soDoCatalogo && nomesComuns.isNotEmpty);

  bool get temTamanho => in53 != null;
  bool get ameacada => lista != null;

  /// Proibida hoje: está na Lista e já constava da lista anterior.
  /// Para as 35 da IN 53 isso foi conferido uma a uma contra a
  /// Portaria 445/2014. Para as demais o app não afirma a data.
  bool get proibidaHoje => in53?.proibidaHoje ?? false;

  /// Entrou agora na Lista: a proibição começa em 25/10/2026.
  bool get proibidaDepois => in53?.proibidaDepois ?? false;

  /// A data da proibição foi conferida contra a Portaria 445/2014?
  bool get dataConferida => in53 != null && in53!.ameacada;

  String get categoriaPorExtenso =>
      lista?.categoriaPorExtenso ?? in53?.categoriaPorExtenso ?? '';

  /// A categoria como a norma a escreve: "Vulnerável - VU".
  String get categoriaComSigla {
    final c = categoriaPorExtenso;
    final s = lista?.cat ?? in53?.ameaca ?? '';
    return c.isEmpty || s.isEmpty ? c : '$c - $s';
  }

  /// O Plano de Recuperação da espécie, quando localizado. Estar na
  /// Lista não veda a captura por si só: o art. 4º da Portaria
  /// 1.666/2026 admite o uso quando há Plano, ato do MMA e norma de
  /// ordenamento. Ver regimes.dart.
  Plano? get plano => ameacada ? planoDe(cientifico) : null;

  /// Regulada quando há plano conferido; não verificado quando está na
  /// Lista e o aplicativo não conferiu. Só faz sentido para ameaçadas.
  Regime? get regime => ameacada ? regimeDe(cientifico) : null;

  /// A pesca desta espécie é regulada por Plano de Recuperação cujo
  /// texto foi conferido.
  bool get temPlano => plano != null && plano!.normaObtida;

  /// Sabe-se que há Plano, mas a norma de ordenamento não foi obtida.
  /// O aplicativo não dá regra: manda consultar, pelo nome da norma.
  bool get planoSemNorma => plano != null && !plano!.normaObtida;

  /// O asterisco que a Portaria 1.667 imprime ao lado do item: marca as
  /// espécies NOVAS na Lista. Ver conflitos.dart para as cinco linhas de
  /// evidência — a legenda não veio no texto publicado, mas nada aponta
  /// para o outro lado.
  bool get marcada => lista?.marca ?? false;

  /// A vedação do art. 3º já vale para esta espécie: ela constava da
  /// lista anterior, então não tem o prazo do art. 12.
  bool get vedadaHoje => ameacada && !marcada;

  /// Espécie nova na Lista: a vedação começa em 25 de outubro de 2026,
  /// pelos 180 dias do art. 12 da Portaria 1.666.
  bool get vedadaEm2510 => ameacada && marcada;

  /// Está na Lista e o aplicativo não conferiu se há plano. Nesse caso
  /// a vedação do art. 3º vale por padrão, mas não como resposta
  /// fechada do aplicativo.
  bool get planoNaoVerificado => ameacada && plano == null;

  /// Defesos e temporadas que alcançam esta espécie. Vêm de
  /// defesos.dart, cada um com a origem do que está escrito nele.
  List<Defeso> get temporadas => defesosDe(cientifico);
  bool get temTemporada => temporadas.isNotEmpty;

  /// Pontos em verificação que alcançam esta espécie. Quando há algum,
  /// a resposta do aplicativo para ela não é definitiva.
  List<Conflito> get emVerificacao => conflitosDe(cientifico);
  bool get temDuvida => emVerificacao.isNotEmpty;

  /// Os nomes comuns oficiais da espécie, pela Portaria MPA nº
  /// 532/2025. Lista vazia quando a espécie não consta daquela Portaria
  /// — o que é comum, porque ela cobre as espécies de interesse
  /// comercial, e a Lista de ameaçadas tem muita espécie que ninguém
  /// pesca.
  List<String> get nomesComuns => comunsDe(cientifico);
  bool get temNomeComum => nomesComuns.isNotEmpty;

  /// Tudo em que a busca deve procurar.
  ///
  /// Os nomes comuns oficiais entram aqui porque quem consulta digita o
  /// nome que usa. Sem isso, procurar "cururuca" não acha a corvina.
  String get textoDeBusca => [
        in53?.nome ?? '',
        in53?.cientifico ?? '',
        lista?.especie ?? '',
        lista?.pop445 ?? '',
        lista?.familia ?? '',
        lista?.ordem ?? '',
        soNome ?? '',
        nomesComuns.join(' '),
      ].join(' ');
}

// =====================================================================
// A MATRIZ x A LISTA
//
// A matriz de modalidades nomeia espécies em quatro campos. A Lista
// Nacional Oficial nomeia 490. Trinta e três estão nas duas, e dezoito
// aparecem na matriz como ESPÉCIE-ALVO — inclusive tubarões CR.
//
// Quem lê a modalidade e vê o bicho na espécie-alvo conclui que aquilo
// se pesca. Estar na Lista não veda por si: o art. 4º da Portaria
// GM/MMA nº 1.666/2026 admite o uso onde há Plano de Recuperação, ato
// do MMA e norma de ordenamento. Mas quem decide isso é a ficha da
// espécie, não a matriz — e é para lá que este cruzamento aponta.
// =====================================================================

/// Uma espécie da Lista nomeada dentro de uma modalidade.
class NaMatriz {
  final Ameacada lista;

  /// Em que campo da modalidade ela aparece: alvo, captura incidental,
  /// fauna acompanhante ou autorização complementar.
  final String campo;

  const NaMatriz({required this.lista, required this.campo});

  String get cientifico => lista.especie;
  String get categoria => lista.cat;

  /// A ficha da espécie, que é quem dá o veredito.
  Ficha? get ficha {
    for (final f in fichas) {
      if (f.cientifico == lista.especie) return f;
    }
    return null;
  }
}

const _camposDaMatriz = <String, String>{
  'alvo': 'espécie-alvo',
  'incidental': 'captura incidental',
  'acompanhante': 'fauna acompanhante previsível',
  'complementar': 'autorização complementar',
};

final Map<String, List<NaMatriz>> _naMatriz = {};

/// As espécies da Lista que esta modalidade nomeia, e em que campo.
///
/// Calculado dos dados, não de lista gerada: se a matriz ou a Lista
/// mudarem, isto acompanha sozinho.
List<NaMatriz> ameacadasNaModalidade(Modalidade m) {
  final achado = _naMatriz[m.numero];
  if (achado != null) return achado;

  final textos = <String, String>{
    'alvo': m.alvo,
    'incidental': m.incidental,
    'acompanhante': m.acompanhante,
    'complementar': m.complementar,
  };
  final saida = <NaMatriz>[];
  final vistos = <String>{};
  for (final a in listaAmeacadas) {
    for (final e in textos.entries) {
      if (e.value.contains(a.especie) && vistos.add(a.especie)) {
        saida.add(NaMatriz(lista: a, campo: _camposDaMatriz[e.key]!));
        break;
      }
    }
  }
  saida.sort((x, y) {
    const ordem = {'CR': 0, 'EN': 1, 'VU': 2};
    final c = (ordem[x.categoria] ?? 9).compareTo(ordem[y.categoria] ?? 9);
    return c != 0 ? c : x.cientifico.compareTo(y.cientifico);
  });
  _naMatriz[m.numero] = saida;
  return saida;
}

/// Quantas modalidades nomeiam ao menos uma espécie da Lista.
int get quantasModalidadesComAmeacada =>
    modalidades.where((m) => ameacadasNaModalidade(m).isNotEmpty).length;

List<Ficha>? _cache;

/// As 514 fichas, montadas uma vez.
///
/// Ordem: primeiro as 35 da IN 53, que são as que têm nome popular e
/// respondem a maioria das consultas; depois as demais da Lista, na
/// ordem do Anexo I.
List<Ficha> get fichas {
  if (_cache != null) return _cache!;

  final porItem = <int, Ameacada>{for (final a in listaAmeacadas) a.n: a};
  final usados = <int>{};
  final saida = <Ficha>[];

  for (final e in especies) {
    final a = e.ameacada ? porItem[e.itemLista] : null;
    if (a != null) usados.add(a.n);
    saida.add(Ficha(in53: e, lista: a));
  }
  for (final a in listaAmeacadas) {
    if (!usados.contains(a.n)) saida.add(Ficha(lista: a));
  }
  // Por último as do catálogo: não respondem regra, respondem nome.
  for (final c in catalogo) {
    saida.add(Ficha(soNome: c));
  }
  // E as que só têm foto: não respondem regra nem nome de norma —
  // respondem à imagem que a pessoa tem na mão.
  for (final c in especiesSoDaFoto) {
    saida.add(Ficha(soNome: c));
  }

  _cache = saida;
  return saida;
}

/// Quantas fichas têm tamanho mínimo, quantas são ameaçadas.
int get quantasDoCatalogo =>
    fichas.where((f) => f.soDoCatalogo && !f.soPelaFoto).length;
int get quantasFichasSoDaFoto => fichas.where((f) => f.soPelaFoto).length;
int get quantasComTamanho => fichas.where((f) => f.temTamanho).length;
int get quantasAmeacadas => fichas.where((f) => f.ameacada).length;

/// As espécies alcançadas por algum defeso ou temporada.
List<Ficha> get comTemporada =>
    fichas.where((f) => f.temTemporada).toList();
