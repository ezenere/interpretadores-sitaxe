# Eduardo Zenere de Oliveira - ezenere

import argparse
import os
import sys
from parser import parseArquivo, parseExpressao
from runner import executar, executarExpressao, Memory, History
from translator import traduzirParaARMv7
from tester import exibirParsed
 
 
def comandoParse(file):
    parsed = parseArquivo(file)
    for expression in parsed:
        exibirParsed(expression)
        print()
 
 
def comandoExecutar(file):
    parsed = parseArquivo(file)
    memory, history = executar(parsed)
    print(f'Memória: {memory}')
    print(f'Histórico: {history}')
 
 
def comandoTraduzir(file, output):
    parsed = parseArquivo(file)
    code = traduzirParaARMv7(parsed)
    if output:
        with open(output, 'w', encoding='utf-8') as f:
            f.write(code)
        print(f'Assembly salvo em: {output}')
    else:
        print(code)
 
 
def cmd_interactive():
    memory = Memory()
    history = History()
    print('Modo interativo — digite expressões RPN (Ctrl+C ou "sair" ou "q" para sair)')
    print()
    while True:
        try:
            linha = input('>>> ').strip()
        except (KeyboardInterrupt, EOFError):
            print('\nSaindo...')
            break
 
        if not linha or linha.startswith('#'):
            continue
 
        if linha.lower() in ('sair', 'exit', 'quit', 'q'):
            print('Saindo...')
            break
 
        try:
            tokens = parseExpressao(linha)
            if not tokens:
                continue
            executarExpressao(tokens, memory, history)
            if history.heap:
                print(f'= {history.heap[-1]}')
        except Exception as e:
            print(f'Erro: {e}')
 
 
if __name__ == '__main__':
    ap = argparse.ArgumentParser(
        description='Interpretador de expressões RPN — Fase 1'
    )
 
    modo = ap.add_mutually_exclusive_group(required=True)
    modo.add_argument('-r', '--run',         action='store_true', help='Executa um arquivo de expressões')
    modo.add_argument('-p', '--parse',       action='store_true', help='Exibe os tokens parseados')
    modo.add_argument('-t', '--translate',   action='store_true', help='Traduz para assembly ARMv7')
    modo.add_argument('-i', '--interactive', action='store_true', help='Modo interativo (REPL)')
 
    ap.add_argument('file', nargs='?', help='Arquivo .rpn de entrada')
    ap.add_argument('-o', '--output', help='Arquivo de saída .s (usado com --translate)')
 
    args = ap.parse_args()
 
    if args.interactive:
        cmd_interactive()
        sys.exit(0)
 
    # Os outros modos precisam de arquivo
    if not args.file:
        print('Erro: informe um arquivo de entrada.')
        ap.print_help()
        sys.exit(1)
 
    if not os.path.exists(args.file):
        print(f'Erro: o arquivo "{args.file}" não existe!')
        sys.exit(1)
 
    if args.parse:
        comandoParse(args.file)
    elif args.run:
        comandoExecutar(args.file)
    elif args.translate:
        comandoTraduzir(args.file, args.output)