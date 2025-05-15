import 'package:flutter/material.dart';

/// Custom button widget that supports different variants and loading state
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final bool isDanger;
  final bool isOutlined;
  final bool isDisabled;
  final IconData? icon;
  final Color? color;
  final double? height;
  final double? width;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.isDanger = false,
    this.isOutlined = false,
    this.isDisabled = false,
    this.icon,
    this.color,
    this.height,
    this.width,
    this.borderRadius = 8.0,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determine button color
    final buttonColor = color ?? 
        (isDanger ? Colors.red : theme.primaryColor);
    
    // Determine text and icon color
    final textColor = isOutlined ? buttonColor : Colors.white;
    
    // Button style
    final style = isOutlined 
        ? OutlinedButton.styleFrom(
            side: BorderSide(color: buttonColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding ?? const EdgeInsets.symmetric(
              vertical: 12.0, 
              horizontal: 16.0,
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding ?? const EdgeInsets.symmetric(
              vertical: 12.0, 
              horizontal: 16.0,
            ),
          );
    
    // Button content
    Widget buttonContent = isLoading 
        ? SizedBox(
            width: 20, 
            height: 20, 
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
    
    // Button with determined size
    final buttonWithSize = Container(
      height: height,
      width: isFullWidth ? double.infinity : width,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading || isDisabled ? null : onPressed,
              style: style,
              child: buttonContent,
            )
          : ElevatedButton(
              onPressed: isLoading || isDisabled ? null : onPressed,
              style: style,
              child: buttonContent,
            ),
    );
    
    return buttonWithSize;
  }
}