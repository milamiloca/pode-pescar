import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dados.dart';

// =====================================================================
// CONFERÊNCIA DE DESEMBARQUE
//
// O registro de uma conferência e a conta que decide se está dentro.
// Nada aqui sai do celular: o histórico é gravado no próprio aparelho,
// com o shared_preferences.
// =====================================================================

/// Os itens que ele confere ter a bordo.
const List<String> itensDeBordo = [
  'Estou com o RGP, meu registro de pescador',
  'Estou com a autorização de pesca da embarcação',
  'Estou com o documento do barco',
  'O petrecho que usei está na minha autorização',
];

class Conferencia {
  final DateTime quando;
  final String especie;
  final int tamanhoMinimo;
  final int tolerancia; // 10% ou 20%, conforme o anexo da IN 53
  final double pesoTotal;
  final double pesoPequeno;
  final List<String> faltando; // os itens que ele NÃO marcou

  const Conferencia({
    required this.quando,
    required this.especie,
    required this.tamanhoMinimo,
    required this.tolerancia,
    required this.pesoTotal,
    required this.pesoPequeno,
    required this.faltando,
  });

  double get porcento =>
      pesoTotal > 0 ? (pesoPequeno / pesoTotal) * 100 : 0;

  bool get dentroDaTolerancia => porcento <= tolerancia;

  bool get tudoCerto => dentroDaTolerancia && faltando.isEmpty;

  int get quantosProblemas =>
      (dentroDaTolerancia ? 0 : 1) + faltando.length;

  /// Quantos quilos de peixe pequeno precisam sair pra ficar dentro.
  ///
  /// Tirando x kg de peixe abaixo da medida, os dois pesos caem juntos.
  /// Resolvendo (pequeno - x) / (total - x) = tolerância, chega-se em
  /// x = (pequeno - t*total) / (1 - t).
  double get kgParaSeparar {
    if (dentroDaTolerancia) return 0;
    final t = tolerancia / 100;
    final x = (pesoPequeno - t * pesoTotal) / (1 - t);
    return x < 0 ? 0 : x;
  }

  Map<String, dynamic> paraMapa() => {
        'quando': quando.toIso8601String(),
        'especie': especie,
        'tamanhoMinimo': tamanhoMinimo,
        'tolerancia': tolerancia,
        'pesoTotal': pesoTotal,
        'pesoPequeno': pesoPequeno,
        'faltando': faltando,
      };

  static Conferencia? deMapa(Map<String, dynamic> m) {
    final quando = DateTime.tryParse('${m['quando']}');
    if (quando == null) return null;
    return Conferencia(
      quando: quando,
      especie: '${m['especie']}',
      tamanhoMinimo: (m['tamanhoMinimo'] as num?)?.toInt() ?? 0,
      tolerancia: (m['tolerancia'] as num?)?.toInt() ?? 20,
      pesoTotal: (m['pesoTotal'] as num?)?.toDouble() ?? 0,
      pesoPequeno: (m['pesoPequeno'] as num?)?.toDouble() ?? 0,
      faltando: (m['faltando'] as List?)?.map((e) => '$e').toList() ?? const [],
    );
  }
}

// ---------------------------------------------------------------------
// GUARDAR E LER
// ---------------------------------------------------------------------

const _chave = 'conferencias';

/// Lê o histórico, da mais recente para a mais antiga.
Future<List<Conferencia>> lerConferencias() async {
  final prefs = await SharedPreferences.getInstance();
  final linhas = prefs.getStringList(_chave) ?? const <String>[];
  final lista = <Conferencia>[];
  for (final linha in linhas) {
    try {
      final mapa = jsonDecode(linha);
      if (mapa is Map<String, dynamic>) {
        final c = Conferencia.deMapa(mapa);
        if (c != null) lista.add(c);
      }
    } catch (_) {
      // linha estragada: ignora em vez de derrubar o app
    }
  }
  lista.sort((a, b) => b.quando.compareTo(a.quando));
  return lista;
}

/// Acrescenta uma conferência ao histórico.
Future<void> guardarConferencia(Conferencia c) async {
  final prefs = await SharedPreferences.getInstance();
  final linhas = prefs.getStringList(_chave) ?? const <String>[];
  final novas = [...linhas, jsonEncode(c.paraMapa())];
  await prefs.setStringList(_chave, novas);
}

/// Apaga tudo. Só é chamado quando a pessoa pede.
Future<void> apagarConferencias() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_chave);
}

// ---------------------------------------------------------------------
// AJUDANTES
// ---------------------------------------------------------------------

/// As espécies que aparecem na primeira pergunta. São as que o pescador
/// artesanal de SC efetivamente tira da água — a lista inteira das 34
/// deixaria a tela longa demais para o momento em que ela é usada.
const List<String> especiesComuns = [
  'Tainha',
  'Corvina',
  'Anchova',
  'Pescada olhuda ou maria-mole',
  'Pescadinha',
  'Robalo flecha',
  'Robalo peba ou peva',
  'Castanha',
  'Linguado',
  'Peixe-espada',
];

/// Devolve a espécie da IN 53 pelo nome, ou null se não achar.
Especie? acharEspecie(String nome) {
  for (final e in especies) {
    if (e.nome == nome) return e;
  }
  return null;
}

String doisDigitos(int n) => n < 10 ? '0$n' : '$n';

const List<String> _meses = [
  'jan', 'fev', 'mar', 'abr', 'mai', 'jun',
  'jul', 'ago', 'set', 'out', 'nov', 'dez',
];

String dataCurta(DateTime d) =>
    '${d.day} ${_meses[d.month - 1]} · ${doisDigitos(d.hour)}:${doisDigitos(d.minute)}';

String numeroBonito(double v) {
  final s = v.toStringAsFixed(v == v.roundToDouble() ? 0 : 1);
  return s.replaceAll('.', ',');
}
