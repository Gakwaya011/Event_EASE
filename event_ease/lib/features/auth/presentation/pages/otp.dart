import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPConfirmationPage extends StatefulWidget {
  @override
  _OTPConfirmationPageState createState() => _OTPConfirmationPageState();
}

class _OTPConfirmationPageState extends State<OTPConfirmationPage> {
  final List<TextEditingController> _otpControllers = 
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    // Add listener to handle pasting entire OTP
    _otpControllers[0].addListener(_handlePastedOTP);
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _handlePastedOTP() {
    String pastedText = _otpControllers[0].text;
    
    // Check if pasted text is exactly 6 digits
    if (pastedText.length == 6 && int.tryParse(pastedText) != null) {
      // Distribute pasted OTP across input fields
      for (int i = 0; i < 6; i++) {
        _otpControllers[i].text = pastedText[i];
      }
      // Move focus to last field
      FocusScope.of(context).requestFocus(_focusNodes[5]);
    }
  }

  void _onOTPChanged(int index, String value) {
    if (value.length == 1) {
      // Move focus to next input
      if (index < 5) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      }
    }
  }

  void _sendOTP() {
    // Implement OTP verification logic here
    String otpCode = _otpControllers.map((controller) => controller.text).join();
    print('Entered OTP: $otpCode');
    // Add your verification logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Verification Badge
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.orange[400],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                
                // Title
                Text(
                  'Confirm OTP',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                
                // Subtitle
                Text(
                  'The OTP was sent to your email, please enter the code below to sign in',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 30),
                
                // OTP Input Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Container(
                      width: 50,
                      height: 60,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: TextStyle(fontSize: 24),
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.orange, width: 2),
                          ),
                        ),
                        onChanged: (value) => _onOTPChanged(index, value),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    );
                  }),
                ),
                SizedBox(height: 30),
                
                // Send Button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _sendOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Send',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}