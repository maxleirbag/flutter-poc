import 'package:cloud_firestore/cloud_firestore.dart';

class ZipZop {
  String id;
  String authorId;
  String text;
  String image;
  Timestamp timestamp;
  int likes;
  int shares;

  ZipZop(
      {required this.id,
      required this.authorId,
      required this.text,
      required this.image,
      required this.timestamp,
      required this.likes,
      required this.shares});

  factory ZipZop.fromDoc(DocumentSnapshot doc) {
    return ZipZop(
        id: doc.id,
        authorId: doc['authorId'],
        text: doc['text'],
        image: doc['image'],
        timestamp: doc['timestamp'],
        likes: doc['likes'],
        shares: doc['shares']);
  }
}
