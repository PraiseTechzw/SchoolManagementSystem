import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'app/app.dart';
import 'config/firebase/firebase_options.dart';
import 'core/services/firebase_service.dart';
import 'core/services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
