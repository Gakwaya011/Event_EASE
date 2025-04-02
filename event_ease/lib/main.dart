import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart'; // Add this import
import 'package:provider/provider.dart';
import 'core/providers/event_provider.dart';
import 'firebase_options.dart';
import 'core/navigation/router.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'core/providers/auth_provider.dart' as local_auth; 
import 'package:firebase_auth/firebase_auth.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling background message: ${message.messageId}");
}

Future<void> requestPermission() async {
  final status = await Permission.notification.request();
  if (status.isGranted) {
    print("Notification Permission Granted");
  } else {
    print("Notification Permission Denied");
  }
}

FirebaseMessaging messaging = FirebaseMessaging.instance;

Future<void> getFCMToken() async {
  String? token = await messaging.getToken();
  print("FCM Token: $token");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } else {
    await Firebase.initializeApp();
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Request notification permission
  // await requestPermission();

  // Get FCM token
  // await getFCMToken();

  // ✅ Set Firebase Authentication language to English
  FirebaseAuth.instance.setLanguageCode("en");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => local_auth.AuthProvider()), 
        ChangeNotifierProvider(create: (_) => EventProvider()),
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
      routerConfig: router,
    );
  }
}
