import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sabia_app/Widgets/RoundedButton.dart';

import '../Constants/Constants.dart';
import '../Services/auth_service.dart';
import 'SkeletonScreen.dart';

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
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Log in',
          style: TextStyle(
              color: defaultDarkColor,
              fontSize: 15,
              fontWeight: FontWeight.bold),
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
            TextField(
              obscureText: true,
              decoration:
                  const InputDecoration(hintText: 'Enter your password'),
              onChanged: (value) {
                _password = value;
              },
            ),
            const SizedBox(
              height: 30,
            ),
            RoundedButton(
              btnText: 'Log In',
              onBtnPressed: () async {
                var result = await AuthService.signIn(_email, _password);
                bool isValid = result[0];
                var user = result[1];
                if (isValid) {
                  Fluttertoast.showToast(
                      msg: 'Logado como $_email',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.amber,
                      textColor: defaultLightColor,
                      fontSize: 15);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SkeletonScreen(
                                currentUserId: user,
                              )));
                } else {
                  Fluttertoast.showToast(
                      msg: 'Impossível logar.\nUsuário e/ou senha incorretos.',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 5,
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
