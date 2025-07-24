import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

/// Default Firebase configuration options for different platforms
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyB5xpW8Up2lMrrqk0kq9eYPfKCf4w9Ad00",
    appId: "1:261766280633:android:d1aac1e1b3b693be0b7268",
    messagingSenderId: "261766280633",
    projectId: "disateraid",
    storageBucket: "disateraid.firebasestorage.app",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyB5xpW8Up2lMrrqk0kq9eYPfKCf4w9Ad00",
    appId: "1:261766280633:ios:0000000000000000000000", // Replace with actual iOS app ID when needed
    messagingSenderId: "261766280633",
    projectId: "disateraid",
    storageBucket: "disateraid.firebasestorage.app",
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyBTCiGkAa3J5R6pZhQZLntNznKA0PWjnGY",
    authDomain: "disateraid.firebaseapp.com",
    projectId: "disateraid",
    storageBucket: "disateraid.firebasestorage.app",
    messagingSenderId: "261766280633",
    appId: "1:261766280633:web:f209e5c762f3d72f0b7268",
    measurementId: "G-TZLJ1WPKDH",
  );
}