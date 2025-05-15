import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants.dart';
import '../../../../core/providers/connectivity_provider.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/utils/sync_utils.dart';

/// Widget that displays the sync status of the app
class SyncStatusWidget extends ConsumerWidget {
  const SyncStatusWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStatus = ref.watch(syncStatusProvider);
    final isConnected = ref.watch(connectivityStatusProvider);
    final pendingItems = LocalStorageService.getSyncQueue().length;
    
    // Determine the status color and icon
    Color statusColor;
    IconData statusIcon;
    String tooltip;
    
    if (!isConnected) {
      statusColor = Colors.grey;
      statusIcon = Icons.cloud_off;
      tooltip = 'Offline - Changes will sync when connection is available';
    } else if (syncStatus == 'pending') {
      statusColor = AppColors.syncPendingColor;
      statusIcon = Icons.sync;
      tooltip = 'Syncing $pendingItems pending items...';
    } else if (syncStatus == 'error') {
      statusColor = AppColors.syncErrorColor;
      statusIcon = Icons.sync_problem;
      tooltip = 'Sync error - Tap to retry';
    } else {
      statusColor = AppColors.syncCompletedColor;
      statusIcon = Icons.cloud_done;
      tooltip = 'All changes synced';
    }
    
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: isConnected && (syncStatus == 'error' || pendingItems > 0)
            ? () => _manualSync(ref)
            : null,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                statusIcon,
                color: statusColor,
              ),
              if (pendingItems > 0 && syncStatus != 'pending')
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      pendingItems.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              if (syncStatus == 'pending')
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.syncPendingColor),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _manualSync(WidgetRef ref) async {
    ref.read(syncStatusProvider.notifier).setPending();
    
    try {
      await SyncUtils.fullSync();
      ref.read(syncStatusProvider.notifier).setCompleted();
    } catch (e) {
      ref.read(syncStatusProvider.notifier).setError();
    }
  }
}
