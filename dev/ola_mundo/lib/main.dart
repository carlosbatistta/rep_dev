// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void main() {
  // ignore: prefer_const_constructors
  runApp(
    MaterialApp(
      /*O MaterialApp é um widget de conveniência que envolve vários widgets que normalmente são necessários para aplicativos de material design. O widget MaterialApp fornece um layout orientado ao material design.*/
      //Consegue colocar Widgets, dentro de outro widgets.
      home: Scaffold(
        //scaffold é uma estrutura básica de layout com uma barra superior e informações abaixo.
        appBar: AppBar(
          title: Text('Hello'),
        ),
        body: Center(
          //body é o corpo do widget scaffold
          child: Text(
            "Olá Mundo",
            style: TextStyle(fontSize: 30, color: Colors.black54),
          ), //é aconselhável separa por vírgulas seus widgets. O widget TEXT possui vários parâmetros, sendo apenas o String data é obrigatória
        ),
      ),
    ),
  );
}
