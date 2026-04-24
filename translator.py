import argparse, struct, os, sys
from common import *
from parser import *

def numeroParaARMv7(number):
    raw = struct.pack('>d', float(number))
    hi, lo = struct.unpack(">II", raw)

    return f"""
    @ Carregar {number} em d0 (IEEE 754: 0x{hi:08X}{lo:08X})
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x{lo:08X}
    @ segunda parte do d0
    LDR     r1, =0x{hi:08X}
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1
"""

adicionarParaAListaDaMemoria = f"""
    @ Adicionar para a memória
    BL   memory_push
"""

pegarUmNumero = """
    @ Coloca a memória em d0
    BL   memory_pop
"""

pegarDoisNumeros = """
    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop
"""

def keywordRES(nRES):
    return f"""
    BL              memory_pop
    VCVT.S32.F64    s0, d0
    VMOV            r1, s0
    ADD             r1, r1, #{1 + nRES}
    MOV             r0, r11
    LSL             r1, r1, #3  @ Multiplica por 8 (desloca 3 bits para a esquerda, dá no mesmo)
    SUB             r0, r0, r1
    VLDR            d0, [r0]
    BL  memory_push
"""

def operacaoMatematica(operation):
    diretas = {
        MATH_PLUS: "ADD",
        MATH_MINUS: "SUB",
        MATH_TIMES: "MUL",
        MATH_FLOAT_DIV: "DIV"
    }
    
    if operation in [MATH_PLUS, MATH_MINUS, MATH_TIMES, MATH_FLOAT_DIV]:
        return f"""
    V{diretas[operation]}.F64 d0, d0, d1
"""
    elif operation == MATH_INT_DIV:
        return """
    BL  fintd
"""
    elif operation == MATH_MODULLUS:
        return """
    BL  fmod
"""
    elif operation == MATH_EXPONENTIAL:
        return """
    BL  fpow
"""

def definirValorNoEndereco(address):
    return f"""
    LDR     r0, =0x{address:08X}    @ Colocar o valor do endereço no registrador r0
    VSTR    d0, [r0]                @ Mover o valor do registrador d0 para o endereço em r0 (8 bytes)
"""

def pegarValorNoEndereco(address):
    return f"""
    LDR     r0, =0x{address:08X}    @ Colocar o valor do endereço no registrador r0
    VLDR    d0, [r0]                @ Ler o valor do edereço em r0 para d0 (8 bytes)
"""

def traduzirParaARMv7(parsed):
    middle_code = ""
    variable_address = 0x00010000
    variables = {}

    for expression in parsed:
        vezesRes = 0
        for i in range(len(expression)):
            token = expression[i]
            if token.kind == PARENTHESES:
                continue
            if token.kind == INT or token.kind == FLOAT:
                # Adiciona número na pilha de variáveis
                middle_code += numeroParaARMv7(token.value)
                middle_code += adicionarParaAListaDaMemoria

            if token.kind == MATH:
                middle_code += pegarDoisNumeros
                middle_code += operacaoMatematica(token.value)
                middle_code += adicionarParaAListaDaMemoria
            if token.kind == VARIABLE:
                if i == len(expression) - 2: # Penultimo item, significa que é uma atribuição ou uma leitura. O ultimo token sempre é ")".
                    if len(expression) > 3:
                        # Tem item na pilha da expressão, então é atribuição 
                        if token.value not in variables:
                            variable_address += 8
                            variables[token.value] = variable_address

                        current_address = variables[token.value]
                        middle_code += pegarUmNumero
                        middle_code += definirValorNoEndereco(current_address)
                        middle_code += adicionarParaAListaDaMemoria
                    else:
                        # Não tem item na pilha de atribuição, então é apenas leitura
                        # Em assembly, se a variável existir, ela será apenas inserida na pilha de resultados, 
                        # se não existir, o valor 0 é inserido na pilha.
                        if token.value not in variables:
                            middle_code += numeroParaARMv7(0)
                        else:
                            middle_code += pegarValorNoEndereco(variables[token.value])
                        middle_code += adicionarParaAListaDaMemoria
                else:
                    if token.value not in variables:
                        middle_code += numeroParaARMv7(0)
                    else:
                        middle_code += pegarValorNoEndereco(variables[token.value])
                    middle_code += adicionarParaAListaDaMemoria

            if token.kind == KEYWORD:
                if(token.value == KEYWORD_RES):
                    middle_code += keywordRES(vezesRes)
                    vezesRes += 1

    return f"""
@ Endereço base da memória de pilha de resultados
.equ MEMORY_BASE, 0x10000000

.text
.global _start

_start:
    @ Configurar o coprocesssador para trabalhar com pontos flutuantes de 64 bits.
    MRC     p15, 0, r0, c1, c0, 2
    ORR     r0, r0, #(0xF << 20)
    MCR     p15, 0, r0, c1, c0, 2
    
    @ Esperar a sincronização do CPU 
    ISB

    @ Habilita o controle de exceção do VFP
    MOV r0, #(1 << 30)
    VMSR FPEXC, r0

    @ Habilitar a stack de valores de operadores e de memória
    LDR     r11, =MEMORY_BASE

    {middle_code}

    halt:
    B       halt

memory_push:
    VSTR    d0, [r11]
    ADD     r11, r11, #8
    BX      lr

memory_pop:
    SUB     r11, r11, #8
    VLDR    d0, [r11]
    BX      lr

fintd:
    VDIV.F64        d2, d0, d1       @ d2 = valor da divisão float
    VCVT.S32.F64    s0, d2           @ s0 = trunca pra inteiro 32 bits
    VCVT.F64.S32    d0, s0           @ d0 = volta pra double
    BX              lr

fmod:
    VDIV.F64        d2, d0, d1
    VCVT.S32.F64    s0, d2
    VCVT.F64.S32    d2, s0
    VMUL.F64        d2, d2, d1
    VSUB.F64        d0, d0, d2
    BX              lr

fpow:
    VMOV.F64     d2, d0          @ d2 = base (salva)
    VCVT.S32.F64 s0, d1          @ s0 = expoente como inteiro
    VMOV         r4, s0          @ r4 = contador

    @ d0 = 1.0 (acumulador, começa em 1 pq 1 * base * base... = base^n)
    LDR          r0, =0x00000000
    LDR          r1, =0x3FF00000
    VMOV         d0, r0, r1

fpow_loop:
    CMP          r4, #0
    BLE          fpow_done      @ volta quando a comparação retornar <= 0 (para casos com expoente negativo)
    VMUL.F64     d0, d0, d2     @ d0 = d0 * base
    SUB          r4, r4, #1
    B            fpow_loop

fpow_done:
    BX           lr
"""

if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument("file", help="O arquivo que você deseja traduzir")

    args = ap.parse_args()

    if not os.path.exists(args.file):
        print("Erro: o arquivo não existe!")
        sys.exit(1)

    parsed = parseArquivo(args.file)
    code = traduzirParaARMv7(parsed)

    print(code)
