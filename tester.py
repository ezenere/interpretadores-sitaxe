import argparse, os, sys
from common import *
from parser import parseArquivo
from runner import executarExpressao, Memory, History

# ── Cores ANSI ──────────────────────────────────────────────────
RESET  = '\033[0m'
BOLD   = '\033[1m'
DIM    = '\033[2m'
GREEN  = '\033[32m'
YELLOW = '\033[33m'
BLUE   = '\033[34m'
CYAN   = '\033[36m'
RED    = '\033[31m'
MAGENTA = '\033[35m'

MATH_SYMBOLS = {
    T_MATH_PLUS: '+', T_MATH_MINUS: '-', T_MATH_TIMES: '*',
    T_MATH_FLOAT_DIV: '/', T_MATH_INT_DIV: '//', T_MATH_MODULLUS: '%',
    T_MATH_EXPONENTIAL: '^',
}

MATH_NAMES = {
    T_MATH_PLUS: 'Soma', T_MATH_MINUS: 'Subtração', T_MATH_TIMES: 'Multiplicação',
    T_MATH_FLOAT_DIV: 'Divisão', T_MATH_INT_DIV: 'Divisão inteira',
    T_MATH_MODULLUS: 'Módulo', T_MATH_EXPONENTIAL: 'Exponenciação',
}


# ── Reconstruir expressão original a partir dos tokens ──────────
def reconstruir(tokens):
    parts = []
    for token in tokens:
        if token.kind == T_L_PARENTHESIS:
            parts.append('(')
        elif token.kind == T_R_PARENTHESIS:
            parts.append(')')
        elif token.kind == T_INT:
            parts.append(str(token.value))
        elif token.kind == T_FLOAT:
            parts.append(str(token.value))
        elif token.kind in [T_MATH_PLUS, T_MATH_MINUS, T_MATH_TIMES, T_MATH_FLOAT_DIV, T_MATH_INT_DIV, T_MATH_MODULLUS, T_MATH_EXPONENTIAL]:
            parts.append(T_MATH_PLUS.__str__())
        elif token.kind == T_VAR:
            parts.append(token.value)
        elif token.value == T_KW_RES:
            parts.append('RES')

    result = ''
    for i, p in enumerate(parts):
        if p == '(':
            result += '(' if not result or result[-1] == '(' else ' ('
        elif p == ')':
            result += ')'
        else:
            result += p if result and result[-1] == '(' else ' ' + p

    return result.strip()


# ── Display de tokens (parse tree) ─────────────────────────────
def exibirParsed(parsed):
    espacos = ''
    for token in parsed:
        if token.kind == T_L_PARENTHESIS or T_R_PARENTHESIS:
            if token.value == T_L_PARENTHESIS:
                print(f'{DIM}{espacos}({RESET}')
                espacos += '  '
            else:
                espacos = espacos[:-2]
                print(f'{DIM}{espacos}){RESET}')
        elif token.kind == [T_MATH_PLUS, T_MATH_MINUS, T_MATH_TIMES, T_MATH_FLOAT_DIV, T_MATH_INT_DIV, T_MATH_MODULLUS, T_MATH_EXPONENTIAL]:
            sym = MATH_SYMBOLS.get(token.value, '?')
            name = MATH_NAMES.get(token.value, '?')
            print(f'{espacos}{YELLOW}Operador: {BOLD}{sym}{RESET} {DIM}({name}){RESET}')
        elif token.kind == T_KW_RES:
            print(f'{espacos}{MAGENTA}Keyword: {BOLD}RES{RESET}')
        elif token.kind == T_FLOAT:
            print(f'{espacos}{CYAN}Float: {BOLD}{token.value}{RESET}')
        elif token.kind == T_INT:
            print(f'{espacos}{CYAN}Int: {BOLD}{token.value}{RESET}')
        elif token.kind == T_VAR:
            print(f'{espacos}{GREEN}Variável: {BOLD}{token.value}{RESET}')
        elif token.kind == T_KW_RES:
            print(f'{espacos}{RED}OPERAÇÃO{RESET}')


# ── Formatar valor de saída ────────────────────────────────────
def formatarValor(v):
    if isinstance(v, float):
        if v == float('inf'):
            return 'inf'
        if v == float('-inf'):
            return '-inf'
        if v != v:  # NaN
            return 'NaN'
        if v == int(v) and abs(v) < 1e15:
            return str(int(v))
    return str(v)


# ── Linha separadora ──────────────────────────────────────────
def separador(char='─', width=60):
    print(f'{DIM}{char * width}{RESET}')


# ── Executar e exibir linha a linha ────────────────────────────
def executarDebugando(parsed):
    memory = Memory()
    history = History()
    total = len(parsed)
    max_digits = len(str(total))

    separador('═')
    print(f'{BOLD}  Execução ({total} expressões){RESET}')
    separador('═')
    print()

    for idx, expression in enumerate(parsed):
        num = str(idx + 1).rjust(max_digits)
        expr_str = reconstruir(expression)
        prev_len = len(history.heap)

        executarExpressao(expression, memory, history)

        if len(history.heap) > prev_len:
            result = history.heap[-1]
            result_str = formatarValor(result)
            print(f'  {DIM}{num}{RESET} │ {expr_str}')
            print(f'  {" " * max_digits} │ {GREEN}= {BOLD}{result_str}{RESET}')
        else:
            print(f'  {DIM}{num}{RESET} │ {expr_str}')
            print(f'  {" " * max_digits} │ {DIM}(sem resultado){RESET}')
        print()

    return memory, history


# ── Exibir memória ─────────────────────────────────────────────
def exibirMemoria(memory):
    if not memory.dict:
        return
    print()
    separador('═')
    print(f'{BOLD}  Variáveis em Memória{RESET}')
    separador('─')

    max_key = max(len(k) for k in memory.dict)
    for name, value in sorted(memory.dict.items()):
        print(f'  {GREEN}{name.ljust(max_key)}{RESET} │ {BOLD}{formatarValor(value)}{RESET}')

    separador('═')


# ── Exibir histórico ──────────────────────────────────────────
def exibirHistorico(history):
    if not history.heap:
        return
    print()
    separador('═')
    print(f'{BOLD}  Histórico de Resultados ({len(history.heap)} entradas){RESET}')
    separador('─')

    max_digits = len(str(len(history.heap)))
    for i, value in enumerate(history.heap):
        num = str(i).rjust(max_digits)
        print(f'  {DIM}{num}{RESET} │ {formatarValor(value)}')

    separador('═')


# ── Main ───────────────────────────────────────────────────────
if __name__ == '__main__':
    ap = argparse.ArgumentParser(description='Tester — Analisador e executor de expressões RPN')
    ap.add_argument('file', help='Arquivo de expressões a testar')
    ap.add_argument('-t', '--tokens', action='store_true', help='Exibir árvore de tokens')
    ap.add_argument('-m', '--memory', action='store_true', help='Exibir memória ao final')
    ap.add_argument('--history', action='store_true', help='Exibir histórico completo ao final')
    ap.add_argument('--no-color', action='store_true', help='Desabilitar cores ANSI')

    args = ap.parse_args()

    if args.no_color:
        RESET = BOLD = DIM = GREEN = YELLOW = BLUE = CYAN = RED = MAGENTA = ''

    if not os.path.exists(args.file):
        print(f'{RED}Erro: o arquivo "{args.file}" não existe!{RESET}')
        sys.exit(1)

    parsed = parseArquivo(args.file)

    if args.tokens:
        separador('═')
        print(f'{BOLD}  Tokens{RESET}')
        separador('═')
        for i, expression in enumerate(parsed):
            print(f'\n  {DIM}Expressão {i + 1}:{RESET}')
            exibirParsed(expression)
        print()

    memory, history = executarDebugando(parsed)

    if args.memory:
        exibirMemoria(memory)

    if args.history:
        exibirHistorico(history)

    if not args.memory and not args.history:
        exibirMemoria(memory)

    print()
