import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Uncomment once generated

import '../config/app_config.dart';
import '../config/routes/app_routes.dart';
import '../config/themes.dart';

/// Main application widget
class ChikoroPro extends ConsumerWidget {
  const ChikoroPro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current theme and locale from providers (to be added later)
    final isDarkMode = ref.watch(isDarkModeProvider);
    final locale = ref.watch(localeProvider);
    
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      locale: locale,
      localizationsDelegates: const [
        // AppLocalizations.delegate,  // Commented until the class is generated
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('sw', ''), // Swahili
        Locale('sn', ''), // Shona
        Locale('nd', ''), // Northern Ndebele
      ],
      onGenerateRoute: AppRoutes.onGenerateRoute,
      initialRoute: AppRoutes.splash,
    );
  }
}

/// Theme mode provider
final isDarkModeProvider = StateProvider<bool>((ref) => false);

/// Locale provider
final localeProvider = StateProvider<Locale?>((ref) => null);