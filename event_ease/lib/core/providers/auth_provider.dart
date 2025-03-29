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
  // Getter to access the current user object
  User? get currentUser {
    return _auth.currentUser;
  }


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
          "status": false,
          "eventsCreated": [],
          "eventsParticipating": [],
          "photoURL": null,
          "role": [],
          "preferedBudget": null,
          "preferedCategory": [],
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
        // print(_userData!.email);
        // print(_userData!.status);
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
    notifyListeners();
  }


// save data from onboarding
Future<void> saveOnboardingData({ List<String>? role, String? preferedBudget, List<String>? preferedCategory }) async {
  
  if (_user == null) {
    throw Exception("User not authenticated");
  }

  try {
    await FirebaseFirestore.instance.collection('users').doc(_user!.uid).update({
      'role': role,
      'preferedBudget': preferedBudget,
      'preferedCategory': preferedCategory,
      'status': true
    });
    // Fetch the user data after signing up
    await _fetchUserData(_user!.uid);
  } catch (e) {
    debugPrint("Error saving user data: $e");
    throw Exception("Failed to save user data");
  }
}

// Update user's events list
void updateUserEvents(List<String> eventIds) {
    if (currentUser != null) {
      print('Updating user events: $eventIds');
      // Update the local state
      userData?.eventsCreated.addAll(eventIds);
      userData?.eventsParticipating.addAll(eventIds);

      // Notify listeners so that all screens that are listening to AuthProvider will update
      notifyListeners();
    }
  }

}




