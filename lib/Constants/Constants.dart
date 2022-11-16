import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

const Color KzipZopColor = Colors.lightGreen;

final _firestore = FirebaseFirestore.instance;
final storageRef = FirebaseStorage.instance.ref();

final usersRef = _firestore.collection('users');
final followersRef = _firestore.collection('followers');
final followingRef = _firestore.collection('following');
final zipZopsRef = _firestore.collection('zipzops');
final feedRefs = _firestore.collection('feeds');
final likesRefs = _firestore.collection('likes');
final activitiesRefs = _firestore.collection('activities');
