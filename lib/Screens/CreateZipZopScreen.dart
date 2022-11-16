import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sabia_app/Constants/Constants.dart';
import 'package:sabia_app/Screens/FeedScreen.dart';

import '../Models/ZipZop.dart';
import '../Services/DatabaseServices.dart';
import '../Widgets/RoundedButton.dart';

// class CreateZipZopScreen extends StatefulWidget {
//   const CreateZipZopScreen({Key? key}) : super(key: key);
//
//   @override
//   State<CreateZipZopScreen> createState() => _CreateZipZopScreenState();
// }
//
// class _CreateZipZopScreenState extends State<CreateZipZopScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           const Text('novo zip zop'),
//           FloatingActionButton(
//             backgroundColor: Colors.white,
//             onPressed: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) =>
//                           const FeedScreen(currentUserId: 'a')));
//             },
//             child: const Icon(
//               Icons.arrow_left,
//               color: Colors.green,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

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
        title: Text(
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
            SizedBox(height: 20),
            TextField(
              maxLength: 280,
              maxLines: 7,
              decoration: InputDecoration(
                hintText: 'Enter your ZipZop',
              ),
              onChanged: (value) {
                _zipZopText = value;
              },
            ),
            SizedBox(height: 20),
            RoundedButton(
              btnText: 'Postar ZipZop',
              onBtnPressed: () async {
                setState(() {
                  _loading = true;
                });
                if (_zipZopText != null && _zipZopText.isNotEmpty) {
                  print(_zipZopText);
                  ZipZop zipZop = ZipZop(
                    text: _zipZopText,
                    // image: image,
                    authorId: widget.currentUserId,
                    likes: 0,
                    shares: 0,
                    timestamp: Timestamp.fromDate(
                      DateTime.now(),
                    ),
                    id: '${widget.currentUserId}${DateTime.now()}',
                  );
                  DatabaseServices.createZipZop(zipZop);
                  print('chamou Create ');
                  Navigator.pop(context);
                }
                setState(() {
                  _loading = false;
                });
              },
            ),
            SizedBox(height: 20),
            _loading ? CircularProgressIndicator() : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
