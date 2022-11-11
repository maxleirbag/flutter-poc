import 'package:flutter/material.dart';
import 'package:sabia_app/Screens/FeedScreen.dart';

class CreateZopScreen extends StatefulWidget {
  const CreateZopScreen({Key? key}) : super(key: key);

  @override
  State<CreateZopScreen> createState() => _CreateZopScreenState();
}

class _CreateZopScreenState extends State<CreateZopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('novo zip zop'),
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const FeedScreen()));
            },
            child: const Icon(
              Icons.arrow_left,
              color: Colors.green,
            ),
          )
        ],
      ),
    );
  }
}
