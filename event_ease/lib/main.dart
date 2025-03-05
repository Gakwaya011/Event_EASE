import 'package:flutter/material.dart';
import 'pages/dashboard.dart'; 
import 'pages/singl_event.dart';

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
      home: SinglEvent(),
    );
  }
}
