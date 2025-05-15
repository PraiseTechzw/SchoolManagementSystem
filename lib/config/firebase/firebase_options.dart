import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Default Firebase configuration options for the ChikoroPro application
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
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  /// Web Firebase options
  static final FirebaseOptions web = FirebaseOptions(
    apiKey: const String.fromEnvironment('FIREBASE_API_KEY'),
    appId: const String.fromEnvironment('FIREBASE_APP_ID'),
    messagingSenderId: const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: ''),
    projectId: const String.fromEnvironment('FIREBASE_PROJECT_ID'),
    authDomain: '${const String.fromEnvironment('FIREBASE_PROJECT_ID')}.firebaseapp.com',
    storageBucket: '${const String.fromEnvironment('FIREBASE_PROJECT_ID')}.appspot.com',
    measurementId: const String.fromEnvironment('FIREBASE_MEASUREMENT_ID', defaultValue: ''),
  );

  /// Android Firebase options
  static final FirebaseOptions android = FirebaseOptions(
    apiKey: const String.fromEnvironment('FIREBASE_API_KEY'),
    appId: const String.fromEnvironment('FIREBASE_APP_ID'),
    messagingSenderId: const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: ''),
    projectId: const String.fromEnvironment('FIREBASE_PROJECT_ID'),
    storageBucket: '${const String.fromEnvironment('FIREBASE_PROJECT_ID')}.appspot.com',
  );

  /// iOS Firebase options
  static final FirebaseOptions ios = FirebaseOptions(
    apiKey: const String.fromEnvironment('FIREBASE_API_KEY'),
    appId: const String.fromEnvironment('FIREBASE_APP_ID'),
    messagingSenderId: const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: ''),
    projectId: const String.fromEnvironment('FIREBASE_PROJECT_ID'),
    storageBucket: '${const String.fromEnvironment('FIREBASE_PROJECT_ID')}.appspot.com',
    iosClientId: const String.fromEnvironment('FIREBASE_IOS_CLIENT_ID', defaultValue: ''),
    iosBundleId: const String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID', defaultValue: 'com.example.chikoropro'),
  );

  /// macOS Firebase options
  static final FirebaseOptions macos = FirebaseOptions(
    apiKey: const String.fromEnvironment('FIREBASE_API_KEY'),
    appId: const String.fromEnvironment('FIREBASE_APP_ID'),
    messagingSenderId: const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: ''),
    projectId: const String.fromEnvironment('FIREBASE_PROJECT_ID'),
    storageBucket: '${const String.fromEnvironment('FIREBASE_PROJECT_ID')}.appspot.com',
    iosClientId: const String.fromEnvironment('FIREBASE_IOS_CLIENT_ID', defaultValue: ''),
    iosBundleId: const String.fromEnvironment('FIREBASE_MACOS_BUNDLE_ID', defaultValue: 'com.example.chikoropro'),
  );

  /// Windows Firebase options
  static final FirebaseOptions windows = FirebaseOptions(
    apiKey: const String.fromEnvironment('FIREBASE_API_KEY'),
    appId: const String.fromEnvironment('FIREBASE_APP_ID'),
    messagingSenderId: const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: ''),
    projectId: const String.fromEnvironment('FIREBASE_PROJECT_ID'),
    storageBucket: '${const String.fromEnvironment('FIREBASE_PROJECT_ID')}.appspot.com',
  );

  /// Linux Firebase options
  static final FirebaseOptions linux = FirebaseOptions(
    apiKey: const String.fromEnvironment('FIREBASE_API_KEY'),
    appId: const String.fromEnvironment('FIREBASE_APP_ID'),
    messagingSenderId: const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: ''),
    projectId: const String.fromEnvironment('FIREBASE_PROJECT_ID'),
    storageBucket: '${const String.fromEnvironment('FIREBASE_PROJECT_ID')}.appspot.com',
  );
}