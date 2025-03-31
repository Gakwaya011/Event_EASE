import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'core/navigation/router.dart';
import 'core/providers/auth_provider.dart' as local_auth; 
import 'firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    //
    // ✅ Web requires FirebaseOptions
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } else {
    // ✅ Mobile initializes normally
    await Firebase.initializeApp();
  }

  // ✅ Set Firebase Authentication language to English
  FirebaseAuth.instance.setLanguageCode("en");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => local_auth.AuthProvider()), // ✅ Use local alias
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
