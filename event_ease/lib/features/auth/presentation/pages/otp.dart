import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OTP Confirmation',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      home: const OtpScreen(),
    );
  }
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F2),
      body: Stack(
        children: [
          // Background design at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/image4.png', // Diagonal lines at the bottom
              fit: BoxFit.fitWidth,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Verification Badge Icon
                  Image.asset(
                    'assets/image3.png', // Orange badge with checkmark
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(height: 40),

                  // Title
                  Image.asset(
                    'assets/image2.png', // "Confirm OTP" text image
                    height: 30,
                  ),
                  const SizedBox(height: 16),

                  // Instructions Text
                  Image.asset(
                    'assets/image7.png', // OTP instructions text
                    height: 40,
                  ),
                  const SizedBox(height: 30),

                  // OTP Input Fields
                  Image.asset(
                    'assets/image5.png', // Input boxes for OTP
                    height: 48,
                  ),
                  const SizedBox(height: 40),

                  // Send Button
                  Image.asset(
                    'assets/image6.png', // Send button
                    height: 50,
                  ),
                ],
              ),
            ),
          ),

          // Add the interactive elements on top
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 150), // Space for top elements
                  // OTP Input Fields - interactive
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                      (index) => SizedBox(
                        width: 48,
                        height: 48,
                        child: TextField(
                          controller: _otpControllers[index],
                          focusNode: _focusNodes[index],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged:
                              (value) => _onOtpDigitChanged(index, value),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Send Button - interactive
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle OTP verification
                        final otp =
                            _otpControllers
                                .map((controller) => controller.text)
                                .join();
                        print('Verifying OTP: $otp');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFBB96A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Send',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
