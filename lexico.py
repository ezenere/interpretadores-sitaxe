# Importar itens comuns
from common import *

def estadoComentario(expr, index, tokens):
    if index == len(expr):
        return tokens
    
    return estadoComentario(expr, index + 1, tokens)

def estadoFim(expr, index, tokens):
    if index == len(expr):
        return tokens
    
    if expr[index] == ' ':
        return estadoFim(expr, index + 1, tokens)
    
    if expr[index] == '#':
        return estadoComentario(expr, index, tokens)

    raise Exception(f"Caractere não reconhecido '{expr[index]}'")

def estadoOperadorDivisaoInteira(expr, index, tokens, parentheses):
    if index == len(expr):
        raise Exception('Expressão inacabada.')

    if expr[index] in " )":
        tokens.append(Token(index, T_MATH_INT_DIV))
        return estadoParenteses(expr, index, tokens, parentheses)

    raise Exception(f"Caractere não reconhecido '{expr[index]}'")

def estadoOperadorUnico(expr, index, tokens, parentheses, token):
    if index == len(expr):
        raise Exception('Expressão inacabada.')

    if expr[index] == '/':
        return estadoOperadorDivisaoInteira(expr, index + 1, tokens, parentheses)

    if expr[index] in " )" and token == '+':
        tokens.append(Token(index, T_MATH_PLUS))
        return estadoParenteses(expr, index, tokens, parentheses)

    if expr[index] in " )" and token == '-':
        tokens.append(Token(index, T_MATH_MINUS))
        return estadoParenteses(expr, index, tokens, parentheses)

    if expr[index] in " )" and token == '*':
        tokens.append(Token(index, T_MATH_TIMES))
        return estadoParenteses(expr, index, tokens, parentheses)

    if expr[index] in " )" and token == '/':
        tokens.append(Token(index, T_MATH_FLOAT_DIV))
        return estadoParenteses(expr, index, tokens, parentheses)

    if expr[index] in " )" and token == '%':
        tokens.append(Token(index, T_MATH_MODULLUS))
        return estadoParenteses(expr, index, tokens, parentheses)

    if expr[index] in " )" and token == '^':
        tokens.append(Token(index, T_MATH_EXPONENTIAL))
        return estadoParenteses(expr, index, tokens, parentheses)

    raise Exception(f"Caractere não reconhecido '{expr[index]}'")

def estadoPonto(expr, index, tokens, parentheses, token):
    if index == len(expr):
        raise Exception('Expressão inacabada.')

    if expr[index] in "0123456789":
        token += expr[index]
        return estadoPontoFlutuante(expr, index + 1, tokens, parentheses, token)
    
    raise Exception(f"Caractere não reconhecido '{expr[index]}'")

def estadoPontoFlutuante(expr, index, tokens, parentheses, token):
    if index == len(expr):
        raise Exception('Expressão inacabada.')

    if expr[index] in "0123456789":
        token += expr[index]
        return estadoPontoFlutuante(expr, index + 1, tokens, parentheses, token)

    if expr[index] in ' )':
        tokens.append(Token(index, T_FLOAT, float(token)))
        return estadoParenteses(expr, index, tokens, parentheses)

    raise Exception(f"Caractere não reconhecido '{expr[index]}'")

def estadoInteiro(expr, index, tokens, parentheses, token):
    if index == len(expr):
        raise Exception('Expressão inacabada.')

    if expr[index] in "0123456789":
        token += expr[index]
        return estadoInteiro(expr, index + 1, tokens, parentheses, token)
    
    if expr[index] == '.':
        token += expr[index]
        return estadoPonto(expr, index + 1, tokens, parentheses, token)

    if expr[index] in ' )':
        tokens.append(Token(index, T_INT, int(token)))
        return estadoParenteses(expr, index, tokens, parentheses)

    raise Exception(f"Caractere não reconhecido '{expr[index]}'")

def estadoPalavraComNumero(expr, index, tokens, parentheses, token):
    if index == len(expr):
        raise Exception('Expressão inacabada.')

    if expr[index] in 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_':
        return estadoPalavraComNumero(expr, index + 1, tokens, parentheses, token + expr[index])
    
    if expr[index] in ' )':
        tokens.append(Token(index, T_VAR, token))
        return estadoParenteses(expr, index, tokens, parentheses)

    raise Exception(f"Caractere não reconhecido '{expr[index]}'")

def estadoPalavra(expr, index, tokens, parentheses, token):
    if index == len(expr):
        raise Exception('Expressão inacabada.')

    if expr[index] in 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_':
        return estadoPalavraComNumero(expr, index + 1, tokens, parentheses, token + expr[index])

    if expr[index] in ' )':
        tokens.append(Token(index, T_VAR, token))
        return estadoParenteses(expr, index, tokens, parentheses)

    raise Exception(f"Caractere não reconhecido '{expr[index]}'")

def estadoKeywordR(expr, index, tokens, parentheses, token):
    if index == len(expr):
        raise Exception('Expressão inacabada.')

    if expr[index] == 'E':
        return estadoKeywordRE(expr, index + 1, tokens, parentheses, token + expr[index])

    if expr[index] in 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_':
        return estadoPalavraComNumero(expr, index + 1, tokens, parentheses, token + expr[index])

    if expr[index] in ' )':
        tokens.append(Token(index, T_VAR, token))
        return estadoParenteses(expr, index, tokens, parentheses)

    raise Exception(f"Caractere não reconhecido '{expr[index]}'")

def estadoKeywordRE(expr, index, tokens, parentheses, token):
    if index == len(expr):
        raise Exception('Expressão inacabada.')

    if expr[index] == 'S':
        return estadoKeywordRES(expr, index + 1, tokens, parentheses, token + expr[index])

    if expr[index] in 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_':
        return estadoPalavraComNumero(expr, index + 1, tokens, parentheses, token + expr[index])

    if expr[index] in ' )':
        tokens.append(Token(index, T_VAR, token))
        return estadoParenteses(expr, index, tokens, parentheses)

    raise Exception(f"Caractere não reconhecido '{expr[index]}'")

def estadoKeywordRES(expr, index, tokens, parentheses, token):
    if index == len(expr):
        raise Exception('Expressão inacabada.')

    if expr[index] in 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_':
        return estadoPalavraComNumero(expr, index + 1, tokens, parentheses, token + expr[index])

    if expr[index] in ' )':
        tokens.append(Token(index, T_KW_RES))
        return estadoParenteses(expr, index, tokens, parentheses)

    raise Exception(f"Caractere não reconhecido '{expr[index]}'")

def estadoMenosSolto(expr, index, tokens, parentheses, token):
    if index == len(expr):
        raise Exception('Expressão inacabada.')

    if expr[index] in "0123456789":
        return estadoInteiro(expr, index + 1, tokens, parentheses, token + expr[index])

    return estadoOperadorUnico(expr, index, tokens, parentheses, token)

# Estado de parenteses (expressão / indice atual / o array de tokens encontrado / equilíbrio de parênteses)
def estadoParenteses(expr, index, tokens, parentheses):
    # Se a expressão acabar, então a expressão não acabou em um estado aceitável, então erro.
    if index == len(expr):
        raise Exception('Expressão inacabada.')

    # Se for espaço, ignore e vá pro próximo indice
    if expr[index] == ' ':
        return estadoParenteses(expr, index + 1, tokens, parentheses)

    # Se for abre parenteses, vá para o estado de abertura de parênteses e incremente 
    # um parentese de abertura a mais, além de adiconar o parentese anterior aos tokens
    if expr[index] == '(':
        tokens.append(Token(index, T_L_PARENTHESIS))
        return estadoParenteses(expr, index + 1, tokens, parentheses + 1)

    # Se for um número, entrar em estado numérico
    if expr[index] in "0123456789":
        return estadoInteiro(expr, index + 1, tokens, parentheses, expr[index])

    # Se for R vai para o estado R[ES]
    if expr[index] == "R":
        return estadoKeywordR(expr, index + 1, tokens, parentheses, expr[index])

    # Se for letra ou _ vai para o estado de palavra
    if expr[index] in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_":
        return estadoPalavra(expr, index + 1, tokens, parentheses, expr[index])

    # Se for um ponto, entra direto em estado de float (aceita .número)
    if expr[index] == ".":
        return estadoPonto(expr, index + 1, tokens, parentheses, '0.')

    # Se for um menos, entra em estado de número negativo
    if expr[index] == "-":
        return estadoMenosSolto(expr, index + 1, tokens, parentheses, expr[index])

    # Se for operador, entra em estado de operador
    if expr[index] in ['+', '-', '*', '/', '%', '^']:
        return estadoOperadorUnico(expr, index + 1, tokens, parentheses, expr[index])
    
    # Se for fecha parênteses e ainda tiver parentese na stack, então entra em estado de 
    # parenteses com um token de parêntese fecha parenteses menos um token de parentese aberto
    if expr[index] == ')' and parentheses > 1:
        tokens.append(Token(index, T_R_PARENTHESIS))
        return estadoParenteses(expr, index + 1, tokens, parentheses - 1)

    # Se for fecha parêntese e tiver somente um parêntese na stack, então o estado vai para estado
    # de fim de expressão com um token de parêntese a mais.
    if expr[index] == ')' and parentheses == 1:
        tokens.append(Token(index, T_R_PARENTHESIS))
        return estadoFim(expr, index + 1, tokens)
    
    # Se não for nada acima, estado de erro por caractere não reconhecido 
    raise Exception(f"Caractere não reconhecido '{expr[index]}'")

def parseLexical(expr, index = 0):
    # Se a expressão acabar, então a expressão não acabou em um estado aceitável, então erro.
    if index == len(expr):
        raise Exception('Expressão inacabada.')

    # Se for espaço, ignore e vá pro próximo indice
    if expr[index] == ' ':
        return parseLexical(expr, index + 1)
    
    # Se for abre parenteses, vá para o estado de abertura de parênteses
    if expr[index] == '(':
        return estadoParenteses(expr, index, [], 0)
    
    # Se for # entra em estado de comentário
    if expr[index] == '#':
        return estadoComentario(expr, index, [])
        
    # Se não for nada acima, estado de erro por caractere não reconhecido 
    raise Exception(f"Caractere não reconhecido '{expr[index]}'")
