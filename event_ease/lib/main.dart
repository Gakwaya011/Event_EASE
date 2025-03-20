import 'package:event_ease/pages/special_event.dart';
import 'package:flutter/material.dart';
import 'pages/special_event.dart';
import 'package:event_ease/pages/profile.dart';
import 'package:event_ease/pages/splash.dart';
//import 'pages/singl_event.dart';
//import 'pages/create_event.dart';
//import 'pages/onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EventEase',
      initialRoute: '/splash', // Set the initial route
      routes: {
        // '/': (context) => SpecialEvent(),
        // '/profile': (context) => ProfilePage(),
        '/splash': (context) => SplashPage(),
        // '/create': (context) => CreateEventPage(),
        // '/onboarding': (context) => OnboardingScreen(),
      },
    );
  }
}
