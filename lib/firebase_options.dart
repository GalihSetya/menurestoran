// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBEsZopi8zbcbSA6aFVrC34gQZZS6c64C8',
    appId: '1:541628732798:web:04a03dc8f6e7d47bd24f2f',
    messagingSenderId: '541628732798',
    projectId: 'fir-flutter-codelab-a3b84',
    authDomain: 'fir-flutter-codelab-a3b84.firebaseapp.com',
    storageBucket: 'fir-flutter-codelab-a3b84.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCfJcTTkXfauNJu6sMrETjidusUgqegjXA',
    appId: '1:541628732798:android:9f2a23e65fbaba0cd24f2f',
    messagingSenderId: '541628732798',
    projectId: 'fir-flutter-codelab-a3b84',
    storageBucket: 'fir-flutter-codelab-a3b84.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB885j1B03jJ91La8N2di0jpc4jRxtsr5A',
    appId: '1:541628732798:ios:23a385e26cfcea9dd24f2f',
    messagingSenderId: '541628732798',
    projectId: 'fir-flutter-codelab-a3b84',
    storageBucket: 'fir-flutter-codelab-a3b84.appspot.com',
    iosClientId: '541628732798-v7pp8elnurlv5e2v2t0s4u9qetpjhli8.apps.googleusercontent.com',
    iosBundleId: 'com.example.menurestoran',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB885j1B03jJ91La8N2di0jpc4jRxtsr5A',
    appId: '1:541628732798:ios:23a385e26cfcea9dd24f2f',
    messagingSenderId: '541628732798',
    projectId: 'fir-flutter-codelab-a3b84',
    storageBucket: 'fir-flutter-codelab-a3b84.appspot.com',
    iosClientId: '541628732798-v7pp8elnurlv5e2v2t0s4u9qetpjhli8.apps.googleusercontent.com',
    iosBundleId: 'com.example.menurestoran',
  );
}
