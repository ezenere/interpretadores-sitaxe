# Analisador Léxico e Interpretador RPN

Interpretador de uma linguagem baseada em **Notação Polonesa Reversa (RPN)** com suporte a operações aritméticas, manipulação de memória e tradução para **Assembly ARMv7**.

## Visão Geral

O projeto é composto por quatro módulos principais:

| Arquivo | Descrição |
|---|---|
| `common.py` | Constantes e classe `Token` usada por todos os módulos |
| `parser.py` | Analisador léxico — transforma expressões textuais em listas de tokens |
| `runner.py` | Interpretador — executa as expressões tokenizadas em Python |
| `translator.py` | Tradutor — gera código Assembly ARMv7 a partir dos tokens |
| `tester.py` | Ferramenta standalone de teste — parseia, exibe tokens e executa |
| `main.py` | CLI principal com todos os modos de uso integrados |

## Sintaxe da Linguagem

As expressões seguem o formato RPN `(A B op)`, onde `A` e `B` são números reais de 64 bits (IEEE 754) e `op` é um operador.

### Operadores Aritméticos

| Operador | Descrição | Exemplo |
|---|---|---|
| `+` | Adição | `(3 4 +)` → `7` |
| `-` | Subtração | `(10 3 -)` → `7` |
| `*` | Multiplicação | `(6 7 *)` → `42` |
| `/` | Divisão real | `(7 2 /)` → `3.5` |
| `//` | Divisão inteira | `(7 2 //)` → `3` |
| `%` | Resto da divisão | `(10 3 %)` → `1` |
| `^` | Potenciação | `(2 10 ^)` → `1024` |

### Aninhamento

Expressões podem ser aninhadas sem limite de profundidade:

```
(3 (4 5 +) *)               → 3 * (4+5) = 27
((2 3 +) (4 1 -) *)         → (2+3) * (4-1) = 15
((2 3 +) ((4 5 *) 2 /) +)   → (2+3) + ((4*5)/2) = 15
```

### Comandos Especiais

| Comando | Descrição | Exemplo |
|---|---|---|
| `(V MEM)` | Armazena o valor `V` na variável `MEM` | `(3.14 PI)` armazena `3.14` em `PI` |
| `(MEM)` | Retorna o valor armazenado em `MEM` (ou `0.0` se não inicializada) | `(PI)` → `3.14` |
| `(N RES)` | Retorna o resultado de `N` linhas anteriores | `(0 RES)` → último resultado |

Nomes de variáveis podem ser qualquer combinação de letras maiúsculas (ex: `MEM`, `VAR`, `X`, `MASSA`). `RES` é a única keyword reservada da linguagem.

### Comentários

Linhas iniciadas com `#` são ignoradas:

```
# Isso é um comentário
(3 4 +)   # Comentário inline também funciona
```

## Instalação

Nenhuma dependência externa é necessária — apenas **Python 3.6+**.

```bash
git clone https://github.com/ezenere/iterpretadores-lexico.git
cd iterpretadores-lexico
```

## Uso

### CLI Principal (`main.py`)

```bash
# Executar um arquivo
python main.py -r arquivo.rpn
python main.py --run arquivo.rpn

# Exibir tokens parseados
python main.py -p arquivo.rpn
python main.py --parse arquivo.rpn

# Traduzir para Assembly ARMv7 (saída no terminal)
python main.py -t arquivo.rpn
python main.py --translate arquivo.rpn

# Traduzir e salvar em arquivo
python main.py -t arquivo.rpn -o saida.s
python main.py --translate arquivo.rpn --output saida.s

# Modo interativo (REPL)
python main.py -i
python main.py --interactive
```

### Modo Interativo

O modo interativo (`-i`) abre um REPL onde cada expressão é parseada e executada na hora. A memória e o histórico persistem entre linhas, permitindo usar `RES` e variáveis normalmente. Se uma linha contiver erro de sintaxe, o REPL imprime a mensagem de erro e continua.

```
$ python main.py -i
Modo interativo — digite expressões RPN (Ctrl+C ou "sair" para sair)

>>> (3 4 +)
= 7
>>> (0 RES)
= 7
>>> (7 X)
= 7
>>> ((X) (X) *)
= 49
>>> (isso vai dar erro
Erro: Expressão inacabada.
>>> (2 3 +)
= 5
>>> sair
Saindo...
```

### Ferramentas Standalone

#### Tester (`tester.py`)

Executa o arquivo linha a linha, exibindo cada expressão com seu resultado formatado e as variáveis em memória ao final:

```bash
# Execução padrão (resultados + memória)
python tester.py test/phase1.rpn

# Com árvore de tokens detalhada
python tester.py test/phase1.rpn -t

# Com histórico completo de RES
python tester.py test/phase1.rpn --history

# Exibir memória explicitamente
python tester.py test/phase1.rpn -m

# Tudo junto
python tester.py test/phase1.rpn -t -m --history

# Sem cores ANSI (para redirecionar a saída)
python tester.py test/phase1.rpn --no-color > resultado.txt
```

Exemplo de saída:

```
════════════════════════════════════════════════════════════
  Execução (4 expressões)
════════════════════════════════════════════════════════════

  1 │ (3 4 +)
    │ = 7

  2 │ (3.14 PI)
    │ = 3.14

  3 │ ((PI) 2 *)
    │ = 6.28

  4 │ (0 RES)
    │ = 6.28

════════════════════════════════════════════════════════════
  Variáveis em Memória
────────────────────────────────────────────────────────────
  PI │ 3.14
════════════════════════════════════════════════════════════
```

#### Translator (`translator.py`)

Parseia o arquivo e imprime o código Assembly ARMv7 gerado no terminal:

```bash
python translator.py test/phase1.rpn
```

## Testes

A pasta `test/` contém arquivos de teste organizados por fase:

```
test/
├── phase1.rpn    # Operações básicas, aninhamento, MEM, RES
├── phase2.rpn    # Testes adicionais
└── phase3.rpn    # Testes avançados
```

### Executando os testes

```bash
# Rodar os testes da Fase 1
python main.py -r test/phase1.rpn

# Ver os tokens parseados da Fase 1
python main.py -p test/phase1.rpn

# Traduzir a Fase 1 para Assembly
python main.py -t test/phase1.rpn -o phase1.s

# Usando as ferramentas standalone
python tester.py test/phase1.rpn
python translator.py test/phase1.rpn
```

## Arquitetura

```
                    ┌──────────────┐
  arquivo.rpn ────▶ │   parser.py  │ ────▶ Lista de Tokens
                    └──────────────┘
                           │
              ┌────────────┴────────────┐
              ▼                         ▼
     ┌──────────────┐         ┌────────────────┐
     │   runner.py  │         │ translator.py  │
     │ (interpreta) │         │ (gera ARMv7)   │
     └──────────────┘         └────────────────┘
              │                         │
              ▼                         ▼
     Memória + Histórico        Código Assembly
```

1. O **parser** (`parser.py`) implementa um autômato de estados que percorre a expressão caractere a caractere, gerando uma lista flat de `Token`.
2. O **runner** (`runner.py`) percorre os tokens usando uma pilha, executando operações, gerenciando memória nomeada (`MEM`) e histórico de resultados (`RES`).
3. O **translator** (`translator.py`) percorre os mesmos tokens e emite instruções ARMv7 equivalentes, usando registradores VFP (`d0`, `d1`) para operações IEEE 754 de 64 bits.

## Validação — Fase 1

O interpretador foi validado com mais de 100 testes cobrindo:

- Todos os operadores (`+`, `-`, `*`, `/`, `//`, `%`, `^`)
- Aninhamento profundo (10+ níveis)
- Árvore binária simétrica
- `MEM` (gravar, ler, sobrescrever)
- `RES` (cadeia, incremental, dentro de expressões)
- IEEE 754 (infinito, NaN, imprecisão de float)
- RPN flat e aninhado
- Fibonacci e cascata quadrática como "programas"

## Dados
Instituição: Pontifícia Universidade Católica do Paraná
Disciplina: Construção de Interpretadores
Professor: Frank Alcantara
Aluno: Eduardo Zenere de Oliveira - ezenere


## Licença

Este projeto é de uso acadêmico.