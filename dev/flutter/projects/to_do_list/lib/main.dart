import 'package:flutter/material.dart';
import 'package:to_do_list/pages/to_do_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoListPage3(),
    );
  }
}
