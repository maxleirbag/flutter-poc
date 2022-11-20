import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firestore = FirebaseFirestore.instance;
final storageRef = FirebaseStorage.instance.ref();

final usersRef = _firestore.collection('users');
final followersRef = _firestore.collection('followers');
final followingRef = _firestore.collection('following');
final pomboCorreiosRef = _firestore.collection('pomboscorreios');
final feedRefs = _firestore.collection('feeds');
final likesRef = _firestore.collection('likes');
final activitiesRef = _firestore.collection('activities');
