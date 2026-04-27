from common import T
from lexico import parseLexical
from sintatico import FINAL_TABLE, PRODUCTIONS, NT_SYM, T_SYM, S

def parseExpressao(expr):
    tokens = parseLexical(expr)
    if (len(tokens) == 0):
        raise Exception('Expressão vazia.')

    stack = [S]

    v = stack.pop(0)
    idx = 0
    while v != None and idx < len(tokens):
        if isinstance(v, T):
            if v == tokens[idx].kind:
                idx += 1
            else:
                err = f'Erro de sintaxe na posição {tokens[idx].index}, esperado {v}, encontrado {tokens[idx]}'
                raise Exception(err)
        else:
            if FINAL_TABLE[NT_SYM.index(v)][T_SYM.index(tokens[idx].kind)] is not None:
                stack = [*PRODUCTIONS[FINAL_TABLE[NT_SYM.index(v)][T_SYM.index(tokens[idx].kind)]][1], *stack]
            else:
                err = f'Erro de sintaxe na posição {tokens[idx].index}, esperado {v}, encontrado {tokens[idx]}'
                raise Exception(err)

            
        v = stack.pop(0)

    if len(tokens) - 1 > idx:
        err = f'Esperado fim do programa, encontrado {tokens[idx]}'
        raise Exception(err)
    
    return tokens

def parseListaExpressao(expressions):
    return [v for v in [parseExpressao(expression) for expression in expressions] if len(v) > 0]

def parseArquivo(file):
    with open(file, "r", encoding="utf-8") as f:
        return parseListaExpressao([linha.strip() for linha in f if linha.strip()])
