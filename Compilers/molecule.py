import moleculeLex
import ply.yacc as yacc
import sys

tokens = moleculeLex.tokens
#parser

molecules = []
count = 0

def p_start(p):
    ''' start : element
            |  element start '''

def p_element(p):
    ''' element : MOLECULE '''
    if(len(molecules) > 0):
        if(molecules[-1] == p[1]):
            raise Exception('Error in formula')
    molecules.append(p[1])
    global count
    count += 1

def p_element_Num(p):
    '''element : MOLECULE NUMBER'''
    if (len(molecules) > 0):
        if (molecules[-1] == p[1]):
            raise Exception('Error in formula')
    molecules.append(p[1])

    global count
    count += p[2]

def p_error(p):
    raise Exception('Error in formula')
    #print('syntax', p.type, p.value)

yacc.yacc(debug=False)

datas = []
while True:
    data = input()
    if data != '#':
        datas.append(data)
    else:
        break

for i in datas:
    #print(i)
    count = 0
    molecules.clear()
    try:
        yacc.parse(i)
        print(count)
    except Exception as x:
        print('Error in formula')

