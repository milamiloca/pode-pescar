import 'package:flutter/material.dart';

/// Paleta do app.
///
/// A ideia é lembrar carta náutica: fundo claro de papel, faixa de
/// azul profundo no topo, e o âmbar de boia usado com parcimônia,
/// só onde precisa chamar atenção. Nada de azul de praia.
///
/// O app é claro de propósito: quem usa está no sol, num molhe ou
/// num barco, e tela clara com contraste alto é o que se enxerga.

const corFundo = Color(0xFFECF1F2); // luz de mar encoberto
const corSuperficie = Color(0xFFFFFFFF);
const corProfundo = Color(0xFF0A2933); // faixa escura, topo da carta
const corMar = Color(0xFF0E6A7C); // azul-petróleo, a cor de ação
const corBoia = Color(0xFFB26A0B); // âmbar, só para destaque
const corTinta = Color(0xFF0B1C22);
const corApagada = Color(0xFF52686F);
const corBorda = Color(0xFFD7E2E5);
const corPode = Color(0xFF186F40);
const corNaoPode = Color(0xFF9C2A21);

ThemeData montarTema() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: corFundo,
    colorScheme: ColorScheme.fromSeed(
      seedColor: corMar,
      primary: corMar,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: corFundo,
      surfaceTintColor: corFundo,
      foregroundColor: corTinta,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        color: corTinta,
      ),
    ),
  );
}

// ---------- estilos de texto reaproveitados ----------

const estiloEtiqueta = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w700,
  letterSpacing: 1.5,
  color: corApagada,
);

const estiloTitulo = TextStyle(
  fontSize: 27,
  fontWeight: FontWeight.bold,
  height: 1.12,
  color: corTinta,
);

const estiloSubtitulo = TextStyle(
  fontSize: 19,
  fontWeight: FontWeight.bold,
  color: corTinta,
);

const estiloCorpo = TextStyle(
  fontSize: 16,
  height: 1.45,
  color: corApagada,
);

// ---------- pedacinhos usados em várias telas ----------

/// Uma linha fina, como as curvas de nível de uma carta.
class Regua extends StatelessWidget {
  const Regua({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: corBorda);
  }
}

/// Caixa que mostra de onde veio a informação. Aparece em toda
/// tela que dá uma resposta — é o que impede o app de virar
/// autoridade paralela.
class Fonte extends StatelessWidget {
  final String norma;
  final String detalhe;

  const Fonte({super.key, required this.norma, required this.detalhe});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3EBED),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('DE ONDE VEM ESSA REGRA', style: estiloEtiqueta),
          const SizedBox(height: 6),
          Text(
            norma,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: corTinta,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            detalhe,
            style: const TextStyle(
              fontSize: 13,
              color: corApagada,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Este aplicativo não substitui a norma. Na dúvida, procure a '
            'sua colônia.',
            style: TextStyle(
              fontSize: 13,
              color: corApagada,
              height: 1.4,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

/// Borda dos campos de digitar, sempre igual em todo o app.
OutlineInputBorder bordaCampo({bool focado = false}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
      color: focado ? corMar : corBorda,
      width: focado ? 2 : 1,
    ),
  );
}

/// Campo de busca, o mesmo nas duas seções do app.
class CampoBusca extends StatelessWidget {
  final String dica;
  final ValueChanged<String> aoMudar;

  const CampoBusca({super.key, required this.dica, required this.aoMudar});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: aoMudar,
      style: const TextStyle(fontSize: 17),
      decoration: InputDecoration(
        hintText: dica,
        prefixIcon: const Icon(Icons.search, size: 24),
        filled: true,
        fillColor: corSuperficie,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: bordaCampo(),
        enabledBorder: bordaCampo(),
        focusedBorder: bordaCampo(focado: true),
      ),
    );
  }
}

/// Cartão branco tocável, a unidade de todas as listas.
class Cartao extends StatelessWidget {
  final Widget child;
  final VoidCallback? aoTocar;
  final EdgeInsets padding;

  /// Quando preenchido, o cartão ganha borda dessa cor, mais grossa.
  /// Serve para marcar o que precisa ser visto antes de tocar.
  final Color? destaque;

  const Cartao({
    super.key,
    required this.child,
    this.aoTocar,
    this.padding = const EdgeInsets.fromLTRB(14, 14, 16, 14),
    this.destaque,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: corSuperficie,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: destaque ?? corBorda,
          width: destaque == null ? 1 : 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: aoTocar,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Botão largo de ação.
class BotaoGrande extends StatelessWidget {
  final String texto;
  final IconData? icone;
  final VoidCallback aoTocar;
  final bool desligado;

  const BotaoGrande({
    super.key,
    required this.texto,
    required this.aoTocar,
    this.icone,
    this.desligado = false,
  });

  @override
  Widget build(BuildContext context) {
    final estilo = FilledButton.styleFrom(
      backgroundColor: corMar,
      foregroundColor: Colors.white,
      disabledBackgroundColor: corBorda,
      disabledForegroundColor: corApagada,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
    final rotulo = Text(texto, style: const TextStyle(fontSize: 17));
    final acao = desligado ? null : aoTocar;
    return SizedBox(
      width: double.infinity,
      child: icone == null
          ? FilledButton(onPressed: acao, style: estilo, child: rotulo)
          : FilledButton.icon(
              onPressed: acao,
              style: estilo,
              icon: Icon(icone),
              label: rotulo,
            ),
    );
  }
}

/// Selo pequeno, usado pra marcar "vale em Santa Catarina".
class Selo extends StatelessWidget {
  final String texto;
  final Color cor;

  /// Fundo cheio em vez de tingido. Para o que não pode passar batido.
  final bool forte;

  const Selo(this.texto, {super.key, this.cor = corBoia, this.forte = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: forte ? 9 : 8, vertical: 4),
      decoration: BoxDecoration(
        color: forte ? cor : cor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        texto.toUpperCase(),
        style: TextStyle(
          fontSize: forte ? 11 : 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.9,
          color: forte ? Colors.white : cor,
        ),
      ),
    );
  }
}

/// Mostra um texto realçando os marcadores de área que a norma usa:
/// faixas de estado como "(ES ao PR)" e códigos de região como "S/SE".
///
/// Não interpreta e não deduz nada — só destaca o que já está escrito
/// no texto da norma, para o trecho que define onde a regra vale não
/// se perder no meio do parágrafo.
class TextoComArea extends StatelessWidget {
  final String texto;
  final TextStyle estilo;

  const TextoComArea({super.key, required this.texto, required this.estilo});

  static final RegExp _marca = RegExp(
    // classe de água, junto com o código de região que vier colado
    r'(?:Mar territorial|ZEE|Águas internacionais|Águas interiores'
    r'|Águas continentais|Águas jurisdicionais brasileiras)'
    r'(?:\s+(?:N/NE/SE|N/NE|S/SE|SE/S|NE|SE|N|S))?'
    // faixa de estados entre parênteses: (ES ao PR), (CE a BA)
    r'|\([A-Z]{2}\s+ao?\s+[A-Z]{2}\)'
    // sigla de estado solta
    r'|\b(?:AC|AL|AP|AM|BA|CE|DF|ES|GO|MA|MT|MS|MG|PA|PB|PR|PE|PI|RJ|RN'
    r'|RS|RO|RR|SC|SP|SE|TO)\b'
    // distância e profundidade
    r'|\b\d+(?:\.\d+)?\s*(?:milhas? náuticas?|MN|metros|m|km|M)\b'
    // paralelo
    r"|\b\d+º\s*\d*'?\s*[NSns]\b",
  );

  @override
  Widget build(BuildContext context) {
    final partes = <TextSpan>[];
    var i = 0;
    for (final m in _marca.allMatches(texto)) {
      if (m.start > i) {
        partes.add(TextSpan(text: texto.substring(i, m.start)));
      }
      partes.add(TextSpan(
        text: m.group(0),
        style: const TextStyle(fontWeight: FontWeight.w700, color: corMar),
      ));
      i = m.end;
    }
    if (i < texto.length) partes.add(TextSpan(text: texto.substring(i)));
    return RichText(text: TextSpan(style: estilo, children: partes));
  }
}

/// Título de seção dentro de uma tela.
class TituloSecao extends StatelessWidget {
  final String texto;
  const TituloSecao(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(texto, style: estiloSubtitulo),
    );
  }
}

/// Bloco de texto longo que começa fechado, com "ver mais".
/// Serve para as listas gigantes de espécie da IN 10.
class TextoDobravel extends StatefulWidget {
  final String titulo;
  final String texto;

  /// Realça os marcadores de área do texto da norma.
  final bool realcarArea;

  const TextoDobravel({
    super.key,
    required this.titulo,
    required this.texto,
    this.realcarArea = false,
  });

  @override
  State<TextoDobravel> createState() => _TextoDobravelState();
}

class _TextoDobravelState extends State<TextoDobravel> {
  bool aberto = false;

  @override
  Widget build(BuildContext context) {
    final curto = widget.texto.length <= 150;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: corSuperficie,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: corBorda),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.titulo.toUpperCase(), style: estiloEtiqueta),
            const SizedBox(height: 6),
            Builder(builder: (context) {
              final mostrar = curto || aberto
                  ? widget.texto
                  : '${widget.texto.substring(0, 140)}…';
              const estilo = TextStyle(
                fontSize: 15,
                height: 1.45,
                color: corTinta,
              );
              return widget.realcarArea
                  ? TextoComArea(texto: mostrar, estilo: estilo)
                  : Text(mostrar, style: estilo);
            }),
            if (!curto) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => setState(() => aberto = !aberto),
                child: Text(
                  aberto ? 'Mostrar menos' : 'Ver a lista inteira',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: corMar,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
