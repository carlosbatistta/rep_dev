km = float(input('Quantos km rodados?'))
dias = int(input('Qual a quantidade de dias?'))
total_pago = (dias*60)+(km*0.15)
print('Total a ser pago: R${:.2f}'.format(total_pago))