'''
Exercício Python: Crie um programa que leia um número inteiro e
mostre na tela se ele é PAR ou ÍMPAR.
'''

num = int(input('Digite um numero: '))
print('PAR' if num % 2 == 0 else 'Impar')

#---------------------------------------------------

num = int(input('Digite um numero: '))

## % é o resto da divisão
if num % 2 == 0:
    print('O numero digitado é par')
else:
    print('O numero digitado é impar')