'''
Exercício Python: Faça um programa que leia o ano de nascimento de um
jovem e informe, de acordo com a sua idade, se ele ainda vai se alistar ao
serviço militar, se é a hora exata de se alistar ou se já passou do tempo
do alistamento. Seu programa também deverá mostrar o tempo que
falta ou que passou do prazo.
'''

from datetime import date

ano_nascimento = int(input('Informe sua datade nascimento: '))
ano_atual = date.today().year
idade = ano_atual - ano_nascimento

if idade >= 18:
    if idade == 18:
        print('Você tem {}, portanto terá que se alistar'.format(idade))
    else:
        print('Você passou do prazo {} anos, terá que se alistar'.format(idade-18))
else:
    print('Você ainda não tem idade suficiente, faltam {} anos'.format(18-idade))