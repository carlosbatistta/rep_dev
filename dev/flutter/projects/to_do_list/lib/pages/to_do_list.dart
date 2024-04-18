import 'package:flutter/material.dart';

class TodoListPage3 extends StatelessWidget {
  const TodoListPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Adicione uma tarefa',
                hintText: 'Ex. Estudar Flutter')),
      ),
    );
  }
}

/* Abaixo são exemplos das aulas */

//Exemplo
class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20), //espaçamento
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Preço',
              hintText: 'R\$ 00,00',
              errorText: null,
              labelStyle: TextStyle(fontSize: 40),
            ),
          ),
        ),
      ),
    );
  }
}

//Exemplo 2
class TodoListPage2 extends StatelessWidget {
  TodoListPage2({super.key});

  final TextEditingController emailController =
      TextEditingController(); //Controler do campo texto, cada campo tem o seu controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller:
                  emailController, //todo textfield tem que definir o controller
              onSubmitted:
                  onSubmitted, //quando apertar enter passa o texto, mas se clicar fora do widget ele não captura o dado
              onChanged:
                  onChanged, //o changed ele grava qualquer alteração no campo
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            const SizedBox(
                height:
                    10), // crar uma caixa transparente apenas para o espaçamento entre os widgets
            ElevatedButton(onPressed: login, child: Text('Entrar')),
          ],
        ),
      )),
    );
  }

  void login() {
    String text = emailController.text + '@gmail.com';
    print(text);
    emailController.clear();
  }

  void onSubmitted(String text) {
    //print(text);
  }

  void onChanged(String text) {
    print(text);
  }
}
