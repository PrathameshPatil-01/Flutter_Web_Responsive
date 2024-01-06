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
    apiKey: 'AIzaSyB7GrQ0dngHT6BSpVM9DNDV4dBHZGAIj8g',
    appId: '1:387183537857:web:8bed271af17efb1c8d6e40',
    messagingSenderId: '387183537857',
    projectId: 'flutter-web-1c692',
    authDomain: 'flutter-web-1c692.firebaseapp.com',
    storageBucket: 'flutter-web-1c692.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCrqw6VTVGOTKQbIkoQhToZpB2yZExO9PA',
    appId: '1:387183537857:android:f1da49b8e0f9fc0f8d6e40',
    messagingSenderId: '387183537857',
    projectId: 'flutter-web-1c692',
    storageBucket: 'flutter-web-1c692.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB4k3mdnedryJ9JhUkD-2CuvaROl4kh2Og',
    appId: '1:387183537857:ios:dd585a9a09d537388d6e40',
    messagingSenderId: '387183537857',
    projectId: 'flutter-web-1c692',
    storageBucket: 'flutter-web-1c692.appspot.com',
    iosBundleId: 'com.example.webAuth',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB4k3mdnedryJ9JhUkD-2CuvaROl4kh2Og',
    appId: '1:387183537857:ios:e8c1d48fccf0cb3f8d6e40',
    messagingSenderId: '387183537857',
    projectId: 'flutter-web-1c692',
    storageBucket: 'flutter-web-1c692.appspot.com',
    iosBundleId: 'com.example.webAuth.RunnerTests',
  );
}
