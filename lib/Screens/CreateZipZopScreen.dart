import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sabia_app/Constants/Constants.dart';
import '../Models/ZipZop.dart';
import '../Services/DatabaseServices.dart';
import '../Widgets/RoundedButton.dart';

class CreateZipZopScreen extends StatefulWidget {
  final String currentUserId;

  const CreateZipZopScreen({super.key, required this.currentUserId});

  @override
  _CreateZipZopScreenState createState() => _CreateZipZopScreenState();
}

class _CreateZipZopScreenState extends State<CreateZipZopScreen> {
  late String _zipZopText;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: KzipZopColor,
        centerTitle: true,
        title: const Text(
          'ZipZop',
          style: TextStyle(
            color: Colors.white,
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
                hintText: 'Escreva seu ZipZop',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) _zipZopText = value;
              },
            ),
            const SizedBox(height: 20),
            RoundedButton(
              btnText: 'Postar ZipZop',
              onBtnPressed: () async {
                setState(() {
                  _loading = true;
                });
                if (_zipZopText.isNotEmpty) {
                  ZipZop zipZop = ZipZop(
                    text: _zipZopText,
                    authorId: widget.currentUserId,
                    likes: 0,
                    shares: 0,
                    timestamp: Timestamp.fromDate(
                      DateTime.now(),
                    ),
                    id: '${widget.currentUserId}${DateTime.now()}',
                  );
                  DatabaseServices.createZipZop(zipZop);
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
