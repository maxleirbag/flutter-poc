import 'package:flutter/material.dart';
import 'package:sabia_app/Screens/FeedScreen.dart';

class CreateZipZopScreen extends StatefulWidget {
  const CreateZipZopScreen({Key? key}) : super(key: key);

  @override
  State<CreateZipZopScreen> createState() => _CreateZipZopScreenState();
}

class _CreateZipZopScreenState extends State<CreateZipZopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('novo zip zop'),
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const FeedScreen(currentUserId: 'a')));
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
