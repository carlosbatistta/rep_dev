'''
Exercício Python: Um professor quer sortear um dos seus quatro alunos
para apagar o quadro. Faça um programa que ajude ele, lendo o nome dos
alunos e escrevendo na tela o nome do escolhido.
'''

from random import choice

lista = []

try:
    for i in range(4):
        valor = str(input("Digite o {}ª nome: ".format(i+1)))
        lista.append(valor)
except:
    print("Erro de conversão")

##choice escolhe um item entre a lista e shufle embaralha
escolha = choice(lista)
print('O nome escolhido foi {}!'.format(escolha))