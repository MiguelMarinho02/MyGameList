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
    apiKey: 'AIzaSyBA632jtjNmyYu5rIMGis7oD1EhfPYNjoY',
    appId: '1:1008518347722:web:298d104c51cd6368efed33',
    messagingSenderId: '1008518347722',
    projectId: 'myshowapp-2e0a1',
    authDomain: 'myshowapp-2e0a1.firebaseapp.com',
    storageBucket: 'myshowapp-2e0a1.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBawVGLzcw43bdbMqaWpf4iPCcrxe2wnW0',
    appId: '1:1008518347722:android:f0c8a452f010f5f1efed33',
    messagingSenderId: '1008518347722',
    projectId: 'myshowapp-2e0a1',
    storageBucket: 'myshowapp-2e0a1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCbNbAfZg_jl4vmsik7mZGkpjKocKdBWcM',
    appId: '1:1008518347722:ios:1282c19d6ff42f8aefed33',
    messagingSenderId: '1008518347722',
    projectId: 'myshowapp-2e0a1',
    storageBucket: 'myshowapp-2e0a1.appspot.com',
    iosBundleId: 'com.example.malClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCbNbAfZg_jl4vmsik7mZGkpjKocKdBWcM',
    appId: '1:1008518347722:ios:1282c19d6ff42f8aefed33',
    messagingSenderId: '1008518347722',
    projectId: 'myshowapp-2e0a1',
    storageBucket: 'myshowapp-2e0a1.appspot.com',
    iosBundleId: 'com.example.malClone',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBA632jtjNmyYu5rIMGis7oD1EhfPYNjoY',
    appId: '1:1008518347722:web:2ec3b012d0e4a10fefed33',
    messagingSenderId: '1008518347722',
    projectId: 'myshowapp-2e0a1',
    authDomain: 'myshowapp-2e0a1.firebaseapp.com',
    storageBucket: 'myshowapp-2e0a1.appspot.com',
  );
}
