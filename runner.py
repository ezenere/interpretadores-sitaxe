from common import *

class Memory:
    def __init__(self):
        self.dict = {}

    def set(self, name, val):
        self.dict[name] = val

    def get(self, name):
        if name not in self.dict:
            return 0.0
        return self.dict[name]

class History:
    def __init__(self):
        self.heap = []
    
    def add(self, value):
        self.heap.append(value)

    def get(self, index):
        if index < 0 or index >= len(self.heap):
            return 0.0
        return self.heap[-(index + 1)]

def executarMatematica(v1, v2, op):
    if op == T_MATH_PLUS:
        data = v1 + v2
    if op == T_MATH_MINUS:
        data = v1 - v2
    if op == T_MATH_TIMES:
        data = v1 * v2
    if op == T_MATH_FLOAT_DIV:
        data = float(v1) / float(v2) if v2 != 0 else float('inf')
    if op == T_MATH_INT_DIV:
        data = v1 // v2 if v2 != 0 else float('inf')
    if op == T_MATH_MODULLUS:
        data = v1 % v2 if v2 != 0 else float('inf')
    if op == T_MATH_EXPONENTIAL:
        data = v1 ** v2
    return data

def executarExpressao(expression, memory, history):
    pile = []
    for i in range(len(expression)):
        token = expression[i]
        if token.kind in [T_L_PARENTHESIS, T_R_PARENTHESIS]:
            continue
        if token.kind in [T_INT,  T_FLOAT]:
            pile.append(token.value)
        if token.kind in [T_MATH_PLUS, T_MATH_MINUS, T_MATH_TIMES, T_MATH_FLOAT_DIV, T_MATH_INT_DIV, T_MATH_MODULLUS, T_MATH_EXPONENTIAL]:
            a = pile.pop()
            b = pile.pop()
            result = executarMatematica(b, a, token.value)
            pile.append(result)
        if token.kind == T_VAR:
            if i == len(expression) - 2:
                if len(pile) == 1:
                    value = pile.pop()
                    memory.set(token.value, value)
                    pile.append(value)
                else:
                    pile.append(memory.get(token.value))
                    print(pile[-1])
            else:
                pile.append(memory.get(token.value))

        if token.kind == T_KW_RES:
            pile.append(history.get(pile.pop()))

    if len(pile) > 0:
        history.add(pile.pop())

def executar(expressions):
    memory = Memory()
    history = History()

    for expression in expressions:
        executarExpressao(expression, memory, history)

    return memory.dict, history.heap
