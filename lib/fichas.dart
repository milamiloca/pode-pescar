import 'ameacadas.dart';
import 'conflitos.dart';
import 'dados.dart';
import 'defesos.dart';
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

  const Ficha({this.in53, this.lista});

  /// O nome que se lê primeiro. Nome popular quando existe na IN 53;
  /// senão o nome científico, que é o que a Lista dá.
  String get titulo => in53?.nome ?? lista!.especie;

  /// O nome científico, sempre.
  String get cientifico => in53?.cientifico ?? lista!.especie;

  /// O nome popular só aparece se vier de norma. Nunca inventado.
  bool get temNomePopular => in53 != null || (lista?.pop445.isNotEmpty ?? false);

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

  /// Tudo em que a busca deve procurar.
  String get textoDeBusca => [
        in53?.nome ?? '',
        in53?.cientifico ?? '',
        lista?.especie ?? '',
        lista?.pop445 ?? '',
        lista?.familia ?? '',
        lista?.ordem ?? '',
      ].join(' ');
}

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

  _cache = saida;
  return saida;
}

/// Quantas fichas têm tamanho mínimo, quantas são ameaçadas.
int get quantasComTamanho => fichas.where((f) => f.temTamanho).length;
int get quantasAmeacadas => fichas.where((f) => f.ameacada).length;

/// As espécies alcançadas por algum defeso ou temporada.
List<Ficha> get comTemporada =>
    fichas.where((f) => f.temTemporada).toList();
