'''
Exercício Python: Faça um programa que leia um número Inteiro
qualquer e mostre na tela a sua tabuada.
'''

numero = float(input('Digite um número para ver sua taboada: '))
for i in range(10):
    print("{} x {} = {:.0f}".format(numero, i+1, numero*(i+1))) #o :.0f o 0 indica a quantidade de casas decimais após o ponto