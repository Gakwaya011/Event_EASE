// lib/core/providers/auth_provider.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthProvider() {
    _initializeUser();
  }

  User? get user => _user;

  bool get isAuthenticated => _user != null;

  // ✅ Initialize user safely after Firebase is ready
  Future<void> _initializeUser() async {
    await Future.delayed(Duration.zero);
    _user = _auth.currentUser;
    notifyListeners();
  }

  // ✅ Sign in with Email & Password
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

  // ✅ Sign up with Email & Password
  Future<bool> signUpWithEmail(String email, String password) async {
  try {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
    _user = _auth.currentUser;
    notifyListeners();
    return true;
  } on FirebaseAuthException catch (e) {
    debugPrint("FirebaseAuthException: ${e.message}");
    return false;
  } catch (e) {
    debugPrint("Unknown error: $e");
    return false;
  }
}

  // ✅ Google Sign-In
Future<bool> signInWithGoogle() async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: kIsWeb 
          ? "335284132892-suvld18m3qbqvvadvin2tt5t9es99c11.apps.googleusercontent.com"  // ✅ Web client ID
          : null, // ✅ Android/iOS does not need this
    );

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      debugPrint("Google sign-in was cancelled.");
      return false;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    _user = FirebaseAuth.instance.currentUser;
    debugPrint("User signed in: ${_user?.email}");
    notifyListeners();

    return true;
  } catch (e) {
    debugPrint("Google sign-in error: $e");
    return false;
  }
}


  // ✅ Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
