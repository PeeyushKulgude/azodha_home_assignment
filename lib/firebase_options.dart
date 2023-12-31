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
    apiKey: 'AIzaSyCOabH99q3-I5jpBUMvy1DCUabzBFnNDPw',
    appId: '1:317937380867:web:a95d73d6136e231cafe836',
    messagingSenderId: '317937380867',
    projectId: 'contacts-b0ff4',
    authDomain: 'contacts-b0ff4.firebaseapp.com',
    databaseURL: 'https://contacts-b0ff4-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'contacts-b0ff4.appspot.com',
    measurementId: 'G-1Y4J863FVW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAec33QBLmwNRjvH0cCd-LTnHXPpjknLTw',
    appId: '1:317937380867:android:20c2d473c7ff8c80afe836',
    messagingSenderId: '317937380867',
    projectId: 'contacts-b0ff4',
    databaseURL: 'https://contacts-b0ff4-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'contacts-b0ff4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAYAHjdngNY2HFBZbZSPAqPWNKnBoiCcj0',
    appId: '1:317937380867:ios:8a15672aa8a4689aafe836',
    messagingSenderId: '317937380867',
    projectId: 'contacts-b0ff4',
    databaseURL: 'https://contacts-b0ff4-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'contacts-b0ff4.appspot.com',
    iosBundleId: 'com.example.contacts',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAYAHjdngNY2HFBZbZSPAqPWNKnBoiCcj0',
    appId: '1:317937380867:ios:7b9eb4bb8292d2e3afe836',
    messagingSenderId: '317937380867',
    projectId: 'contacts-b0ff4',
    databaseURL: 'https://contacts-b0ff4-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'contacts-b0ff4.appspot.com',
    iosBundleId: 'com.example.contacts.RunnerTests',
  );
}
