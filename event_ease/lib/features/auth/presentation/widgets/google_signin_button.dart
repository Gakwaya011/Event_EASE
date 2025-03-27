import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/../core/providers/auth_provider.dart';

class GoogleSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Implement Goog
        //le Sign-In logic
        Provider.of<AuthProvider>(context, listen: false).signInWithGoogle();
        
     
      },
      icon: Image.asset(
        'assets/google.png', // Ensure this asset exists
        height: 24,
        width: 24,
      ),
      label: const Text('Sign in with Google'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    ); // Closing parentheses added here
  }
}
