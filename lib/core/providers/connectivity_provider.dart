import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../services/connectivity_service.dart';
import '../utils/sync_utils.dart';

/// Provider for the current connectivity status
final connectivityStatusProvider = StateNotifierProvider<ConnectivityStatusNotifier, bool>((ref) {
  return ConnectivityStatusNotifier();
});

/// State notifier for connectivity status
class ConnectivityStatusNotifier extends StateNotifier<bool> {
  ConnectivityStatusNotifier() : super(false) {
    _connectivityService.initialize().then((_) {
      _subscription = _connectivityService.connectionStatus.listen(_updateConnectionStatus);
      _checkConnectivity();
    });
  }

  final ConnectivityService _connectivityService = ConnectivityService();
  StreamSubscription<bool>? _subscription;
  Timer? _syncTimer;

  Future<void> _checkConnectivity() async {
    state = await _connectivityService.checkConnectivity();
  }

  void _updateConnectionStatus(bool isConnected) {
    if (!state && isConnected) {
      // Connection was restored, start sync
      _startSync();
    }
    
    state = isConnected;
  }

  /// Start data synchronization when connection is available
  void _startSync() {
    // Cancel any existing sync timer
    _syncTimer?.cancel();
    
    // Perform immediate sync
    SyncUtils.fullSync();
    
    // Schedule periodic sync
    _syncTimer = Timer.periodic(
      const Duration(minutes: 30),
      (_) => SyncUtils.fullSync(),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _syncTimer?.cancel();
    super.dispose();
  }

  /// Manually trigger a synchronization
  Future<void> manualSync() async {
    await SyncUtils.fullSync();
  }
}

/// Provider for a widget that displays connectivity status
final connectivityIndicatorProvider = Provider<Widget>((ref) {
  final isConnected = ref.watch(connectivityStatusProvider);
  
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: isConnected ? Colors.green : Colors.red,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      isConnected ? 'Online' : 'Offline',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
});
