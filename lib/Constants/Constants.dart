import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// Cores
const Color KzipZopColor = Colors.lightGreen;

const Color defaultDarkColor = Color.fromARGB(255, 56, 56, 56);
const Color defaultLightColor = Color.fromARGB(255, 243, 243, 243);
const Color defaultGrayColor = Color.fromARGB(180, 120, 120, 120);

const Color primaryColor = Color.fromARGB(255, 16, 229, 186);
const Color secondaryColor = Color.fromARGB(255, 18, 186, 152);
const Color tertiaryColor = Color.fromARGB(255, 4, 64, 52);

final _firestore = FirebaseFirestore.instance;
final storageRef = FirebaseStorage.instance.ref();

final usersRef = _firestore.collection('users');
final followersRef = _firestore.collection('followers');
final followingRef = _firestore.collection('following');
final zipZopsRef = _firestore.collection('zipzops');
final feedRefs = _firestore.collection('feeds');
final likesRef = _firestore.collection('likes');
final activitiesRef = _firestore.collection('activities');
