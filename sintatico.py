from parser import parseExpressao
from common import NT, T, S, PRODUCTIONS, T_EMPTY, T_EOF, T_SYM, NT_SYM

def find_all_productions_of(SYM: NT):
    return [t[1] for t in PRODUCTIONS if t[0] == SYM]

def find_all_productions_including(SYM: NT):
    return [t for t in PRODUCTIONS if SYM in t[1]]

def is_end(SYM, prod):
    return prod.index(SYM) == len(prod) - 1

def get_after(SYM, prod):
    return [i for i in prod[prod.index(SYM)+1:]]

def remove_empty(items):
    return [i for i in items if i != T_EMPTY]

def FIRST(SYM: NT):
    values = []

    productions = find_all_productions_of(SYM)

    for production in productions:
        if len(production) == 0:
            values.append(T_EMPTY)

        for item in production:
            if isinstance(item, NT):
                it_f = FIRST(item)
                values.extend(it_f)
                if not T_EMPTY in it_f:
                    break
            else:
                values.append(item)
                break

    final = []
    for i in values:
        if i not in final:
            final.append(i)

    return final

def FOLLOW(SYM: NT):
    if SYM == S:
        return [T_EOF]

    productions = find_all_productions_including(SYM)
    values = []

    for nt, prod in productions:
        if is_end(SYM, prod):
            values.extend(remove_empty(FOLLOW(nt)))
            continue

        after = get_after(SYM, prod)

        finish_empty = True
        for it in after:
            if isinstance(it, NT):
                it_f = FIRST(it)
                if T_EMPTY in it_f:
                   values.extend(remove_empty(it_f))
                   finish_empty = True
                else:
                    values.extend(it_f)
                    finish_empty = False
                    break
            else:
                values.append(it)
                finish_empty = False
                break
        
        if finish_empty:
            values.extend(remove_empty(FOLLOW(nt)))

    final = []
    for i in values:
        if i not in final:
            final.append(i)

    return final

FINAL_TABLE = [[None for _ in range(len(T_SYM))] for _ in range(len(NT_SYM))]

for idx in range(len(PRODUCTIONS)):
    nt, prod = PRODUCTIONS[idx]

    y = NT_SYM.index(nt)
    last_can_be_empty = True
    for sym in prod:
        if isinstance(sym, T):
            x = T_SYM.index(sym)
            if FINAL_TABLE[y][x] is not None:
                raise Exception('Erro: Produção conflitante!')
            FINAL_TABLE[y][x] = idx
            last_can_be_empty = False
            break
        elif isinstance(sym, NT):
            first = FIRST(sym)
            for f in first:
                if T_EMPTY == f:
                    continue
                x = T_SYM.index(f)
                if FINAL_TABLE[y][x] is not None:
                    raise Exception('Erro: Produção conflitante!')

                FINAL_TABLE[y][x] = idx
            if T_EMPTY not in first:
                last_can_be_empty = False
                break
            
    
    if last_can_be_empty:
        for f in FOLLOW(nt):
            x = T_SYM.index(f)
            if FINAL_TABLE[y][x] is not None:
                raise Exception('Erro: Produção conflitante!')
            FINAL_TABLE[y][x] = idx






def pretty_print_table():
    def prod_str(idx):
        nt, rhs = PRODUCTIONS[idx]
        body = ' '.join(str(s) for s in rhs) if rhs else 'empty'
        return f"{nt} -> {body}"

    # Constrói todas as strings das células
    cells = [
        [prod_str(FINAL_TABLE[y][x]) if FINAL_TABLE[y][x] is not None else ''
         for x in range(len(T_SYM))]
        for y in range(len(NT_SYM))
    ]

    # Largura da coluna de NTs
    nt_w = max(len(str(nt)) for nt in NT_SYM)

    # Largura de cada coluna de terminal: máximo entre cabeçalho e células
    col_w = [
        max(len(str(T_SYM[x])), max(len(cells[y][x]) for y in range(len(NT_SYM))))
        for x in range(len(T_SYM))
    ]

    def sep_line():
        return '-' * nt_w + '-+-' + '-+-'.join('-' * w for w in col_w)

    # Cabeçalho
    header = (
        f"{'':>{nt_w}} | "
        + ' | '.join(f"{str(T_SYM[x]):^{col_w[x]}}" for x in range(len(T_SYM)))
    )

    sep = sep_line()
    print(sep)
    print(header)
    print(sep)

    for y in range(len(NT_SYM)):
        row = (
            f"{str(NT_SYM[y]):>{nt_w}} | "
            + ' | '.join(f"{cells[y][x]:<{col_w[x]}}" for x in range(len(T_SYM)))
        )
        print(row)
        print(sep)
