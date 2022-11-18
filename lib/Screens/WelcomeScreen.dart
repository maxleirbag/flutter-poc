import 'package:flutter/material.dart';
import 'package:sabia_app/Screens/LoginScreen.dart';
import 'package:sabia_app/Screens/RegistrationScreen.dart';
import '../Widgets/RoundedButton.dart';
import '../Widgets/DrawerSiderBar.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                  ),
                  Image.asset(
                    'assets/zip zop.png',
                    height: 200,
                    width: 200,
                  ),
                  const Text(
                    'Se tá a internet, é verdade',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  RoundedButton(
                      btnText: 'Log In',
                      onBtnPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                  RoundedButton(
                      btnText: 'Criar Conta',
                      onBtnPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RegistrationScreen()));
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
