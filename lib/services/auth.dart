import 'package:ding_dong/models/user.dart';
import 'package:ding_dong/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get user uid
  UserId? _uidFromFirebaseUser(User? user) {
    return user != null ? UserId(uid: user.uid) : null;
  }

  //Auth changes
  Stream<UserId?> get user {
    return _auth.authStateChanges().map(_uidFromFirebaseUser);
  }

  //register with email & password
  Future signUpEmail(
      String email, String password, String ddId, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      await DatabaseService(
        user!.uid,
      ).uploadUserData(ddId, email, name);
      return _uidFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('Email alreaday registered');
        return null;
      }
    }
  }

  //sign in with email & password
  Future signInEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _uidFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      if (e.code == 'user-not-found') {
        return e.code;
      } else if (e.code == 'wrong-password') {
        return e.code;
      } else if (e.code == 'too-many-requests') {
        return e.code;
      }
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Reset password
  Future passReset(String email, String password) async {
    try {
      dynamic result = await signInEmail(email, password);
      if (result == 'user-not-found') {
        return 'user-not-found';
      } else if (result == 'wrong-password') {
        await _auth.sendPasswordResetEmail(email: email);
        return 'wrong-password';
      } else if (result == 'too-many-requests') {
        await _auth.sendPasswordResetEmail(email: email);
        return 'too-many-requests';
      } else if (result == "Instance of 'UserId'") {
        print(result.toString());
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
