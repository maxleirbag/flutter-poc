import 'package:flutter/material.dart';

import 'Widgets/RoundedButton.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late String _email;
  late String _password;
  late String _name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Criação de Conta',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Enter your name'),
              onChanged: (value) {
                _name = value;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              decoration:
                  const InputDecoration(hintText: 'Enter your main email'),
              onChanged: (value) {
                _email = value;
              },
            ),
            const SizedBox(
              height: 30,
            ),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(hintText: 'Enter your new password'),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundedButton(
                btnText: 'Criar conta',
                onBtnPressed: () => print('criação de conta'))
            //  ajustar com AuthService.signUp()
          ],
        ),
      ),
    );
  }
}
