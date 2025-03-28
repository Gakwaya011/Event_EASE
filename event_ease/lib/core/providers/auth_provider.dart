// lib/core/providers/auth_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'user_model.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  UserModel? _userData;
  bool _isLoading = true;  

  AuthProvider() {
    _initializeUser();
  }

  User? get user => _user;
  UserModel? get userData => _userData;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;


  // Initialize user data after Firebase is ready
  Future<void> _initializeUser() async {
    _user = _auth.currentUser;
    if (_user != null) {
      await _fetchUserData(_user!.uid);
    }
    _isLoading = false; // Set loading to false once user data is fetched
    notifyListeners();
  }

  // Sign in with Email & Password
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _user = _auth.currentUser;

      if (_user != null) {
        // Fetch user data and store it in the provider
        await _fetchUserData(_user!.uid);
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Sign in error: $e");
      return false;
    }
  }

  // Sign up with Email & Password
  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password,
      );

      _user = userCredential.user;

      if (_user != null) {
        // Save user data in Firestore
        await FirebaseFirestore.instance.collection('users').doc(_user!.uid).set({
          "email": email,
          "created_at": DateTime.now(),
          'eventsParticipating': [],
          'eventsCreated': [],
          'photoURL': '',
          'name': '',
          'status': false
        });
        // Fetch the user data after signing up
        await _fetchUserData(_user!.uid);
      }

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

  // Google Sign-In
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

      if (_user != null) {
        // Fetch user data and store it in the provider
        await _fetchUserData(_user!.uid);
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Google sign-in error: $e");
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _userData = null;  // Clear the user data as well
    notifyListeners();
  }

  // Fetch user data from Firestore and store it in the provider
  Future<void> _fetchUserData(String uid) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        // Convert Firestore data to UserModel and update provider
        _userData = UserModel.fromFirestore(userDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
    notifyListeners();
  }
}
