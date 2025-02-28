import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser({
    required String email,
    required String username,
    required String password,
    required String name,
  }) async {
    String res = "Some errors occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty && username.isNotEmpty) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await _firestore.collection("users").doc(credential.user!.uid).set({
          'name': name,
          'username': username,
          'email': email,
          'uid': credential.user!.uid,
        });

        res = "Successfully!";
      } else {
        res = "Please fill in all fields";
      }
    } catch (e) {
      return e.toString(); // Return the error message
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some errors occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (e) {
      return e.toString();
    }
    return res;
  }
}
