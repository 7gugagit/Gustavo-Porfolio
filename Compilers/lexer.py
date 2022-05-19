import ply.lex as lex

tokens = ['NAME', 'NUMBER', 'PLUS', 'EQUALS', 'LPAREN', 'RPAREN']
literals = ['+', '=', '(', ')']


t_ignore = ' \t'
# t_PLUS = r'\+'
# t_MINUS = r'\-'
# t_TIMES = r'\*'
# t_DIVIDE = r'/'
# t_EQUALS = r'='
t_NAME = r'[a-zA-Z_][a-zA-Z0-9_]*'


# t_LPAREN = r'\('
# t_RPAREN = r'\)'

def t_PLUS(t):
    r'\+'
    t.type = '+'
    return t


def t_EQUALS(t):
    r'\='
    t.type = '='
    return t


def t_LPAREN(t):
    r'\('
    t.type = '('
    return t


def t_RPAREN(t):
    r'\)'
    t.type = ')'
    return t

def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)


def t_NUMBER(t):
    r'\d+'
    t.value = int(t.value)
    return t


lexer = lex.lex()

datas = []
while True:
    data = input()
    if data != '#':
        datas.append(data)
    else:
        break
#print(''.join(datas))
lexer.input('\n'.join(datas))

while True:
    tok = lexer.token()
    if not tok:
        break
    if tok.type == 'NUMBER':
        print('(\'' + tok.type + '\', ' + str(tok.value) + ', ' + str(tok.lineno) + ', ' + str(tok.lexpos) + ')')
    else:
        print('(\'' + tok.type + '\',', '\'' + str(tok.value) + '\',', str(tok.lineno) + ',',  str(tok.lexpos) + ')')
