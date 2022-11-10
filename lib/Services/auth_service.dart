import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  static Future<bool> signUp(String name, String email, String password) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? signedInUser = authResult.user;
      if (signedInUser != null) {
        _firestore
            .collection('users')
            .doc(signedInUser.uid)
            .set({'name': name, 'email': email, 'profilePicture': ''});
        print('Usuário registrado com sucesso');
        return true;
      }
      return false;
    } catch (e) {
      print(e);
    }
    return false;
  }
}
