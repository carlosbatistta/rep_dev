'''
Exercício Python: Crie um programa que leia o nome de uma pessoa
e diga se ela tem "SILVA" no nome.
'''
nome = str(input('Digite o seu nome: ')).strip()

if 'SILVA' in nome.upper():
    print("Possui!")
else:
    print("Não possui!")