
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

    
    @ Carregar 42 em d0 (IEEE 754: 0x4045000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40450000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 3.14 em d0 (IEEE 754: 0x40091EB851EB851F)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x51EB851F
    @ segunda parte do d0
    LDR     r1, =0x40091EB8
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 0 em d0 (IEEE 754: 0x0000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x00000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar -7.5 em d0 (IEEE 754: 0xC01E000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0xC01E0000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 3 em d0 (IEEE 754: 0x4008000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40080000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 4 em d0 (IEEE 754: 0x4010000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40100000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VADD.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 1.5 em d0 (IEEE 754: 0x3FF8000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x3FF80000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 2.5 em d0 (IEEE 754: 0x4004000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40040000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VADD.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 0 em d0 (IEEE 754: 0x0000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x00000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 0 em d0 (IEEE 754: 0x0000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x00000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VADD.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar -3 em d0 (IEEE 754: 0xC008000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0xC0080000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 3 em d0 (IEEE 754: 0x4008000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40080000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VADD.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 10 em d0 (IEEE 754: 0x4024000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40240000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 3 em d0 (IEEE 754: 0x4008000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40080000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VSUB.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 0 em d0 (IEEE 754: 0x0000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x00000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 5 em d0 (IEEE 754: 0x4014000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40140000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VSUB.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 2.5 em d0 (IEEE 754: 0x4004000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40040000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 1.5 em d0 (IEEE 754: 0x3FF8000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x3FF80000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VSUB.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 6 em d0 (IEEE 754: 0x4018000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40180000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 7 em d0 (IEEE 754: 0x401C000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x401C0000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VMUL.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 0.5 em d0 (IEEE 754: 0x3FE0000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x3FE00000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 4 em d0 (IEEE 754: 0x4010000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40100000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VMUL.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 0 em d0 (IEEE 754: 0x0000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x00000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 999 em d0 (IEEE 754: 0x408F380000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x408F3800
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VMUL.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar -3 em d0 (IEEE 754: 0xC008000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0xC0080000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar -3 em d0 (IEEE 754: 0xC008000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0xC0080000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VMUL.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 10 em d0 (IEEE 754: 0x4024000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40240000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 3 em d0 (IEEE 754: 0x4008000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40080000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VDIV.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 7 em d0 (IEEE 754: 0x401C000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x401C0000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 2 em d0 (IEEE 754: 0x4000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VDIV.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 1 em d0 (IEEE 754: 0x3FF0000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x3FF00000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 0 em d0 (IEEE 754: 0x0000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x00000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VDIV.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 10 em d0 (IEEE 754: 0x4024000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40240000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 3 em d0 (IEEE 754: 0x4008000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40080000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    BL  fintd

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 7 em d0 (IEEE 754: 0x401C000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x401C0000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 2 em d0 (IEEE 754: 0x4000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    BL  fintd

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar -7 em d0 (IEEE 754: 0xC01C000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0xC01C0000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 2 em d0 (IEEE 754: 0x4000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    BL  fintd

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 10 em d0 (IEEE 754: 0x4024000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40240000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 3 em d0 (IEEE 754: 0x4008000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40080000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    BL  fmod

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 7 em d0 (IEEE 754: 0x401C000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x401C0000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 2 em d0 (IEEE 754: 0x4000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    BL  fmod

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 9 em d0 (IEEE 754: 0x4022000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40220000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 3 em d0 (IEEE 754: 0x4008000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40080000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    BL  fmod

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 2 em d0 (IEEE 754: 0x4000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 10 em d0 (IEEE 754: 0x4024000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40240000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    BL  fpow

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 5 em d0 (IEEE 754: 0x4014000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40140000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 0 em d0 (IEEE 754: 0x0000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x00000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    BL  fpow

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 3 em d0 (IEEE 754: 0x4008000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40080000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 3 em d0 (IEEE 754: 0x4008000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40080000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    BL  fpow

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 2.5 em d0 (IEEE 754: 0x4004000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40040000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 2 em d0 (IEEE 754: 0x4000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    BL  fpow

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 3 em d0 (IEEE 754: 0x4008000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40080000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 4 em d0 (IEEE 754: 0x4010000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40100000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 5 em d0 (IEEE 754: 0x4014000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40140000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VADD.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VMUL.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 10 em d0 (IEEE 754: 0x4024000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40240000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 2 em d0 (IEEE 754: 0x4000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VDIV.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 3 em d0 (IEEE 754: 0x4008000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40080000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VADD.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 2 em d0 (IEEE 754: 0x4000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 3 em d0 (IEEE 754: 0x4008000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40080000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VADD.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 4 em d0 (IEEE 754: 0x4010000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40100000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 1 em d0 (IEEE 754: 0x3FF0000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x3FF00000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VSUB.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VMUL.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 8 em d0 (IEEE 754: 0x4020000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40200000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 2 em d0 (IEEE 754: 0x4000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VDIV.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 3 em d0 (IEEE 754: 0x4008000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40080000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 1 em d0 (IEEE 754: 0x3FF0000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x3FF00000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VADD.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VSUB.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 2 em d0 (IEEE 754: 0x4000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 3 em d0 (IEEE 754: 0x4008000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40080000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VADD.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 4 em d0 (IEEE 754: 0x4010000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40100000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 5 em d0 (IEEE 754: 0x4014000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40140000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VMUL.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 2 em d0 (IEEE 754: 0x4000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VDIV.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VADD.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 1 em d0 (IEEE 754: 0x3FF0000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x3FF00000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 2 em d0 (IEEE 754: 0x4000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VADD.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 3 em d0 (IEEE 754: 0x4008000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40080000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 4 em d0 (IEEE 754: 0x4010000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40100000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VADD.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VMUL.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 5 em d0 (IEEE 754: 0x4014000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40140000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VSUB.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 2 em d0 (IEEE 754: 0x4000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 3 em d0 (IEEE 754: 0x4008000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40080000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    BL  fpow

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 1 em d0 (IEEE 754: 0x3FF0000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x3FF00000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 1 em d0 (IEEE 754: 0x3FF0000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x3FF00000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VADD.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VMUL.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 4 em d0 (IEEE 754: 0x4010000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40100000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VDIV.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 1 em d0 (IEEE 754: 0x3FF0000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x3FF00000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 1 em d0 (IEEE 754: 0x3FF0000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x3FF00000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VADD.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 2 em d0 (IEEE 754: 0x4000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VMUL.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 3 em d0 (IEEE 754: 0x4008000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40080000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VMUL.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 4 em d0 (IEEE 754: 0x4010000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40100000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VMUL.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 3.14 em d0 (IEEE 754: 0x40091EB851EB851F)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x51EB851F
    @ segunda parte do d0
    LDR     r1, =0x40091EB8
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em d0
    BL   memory_pop

    LDR     r0, =0x00010008    @ Colocar o valor do endereço no registrador r0
    VSTR    d0, [r0]                @ Mover o valor do registrador d0 para o endereço em r0 (8 bytes)

    @ Adicionar para a memória
    BL   memory_push

    LDR     r0, =0x00010008    @ Colocar o valor do endereço no registrador r0
    VLDR    d0, [r0]                @ Ler o valor do edereço em r0 para d0 (8 bytes)

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 2.718 em d0 (IEEE 754: 0x4005BE76C8B43958)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0xC8B43958
    @ segunda parte do d0
    LDR     r1, =0x4005BE76
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em d0
    BL   memory_pop

    LDR     r0, =0x00010010    @ Colocar o valor do endereço no registrador r0
    VSTR    d0, [r0]                @ Mover o valor do registrador d0 para o endereço em r0 (8 bytes)

    @ Adicionar para a memória
    BL   memory_push

    LDR     r0, =0x00010010    @ Colocar o valor do endereço no registrador r0
    VLDR    d0, [r0]                @ Ler o valor do edereço em r0 para d0 (8 bytes)

    @ Adicionar para a memória
    BL   memory_push

    LDR     r0, =0x00010008    @ Colocar o valor do endereço no registrador r0
    VLDR    d0, [r0]                @ Ler o valor do edereço em r0 para d0 (8 bytes)

    @ Adicionar para a memória
    BL   memory_push

    LDR     r0, =0x00010010    @ Colocar o valor do endereço no registrador r0
    VLDR    d0, [r0]                @ Ler o valor do edereço em r0 para d0 (8 bytes)

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VADD.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 9.81 em d0 (IEEE 754: 0x40239EB851EB851F)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x51EB851F
    @ segunda parte do d0
    LDR     r1, =0x40239EB8
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em d0
    BL   memory_pop

    LDR     r0, =0x00010018    @ Colocar o valor do endereço no registrador r0
    VSTR    d0, [r0]                @ Mover o valor do registrador d0 para o endereço em r0 (8 bytes)

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 100 em d0 (IEEE 754: 0x4059000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40590000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em d0
    BL   memory_pop

    LDR     r0, =0x00010020    @ Colocar o valor do endereço no registrador r0
    VSTR    d0, [r0]                @ Mover o valor do registrador d0 para o endereço em r0 (8 bytes)

    @ Adicionar para a memória
    BL   memory_push

    LDR     r0, =0x00010020    @ Colocar o valor do endereço no registrador r0
    VLDR    d0, [r0]                @ Ler o valor do edereço em r0 para d0 (8 bytes)

    @ Adicionar para a memória
    BL   memory_push

    LDR     r0, =0x00010018    @ Colocar o valor do endereço no registrador r0
    VLDR    d0, [r0]                @ Ler o valor do edereço em r0 para d0 (8 bytes)

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VMUL.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 0 em d0 (IEEE 754: 0x0000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x00000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 10 em d0 (IEEE 754: 0x4024000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40240000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 20 em d0 (IEEE 754: 0x4034000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40340000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 0 em d0 (IEEE 754: 0x0000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x00000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    BL              memory_pop
    VCVT.S32.F64    s0, d0
    VMOV            r1, s0
    
    MOV             r0, r11
    LSL             r1, r1, #3  @ Multiplica por 8 (desloca 3 bits para a esquerda, dá no mesmo)
    SUB             r0, r0, r1
    VLDR            d0, [r0]
    BX              lr
    BL  memory_push

    @ Carregar 1 em d0 (IEEE 754: 0x3FF0000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x3FF00000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    BL              memory_pop
    VCVT.S32.F64    s0, d0
    VMOV            r1, s0
    
    MOV             r0, r11
    LSL             r1, r1, #3  @ Multiplica por 8 (desloca 3 bits para a esquerda, dá no mesmo)
    SUB             r0, r0, r1
    VLDR            d0, [r0]
    BX              lr
    BL  memory_push

    @ Carregar 2 em d0 (IEEE 754: 0x4000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    BL              memory_pop
    VCVT.S32.F64    s0, d0
    VMOV            r1, s0
    
    MOV             r0, r11
    LSL             r1, r1, #3  @ Multiplica por 8 (desloca 3 bits para a esquerda, dá no mesmo)
    SUB             r0, r0, r1
    VLDR            d0, [r0]
    BX              lr
    BL  memory_push

    @ Carregar 5 em d0 (IEEE 754: 0x4014000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40140000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 3 em d0 (IEEE 754: 0x4008000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40080000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 1 em d0 (IEEE 754: 0x3FF0000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x3FF00000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    BL              memory_pop
    VCVT.S32.F64    s0, d0
    VMOV            r1, s0
    
    MOV             r0, r11
    LSL             r1, r1, #3  @ Multiplica por 8 (desloca 3 bits para a esquerda, dá no mesmo)
    SUB             r0, r0, r1
    VLDR            d0, [r0]
    BX              lr
    BL  memory_push

    @ Carregar 0 em d0 (IEEE 754: 0x0000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x00000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    BL              memory_pop
    VCVT.S32.F64    s0, d0
    VMOV            r1, s0
    
    LDR             r0, =1
    SUB             r1, r1, r0

    MOV             r0, r11
    LSL             r1, r1, #3  @ Multiplica por 8 (desloca 3 bits para a esquerda, dá no mesmo)
    SUB             r0, r0, r1
    VLDR            d0, [r0]
    BX              lr
    BL  memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VADD.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 1 em d0 (IEEE 754: 0x3FF0000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x3FF00000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em d0
    BL   memory_pop

    LDR     r0, =0x00010028    @ Colocar o valor do endereço no registrador r0
    VSTR    d0, [r0]                @ Mover o valor do registrador d0 para o endereço em r0 (8 bytes)

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 5 em d0 (IEEE 754: 0x4014000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40140000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em d0
    BL   memory_pop

    LDR     r0, =0x00010030    @ Colocar o valor do endereço no registrador r0
    VSTR    d0, [r0]                @ Mover o valor do registrador d0 para o endereço em r0 (8 bytes)

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 6 em d0 (IEEE 754: 0x4018000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40180000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em d0
    BL   memory_pop

    LDR     r0, =0x00010038    @ Colocar o valor do endereço no registrador r0
    VSTR    d0, [r0]                @ Mover o valor do registrador d0 para o endereço em r0 (8 bytes)

    @ Adicionar para a memória
    BL   memory_push

    LDR     r0, =0x00010030    @ Colocar o valor do endereço no registrador r0
    VLDR    d0, [r0]                @ Ler o valor do edereço em r0 para d0 (8 bytes)

    @ Adicionar para a memória
    BL   memory_push

    LDR     r0, =0x00010030    @ Colocar o valor do endereço no registrador r0
    VLDR    d0, [r0]                @ Ler o valor do edereço em r0 para d0 (8 bytes)

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VMUL.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 0 em d0 (IEEE 754: 0x0000000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x00000000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    BL              memory_pop
    VCVT.S32.F64    s0, d0
    VMOV            r1, s0
    
    MOV             r0, r11
    LSL             r1, r1, #3  @ Multiplica por 8 (desloca 3 bits para a esquerda, dá no mesmo)
    SUB             r0, r0, r1
    VLDR            d0, [r0]
    BX              lr
    BL  memory_push

    @ Carregar 4 em d0 (IEEE 754: 0x4010000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x40100000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    LDR     r0, =0x00010028    @ Colocar o valor do endereço no registrador r0
    VLDR    d0, [r0]                @ Ler o valor do edereço em r0 para d0 (8 bytes)

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VMUL.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    LDR     r0, =0x00010038    @ Colocar o valor do endereço no registrador r0
    VLDR    d0, [r0]                @ Ler o valor do edereço em r0 para d0 (8 bytes)

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VMUL.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    VSUB.F64 d0, d0, d1

    @ Adicionar para a memória
    BL   memory_push

    @ Carregar 1 em d0 (IEEE 754: 0x3FF0000000000000)
    @ Adicionar valor de 64 bits em r0, r1:
    @ primeira parte do d0
    LDR     r0, =0x00000000
    @ segunda parte do d0
    LDR     r1, =0x3FF00000
    @ Integralizar o valor r0, r1 em d0
    VMOV d0, r0, r1

    @ Adicionar para a memória
    BL   memory_push

    @ Coloca a memória em D0
    BL   memory_pop

    @ Coloca o d0 em d1
    VMOV.F64 d1, d0

    @ Coloca a outra memória d0
    BL  memory_pop

    BL  fpow

    @ Adicionar para a memória
    BL   memory_push


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
