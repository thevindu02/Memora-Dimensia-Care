import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // WEB CONFIGURATION - From Firebase Console
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAGIMis-SuVtV21CX5DSW3htW2UitOmHMg',
    appId: '1:212050041276:web:cd72a36f248f355ec1f3b9',
    messagingSenderId: '212050041276',
    projectId: 'memora-2025',
    authDomain: 'memora-2025.firebaseapp.com',
    storageBucket: 'memora-2025.firebasestorage.app',
    measurementId: 'G-RFQYWD6Z0Q',
  );

  // ANDROID CONFIGURATION - From google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDIKxiGIU29Lq730dXFYRzA0OFyCjDhNxc',
    appId: '1:212050041276:android:43e33c3824395f7bc1f3b9',
    messagingSenderId: '212050041276',
    projectId: 'memora-2025',
    storageBucket: 'memora-2025.firebasestorage.app',
  );
}