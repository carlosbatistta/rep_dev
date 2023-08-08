import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Stack App")),
        body: Stack(
          alignment: AlignmentDirectional
              .center, //muda a disposição dos containers de acordo com o parâmetro
          //Um stack vai empilhar widgets, colocar nome sobre fotos, etc.
          children: [
            Container(
              height: 150,
              width: 150,
              color: Colors.black,
            ),
            Positioned( //pode posicionar um elemento
                left: 80, 
                top: 10,
                child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.red,
                ))
          ],
        ),
      ),
    );
  }
}
