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
    return Scaffold(
      backgroundColor: Colors.green,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover, //aqui redimencionamos de acordo com o Box.fit
        )),
        child: Column(
          //body é o corpo ta tela
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Pode entrar",
              style: TextStyle(
                fontSize: 60,
                color: Colors.white,
                fontWeight: FontWeight.w500, //Negrito
              ),
            ),
            const Padding(
              //Substituir o Text do 0
              padding: EdgeInsets.all(35),
              child: Text(
                '0',
                style: TextStyle(
                    fontSize: 60,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: decrementar,
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      fixedSize: const Size(100, 40)),
                  child: const Text(
                    'sair',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w200),
                  ),
                ),
                const SizedBox(width: 15),
                TextButton(
                    onPressed: incrementar,
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        fixedSize: const Size(100, 40)),
                    child: const Text(
                      'entrou',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w200),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
