// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void main() {
  //runApp(MyApp(title: "Barra de teste"));
  runApp(App());
}

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

class App extends StatefulWidget {
  //statefulwidget são widgets dinâmicos que mudam na IA, essa primeira classe serão guardados os apps que não serão mudados
  final String nome = "Carlos";
  const App({Key? key}) : super(key: key); // construtor

  @override
  State<App> createState() => _App();
}

class _App extends State<App> {
  int salario = 500;
  //armazenados os dados alteráveis
  //a chamada vai criar essa classe do tipo state e com um método build, com a função de ataualização da página
  @override
  Widget build(BuildContext context) {
    //widget build irá fazer a contrução da página
    return Container(
      child: Center(
        child: Text("Funcionário: ${widget.nome}",
            textDirection: TextDirection.ltr),
      ),
    );
  }
}
