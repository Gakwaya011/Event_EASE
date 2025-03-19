import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/google_signin_button.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      // Save the user data to the database or authentication service
      // For now, we just print the details
      print("Sign Up successful for ${nameController.text}, Email: ${emailController.text}");
      // Navigate to login page after successful sign-up
      context.push('/login');
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey, // Add Form key
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEB7D3A), // App orange color
                  ),
                ),

                const SizedBox(height: 20),

                // Full Name input field
                CustomTextField(
                  hintText: "Full Name",
                  icon: Icons.person,
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Full Name is required";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                // Email input field with validation
                CustomTextField(
                  hintText: "Email",
                  icon: Icons.email,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(value)) {
                      return "Enter a valid email";
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
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Sign Up Button
                ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEB7D3A), // App orange color
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 10),

                // Google Sign-In Button
                GoogleSignInButton(),

                const SizedBox(height: 10),

                // Login redirect
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        context.push('/login'); // Navigate to login page
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Color(0xFFEB7D3A)), // App orange color
                      ),
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
