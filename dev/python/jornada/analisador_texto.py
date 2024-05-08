'''
Exercício Python: Crie um programa que leia o nome completo de uma pessoa e mostre:
- O nome com todas as letras maiúsculas e minúsculas.
- Quantas letras tem ao total sem considerar espaços.
- Quantas letras tem o primeiro nome.
'''

nome = str(input('Digite o seu nome completo: '))
##o método split: Divida uma string em uma lista onde cada palavra é um item da lista
tamanho = nome.split()

print('Nome com letras maiusculas: {}'.format(nome.upper()))
print('Nome com letras minusculas: {}'.format(nome.lower()))

print(f'O seu nome tem ao todo {len(nome.strip())} letras')

print(f'O seu primeiro nome tem {len(tamanho[0])} letras')