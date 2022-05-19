import sys

import ply.yacc as yacc
import lexer2

tokens = lexer2.tokens

names = {}


def p_assign(p):
    '''assign : NAME '=' exp'''
    names[p[1]] = p[3]


def p_exp(p):
    '''exp : term'''


def p_exp_add(p):
    '''exp : exp '+' term'''


def p_term(p):
    ''' term : NUMBER
            | '(' exp ')' '''

def p_term_NAME(p):
    ''' term : NAME'''
    try:
        p[0] = names[p[1]]
    except LookupError:
        print("Error in input")
        sys.exit()


def p_error(p):
    print('Error in input')
    sys.exit()


yacc.yacc(debug=False)

datas = []
while True:
    data = input()
    if data != '#':
        datas.append(data)
    else:
        break

for i in datas:
    yacc.parse(i)
print('Accepted')
