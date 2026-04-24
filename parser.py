from lexico import estadoComentario, estadoParenteses

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
