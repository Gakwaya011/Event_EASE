import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/google_signin_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      // Perform login logic here
      // ignore: avoid_print
      print("Logging in with Username: ${_usernameController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF), // White at the top
              Color(0xFFFFF2DC), // Soft peach at the bottom
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey, // ✅ Wrap everything in Form for validation
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // EventEase Logo
                  Image.asset(
                    'assets/event_ease_logo.png',
                    height: 100,
                  ),
                  const SizedBox(height: 20),

                  // Welcome text
                  const Text(
                    "Welcome to Event Ease",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Sign in to use our services",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),

                  // Google Sign-In Button
                  GoogleSignInButton(),
                  const SizedBox(height: 10),

                  const Text("Or", style: TextStyle(fontSize: 14, color: Colors.grey)),

                  const SizedBox(height: 10),

                  // Username input field with validation
                  CustomTextField(
                    hintText: "Username",
                    icon: Icons.person,
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Username is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Password input field with validation
                  CustomTextField(
                    hintText: "Password",
                    icon: Icons.lock,
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 characters long";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        // Navigate to Forgot Password page
                      },
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Login Button with validation
                  ElevatedButton(
                    onPressed: _signIn, // ✅ Calls validation before signing in
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                    ),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Sign Up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          context.push('/signup'); // Navigate to Sign-up page
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
