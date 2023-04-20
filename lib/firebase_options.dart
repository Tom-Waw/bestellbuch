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
    apiKey: 'AIzaSyA8q9rw6haFIeeYmtXxJ-rUjK_Ef4HFDD4',
    appId: '1:844137022732:web:fec400426b82f412a6f529',
    messagingSenderId: '844137022732',
    projectId: 'bb-firebase-26fbf',
    authDomain: 'bb-firebase-26fbf.firebaseapp.com',
    storageBucket: 'bb-firebase-26fbf.appspot.com',
    measurementId: 'G-BKBK20DK4W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC7pXByeC5545CicrzOjOxHuWFVrglYoaw',
    appId: '1:844137022732:android:51a83075e1881f4aa6f529',
    messagingSenderId: '844137022732',
    projectId: 'bb-firebase-26fbf',
    storageBucket: 'bb-firebase-26fbf.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDenwYOW2BqQTihfhFbir9ppJ2tXD5-zQE',
    appId: '1:844137022732:ios:4cf37ac5b3b7a7cea6f529',
    messagingSenderId: '844137022732',
    projectId: 'bb-firebase-26fbf',
    storageBucket: 'bb-firebase-26fbf.appspot.com',
    iosClientId: '844137022732-vj3po4ddav0j464769h99jsep94jjdpu.apps.googleusercontent.com',
    iosBundleId: 'com.shahaab.bestellbuch',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDenwYOW2BqQTihfhFbir9ppJ2tXD5-zQE',
    appId: '1:844137022732:ios:4cf37ac5b3b7a7cea6f529',
    messagingSenderId: '844137022732',
    projectId: 'bb-firebase-26fbf',
    storageBucket: 'bb-firebase-26fbf.appspot.com',
    iosClientId: '844137022732-vj3po4ddav0j464769h99jsep94jjdpu.apps.googleusercontent.com',
    iosBundleId: 'com.shahaab.bestellbuch',
  );
}
