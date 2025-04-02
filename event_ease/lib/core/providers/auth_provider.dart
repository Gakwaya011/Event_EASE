// lib/core/providers/auth_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'user_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (kIsWeb) {
      await _auth.setPersistence(Persistence.LOCAL); // ✅ Ensures persistence on web
    }

    _user = isLoggedIn ? _auth.currentUser : null;
    if (_user != null) {
      await _fetchUserData(_user!.uid);
    }
    _isLoading = false; // Set loading to false once user data is fetched
    notifyListeners();
  }

  // ✅ Save login state
  Future<void> _setLoginState(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
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
      await _setLoginState(true); // Save login state

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Sign in error: $e");
      return false;
    }
  }


  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent.");
    } on FirebaseAuthException catch (e) {
      print("Error: $e");
    }
  }


  // Sign up with Email & Password
  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password,
      );

      _user = userCredential.user;
      await _setLoginState(true); // Save login state

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

    // ✅ Fetch and update user data from Firestore or API
    await _fetchUserData(_user!.uid);

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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Clear login state
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
      // Update the local state
      userData?.eventsCreated.addAll(eventIds);
      userData?.eventsParticipating.addAll(eventIds);

      // Notify listeners so that all screens that are listening to AuthProvider will update
      notifyListeners();
    }
  }


// Update user data in Firestore and local state
Future<void> updateUserData({
  String? name,
  String? email,
  List<String>? role,
  String? preferedBudget,
  List<String>? preferedCategory,
}) async {
  if (_user == null) {
    throw Exception("User not authenticated");
  }

  try {
    // Prepare the update map
    Map<String, dynamic> updatedData = {
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (role != null) 'role': role,
      if (preferedBudget != null) 'preferedBudget': preferedBudget,
      if (preferedCategory != null) 'preferedCategory': preferedCategory,
    };

    // Update Firestore
    await FirebaseFirestore.instance.collection('users').doc(_user!.uid).update(updatedData);

    // Update local userData state
    if (_userData != null) {
      _userData = _userData!.copyWith(
        name: name ?? _userData!.name,
        email: email ?? _userData!.email,
        role: role ?? _userData!.role,
        preferedBudget: preferedBudget ?? _userData!.preferedBudget,
        preferedCategory: preferedCategory ?? _userData!.preferedCategory,
      );
    }

    notifyListeners();
  } catch (e) {
    debugPrint("Error updating user data: $e");
    throw Exception("Failed to update user data");
  }
}











}