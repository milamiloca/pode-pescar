# As conferências

O Flutter diz se o código **compila**. Estas ferramentas dizem se o que o
aplicativo **afirma** está de pé. São coisas diferentes, e a segunda é a
que importa num app usado para autuar.

    cd pode_pescar && bash ferramentas/conferir.sh

## O que cada uma faz

| Ferramenta | O que pega |
|---|---|
| `checar.py` | parênteses, chaves e colchetes desequilibrados |
| `duplicados.py` | o mesmo campo escrito duas vezes num construtor |
| `colisoes.py` | nomes iguais em arquivos importados juntos |
| `simbolos2.py` | símbolos usados e não definidos |
| `limpar.py` | caracteres invisíveis |
| `imports.py` | imports sem uso e arquivos órfãos |
| **`coerencia.py`** | **se o que o app afirma é verdade** |

## Por que a última existe

Ela nasceu de um erro real. O painel de próximas viradas escrevia
**"ABRE Tainha"** no dia 16 de setembro — porque naquele dia termina o
fechamento das desembocaduras estuarino-lagunares.

Só que a tainha não abre em 16 de setembro. A temporada de cerco fechou
em 31 de julho, e outras quatro regras seguem proibindo naquela data. A
frase era a resposta permissiva: a que libera quem deveria ser autuado.

Todos os outros validadores passaram, porque sintaticamente a frase
estava perfeita. Quem pegou foi uma pessoa lendo a tela.

`coerencia.py` existe para que ninguém precise pegar isso de novo no
olho. Ela confere, entre outras coisas:

- que toda data existe no calendário, e que a conversão dia ↔ data
  fecha nos 365 dias;
- que **nenhuma "abertura" é anunciada sem o aviso** de que a espécie
  segue restrita por outra regra — hoje isso vale para 10 das 20
  aberturas do ano, metade delas;
- que os verbos descrevem a **regra**, não a pescaria;
- que nenhum período confirmado cita "norma a obter", e nenhum período a
  confirmar cita artigo como se fosse conferido;
- que toda regra declara para qual estado vale.

## A regra de bolso

Compilar não é o mesmo que estar certo. Rode `conferir.sh` antes de
publicar, e se a coerência falhar, não publique — mesmo com o Flutter
verde.
