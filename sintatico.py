from common import *

# ================================================================
# GRAMÁTICA LL(1) PARA A LINGUAGEM RPN
# ================================================================
#
#  Program   ->Expr Program | ε
#  Expr      ->'(' Body ')'
#  Body      ->Operand BodyRest
#  BodyRest  ->NonVarOp Operator          -- binário: (A B op)
#             | VAR VarTail               -- atribuição ou 2º operando VAR
#             | RES                       -- acesso a histórico: (N RES)
#             | ε                         -- valor único: (A)
#  VarTail   ->Operator                   -- era 2º operando: (A VAR op)
#             | ε                         -- era atribuição: (A VAR)
#  Operand   ->INT | FLOAT | VAR | Expr
#  NonVarOp  ->INT | FLOAT | Expr         -- 2º operando não-VAR
#  Operator  ->'+' | '-' | '*' | '/' | '//' | '%' | '^'
#
# O conflito VAR em BodyRest é resolvido por VarTail:
#   se depois do VAR vier ')' ->atribuição (VarTail ->ε)
#   se depois do VAR vier operador ->2º operando (VarTail ->Operator)
# ================================================================

# ---- Não-terminais ----
NT_PROGRAM  = 'Program'
NT_EXPR     = 'Expr'
NT_BODY     = 'Body'
NT_BODYREST = 'BodyRest'
NT_VARTAIL  = 'VarTail'
NT_OPERAND  = 'Operand'
NT_NONVAROP = 'NonVarOp'
NT_OPERATOR = 'Operator'

NON_TERMINALS = [
    NT_PROGRAM, NT_EXPR, NT_BODY, NT_BODYREST,
    NT_VARTAIL, NT_OPERAND, NT_NONVAROP, NT_OPERATOR,
]

# ---- Terminais como (kind, value); value=None = qualquer valor desse kind ----
T_LPAREN = (PARENTHESES, PARENTHESES_L)
T_RPAREN = (PARENTHESES, PARENTHESES_R)
T_PLUS   = (MATH, MATH_PLUS)
T_MINUS  = (MATH, MATH_MINUS)
T_TIMES  = (MATH, MATH_TIMES)
T_FDIV   = (MATH, MATH_FLOAT_DIV)
T_IDIV   = (MATH, MATH_INT_DIV)
T_MOD    = (MATH, MATH_MODULLUS)
T_EXP    = (MATH, MATH_EXPONENTIAL)
T_RES    = (KEYWORD, KEYWORD_RES)
T_INT    = (INT, None)
T_FLOAT  = (FLOAT, None)
T_VAR    = (VARIABLE, None)
T_EOF    = ('$', None)

TERMINAL_NAMES = {
    T_LPAREN: '(',  T_RPAREN: ')', T_PLUS: '+',  T_MINUS: '-',
    T_TIMES:  '*',  T_FDIV:   '/', T_IDIV: '//', T_MOD:   '%',
    T_EXP:    '^',  T_RES:   'RES', T_INT: 'INT', T_FLOAT: 'FLOAT',
    T_VAR:   'VAR', T_EOF:   '$',
}

def terminal_name(sym):
    return TERMINAL_NAMES.get(sym, str(sym))

# ---- Produções (índice, lhs, rhs) ----
PRODUCTIONS = [
    (NT_PROGRAM,  [NT_EXPR, NT_PROGRAM]),            # 0
    (NT_PROGRAM,  []),                               # 1  ε
    (NT_EXPR,     [T_LPAREN, NT_BODY, T_RPAREN]),    # 2
    (NT_BODY,     [NT_OPERAND, NT_BODYREST]),        # 3
    (NT_BODYREST, [NT_NONVAROP, NT_OPERATOR]),       # 4
    (NT_BODYREST, [T_VAR, NT_VARTAIL]),              # 5
    (NT_BODYREST, [T_RES]),                          # 6
    (NT_BODYREST, []),                               # 7  ε
    (NT_VARTAIL,  [NT_OPERATOR]),                    # 8
    (NT_VARTAIL,  []),                               # 9  ε
    (NT_OPERAND,  [T_INT]),                          # 10
    (NT_OPERAND,  [T_FLOAT]),                        # 11
    (NT_OPERAND,  [T_VAR]),                          # 12
    (NT_OPERAND,  [NT_EXPR]),                        # 13
    (NT_NONVAROP, [T_INT]),                          # 14
    (NT_NONVAROP, [T_FLOAT]),                        # 15
    (NT_NONVAROP, [NT_EXPR]),                        # 16
    (NT_OPERATOR, [T_PLUS]),                         # 17
    (NT_OPERATOR, [T_MINUS]),                        # 18
    (NT_OPERATOR, [T_TIMES]),                        # 19
    (NT_OPERATOR, [T_FDIV]),                         # 20
    (NT_OPERATOR, [T_IDIV]),                         # 21
    (NT_OPERATOR, [T_MOD]),                          # 22
    (NT_OPERATOR, [T_EXP]),                          # 23
]

def is_nt(sym):
    return sym in NON_TERMINALS

def token_to_terminal(tok):
    """Converte um Token do léxico para o terminal da gramática."""
    if tok is None:
        return T_EOF
    if tok.kind == INT:
        return T_INT
    if tok.kind == FLOAT:
        return T_FLOAT
    if tok.kind == VARIABLE:
        return T_VAR
    if tok.kind == PARENTHESES:
        return T_LPAREN if tok.value == PARENTHESES_L else T_RPAREN
    if tok.kind == MATH:
        return (MATH, tok.value)
    if tok.kind == KEYWORD and tok.value == KEYWORD_RES:
        return T_RES
    raise Exception(f"Token desconhecido: kind={tok.kind}, value={tok.value}")


# ================================================================
# FIRST / FOLLOW
# ================================================================

def compute_first(productions, non_terminals):
    """Calcula FIRST para todos os não-terminais. None representa ε."""
    first = {nt: set() for nt in non_terminals}
    changed = True
    while changed:
        changed = False
        for lhs, rhs in productions:
            before = frozenset(first[lhs])
            if not rhs:
                first[lhs].add(None)
            else:
                for sym in rhs:
                    if not is_nt(sym):
                        first[lhs].add(sym)
                        break
                    first[lhs] |= (first[sym] - {None})
                    if None not in first[sym]:
                        break
                else:
                    first[lhs].add(None)
            if frozenset(first[lhs]) != before:
                changed = True
    return first

def first_of_seq(seq, first):
    """FIRST de uma sequência de símbolos gramaticais."""
    result = set()
    for sym in seq:
        if not is_nt(sym):
            result.add(sym)
            return result
        result |= (first[sym] - {None})
        if None not in first[sym]:
            return result
    result.add(None)
    return result

def compute_follow(productions, non_terminals, first, start):
    """Calcula FOLLOW para todos os não-terminais."""
    follow = {nt: set() for nt in non_terminals}
    follow[start].add(T_EOF)
    changed = True
    while changed:
        changed = False
        for lhs, rhs in productions:
            for i, sym in enumerate(rhs):
                if not is_nt(sym):
                    continue
                before = frozenset(follow[sym])
                rest_first = first_of_seq(rhs[i + 1:], first)
                follow[sym] |= (rest_first - {None})
                if None in rest_first:
                    follow[sym] |= follow[lhs]
                if frozenset(follow[sym]) != before:
                    changed = True
    return follow


# ================================================================
# TABELA LL(1)
# ================================================================

def build_table(productions, first, follow):
    """Constrói a tabela de parsing LL(1). Retorna (tabela, conflitos)."""
    table = {}
    conflicts = []
    for i, (lhs, rhs) in enumerate(productions):
        for sym in first_of_seq(rhs, first):
            if sym is not None:
                key = (lhs, sym)
                if key in table:
                    conflicts.append((key, table[key], i))
                else:
                    table[key] = i
        if None in first_of_seq(rhs, first):
            for sym in follow[lhs]:
                key = (lhs, sym)
                if key in table:
                    conflicts.append((key, table[key], i))
                else:
                    table[key] = i
    return table, conflicts


# ================================================================
# NÓ DA ÁRVORE DE DERIVAÇÃO
# ================================================================

class ParseNode:
    def __init__(self, symbol, token=None):
        self.symbol   = symbol
        self.token    = token
        self.children = []

    def pretty(self, indent=0):
        prefix = '  ' * indent
        if is_nt(self.symbol):
            label = self.symbol
        elif self.token is not None:
            label = f"{terminal_name(self.symbol)}({self.token.value})"
        else:
            label = terminal_name(self.symbol)
        lines = [prefix + label]
        for child in self.children:
            lines.append(child.pretty(indent + 1))
        return '\n'.join(lines)


# ================================================================
# ANALISADOR SINTÁTICO LL(1)
# ================================================================

class LL1Parser:
    def __init__(self):
        self.first  = compute_first(PRODUCTIONS, NON_TERMINALS)
        self.follow = compute_follow(PRODUCTIONS, NON_TERMINALS, self.first, NT_PROGRAM)
        self.table, self.conflicts = build_table(
            PRODUCTIONS, self.first, self.follow
        )

    # ------------------------------------------------------------------ análise

    def parse(self, tokens):
        """
        Recebe lista de Token (saída do léxico) e retorna a raiz da árvore
        de derivação. Lança Exception em caso de erro sintático.
        """
        pos = 0

        def peek():
            tok = tokens[pos] if pos < len(tokens) else None
            return token_to_terminal(tok)

        def consume():
            nonlocal pos
            tok = tokens[pos] if pos < len(tokens) else None
            pos += 1
            return tok

        def match(sym):
            la = peek()
            if la == sym:
                return ParseNode(sym, consume())
            raise Exception(
                f"esperado '{terminal_name(sym)}', encontrado '{terminal_name(la)}'"
            )

        def parse_sym(sym):
            if not is_nt(sym):
                return match(sym)

            la  = peek()
            key = (sym, la)
            if key not in self.table:
                raise Exception(
                    f"<{sym}>: símbolo '{terminal_name(la)}' inesperado"
                )

            _, rhs = PRODUCTIONS[self.table[key]]
            node   = ParseNode(sym)
            for child_sym in rhs:
                node.children.append(parse_sym(child_sym))
            return node

        root = parse_sym(NT_PROGRAM)
        if peek() != T_EOF:
            raise Exception(
                f"tokens inesperados após fim da expressão: '{terminal_name(peek())}'"
            )
        return root

    # ------------------------------------------------------------------ exibição

    def _fmt_set(self, s):
        parts = sorted('eps' if x is None else terminal_name(x) for x in s)
        return '{ ' + ', '.join(parts) + ' }'

    def _rhs_str(self, rhs):
        if not rhs:
            return 'eps'
        return ' '.join(s if is_nt(s) else terminal_name(s) for s in rhs)

    def print_first_follow(self):
        w = max(len(nt) for nt in NON_TERMINALS)
        sep = '=' * 60

        print(sep)
        print('FIRST sets')
        print(sep)
        for nt in NON_TERMINALS:
            print(f"  FIRST({nt:{w}}) = {self._fmt_set(self.first[nt])}")

        print()
        print(sep)
        print('FOLLOW sets')
        print(sep)
        for nt in NON_TERMINALS:
            print(f"  FOLLOW({nt:{w}}) = {self._fmt_set(self.follow[nt])}")

    def print_table(self):
        # Terminais que aparecem na tabela, ordenados
        all_terms = sorted(set(t for (_, t) in self.table), key=terminal_name)

        nt_w  = max(len(nt) for nt in NON_TERMINALS) + 1
        col_w = 26

        total_w = nt_w + col_w * len(all_terms)
        sep = '=' * total_w

        print()
        print(sep)
        print('TABELA LL(1) -- Parsing Table')
        print(sep)

        header = f"{'NT':{nt_w}}" + ''.join(
            f"{terminal_name(t):{col_w}}" for t in all_terms
        )
        print(header)
        print('-' * total_w)

        for nt in NON_TERMINALS:
            row = f"{nt:{nt_w}}"
            for t in all_terms:
                key = (nt, t)
                if key in self.table:
                    _, rhs = PRODUCTIONS[self.table[key]]
                    cell = f"{nt} ->{self._rhs_str(rhs)}"
                else:
                    cell = ''
                row += f"{cell:{col_w}}"
            print(row)

        print()
        if self.conflicts:
            print('CONFLITOS DETECTADOS:')
            for key, p1, p2 in self.conflicts:
                nt, sym = key
                print(f"  M[{nt}, {terminal_name(sym)}]: prod {p1} × prod {p2}")
        else:
            print('Sem conflitos -- gramatica e LL(1).')

    def print_productions(self):
        sep = '=' * 50
        print(sep)
        print('PRODUCOES')
        print(sep)
        for i, (lhs, rhs) in enumerate(PRODUCTIONS):
            print(f"  {i:>2}. {lhs} ->{self._rhs_str(rhs)}")


# ================================================================
# INTERFACE PÚBLICA
# ================================================================

def parsear(tokens):
    """Parse de uma lista de Tokens e retorna a árvore de derivação."""
    return LL1Parser().parse(tokens)

def analisar(tokens, mostrar_arvore=False, mostrar_tabela=True):
    """
    Parse completo com exibição de FIRST/FOLLOW, tabela e resultado.
    Retorna (arvore | None).
    """
    parser = LL1Parser()

    if mostrar_tabela:
        parser.print_productions()
        print()
        parser.print_first_follow()
        parser.print_table()
        print()

    try:
        tree = parser.parse(tokens)
        print("Analise sintatica: OK")
        if mostrar_arvore:
            print()
            print("Árvore de derivação:")
            print(tree.pretty())
        return tree
    except Exception as e:
        print(f"Analise sintatica: ERRO -- {e}")
        return None
