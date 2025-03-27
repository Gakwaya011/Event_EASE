// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCAt6uBTlPBI5_RX2BZOBLLoQa0toE6-JA',
    appId: '1:335284132892:web:78fceae5d3cd50548fd3d9',
    messagingSenderId: '335284132892',
    projectId: 'eventease-e6bda',
    authDomain: 'eventease-e6bda.firebaseapp.com',
    storageBucket: 'eventease-e6bda.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBKIW939wO_e4VIHJx3S5dByYghJO37r3k',
    appId: '1:335284132892:android:7812df68d8a9eeb48fd3d9',
    messagingSenderId: '335284132892',
    projectId: 'eventease-e6bda',
    storageBucket: 'eventease-e6bda.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAZ0pMqN_CZEVXRy-cMd92cn4LCkeLijNk',
    appId: '1:335284132892:ios:a1900efbecad75628fd3d9',
    messagingSenderId: '335284132892',
    projectId: 'eventease-e6bda',
    storageBucket: 'eventease-e6bda.firebasestorage.app',
    iosBundleId: 'com.example.eventEase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAZ0pMqN_CZEVXRy-cMd92cn4LCkeLijNk',
    appId: '1:335284132892:ios:a1900efbecad75628fd3d9',
    messagingSenderId: '335284132892',
    projectId: 'eventease-e6bda',
    storageBucket: 'eventease-e6bda.firebasestorage.app',
    iosBundleId: 'com.example.eventEase',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCAt6uBTlPBI5_RX2BZOBLLoQa0toE6-JA',
    appId: '1:335284132892:web:4d5398ca1e30b3dd8fd3d9',
    messagingSenderId: '335284132892',
    projectId: 'eventease-e6bda',
    authDomain: 'eventease-e6bda.firebaseapp.com',
    storageBucket: 'eventease-e6bda.firebasestorage.app',
  );
}
