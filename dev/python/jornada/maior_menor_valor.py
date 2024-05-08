'''
Exercício Python: Faça um programa que leia três números e mostre qual
é o maior e qual é o menor.

'''
lista = []

for i in range(3):
    try:
        lista = int(input('Digite um número: '))
    except:
        print('Erro na conversão')
        lista.clear
        i=0

##lista.sort()
print('O item de menor valor é {} e o de menor valor é {}'.format(lista[0], lista[2]))
