import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/navigation/router.dart';
import 'core/providers/auth_provider.dart';
// import 'firebase_options.dart';



Future<void> main() async {
  

WidgetsFlutterBinding.ensureInitialized();

  // if (Firebase.apps.isEmpty) {
  //   await Firebase.initializeApp();
  // }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()), // ✅ Provide AuthProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router, // Use GoRouter for navigation
    );
  }
}