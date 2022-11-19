import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sabia_app/Services/DatabaseServices.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  static Future<List<dynamic>> signUp(
      String name, String email, String password) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? signedInUser = authResult.user;
      if (signedInUser != null) {
        _firestore.collection('users').doc(signedInUser.uid).set({
          'name': name,
          'email': email,
          'profilePicture': DatabaseServices.randomImageProfilePicker(),
          'coverImage': DatabaseServices.randomBackgroundImagePicker(),
          'bio': '(Insira biografia)'
        });
        return [true, signedInUser];
      }
      return [false, null];
    } catch (e) {
      print('Falha ao cadastrar $email. \nMensagem de erro: $e');
    }
    return [false, null];
  }

  static Future<List<dynamic>> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return [true, _auth.currentUser?.uid];
    } catch (e) {
      print('Falha ao fazer login com $email. \nMensagem de erro: $e');
      return [false, null];
    }
  }

  static Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(
          'Falha ao sair da conta ${_auth.currentUser?.email}. Mensagem de erro: $e');
    }
  }
}
