import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/navigation/router.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/auth_provider.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;



Future<void> main() async {
  

WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // ✅ Web requires FirebaseOptions
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } else {
    // ✅ Mobile initializes normally
    await Firebase.initializeApp();
  }

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