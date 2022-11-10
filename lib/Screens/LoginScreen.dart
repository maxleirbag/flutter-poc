import 'package:flutter/material.dart';
import 'package:sabia_app/Widgets/RoundedButton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String _email;
  late String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Log in',
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
              decoration: const InputDecoration(hintText: 'Enter your email'),
              onChanged: (value) {
                _email = value;
              },
            ),
            const SizedBox(
              height: 30,
            ),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(hintText: 'Enter your password'),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundedButton(
                btnText: 'Entrar', onBtnPressed: () => print('log in'))
            //  ajustar com AuthService.logIn
            //  teste
          ],
        ),
      ),
    );
  }
}
