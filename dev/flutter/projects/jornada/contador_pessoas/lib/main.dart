import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  //criado uma classe widget editada voltada para definir o que será exibido para o cliente
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ThirdPage(), // a alteração do return altera o que será exibido
    );
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

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //como o container o scaffold reune diversas ferramentas para compor sua page.
      appBar: AppBar(
        title: Text('Olá mundo'),
      ),
      drawer: Drawer(),
    );
  }
}

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        //body é o corpo ta tela
        children: [],
      ),
    );
  }
}
