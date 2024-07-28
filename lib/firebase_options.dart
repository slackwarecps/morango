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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCtdRVjs8-nH8FYE3okalZDwdchkfJc9CU',
    appId: '1:299976161637:web:61b120886069024462898c',
    messagingSenderId: '299976161637',
    projectId: 'teste123-8236a',
    authDomain: 'teste123-8236a.firebaseapp.com',
    storageBucket: 'teste123-8236a.appspot.com',
    measurementId: 'G-XVMY6ZF075',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBrKU_thmc-avjqeIg34hqJFesEdGbEioI',
    appId: '1:299976161637:android:7f99933c4c8db8b362898c',
    messagingSenderId: '299976161637',
    projectId: 'teste123-8236a',
    storageBucket: 'teste123-8236a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC4wgRofLnTrJkfMxqCs-b7USXHHWpPCTI',
    appId: '1:299976161637:ios:78786e4f2260a6e962898c',
    messagingSenderId: '299976161637',
    projectId: 'teste123-8236a',
    storageBucket: 'teste123-8236a.appspot.com',
    iosBundleId: 'br.com.fabioalvaro.morango',
  );

}