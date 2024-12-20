'''
Exercício Python: Um professor quer sortear um dos seus quatro alunos
para apagar o quadro. Faça um programa que ajude ele, lendo o nome dos
alunos e escrevendo na tela o nome do escolhido.
'''

from random import choice

lista = ['Carlos', 'Gustavo', 'Thiago', 'Venancio', 'Tarcisio']
escolhidos = []

def sorteando(lista):
    escolhidos.append(choice(lista))
    lista.remove(escolhidos[0])
    escolhidos.append(choice(lista))

sorteando(lista)

print('O nome escolhido para Natal: {}!'.format(escolhidos[0]))
print('O nome escolhido para Ano Novo: {}!'.format(escolhidos[1]))