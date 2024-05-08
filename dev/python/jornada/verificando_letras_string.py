'''
Exercício Python: Crie um programa que leia o nome de uma cidade diga
se ela começa ou não com o nome "SANTO".
'''

## COnverte em String
cidade = str(input('Digite o nome de uma cidade: ')).strip()
## O :5 pega uma substring até a 5ª letra e o .upper coloca tudo em maiúsculo
print(cidade[:5].upper() == 'SANTO')

#-------------------------------------------------------------------

cidade = str(input('Digite o nome de uma cidade: ')).strip()
esplitado = cidade.split()

print(esplitado[0].upper() == 'SANTO')