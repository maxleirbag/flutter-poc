import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'Screens/SkeletonScreen.dart';
import 'Screens/WelcomeScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'config.env');
  final options = FirebaseOptions(
    apiKey: dotenv.env['API_KEY']!,
    appId: dotenv.env['APP_ID']!,
    messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
    projectId: dotenv.env['PROJECT_ID']!,
  );
  await Firebase.initializeApp(options: options);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  Widget getScreenId() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return SkeletonScreen(
            currentUserId: snapshot.hasData
                ? snapshot.data!.uid.toString()
                : 'sem usuário',
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
