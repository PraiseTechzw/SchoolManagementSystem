import 'package:flutter/material.dart';

import 'custom_button.dart';

/// A customized alert dialog with consistent styling
class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDanger;
  final Widget? content;
  final bool dismissible;
  final IconData? icon;
  final Color? iconColor;
  final double maxWidth;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.isDanger = false,
    this.content,
    this.dismissible = true,
    this.icon,
    this.iconColor,
    this.maxWidth = 400.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: iconColor ?? (isDanger ? Colors.red : theme.primaryColor),
                      size: 24.0,
                    ),
                    const SizedBox(width: 12.0),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDanger ? Colors.red : null,
                      ),
                    ),
                  ),
                  if (dismissible)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      splashRadius: 20.0,
                      tooltip: 'Close',
                    ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                message,
                style: theme.textTheme.bodyMedium,
              ),
              if (content != null) ...[
                const SizedBox(height: 16.0),
                content!,
              ],
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (cancelText != null) ...[
                    CustomButton(
                      text: cancelText!,
                      onPressed: onCancel ?? () => Navigator.of(context).pop(false),
                      isOutlined: true,
                    ),
                    const SizedBox(width: 16.0),
                  ],
                  if (confirmText != null)
                    CustomButton(
                      text: confirmText!,
                      onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
                      isDanger: isDanger,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show a simple alert dialog
  static Future<void> showAlert({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
    bool isDanger = false,
    IconData? icon,
    Color? iconColor,
  }) {
    return showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        onConfirm: onConfirm,
        isDanger: isDanger,
        icon: icon,
        iconColor: iconColor,
      ),
    );
  }

  /// Show a confirmation dialog with confirm and cancel buttons
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDanger = false,
    IconData? icon,
    Color? iconColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => CustomDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDanger: isDanger,
        icon: icon,
        iconColor: iconColor,
      ),
    );
  }
  
  /// Show a success dialog
  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        onConfirm: onConfirm,
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
      ),
    );
  }
  
  /// Show an error dialog
  static Future<void> showError({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        onConfirm: onConfirm,
        isDanger: true,
        icon: Icons.error_outline,
        iconColor: Colors.red,
      ),
    );
  }
}