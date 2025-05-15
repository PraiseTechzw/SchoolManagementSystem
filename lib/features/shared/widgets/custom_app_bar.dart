import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/app_config.dart';

/// A customized app bar with consistent styling for the app
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final double elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool? isTransparent;
  
  const CustomAppBar({
    Key? key,
    required this.title,
    this.centerTitle = true,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.leading,
    this.bottom,
    this.elevation = 0.5,
    this.backgroundColor,
    this.foregroundColor,
    this.systemOverlayStyle,
    this.isTransparent = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isTransparent == true
              ? (foregroundColor ?? Colors.white)
              : (foregroundColor ?? theme.primaryColor),
        ),
      ),
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      actions: actions,
      elevation: elevation,
      backgroundColor: isTransparent == true
          ? Colors.transparent
          : (backgroundColor ?? theme.scaffoldBackgroundColor),
      foregroundColor: foregroundColor ?? theme.primaryColor,
      systemOverlayStyle: systemOverlayStyle ??
          (theme.brightness == Brightness.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark),
      shape: isTransparent == true
          ? null
          : Border(
              bottom: BorderSide(
                color: theme.dividerColor,
                width: 0.5,
              ),
            ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}

/// A transparent app bar for use over images or gradients
class TransparentAppBar extends CustomAppBar {
  TransparentAppBar({
    Key? key,
    required String title,
    List<Widget>? actions,
    Widget? leading,
    Color foregroundColor = Colors.white,
    SystemUiOverlayStyle systemOverlayStyle = SystemUiOverlayStyle.light,
  }) : super(
          key: key,
          title: title,
          actions: actions,
          leading: leading,
          isTransparent: true,
          foregroundColor: foregroundColor,
          systemOverlayStyle: systemOverlayStyle,
        );
}

/// A sliver app bar with custom styling for scroll effects
class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? flexibleSpace;
  final double? expandedHeight;
  final bool floating;
  final bool pinned;
  final bool snap;
  final SystemUiOverlayStyle? systemOverlayStyle;
  
  const CustomSliverAppBar({
    Key? key,
    required this.title,
    this.centerTitle = true,
    this.actions,
    this.leading,
    this.flexibleSpace,
    this.expandedHeight,
    this.floating = false,
    this.pinned = true,
    this.snap = false,
    this.systemOverlayStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SliverAppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: theme.primaryColor,
        ),
      ),
      centerTitle: centerTitle,
      leading: leading,
      actions: actions,
      backgroundColor: theme.scaffoldBackgroundColor,
      foregroundColor: theme.primaryColor,
      systemOverlayStyle: systemOverlayStyle ??
          (theme.brightness == Brightness.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark),
      elevation: 0.5,
      flexibleSpace: flexibleSpace,
      expandedHeight: expandedHeight,
      floating: floating,
      pinned: pinned,
      snap: snap,
      shape: Border(
        bottom: BorderSide(
          color: theme.dividerColor,
          width: 0.5,
        ),
      ),
    );
  }
}