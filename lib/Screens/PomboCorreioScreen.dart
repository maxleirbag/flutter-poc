import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sabia_app/Constants/ColorPalette.dart';

import '../Models/PomboCorreio.dart';
import '../Services/DatabaseServices.dart';
import '../Widgets/RoundedButton.dart';

class CreatePomboCorreioScreen extends StatefulWidget {
  final String currentUserId;

  const CreatePomboCorreioScreen({super.key, required this.currentUserId});

  @override
  _CreatePomboCorreioScreenState createState() =>
      _CreatePomboCorreioScreenState();
}

class _CreatePomboCorreioScreenState extends State<CreatePomboCorreioScreen> {
  late String _pomboCorreioText;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultLightColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text(
          'Pombo Correio',
          style: TextStyle(
            color: defaultDarkColor,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              maxLength: 280,
              maxLines: 7,
              decoration: const InputDecoration(
                hintText: 'Escreva seu Pombo Correio',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) _pomboCorreioText = value;
              },
            ),
            const SizedBox(height: 20),
            RoundedButton(
              btnText: 'Postar Pombo Correio',
              onBtnPressed: () async {
                setState(() {
                  _loading = true;
                });
                if (_pomboCorreioText.isNotEmpty) {
                  PomboCorreio pomboCorreio = PomboCorreio(
                    text: _pomboCorreioText,
                    authorId: widget.currentUserId,
                    likes: 0,
                    shares: 0,
                    timestamp: Timestamp.fromDate(
                      DateTime.now(),
                    ),
                    id: '${widget.currentUserId}${DateTime.now()}',
                  );
                  DatabaseServices.createPomboCorreio(pomboCorreio);
                  await DatabaseServices.getUserPombosCorreios(
                      widget.currentUserId);
                  Navigator.pop(context);
                }
                setState(() {
                  _loading = false;
                });
              },
            ),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
