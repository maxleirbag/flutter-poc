import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const Color KzipZopColor = Colors.red;

final _firestore = FirebaseFirestore.instance;

final usersRef = _firestore.collection('users');
final followersRef = _firestore.collection('followers');
final followingRef = _firestore.collection('following');
