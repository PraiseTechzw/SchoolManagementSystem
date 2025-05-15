import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/app.dart';
import 'core/services/firebase_service.dart';
import 'core/services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: const String.fromEnvironment('FIREBASE_API_KEY', defaultValue: 'demo-api-key'),
      appId: const String.fromEnvironment('FIREBASE_APP_ID', defaultValue: 'demo-app-id'),
      messagingSenderId: const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: 'demo-sender-id'),
      projectId: const String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'demo-project-id'),
      storageBucket: const String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: 'demo-storage-bucket'),
    ),
  );
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  await LocalStorageService.initialize();
  
  // Initialize Firebase service
  await FirebaseService.initialize();
  
  runApp(
    const ProviderScope(
      child: ChikoroPro(),
    ),
  );
}
