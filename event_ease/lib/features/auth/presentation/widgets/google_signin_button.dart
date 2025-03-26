import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/../core/providers/auth_provider.dart';

class GoogleSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Image.asset('assets/google.png', height: 20),
      label: const Text("Sign in with Google"),
      onPressed: () {
        Provider.of<AuthProvider>(context, listen: false).signInWithGoogle();
      },
    );
  }
}
