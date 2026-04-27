class Token:
    def __init__(self, index, kind, value = None):
        self.index = index
        self.kind = kind
        self.value = value

    def __str__(self):
        return f"{self.kind}({self.value})" if self.value is not None else f"{self.kind}"

class T:
    def __init__(self, value):
        self.value = value
    
    def __eq__(self, value):
        if isinstance(value, str):
            return self.value == value

        if not isinstance(value, T):
            return False
        
        return self.value == value.value
    
    def __str__(self):
        return self.value
    
    def __repr__(self):
        return self.__str__()

class NT:
    def __init__(self, value):
        self.value = value

    def __eq__(self, value):
        if not isinstance(value, NT):
            return False

        return self.value == value.value
    
    def __str__(self):
        return self.value
    
    def __repr__(self):
        return self.__str__()

# Terminal
T_L_PARENTHESIS =       T('(')
T_R_PARENTHESIS =       T(')')
T_MATH_PLUS =           T('+')
T_MATH_MINUS =          T('-')
T_MATH_TIMES =          T('*')
T_MATH_FLOAT_DIV =      T('/')
T_MATH_INT_DIV =        T('//')
T_MATH_MODULLUS =       T('%')
T_MATH_EXPONENTIAL =    T('^')
T_VAR =                 T('VAR')
T_INT =                 T('INT')
T_FLOAT =               T('FLOAT')
T_KW_RES =              T('RES')
T_EOF =                 T('$')
T_EMPTY =               T('empty')

T_SYM = [
    T_L_PARENTHESIS,
    T_R_PARENTHESIS,
    T_MATH_PLUS,
    T_MATH_MINUS,
    T_MATH_TIMES,
    T_MATH_FLOAT_DIV,
    T_MATH_INT_DIV,
    T_MATH_MODULLUS,
    T_MATH_EXPONENTIAL,
    T_VAR,
    T_INT,
    T_FLOAT,
    T_KW_RES,
]


# Não Terminal
S =                     NT('Start')
NT_COMP =               NT('Comp')
NT_OPT_COMP =           NT('OptComp')
NT_OPERAND =            NT('Operador')
NT_NUMBER =             NT('Number')
NT_ARG =                NT('Argument')
NT_REST =               NT('Rest')
NT_BODY =               NT('Body')

NT_SYM = [
    S,
    NT_COMP,
    NT_OPT_COMP,
    NT_OPERAND,
    NT_NUMBER,
    NT_ARG,
    NT_REST,
    NT_BODY
]

# Produções
PRODUCTIONS = [
    [S,             [T_L_PARENTHESIS, NT_ARG, NT_COMP, T_R_PARENTHESIS, T_EOF]],        # 1

    [NT_COMP,       [NT_ARG, NT_OPT_COMP]],                                             # 2
    [NT_COMP,       [T_KW_RES]],                                                        # 3

    [NT_OPT_COMP,   [NT_OPERAND]],                                                      # 4
    [NT_OPT_COMP,   []],                                                                # 5

    [NT_BODY,       [NT_ARG, NT_REST]],                                                 # 6

    [NT_REST,       [NT_ARG, NT_OPERAND]],                                              # 7
    [NT_REST,       [T_KW_RES]],                                                        # 8

    [NT_ARG,        [T_L_PARENTHESIS, NT_BODY, T_R_PARENTHESIS]],                       # 9
    [NT_ARG,        [NT_NUMBER]],                                                       # 10

    [NT_OPERAND,    [T_MATH_PLUS]],                                                     # 11
    [NT_OPERAND,    [T_MATH_MINUS]],                                                    # 12
    [NT_OPERAND,    [T_MATH_TIMES]],                                                    # 13
    [NT_OPERAND,    [T_MATH_FLOAT_DIV]],                                                # 14
    [NT_OPERAND,    [T_MATH_INT_DIV]],                                                  # 15
    [NT_OPERAND,    [T_MATH_MODULLUS]],                                                 # 16
    [NT_OPERAND,    [T_MATH_EXPONENTIAL]],                                              # 17
    [NT_NUMBER,     [T_FLOAT]],                                                         # 18
    [NT_NUMBER,     [T_INT]],                                                           # 19
    [NT_NUMBER,     [T_VAR]],                                                           # 20
]
