'''
Exercício Python: Escreva um programa que pergunte a quantidade
de Km percorridos por um carro alugado e a quantidade de dias pelos
quais ele foi alugado. Calcule o preço a pagar, sabendo que o carro
custa R$60 por dia e R$0,15 por Km rodado.
'''

km = float(input('Quantos km rodados?'))
dias = int(input('Qual a quantidade de dias?'))
total_pago = (dias*60)+(km*0.15)
print('Total a ser pago: R${:.2f}'.format(total_pago))