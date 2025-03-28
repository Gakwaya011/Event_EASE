// lib/widgets/google_signin_button.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/../core/providers/auth_provider.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        await Provider.of<AuthProvider>(context, listen: false).signInWithGoogle();
      },
      icon: Image.asset(
        'assets/google.png',
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
    );
  }
}
