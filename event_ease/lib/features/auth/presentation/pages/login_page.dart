// import 'package:event_ease/core/providers/auth_provider.dart' as local_auth;
import 'package:event_ease/core/providers/auth_provider.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
//import '../widgets/custom_textfield.dart';
import '../widgets/google_signin_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? errorMessage;

  bool isLoading = false;
  bool _obscurePassword = true; 


  @override
  void initState() {
    super.initState();
    // Check if the user is already authenticated on page load
    _checkAuthenticationStatus();
  }

  void _checkAuthenticationStatus() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

     // Wait until the user data is fully loaded
    if (authProvider.isLoading) return;

    // If user info is available in the provider, navigate to dashboard
    if (authProvider.userData != null) {
      // If user is already logged in, redirect to the dashboard
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/dashboard');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFFFF2D6),
              Color(0xFFFFE4B3),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
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

                  // Email Input
                  CustomTextField(
                    hintText: "Email",
                    icon: Icons.email,
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Email is required';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },                  ),
                  const SizedBox(height: 10),

                  // Password Input
                  CustomTextField(
                    hintText: "Password",
                    icon: Icons.lock,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                    ),
                    controller: passwordController,
                    validator: (value) => value == null || value.length < 6 ? "Password must be at least 6 characters" : null,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        context.go('/reset'); // Ensure this route exists in your router
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),


                  // Error Message
                  if (errorMessage != null) ...[
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                  ],


                  // Login Button
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                          errorMessage = null;
                        });
                        bool success = await authProvider.signInWithEmail(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                        setState(() {
                          isLoading = false;
                        });
                        if (success) {
                          context.go('/otp');
                        } else {
                          setState(() {
                            errorMessage = "Invalid email or password";
                          });
                        }
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
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Sign In", style: TextStyle(fontSize: 16, color: Colors.white)),
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
      ),
    );
  }
}
