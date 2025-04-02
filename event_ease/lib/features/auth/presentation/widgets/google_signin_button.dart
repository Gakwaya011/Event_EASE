// lib/widgets/google_signin_button.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/../core/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        
        // Show loading indicator until Google sign-in is complete
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.amber),)),
        );

        bool success = await authProvider.signInWithGoogle();
        
        if (success) {
          // Close the loading dialog
          if (Navigator.canPop(context)) Navigator.pop(context);

          // Navigate to the Dashboard after successful sign-in
          context.push('/dashboard');  // Navigate to Dashboard page
        } else {
          // Close the loading dialog and show failure message
          if (Navigator.canPop(context)) Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Google sign-in failed. Please try again.')),
          );
        }
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