# imagens

A new Flutter project.

## Lista comandos básicos

# Variáveis
int numero = 1;
double valor = 1.5;
String nome = 'Maiza' ou "Maiza";
bool validacao = false;
List lista = [ 'Rosa', 'Lilás', 'Azul'];   
var variavel = 1
    variavel = 'também pode ser texto'
    variavel = false
const constante = 1
      constante = 2 //constante não pode ser alterado

# Loop's

int numero = 1;

for(var i = 1;i<3;i++){
    print('numero $i');
}

while(numero <=100){
    print('numero');
    numero++;
}

do{
    print('Numero é $numero')
    numero++
} while(numero <= 100) //o DO executa o código antes de fazer a validação

# Tomada de decisão

int idade = 16;
String linguagem = 'Dart';
if(idade<18){print('é menor de idade')}
else{print('não é menor de idade')}

bool condicao = idade <= 18 //condicao recebe true ou false fazendo a operação lógica logo depois
String condicao = idade <18 && idade = 18? 'Menor de idade' : 'Maior de idade'; //operador ternário

switch(idade){
    case 'C':
        print('linguagem C#');
        break;
    case 'Dart':
        print('linguagem Dart);
        break;
    case default:
        print('nenhuma das opções');
        break;
}


