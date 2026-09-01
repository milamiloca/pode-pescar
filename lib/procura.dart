import 'areas.dart';
import 'dados.dart' show modalidades, semAcento;
import 'defesos.dart';
import 'nomes.dart';

// =====================================================================
// QUANDO A BUSCA NÃO ACHA FICHA
//
// Nasceu de um caso real: alguém procurou "carapeba" e o aplicativo não
// devolveu nada. A carapeba não tem tamanho mínimo na IN 53 e não está
// na Lista de espécies ameaçadas — logo, não tem ficha. Mas ela aparece
// no defeso do Complexo Lagunar Sul e nas modalidades da IN 10/2011.
//
// Silêncio, num aplicativo de regra, é a pior resposta possível: quem
// procurou lê "não achei nada" como "não há regra". São coisas
// diferentes, e a diferença é justamente onde o erro acontece.
//
// Este arquivo faz a busca continuar nas outras camadas e devolve ONDE o
// nome aparece — sem afirmar qual regra se aplica ao caso, porque isso
// depende do lugar, do petrecho e da data.
// =====================================================================

/// De qual camada do aplicativo veio a menção.
enum Camada { defeso, area, modalidade }

const nomesDeCamada = <Camada, String>{
  Camada.defeso: 'Defesos e temporadas',
  Camada.area: 'Onde não pode',
  Camada.modalidade: 'Modalidades e petrechos',
};

class Mencao {
  final Camada camada;

  /// O nome do item onde o termo apareceu.
  final String titulo;

  /// A norma daquele item.
  final String norma;

  /// Uma frase curta dizendo em que campo o termo apareceu.
  final String onde;

  const Mencao({
    required this.camada,
    required this.titulo,
    required this.norma,
    required this.onde,
  });
}

/// Procura o termo nas camadas que não são a de espécies.
///
/// Devolve no máximo [teto] menções, para a tela não virar uma parede.
List<Mencao> ondeMaisAparece(String termo, {int teto = 12}) {
  final t = semAcento(termo).trim();
  if (t.length < 3) return const [];
  final saida = <Mencao>[];

  bool tem(String campo) => semAcento(campo).contains(t);

  for (final d in defesos) {
    if (saida.length >= teto) break;
    final campos = <String, String>{
      'no nome': d.titulo,
      'no texto da norma': d.detalhe,
      'na abrangência': d.abrangencia,
      'na ressalva': d.ressalva,
      'entre os nomes científicos': d.cientificos.join(' '),
    };
    for (final e in campos.entries) {
      if (e.value.isNotEmpty && tem(e.value)) {
        saida.add(Mencao(
          camada: Camada.defeso,
          titulo: d.titulo,
          norma: d.norma,
          onde: e.key,
        ));
        break;
      }
    }
  }

  for (final r in restricoes) {
    if (saida.length >= teto) break;
    final campos = <String, String>{
      'no nome': r.titulo,
      'no lugar alcançado': r.onde,
      'no que a regra proíbe': r.oQueProibe,
      'no texto da norma': r.detalhe,
    };
    for (final e in campos.entries) {
      if (e.value.isNotEmpty && tem(e.value)) {
        saida.add(Mencao(
          camada: Camada.area,
          titulo: r.titulo,
          norma: r.norma,
          onde: e.key,
        ));
        break;
      }
    }
  }

  for (final m in modalidades) {
    if (saida.length >= teto) break;
    final campos = <String, String>{
      'como espécie-alvo': m.alvo,
      'como fauna acompanhante': m.acompanhante,
      'no nome do petrecho': '${m.petrecho} ${m.locais}',
    };
    for (final e in campos.entries) {
      if (e.value.isNotEmpty && tem(e.value)) {
        saida.add(Mencao(
          camada: Camada.modalidade,
          titulo: '${m.numero} — ${m.petrecho}',
          norma: 'IN MPA/MMA nº 10, de 10 de junho de 2011',
          onde: e.key,
        ));
        break;
      }
    }
  }

  return saida;
}

/// Os nomes científicos que a Portaria 532/2025 dá para o termo buscado.
///
/// Serve para o caso mais comum: a pessoa digita o nome que usa, e o
/// aplicativo mostra por qual nome a norma chama aquele peixe.
List<String> cientificosDoTermo(String termo) => cientificosDe(termo);

/// Quantas menções, por camada, para o resumo da tela.
Map<Camada, int> contarPorCamada(List<Mencao> m) {
  final c = <Camada, int>{};
  for (final x in m) {
    c[x.camada] = (c[x.camada] ?? 0) + 1;
  }
  return c;
}
