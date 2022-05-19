import sys

import ply.lex as lex

tokens = ['NAME', 'NUMBER']
literals = ['+', '=', '(', ')']


t_ignore = ' \t'
t_NAME = r'[a-zA-Z_][a-zA-Z0-9_]*'


def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

def t_error(t):
    print('Error in input')
    sys.exit()
    t.lexer.skip(1)


def t_NUMBER(t):
    r'\d+'
    t.value = int(t.value)
    return t


lexer = lex.lex()
