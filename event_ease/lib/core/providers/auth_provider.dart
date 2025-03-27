
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthProvider() {
    _user = _auth.currentUser;
  }

  User? get user => _user;

  bool get isAuthenticated => _user != null;

  // 🔹 Sign in with Email & Password
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _user = _auth.currentUser;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Sign in error: $e");
      return false;
    }
  }

  // 🔹 Sign up with Email & Password
  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _user = _auth.currentUser;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Sign up error: $e");
      return false;
    }
  }

  // 🔹 Google Sign-In
  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      _user = _auth.currentUser;
      notifyListeners();
      
      return true;
    } catch (e) {
      debugPrint("Google sign-in error: $e");
      return false;
    }
  }

  // 🔹 Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}



