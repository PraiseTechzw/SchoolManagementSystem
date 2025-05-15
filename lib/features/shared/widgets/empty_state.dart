import 'package:flutter/material.dart';

import 'custom_button.dart';

/// Widget for displaying empty states with consistent styling
class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final double iconSize;
  final bool isFullScreen;
  final Color? iconColor;
  final Widget? child;

  const EmptyState({
    Key? key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox,
    this.buttonText,
    this.onButtonPressed,
    this.iconSize = 80.0,
    this.isFullScreen = false,
    this.iconColor,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: iconSize,
          color: iconColor ?? theme.colorScheme.primary.withOpacity(0.5),
        ),
        const SizedBox(height: 24.0),
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            message,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
        if (buttonText != null && onButtonPressed != null) ...[
          const SizedBox(height: 24.0),
          CustomButton(
            text: buttonText!,
            onPressed: onButtonPressed!,
          ),
        ],
        if (child != null) ...[
          const SizedBox(height: 24.0),
          child!,
        ],
      ],
    );
    
    if (isFullScreen) {
      return Scaffold(
        body: Center(
          child: content,
        ),
      );
    }
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48.0),
        child: content,
      ),
    );
  }
}

/// Empty state for no data available
class NoDataEmptyState extends StatelessWidget {
  final VoidCallback? onRefresh;
  final VoidCallback? onAddNew;
  final String title;
  final String message;
  final IconData icon;

  const NoDataEmptyState({
    Key? key,
    this.onRefresh,
    this.onAddNew,
    this.title = 'No Data Available',
    this.message = 'There are no items to display at this time.',
    this.icon = Icons.inbox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: title,
      message: message,
      icon: icon,
      buttonText: onAddNew != null ? 'Add New' : (onRefresh != null ? 'Refresh' : null),
      onButtonPressed: onAddNew ?? onRefresh,
    );
  }
}

/// Empty state for search results
class NoSearchResultsEmptyState extends StatelessWidget {
  final String searchTerm;
  final VoidCallback? onClearSearch;

  const NoSearchResultsEmptyState({
    Key? key,
    required this.searchTerm,
    this.onClearSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'No Results Found',
      message: 'We couldn\'t find any results for "$searchTerm"',
      icon: Icons.search_off,
      buttonText: onClearSearch != null ? 'Clear Search' : null,
      onButtonPressed: onClearSearch,
    );
  }
}

/// Empty state for offline mode
class OfflineEmptyState extends StatelessWidget {
  final VoidCallback? onRetry;

  const OfflineEmptyState({
    Key? key,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'You\'re Offline',
      message: 'Please check your connection and try again',
      icon: Icons.wifi_off,
      buttonText: onRetry != null ? 'Retry' : null,
      onButtonPressed: onRetry,
      iconColor: Colors.orange,
    );
  }
}

/// Empty state for errors
class ErrorEmptyState extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;

  const ErrorEmptyState({
    Key? key,
    required this.errorMessage,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'Something Went Wrong',
      message: errorMessage,
      icon: Icons.error_outline,
      buttonText: onRetry != null ? 'Retry' : null,
      onButtonPressed: onRetry,
      iconColor: Colors.red,
    );
  }
}