import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// Cores
const Color KzipZopColor = Colors.lightGreen;

const defaultFontColor = Colors.black;
const opositeFontColor = Colors.white;

const Color primaryColorLight = Colors.yellow;
const Color secondaryColorLight = Colors.yellow;
const Color tertiaryColorLight = Colors.yellowAccent;

const Color primaryColorDark = Colors.red;
const Color secondaryColorDark = Colors.red;
const Color tertiaryColorDark = Colors.red;
//

final _firestore = FirebaseFirestore.instance;
final storageRef = FirebaseStorage.instance.ref();

final usersRef = _firestore.collection('users');
final followersRef = _firestore.collection('followers');
final followingRef = _firestore.collection('following');
final zipZopsRef = _firestore.collection('zipzops');
final feedRefs = _firestore.collection('feeds');
final likesRef = _firestore.collection('likes');
final activitiesRef = _firestore.collection('activities');
