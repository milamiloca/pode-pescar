import io, re, glob, os, sys

LIB = 'pode_pescar/lib'
fonte = {os.path.basename(p): io.open(p, encoding='utf-8').read()
         for p in sorted(glob.glob(LIB + '/*.dart'))}
tudo = '\n'.join(fonte.values())

definidos = set()
definidos |= set(re.findall(r'\bclass\s+(\w+)', tudo))
definidos |= set(re.findall(r'\benum\s+(\w+)', tudo))
definidos |= set(re.findall(r'^(?:final|const)\s+(?:\w[\w<>?, ]*\s+)?(\w+)\s*=',
                            tudo, re.M))
definidos |= set(re.findall(r'^[\w<>?, ]+\s+(\w+)\s*\(', tudo, re.M))
definidos |= set(re.findall(r'\bfinal\s+[\w<>?, ]+\s+(\w+)\s*;', tudo))
definidos |= set(re.findall(r'\b(\w+)\s*:', tudo))          # nomes de parâmetro
definidos |= set(re.findall(r'\bget\s+(\w+)', tudo))
definidos |= set(re.findall(r'\bthis\.(\w+)', tudo))
definidos |= set(re.findall(r'\bvar\s+(\w+)', tudo))
definidos |= set(re.findall(r'\bfor\s*\(\s*(?:final|var)\s+(\w+)', tudo))

flutter = set('''
Widget StatelessWidget StatefulWidget State BuildContext Text TextStyle
TextSpan RichText Container Column Row Padding Center Scaffold AppBar
ListView SizedBox EdgeInsets BoxDecoration BorderRadius Border Colors
Color FontWeight TextAlign FontStyle CrossAxisAlignment MainAxisAlignment
MaterialPageRoute Navigator AspectRatio CustomPaint Builder RegExp String
int double bool List Set Map DateTime Icons Icon InkWell Material
MaterialApp ThemeData Expanded Flexible Wrap Stack Positioned Divider
Opacity Transform ClipRRect SingleChildScrollView TextField
TextEditingController FocusNode Clipboard ClipboardData ScaffoldMessenger
SnackBar Theme IconButton GestureDetector BoxConstraints ConstrainedBox
Align Spacer Duration Curves CustomPainter Path Paint Canvas Size Offset
Rect Radius StrokeCap PaintingStyle StrokeJoin TextPainter TextDirection
TextDecoration TextInputType InputDecoration Key ValueKey VoidCallback
ValueChanged WidgetsFlutterBinding Brightness ColorScheme AppBarTheme
TextButton FilledButton OutlinedButton ButtonStyle WidgetStateProperty
MediaQuery Alignment LinearGradient BoxShadow Object Iterable Comparable
num Function Future void dynamic override required const final
'''.split())

conhecidos = definidos | flutter
alvos = sys.argv[1:] or ['tela_ameacadas.dart']
falta = {}
for nome in alvos:
    src = fonte[nome]
    # tira strings e comentários
    limpo = re.sub(r"'(?:[^'\\]|\\.)*'", "''", src)
    limpo = re.sub(r'//[^\n]*', '', limpo)
    usados = set(re.findall(r'\b([A-Z]\w+)\b', limpo))
    usados |= set(re.findall(r'\b((?:cor|estilo)[A-Z]\w*)\b', limpo))
    usados |= set(re.findall(r'\b(lista\w+|grupos\w+|classes\w+|especies|'
                             r'semAcento|dias\w+)\b', limpo))
    f = sorted(u for u in usados if u not in conhecidos)
    if f:
        falta[nome] = f

for nome in alvos:
    print(f'{nome}: {falta.get(nome) or "todos os simbolos conferem"}')
