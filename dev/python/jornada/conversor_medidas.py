'''
Exercício Python: Faça um programa que leia algo pelo teclado
e mostre na tela a conversão de metros para KM, HM, DAM, DM, CM e MM.
'''
distancia = input("Uma distância em metros?")

## A raise palavra-chave é usada para gerar uma exceção. Gere um TypeError se distancia não for um número float:
if not type(distancia) is float:
  raise TypeError("Tipo não é alfanumérico")

print("A medida de {} corresponde a:".format(distancia))
print("{}km".format(distancia*0.001))
print("{}hm".format(distancia*0.010))
print("{}dam".format(distancia*0.100))
print("{}dm".format(distancia*10))
print("{}cm".format(distancia*100))
print("{}mmm".format(distancia*1000))