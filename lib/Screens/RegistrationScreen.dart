import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Constants/Constants.dart';
import '../Services/auth_service.dart';
import '../Widgets/RoundedButton.dart';
import 'SkeletonScreen.dart';

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
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Criação de Conta',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: defaultDarkColor),
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
              decoration: const InputDecoration(hintText: 'NOME'),
              onChanged: (value) {
                _name = value;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'E-MAIL'),
              onChanged: (value) {
                _email = value;
              },
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              onChanged: (value) {
                _password = value;
              },
              obscureText: true,
              decoration: const InputDecoration(hintText: 'SENHA'),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundedButton(
              btnText: 'Criar conta',
              onBtnPressed: () async {
                var result = await AuthService.signUp(_name, _email, _password);
                bool isValid = result[0];
                var user = result[1];
                // DatabaseServices.updateUserData(user);
                if (isValid) {
                  Fluttertoast.showToast(
                      msg: 'E-mail $_email cadastrado com sucesso.',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 7,
                      backgroundColor: Colors.amber,
                      textColor: defaultLightColor,
                      fontSize: 15);
                  // Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FeedScreen(
                                currentUserId: user.uid,
                                novoTitulo: 'Feed',
                              )));
                } else {
                  Fluttertoast.showToast(
                      msg: 'Impossível concluir o registro do e-mail: $_email.',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 7,
                      backgroundColor: Colors.amber,
                      textColor: defaultLightColor,
                      fontSize: 15);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
