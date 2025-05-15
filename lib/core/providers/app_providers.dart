import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/local_storage_service.dart';
import '../services/connectivity_service.dart';
import '../enums/app_enums.dart';

/// Theme mode provider (light/dark)
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }
  
  void _loadThemeMode() {
    final savedMode = LocalStorageService.getSetting('themeMode', defaultValue: 'system');
    switch (savedMode) {
      case 'light':
        state = ThemeMode.light;
        break;
      case 'dark':
        state = ThemeMode.dark;
        break;
      default:
        state = ThemeMode.system;
    }
  }
  
  void setThemeMode(ThemeMode mode) {
    state = mode;
    LocalStorageService.saveSetting('themeMode', mode.toString().split('.').last);
  }
}

/// Locale provider for language selection
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>(
  (ref) => LocaleNotifier(),
);

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _loadLocale();
  }
  
  void _loadLocale() {
    final savedLocale = LocalStorageService.getSetting('locale', defaultValue: 'en');
    state = Locale(savedLocale);
  }
  
  void setLocale(Locale locale) {
    state = locale;
    LocalStorageService.saveSetting('locale', locale.languageCode);
  }
  
  void clearLocale() {
    state = null;
    LocalStorageService.saveSetting('locale', 'en');
  }
}

/// Connectivity status provider
final connectivityProvider = StreamProvider<bool>((ref) {
  final connectivityService = ConnectivityService();
  connectivityService.initialize();
  return connectivityService.connectionStatus;
});

/// Sync status provider
final syncStatusProvider = StateNotifierProvider<SyncStatusNotifier, String>(
  (ref) => SyncStatusNotifier(),
);

class SyncStatusNotifier extends StateNotifier<String> {
  SyncStatusNotifier() : super('completed');
  
  void setPending() {
    state = 'pending';
  }
  
  void setCompleted() {
    state = 'completed';
  }
  
  void setError() {
    state = 'error';
  }
}

/// Active school provider
final activeSchoolProvider = StateNotifierProvider<ActiveSchoolNotifier, String?>(
  (ref) => ActiveSchoolNotifier(),
);

class ActiveSchoolNotifier extends StateNotifier<String?> {
  ActiveSchoolNotifier() : super(null) {
    _loadActiveSchool();
  }
  
  void _loadActiveSchool() {
    final schoolId = LocalStorageService.getSetting('activeSchool');
    state = schoolId;
  }
  
  void setActiveSchool(String schoolId) {
    state = schoolId;
    LocalStorageService.saveSetting('activeSchool', schoolId);
  }
  
  void clearActiveSchool() {
    state = null;
    LocalStorageService.saveSetting('activeSchool', null);
  }
}

/// Active term provider
final activeTermProvider = StateNotifierProvider<ActiveTermNotifier, String?>(
  (ref) => ActiveTermNotifier(),
);

class ActiveTermNotifier extends StateNotifier<String?> {
  ActiveTermNotifier() : super(null) {
    _loadActiveTerm();
  }
  
  void _loadActiveTerm() {
    final termId = LocalStorageService.getSetting('activeTerm');
    state = termId;
  }
  
  void setActiveTerm(String termId) {
    state = termId;
    LocalStorageService.saveSetting('activeTerm', termId);
  }
  
  void clearActiveTerm() {
    state = null;
    LocalStorageService.saveSetting('activeTerm', null);
  }
}

/// Currency conversion rate provider
final currencyRateProvider = StateNotifierProvider<CurrencyRateNotifier, double>(
  (ref) => CurrencyRateNotifier(),
);

class CurrencyRateNotifier extends StateNotifier<double> {
  CurrencyRateNotifier() : super(1.0) {
    _loadCurrencyRate();
  }
  
  void _loadCurrencyRate() {
    final rate = LocalStorageService.getSetting('currencyRate', defaultValue: 1.0);
    state = rate is double ? rate : 1.0;
  }
  
  void setCurrencyRate(double rate) {
    state = rate;
    LocalStorageService.saveSetting('currencyRate', rate);
  }
}
