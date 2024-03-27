import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

void incrementar() {
  print('incrementar');
}

void decrementar() {
  print('decrementar');
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
        title: const Text('Olá mundo'),
      ),
      drawer: const Drawer(),
    );
  }
}

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        //body é o corpo ta tela
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Pode entrar",
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            "0",
            style: TextStyle(fontSize: 100, color: Colors.white),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*TextButton(
                onPressed: decrementar,
                style: ButtonStyle.styleFrom(
                  backgroundColor: Colors.white,
                  fixedSize: Size(100, 100),
                ),
                child: Text(
                  'sair',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              TextButton(onPressed: incrementar, child: Text('entrou')),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: null,
                child: const Text('Disabled'),
              ),*/
            ],
          )
        ],
      ),
    );
  }
}
