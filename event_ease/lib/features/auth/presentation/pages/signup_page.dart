import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/google_signin_button.dart';
// ignore: unused_import
import 'login_page.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Sign Up", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),

            CustomTextField(hintText: "Full Name", icon: Icons.person),
            CustomTextField(hintText: "Email", icon: Icons.email),
            CustomTextField(hintText: "Password", icon: Icons.lock, obscureText: true),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                // Implement sign-up logic
              },
              child: Text("Sign Up"),
            ),

            const SizedBox(height: 10),

            GoogleSignInButton(),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    context.push('/login'); // Navigate back to Login Page
                  },
                  child: const Text("Login"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
