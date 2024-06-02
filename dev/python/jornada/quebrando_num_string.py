'''
Exercício Python: Crie um programa que leia um número Real
qualquer pelo teclado e mostre na tela a sua porção Inteira.
'''

import math

numero = input('Digite um valor: ')
numero_convertido = float(numero)
## importada a biblioteca math, o trunc "arredonda" números float para inteiro
print('o valor digitado foi: {}, sua parte inteira foi:{}, seu ponto flutuante foi: {}'.format(numero, math.trunc(numero_convertido), numero_convertido))