import 'ameacadas.dart';
import 'conflitos.dart';
import 'dados.dart';
import 'defesos.dart';

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
