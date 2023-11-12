# imagens

A new Flutter project.

## Lista comandos básicos DART

# Variáveis
int numero = 1;
int? numero_2; //são variaveis nullable, que podem ser nulas. *Não podem fazer operações, ++, atribuições, funções.
int numero_3 = numero_2 ?? "0" // operador Non-Nullable valida se a variavel é nula se for difine como "0".
double valor = 1.5;
num numero //pode receber tanto inteiro como double
String nome = 'Maiza' ou "Maiza";
bool validacao = false;
List lista = [ 'Rosa', 'Lilás', 'Azul'];   
var variavel = 'uma vez texto' //adota a primeira referência como tipo da variável
    variavel = 'pode ser OUTRO texto'
dynamic dinamico = 1  //não possui pre-definições
        dinanmico = 'Pode ser qualquer coisa'
const constante = 1
      constante = 2 //constante não pode ser alterado

# Funções
void main(){
    saudacoes("Carlos") //forma de chamar uma função
    agora("PE", ativo: true, corpo: funcao) //se você receber uma função como parâmetro, se colocar sem o () vai chamar a função para ser executada, se colocar com os () vai chamar apenas o return da função.
}
void saudacoes(String nome, [String mensagem, String mensagem_2]){ //funções void não possuem retorno. Os parâmetros entre colchetes [] são parâmetros opcionais, mas que devem  ser respeitados a ordem de posição.
    
    print("Saudações!! ${nome.toUpperCase()}") //chamar métodos dentro de um texto " ${} "
    print("& * 20")
    print("Agora: ${agora()}") //chamada da função atribuindo valor 
}
String agora(String estado, {String cidade, bool ativo, required Function(int) corpo}){ //funções String, int, double, etc possuem retorno, então possuem valor. Os parâmetros entre chaves {}  são parâmetros opcionais mas não importa a ordem. Mesmo dentro de {} parâmetros "required" são obrigatórios.
    Datetime agora = Date.time.now()
    corpo();
    return agora.toString()
}
void funcao (int i){
    for(int j = 0; j < i; j++){
        print('Olá')
    }
}
String imprimir_nome (String nome) => nome.toString(); //O fletcher "=>" equivale ao return da função.


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

# Listas

list nomes = ['Maria','José', 10, false]
list so_nomes <String> = ['Maria', 'José']
List<String?> lista_nullsafety = ['Carlos', null, 'Maria'];
List<String?>? lista_null_full;  //listas com duplas ? não precisam ser inicializadas e podem aceitar valores nulos, ou seja, a lista pode ser nula e receber valores nulos
    if(lista_null_full != null){
        lista_null_full.add(null);
    }

## Percorrendo um for

for (String nome in nomes){ //para cada nome na lista de nomes, execute...
    print(nome.toUppercase())
}

nomes.forEach((nome){ //pode usar o forEach a qual pode iniciar um médoto para cada organismo na lista e um mapa, assim como uma função anônima (variável){}.
    print(nome.toUppercase());
});

nomes.filled(100, 'Carlos') //alimenta Carlos 100x
nomes.generate(10, (i) => i * 10) //essa função permite colocar 10 vezes numa lista um valor dinâmico, como uma função anônima

## Mapas

Map<int, String?> ddd = { //Um mapa um dado a outro, por exemplo se usar um print(ddd[11]), irá retornar São Paulo
    11: 'São Paulo',
    81: 'Pernambuco',
    83: 'Paraiba',
};
ddd[87] = 'Interior de Pernambuco' // adiciona itens ao Mapa
ddd.remove[87]; //remoção de dados
ddd.removeWhere((key, value)=> key > 20)

## JSON

void main(){}

String dados_user(){
    return """
    {
        
    }
}




