import 'package:cloud_firestore/cloud_firestore.dart';

class PomboCorreio {
  String id;
  String authorId;
  String text;
  Timestamp timestamp;
  int likes;
  int shares;

  PomboCorreio(
      {required this.id,
      required this.authorId,
      required this.text,
      required this.timestamp,
      required this.likes,
      required this.shares});

  factory PomboCorreio.fromDoc(DocumentSnapshot doc) {
    return PomboCorreio(
        id: doc.id,
        authorId: doc['authorId'],
        text: doc['text'],
        timestamp: doc['timestamp'],
        likes: doc['likes'],
        shares: doc['shares']);
  }
}
