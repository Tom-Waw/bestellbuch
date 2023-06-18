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
    apiKey: 'AIzaSyBxhJpk6ZddC3v0FiQylN_fVdgyyZhZHgg',
    appId: '1:192306945627:web:8d41ae2a6119a6c098e97e',
    messagingSenderId: '192306945627',
    projectId: 'bestellbuchmanager',
    authDomain: 'bestellbuchmanager.firebaseapp.com',
    storageBucket: 'bestellbuchmanager.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBOM9ppyvRVd8MZTI-K-vwjOYwf7mvj44U',
    appId: '1:192306945627:android:7685161eb8b1902f98e97e',
    messagingSenderId: '192306945627',
    projectId: 'bestellbuchmanager',
    storageBucket: 'bestellbuchmanager.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBPPnFVYHPl05BEuddMtkRRYuc_jXXA2Ak',
    appId: '1:192306945627:ios:f7a01a6fc5b7561698e97e',
    messagingSenderId: '192306945627',
    projectId: 'bestellbuchmanager',
    storageBucket: 'bestellbuchmanager.appspot.com',
    iosClientId: '192306945627-sfief9c9sv6929r16clnn1ak7atgj7uc.apps.googleusercontent.com',
    iosBundleId: 'com.shahaab.bestellbuch',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBPPnFVYHPl05BEuddMtkRRYuc_jXXA2Ak',
    appId: '1:192306945627:ios:5e223c446478727198e97e',
    messagingSenderId: '192306945627',
    projectId: 'bestellbuchmanager',
    storageBucket: 'bestellbuchmanager.appspot.com',
    iosClientId: '192306945627-b7e5i96ngd94293328mp7dlgs0q0de4t.apps.googleusercontent.com',
    iosBundleId: 'com.shahaab.bestellbuch.RunnerTests',
  );
}
