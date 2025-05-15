import 'package:flutter/material.dart';

/// A custom card with consistent styling for content display
class CustomCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool hasBorder;
  final Color? borderColor;
  final Widget? header;
  final Widget? footer;

  const CustomCard({
    Key? key,
    required this.child,
    this.color,
    this.elevation = 1.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.only(bottom: 16.0),
    this.borderRadius = 8.0,
    this.onTap,
    this.hasBorder = false,
    this.borderColor,
    this.header,
    this.footer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = color ?? theme.colorScheme.surface;
    final border = hasBorder 
        ? Border.all(
            color: borderColor ?? theme.colorScheme.outline.withOpacity(0.5),
            width: 1.0,
          )
        : null;
    
    // Build card content
    Widget cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (header != null) ...[
          header!,
          const Divider(),
        ],
        child,
        if (footer != null) ...[
          const Divider(),
          footer!,
        ],
      ],
    );
    
    // Wrap with InkWell if onTap is provided
    if (onTap != null) {
      cardContent = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: cardContent,
      );
    }
    
    return Card(
      elevation: elevation,
      margin: margin,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: border ?? BorderSide.none,
      ),
      color: cardColor,
      child: Padding(
        padding: padding,
        child: cardContent,
      ),
    );
  }
}

/// A card specifically designed for list items with standardized layout
class ListItemCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? color;
  final bool hasBorder;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool isDense;
  final double elevation;
  final Color? backgroundColor;

  const ListItemCard({
    Key? key,
    required this.title,
    this.subtitle,
    this.description,
    this.leading,
    this.trailing,
    this.onTap,
    this.color,
    this.hasBorder = false,
    this.padding = const EdgeInsets.all(12.0),
    this.margin = const EdgeInsets.only(bottom: 8.0),
    this.isDense = false,
    this.elevation = 1.0,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return CustomCard(
      padding: EdgeInsets.zero,
      margin: margin,
      elevation: elevation,
      color: backgroundColor,
      hasBorder: hasBorder,
      borderColor: color,
      onTap: onTap,
      child: ListTile(
        contentPadding: padding,
        leading: leading,
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: color,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subtitle != null) ...[
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium,
              ),
            ],
            if (description != null) ...[
              const SizedBox(height: 4.0),
              Text(
                description!,
                style: theme.textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        trailing: trailing,
        dense: isDense,
      ),
    );
  }
}