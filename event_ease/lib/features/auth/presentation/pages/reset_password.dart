import 'package:flutter/material.dart';
import '../../../../core/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final AuthProvider _authService = AuthProvider();
  bool _isLoading = false;

  void sendResetEmail() async {
    String email = emailController.text.trim();
    if (email.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        await _authService.resetPassword(email);
        // Show modal dialog after completing the request
        showSuccessModal(context);
      } catch (e) {
        // Handle error if needed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to send reset email. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        // Ensure loading state is reset even if there's an error
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter a valid email."),
          backgroundColor: Colors.amber[700],
        ),
      );
    }
  }

  void showSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.amber[50],
          title: Text(
            "Email Sent!",
          ),
          content: Text(
            "Please check your email for the reset password link.",
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.amber[900],
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to login page using go_router
                context.go('/login');
              },
              child: Text("Go to Login"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use amber theme
    final amberTheme = ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFFFAD33),
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.amber[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.amber[600]!, width: 2.0),
        ),
        labelStyle: TextStyle(color: Colors.amber[800]),
        filled: true,
        fillColor: Colors.amber[50],
      ),
    );

    return Theme(
      data: amberTheme,
      child: Scaffold(
        appBar: AppBar(title: Text("Reset Password")),
        body: Container(
          height: double.infinity,
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  // App Logo
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.amber, width: 2),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.lock_reset,
                        size: 70,
                        color: Colors.amber[800],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Heading Text
                  Text(
                    "Forgot Your Password?",
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Explanatory Text
                  Text(
                    "Enter your email address below and we'll send you a link to reset your password.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 40),
                  // Email TextField with full border
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      prefixIcon: Icon(Icons.email, color: Colors.amber[600]),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Reset Button with loading indicator
                  ElevatedButton(
                    onPressed: _isLoading ? null : sendResetEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFAD33),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(double.infinity, 50),
                      // When loading, keep the button's appearance consistent but disable it
                      disabledBackgroundColor: Color(0xFFFFAD33).withOpacity(0.7),
                      disabledForegroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Sending...",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        : Text(
                            "Send Reset Link",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                  SizedBox(height: 20),
                  // Return to Login Link
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: Text(
                      "Back to Login",
                      style: TextStyle(color: Colors.amber[800]),
                    ),
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