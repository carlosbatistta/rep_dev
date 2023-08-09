import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Imgens'),
        ),
        body: Image.asset(
          'assets/images/amg_blue_resized.png',
          width: 200,
        ),
      ),
    );
  }
}
