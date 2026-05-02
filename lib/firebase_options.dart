import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are configured only for web. '
      'Run `flutterfire configure` to add Android, iOS, macOS, Windows, and Linux options.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBG4kHUu_IpR01_TD02JX3m-LvscBQPpdU',
    appId: '1:283187673709:web:26a947cc6e8801814add64',
    messagingSenderId: '283187673709',
    projectId: 'yash-e51e0',
    authDomain: 'yash-e51e0.firebaseapp.com',
    storageBucket: 'yash-e51e0.firebasestorage.app',
  );
}
