import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums/app_enums.dart';
import '../../../core/providers/app_providers.dart';

/// Widget for language selection in the app
class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    
    return DropdownButton<AppLanguage>(
      value: _getLanguageFromLocale(currentLocale),
      underline: const SizedBox.shrink(),
      icon: const Icon(Icons.language),
      onChanged: (AppLanguage? language) {
        if (language != null) {
          final locale = _getLocaleFromLanguage(language);
          ref.read(localeProvider.notifier).state = locale;
        }
      },
      items: AppLanguage.values.map((language) {
        return DropdownMenuItem<AppLanguage>(
          value: language,
          child: Text(_getLanguageName(language)),
        );
      }).toList(),
    );
  }
  
  /// Get language enum from locale
  AppLanguage _getLanguageFromLocale(Locale? locale) {
    if (locale == null) return AppLanguage.english;
    
    switch (locale.languageCode) {
      case 'en':
        return AppLanguage.english;
      case 'sw':
        return AppLanguage.shona;
      case 'nd':
        return AppLanguage.ndebele;
      default:
        return AppLanguage.english;
    }
  }
  
  /// Get locale from language enum
  Locale _getLocaleFromLanguage(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return const Locale('en', '');
      case AppLanguage.shona:
        return const Locale('sw', '');
      case AppLanguage.ndebele:
        return const Locale('nd', '');
    }
  }
  
  /// Get display name for language
  String _getLanguageName(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.shona:
        return 'Shona';
      case AppLanguage.ndebele:
        return 'Ndebele';
    }
  }
} 