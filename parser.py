from common import T
from lexico import estadoComentario, estadoParenteses
from sintatico import FINAL_TABLE, PRODUCTIONS, NT_SYM, T_SYM, S

def parse(expr):
    tokens = parseExpressao(expr)
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

# Início do estado principal (expressão inteira / indice ativo)
def parseExpressao(expr, index = 0):
    # Se a expressão acabar, então a expressão não acabou em um estado aceitável, então erro.
    if index == len(expr):
        raise Exception('Expressão inacabada.')

    # Se for espaço, ignore e vá pro próximo indice
    if expr[index] == ' ':
        return parseExpressao(expr, index + 1)
    
    # Se for abre parenteses, vá para o estado de abertura de parênteses
    if expr[index] == '(':
        return estadoParenteses(expr, index, [], 0)
    
    # Se for # entra em estado de comentário
    if expr[index] == '#':
        return estadoComentario(expr, index, [])
        
    # Se não for nada acima, estado de erro por caractere não reconhecido 
    raise Exception(f"Caractere não reconhecido '{expr[index]}'")

def parseListaExpressao(expressions):
    return [v for v in [parseExpressao(expression) for expression in expressions] if len(v) > 0]

def parseArquivo(file):
    with open(file, "r", encoding="utf-8") as f:
        return parseListaExpressao([linha.strip() for linha in f if linha.strip()])
