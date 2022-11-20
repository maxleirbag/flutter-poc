import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sabia_app/Screens/SkeletonScreen.dart';

import 'Screens/WelcomeScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const options = FirebaseOptions(
      apiKey: "AIzaSyDumexmX5nkr5L4tsjKU_zY0mEoyzCb1sQ",
      appId: "1:415516467757:android:394f36a7a2c63f60d04ea4",
      messagingSenderId: "415516467757",
      projectId: "flutter-sabia-app");
  await Firebase.initializeApp(options: options);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  Widget getScreenId() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return FeedScreen(
            currentUserId: snapshot.hasData
                ? snapshot.data!.uid.toString()
                : 'sem usuário',
            novoTitulo: 'Erro: Usuário Inexistente',
          );
        } else {
          return const WelcomeScreen();
        }
      },
    );
  }

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: ThemeData.light(),
      home: getScreenId(),
    );
  }
}
