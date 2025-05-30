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
    apiKey: 'AIzaSyB4D0JZUhXhIGsVtlosEe-OCuHCOs-GIHw',
    appId: '1:772342934082:web:247f83325a8b42f6481bdb',
    messagingSenderId: '772342934082',
    projectId: 'fish-delivery-demo',
    authDomain: 'fish-delivery-demo-72c7f.firebaseapp.com',
    storageBucket: 'fish-delivery-demo.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAZlfgJ2FfUmqhvNACB6KtXsA4BIsR9WY4',
    appId: '1:772342934082:android:f77491daeda795a5481bdb',
    messagingSenderId: '772342934082',
    projectId: 'fish-delivery-demo',
    storageBucket: 'fish-delivery-demo.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBp4SQAPtv_1iv18nS_iFSWFFtYNpppD1g',
    appId: '1:772342934082:ios:d9bbc9ce25de651e481bdb',
    messagingSenderId: '772342934082',
    projectId: 'fish-delivery-demo',
    storageBucket: 'fish-delivery-demo.firebasestorage.app',
    iosBundleId: 'com.example.fishDeliveryApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBp4SQAPtv_1iv18nS_iFSWFFtYNpppD1g',
    appId: '1:772342934082:ios:d9bbc9ce25de651e481bdb',
    messagingSenderId: '772342934082',
    projectId: 'fish-delivery-demo',
    storageBucket: 'fish-delivery-demo.firebasestorage.app',
    iosBundleId: 'com.example.fishDeliveryApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB4D0JZUhXhIGsVtlosEe-OCuHCOs-GIHw',
    appId: '1:772342934082:web:6a67a58e3902b13d481bdb',
    messagingSenderId: '772342934082',
    projectId: 'fish-delivery-demo',
    authDomain: 'fish-delivery-demo-72c7f.firebaseapp.com',
    storageBucket: 'fish-delivery-demo.firebasestorage.app',
  );
}
