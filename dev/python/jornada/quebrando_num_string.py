'''
Exercício Python: Crie um programa que leia um número Real
qualquer pelo teclado e mostre na tela a sua porção Inteira.
'''

import math

numero = float(input('Digite um valor: '))
## importada a biblioteca math, o trunc "arredonda" números float para inteiro
print('o valor digitado foi: {}, sua parte inteira foi:, seu ponto flutuante foi: {}'.format( math.trunc(numero), numero))