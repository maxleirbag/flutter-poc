import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  static Future<bool> signUp(String name, String email, String password) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? signedInUser = authResult.user;
      if (signedInUser != null) {
        _firestore.collection('users').doc(signedInUser.uid).set({
          'name': name,
          'email': email,
          'profilePicture': '',
          'coverImage': '',
          'bio': ''
        });
        print('Usuário registrado com sucesso');
        return true;
      }
      return false;
    } catch (e) {
      print(e);
    }
    return false;
  }

  // static Future<bool> signIn(String email, String password) async {
  static Future<List<dynamic>> signIn(String email, String password) async {
    try {
      print(_auth.currentUser);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print(_auth.currentUser);
      return [true, _auth.currentUser?.uid];
    } catch (e) {
      print(e);
      print('login problem');
      return [false, null];
    }
  }

  static Future<void> logout() async {
    try {
      print(_auth.currentUser);
      await _auth.signOut();
      print(_auth.currentUser);
      // _auth.userChanges();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
