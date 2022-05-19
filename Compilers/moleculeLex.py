import ply.lex as lex

tokens = ['NUMBER', 'MOLECULE']
literals = ['+', '=', '(', ')']

#t_NUMBER = r'[[0-9]+[0-9]*]'
t_MOLECULE = r'A[cglmrstu]|B[aehikr]?|C[adeflmnorsu]?|D[bsy]|E[rsu]|F[elmr]?|G[ade]|H[efgos]?|I[nr]?|Kr?|L[airuv]|M[dgnot]|N[abdeiop]?|Os?|P[abdmortu]?|R[abefghnu]|S[bcegimnr]?|T[abcehilm]|U(u[opst])?|V|W|Xe|Yb?|Z[nr]'

t_ignore = ' \t'

def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

def t_error(t):
    #print('Error in formula', t.type, t.value)
    raise Exception('Error in formula')
    #sys.exit()
   # t.lexer.skip(1)


def t_NUMBER(t):
    r'[0-9]+[0-9]*'
    t.value = int(t.value)
    return t

lex.lex()

