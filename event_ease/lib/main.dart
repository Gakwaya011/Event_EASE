import 'package:flutter/material.dart';
import 'pages/dashboard.dart'; 
import 'pages/singl_event.dart';
import 'pages/create_event.dart';
import 'pages/onboarding.dart';
import 'pages/profile.dart';
import 'pages/splash.dart';
import 'pages/otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget { 
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EventEase',
      initialRoute: '/otp', // Set the initial route
      routes: {
        '/': (context) => EventPlannerHome(),
        '/event': (context) => SinglEvent(),
        '/create': (context) => CreateEventPage(),
        '/onboarding': (context) => OnboardingScreen(),
        '/profile': (context) => ProfilePage(),
        '/splash': (context) => SplashPage(),
        '/otp': (context) => OTPConfirmationPage(),
      },
    );
  }
}
