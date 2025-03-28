import 'package:event_ease/core/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/google_signin_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFFFF2D6),
              Color(0xFFFFE4B3),],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/event_ease_logo.png', height: 100),
                const SizedBox(height: 20),

                const Text(
                  "Welcome to Event Ease",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Sign in to use our services",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),

                GoogleSignInButton(),
                const SizedBox(height: 10),
                const Text("Or", style: TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 10),

                CustomTextField(
                  controller: emailController,
                  hintText: "Email",
                  icon: Icons.email,
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                CustomTextField(
                  controller: passwordController,
                  hintText: "Password",
                  icon: Icons.lock,
                  obscureText: true,
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return 'Please enter your password';
                    }
                  },
                ),
                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () async {
                    print("Attempting login with email: ${emailController.text.trim()}");
                    await authProvider.signInWithEmail(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                    if (authProvider.isAuthenticated) {
                      context.go('/dashboard');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                   backgroundColor: const Color(0xFFFFAD33),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                  ),
                  child: const Text("Sign In", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        context.go('/signup');
                      },
                      child: const Text("Sign up", style: TextStyle(color: Colors.orange)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
