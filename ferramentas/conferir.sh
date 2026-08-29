#!/bin/bash
# Roda todas as conferências antes de publicar. Se qualquer uma falhar,
# não publique — mesmo que o Flutter compile.
#
#   cd pode_pescar && bash ferramentas/conferir.sh
cd "$(dirname "$0")/.." || exit 1
cd ..
falhou=0
echo "== 1. parênteses e chaves"
python3 pode_pescar/ferramentas/checar.py pode_pescar/lib/*.dart | grep -v "^   ok" && falhou=1
echo "== 2. argumentos repetidos no mesmo construtor"
python3 pode_pescar/ferramentas/duplicados.py pode_pescar/lib/*.dart || falhou=1
echo "== 3. nomes que colidem entre arquivos importados juntos"
python3 pode_pescar/ferramentas/colisoes.py | tail -1
echo "== 4. caracteres invisíveis"
python3 pode_pescar/ferramentas/limpar.py | tail -1
echo "== 5. coerência do que o app afirma"
python3 pode_pescar/ferramentas/coerencia.py || falhou=1
echo
[ $falhou -eq 0 ] && echo "TUDO CERTO" || echo "TEM FALHA — não publique"
exit $falhou
