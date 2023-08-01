// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void main() {
  //runApp(MyApp(title: "Barra de teste")); //Exempo 1
  //runApp(App()); //Exemplo 2
  runApp(AppMy());
}

//Exemplo 1: App estático, sem manipulação
class MyApp extends StatelessWidget {
  final String title;
  //statelesswidget é uma das principais classes do flutter, são locais estáticos da pagina, geralmente Menus, Help, etc
  const MyApp({Key? key, this.title = ""}) : super(key: key); //contrutor
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /*O MaterialApp é um widget de conveniência que envolve vários widgets que normalmente são necessários para aplicativos de material design. O widget MaterialApp fornece um layout orientado ao material design.*/
      //Consegue colocar Widgets, dentro de outro widgets.
      home: Scaffold(
        //scaffold é uma estrutura básica de layout com uma barra superior appBar e informações abaixo body
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          //body é o corpo do widget scaffold
          child: Text(
            "Olá Mundo",
            style: TextStyle(fontSize: 30, color: Colors.black54),
          ), //é aconselhável separa por vírgulas seus widgets. O widget TEXT possui vários parâmetros, sendo apenas o String data é obrigatória
        ),
      ),
    );
  }
}

//Exemplo 2: App variavel, com manipulação
class App extends StatefulWidget {
  //statefulwidget são widgets dinâmicos que mudam na IA, essa primeira classe serão guardados os apps que não serão mudados
  final String nome = "Carlos";
  const App({Key? key}) : super(key: key); // construtor

  @override
  State<App> createState() => _App();
}

class _App extends State<App> {
  int salario = 800; //função abreviada
  //armazenados os dados alteráveis
  //a chamada vai criar essa classe do tipo state e com um método build, com a função de ataualização da página
  @override
  Widget build(BuildContext context) {
    //widget build irá fazer a contrução da página
    return Center(
      child: GestureDetector(
        // widget de manipulação
        onTap: () {
          //função de clica na tela
          setState(() {
            salario = salario + 20;
          });
        },
        child: Text(
            "Funcionário => ${widget.nome} salario => $salario", //forma de acessar constantes da classe statefulwidget
            textDirection: TextDirection.ltr),
      ),
    );
  }
}

//Exemplo 3: mix de app estático e de manipulação
class AppMy extends StatefulWidget {
  const AppMy({super.key});

  @override
  State<AppMy> createState() => _AppMyState();
}

class _AppMyState extends State<AppMy> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("App scaffold")),
        body: Row(
          //organiza os widgets em linha
          mainAxisAlignment: MainAxisAlignment
              .spaceAround, //organiza a disposição dos childrens na tela
          children: [
            Center(
              child: Text(
                "Row01",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 30, color: Colors.blueGrey),
              ),
            ),
            Center(
              child: Text(
                "Row02",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 30, color: Colors.blueGrey),
              ),
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    "Colm03",
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 30, color: Colors.blueGrey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
