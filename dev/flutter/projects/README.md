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
List lista = [ 'Rosa', 'Lilás', 'Azul' ];   
var variavel = 'uma vez texto' //adota a primeira referência como tipo da variável
    variavel = 'pode ser OUTRO texto'
dynamic dinamico = 1  //não possui pre-definições
        dinanmico = 'Pode ser qualquer coisa'
const constante = 1
      constante = 2 //constante não pode ser alterado
final Datetime data = Datetime.now() //a diferença entre const e final é que final é chave única assim que receber algum valor, já const precisa ter algum valor antes de debugar o código.


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

//Sempre será desta forma: Map <"Chave que liga os dados", "valor retornado">, ou seja, a chave é inteiro e o valor recebido é uma string
Map<int, String?> ddd = { //Um mapa liga um dado a outro, por exemplo se usar um print(ddd[11]), irá retornar São Paulo
    11: 'São Paulo',
    81: 'Pernambuco',
    83: 'Paraiba',
};
ddd[87] = 'Interior de Pernambuco' // adiciona itens ao Mapa
ddd.remove[87]; //remoção de dados
ddd.removeWhere((key, value)=> key > 20)

## JSON
import 'dart:convert'; //biblioteca usada para decodificação de JSON

void main(){
    Map<String, dynamic> dados = json.decode(dados_user()); //a chave é Srting e os valores recebidos são listas, strings, inteiros, então esse é um caso de uso da variável      dynamic
    //Após a decodificação poderá ser tratado como um Map
    print(dados['nome']); //retorna: Daniel
    print(dados['endereco']['numero']); //retorna:422
    print(dados['curso'][0]['nome']); //retorna: Dart

}

//JSON
String dados_user(){ //observe que o formato de JSON é o mesmo formato que um MAP
    return """
    {
       "nome": "Daniel", //String
       "idade": 18, //Inteiro
       "cadastro": false, //boo
       "cursos":[ //lista
        {
            "nome": "Dart",
            "dificuldade": 1
        },
        {
            "nome": "Java",
            "dificuldade": 2
        }
        ]
        "endereco": //map
        {
            "rua": "Inocencio Oliveira",
            "numero": 422,
            "bairro": "Centro"
        }
    }
    """;
}

## TRY CATCH

void main(){
    try{
    int resultado = 100 ~/ 7 //divisão arredondado para valores inteiros
    int resto = 100 % 7 //resto da divisão
    } on UnsupportedError{ //on: são várias casos que o erro pode entrar, onde se o erro dor de formato, vai cair no FormatException por exemplo, então o tratamento pode ser realizado de acordo com o erro cadastrado no "on"
        print('Erro não suportado');
    } on FormatException catch (error) {
        print('Erro de formato: $(error.message)');
    }
    catch(e){
        print("Erro na operação: $e)
    }
    finally{ //Executa o código independente se cair em exceção ou não
        print('Execução do código') 
    }
}

## Enumeradores

enum Status_pagamento {pendente, pago, estornado} //Apenas um conjunto de dados que deliminta um intervalo de dados.

void main(){
    Status_pagamento status = Status_pagamento.pago;
}

## Classes, Objetos, Atributos, Métodos, Static

void main(){
    Pessoa user = Pessoa("Carlos", 18); //Instanciando a classe
    user.aniversario();
    user.casar(user.casado);

    print(Pessoa.atributo_static); // chamando o atributo static

    user.cpf = 10144698480;
    print("CPF: $user.cpf");
}

//a classe é organizada da seguinte forma: Contrutor, Atributos, Métodos.
Class Pessoa { //Classe nomeada
    
    //Construtor
    Pessoa({required this.nome. required this.idade});
    //Construtores nomeados são construtores com alterações mais específicas.
    Pessoa.casada({required this.nome. required this.idade}){
        this.casado = true;
    }
    
    //Atributos
    String? nome;
    int? idade;
    bool? casado
    Static String atributo_static = "Atributo estático"; //Static são relacionados a classe, não ao objeto
    late int cpf; //o Late são variáveis que serão obrigatóriamente preenchida pelo sistema em alguma parte após a execução.

    //Metodos
    void aniversario(){
        print('Parabéns: $nome');
        idade = idade! + 1;
    }
    bool casar (bool casado){
        if(casado == false){
            casado = true
        }
        return casado
    }
}

## Herança e Polimorfismo

void main(){

     Cachorro dog = Cachorro('Bob', 6); //nomeação do objeto se deu no momento da instância
     dog.latir();
     dog.dormir();
     dog.comer();

     Gato cat = Gato('Orion', 4);
     cat.miar();
     cat.dormir();
     cat.comer();

}

abstract class Animal{ //classe abstrata, não pode ser instânciada
    Animal(this.nome, this.idade);
    String nome;
    int idade;

    void comer(){
        print('Comeu');
    }
    void dormir(){
        print ('Dormiu');
    }
    void morrer(); //repare que falta corpo nesse método nas classes filhas, nesse caso vai dar um erro informando que esse método está faltando nas classes filhas, logo toda classe abstrata que for estendida, as filhas tem que sobrescrever todos os métodos da mãe sem corpo.
       
}

Classe Cachorro extends Animal{ // Cachorro extende de animais.
    Cachorro(String nomr. int idade) : (super.nome, super.idade); //referencia o nome e idade de Animal
    void latir(){
        print('Latiu');
    }
    @override // boas práticas de programação
    void dormir(){ //a reescrita tem que manter o padrão da classe mãe.
        super.dormiu()//o super vai chamar o método da classe Animal
        print('Dormiu roncando');
    }
}

Class Gato extends Animal{
    Gato (String nome, int idade) : (super.nome, int.idade);
    void miar(){
        print('Miau');
    }
}

## Interfaces

void main(){

    Pessoa user = Controle_cliente(); //instacia uma pessoa do tipo controle_cliente, todos os métodos de user são direcionados para o controle_cliente.
    user.adicioar();

}

abstract class Pessoa{
    bool adicionar();
    bool remover();
}

class Controle_cliente implements Pessoa{ //o uso do implents considera Pessoa como uma interface.

    @override
    bool adicionar(){
        print('adicionado')
        return true;
    }

    @override
    bool adicionar(){
        return true;
    }
}
class Controle_usuario implements Pessoa{

    override
    bool adicionar(){
        return true;
    }
    
    @override
    bool adicionar(){
        return true;
    }

}

## Widget

Todos os componentes em tela são widgets.
Toda a Interface gráfica, textos, botões, bordas, planos de fundo, etc..
documentação oficial, lista de todos os widgets: https://docs.flutter.dev/reference/widgets

## MaterialApp

Todos os componentes do Material Desing 
