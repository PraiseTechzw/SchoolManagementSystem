import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Service to monitor and manage internet connectivity
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  
  ConnectivityService._internal();
  
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();
  
  Stream<bool> get connectionStatus => _connectionStatusController.stream;
  bool _isConnected = false;
  
  /// Initialize connectivity monitoring
  Future<void> initialize() async {
    // Get initial connection status
    await checkConnectivity();
    
    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _updateConnectionStatus(result);
    });
  }
  
  /// Check current connectivity status
  Future<bool> checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
      return _isConnected;
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      _isConnected = false;
      _connectionStatusController.add(false);
      return false;
    }
  }
  
  /// Update connection status based on connectivity result
  void _updateConnectionStatus(ConnectivityResult result) {
    _isConnected = result != ConnectivityResult.none;
    _connectionStatusController.add(_isConnected);
    debugPrint('Connection status: ${_isConnected ? 'Connected' : 'Disconnected'}');
  }
  
  /// Get current connection status
  bool get isConnected => _isConnected;
  
  /// Cleanup resources
  void dispose() {
    _connectionStatusController.close();
  }
}
