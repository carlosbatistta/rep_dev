import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  //criado uma classe widget editada voltada para definir o que será exibido para o cliente
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const HomePage(); // a alteração do return altera o que será exibido
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //com o return como material app
      //materialApp é um conglomerado de estruturas para o nosso desenvolvimento
      home: Container(
        color: Colors.red,
        alignment: Alignment.center,
        child: const Text('Olá Mundo'),
      ), //container é uma caixa onde vc pode adicionar cores, opacidade, bordas, etc.
    );
  }
}
