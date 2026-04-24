# Constantes que representam os valores dos tokens
PARENTHESES = 1
PARENTHESES_L = 1
PARENTHESES_R = 2

MATH = 2
MATH_PLUS = 1
MATH_MINUS = 2
MATH_TIMES = 3
MATH_FLOAT_DIV = 4
MATH_INT_DIV = 5
MATH_MODULLUS = 6
MATH_EXPONENTIAL = 7

KEYWORD = 3
KEYWORD_RES = 1

FLOAT = 4
INT = 5

VARIABLE = 6

OPERATION = 7

# Classe de tokens
class Token:
    def __init__(self, kind, value):
        self.kind = kind
        self.value = value
