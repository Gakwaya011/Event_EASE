import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
// import '../../../../core/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpVerificationScreen extends StatefulWidget {
  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController phoneController = TextEditingController();
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> _sendOTP() async {
    String phoneNumber = phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid phone number")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          // Only show error if the phone number is incorrect
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Verification failed: ${e.message}")),
          );
          setState(() {
            _isLoading = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _isLoading = false;
          });
          if (verificationId.isNotEmpty) {
            // If the verification ID is received, show the OTP modal
            showOtpInputModal(context, phoneNumber, verificationId);
          } else {
            // If verification ID is empty, it means there was an error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to send OTP. Please try again.")),
            );
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto retrieval timeout callback
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred: ${e.toString()}")),
      );
    }
  }

void showOtpInputModal(BuildContext context, String phoneNumber, String verificationId) {
  final otpController = TextEditingController();
  bool isVerifying = false;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.amber[50],
            title: Text("Enter OTP"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("We've sent a verification code to $phoneNumber", style: TextStyle(fontSize: 14)),
                SizedBox(height: 20),
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: "6-digit code",
                    counterText: "",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel", style: TextStyle(color: Colors.grey[700])),
              ),
              ElevatedButton(
                onPressed: isVerifying
                    ? null
                    : () async {
                        if (otpController.text.length == 6) {
                          setState(() {
                            isVerifying = true;
                          });

                          try {
                            // Verify OTP with the verification ID and the entered code
                            PhoneAuthCredential credential = PhoneAuthProvider.credential(
                              verificationId: verificationId,
                              smsCode: otpController.text,
                            );

                            // Sign in with the credential
                            await _auth.signInWithCredential(credential);
                            Navigator.of(dialogContext).pop();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Phone verified successfully!"), backgroundColor: Colors.green),
                            );

                            // Navigate to home or profile page
                            context.go('/dashboard');
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Invalid OTP. Please try again."), backgroundColor: Colors.red),
                            );

                            setState(() {
                              isVerifying = false;
                            });
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please enter a valid 6-digit OTP."), backgroundColor: Colors.amber[700]),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFAD33), foregroundColor: Colors.white),
                child: isVerifying
                    ? SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                      )
                    : Text("Verify"),
              ),
            ],
          );
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Verification"),
        backgroundColor: const Color.fromARGB(255, 244, 175, 71),
        foregroundColor: Colors.white,
      ),
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
                      Icons.phone_android,
                      size: 70,
                      color: Colors.amber[800],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                // Heading Text
                Text(
                  "Verify Your Phone Number",
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                // Explanatory Text
                Text(
                  "Enter your phone number below and we'll send you a one-time verification code.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 40),
                // Phone TextField with full border
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    hintText: "Enter your phone number",
                    prefixIcon: Icon(Icons.phone, color: Colors.amber[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.amber[600]!, width: 2.0),
                    ),
                    filled: true,
                    fillColor: Colors.amber[50],
                  ),
                ),
                SizedBox(height: 30),
                // Send OTP Button with loading indicator
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFAD33),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(double.infinity, 50),
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
                              "Sending OTP...",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : Text(
                          "Send Verification Code",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}