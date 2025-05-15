import 'package:flutter/material.dart';

/// Custom navigation drawer with profile and menu items
class CustomDrawer extends StatelessWidget {
  final String userName;
  final String? userEmail;
  final String? userRole;
  final String? avatarUrl;
  final List<DrawerMenuItem> menuItems;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLogout;
  final Widget? footer;
  final Color? backgroundColor;
  final Color? activeColor;

  const CustomDrawer({
    Key? key,
    required this.userName,
    this.userEmail,
    this.userRole,
    this.avatarUrl,
    required this.menuItems,
    this.onProfileTap,
    this.onLogout,
    this.footer,
    this.backgroundColor,
    this.activeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.background;
    final activeItemColor = activeColor ?? theme.colorScheme.primary;
    
    return Drawer(
      backgroundColor: bgColor,
      child: Column(
        children: [
          // Drawer header with user info
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: userEmail != null ? Text(userEmail!) : null,
            currentAccountPicture: CircleAvatar(
              backgroundColor: theme.colorScheme.secondaryContainer,
              backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null ? Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ) : null,
            ),
            otherAccountsPictures: userRole != null ? [
              Tooltip(
                message: userRole!,
                child: CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    _getRoleIcon(userRole!),
                    size: 18,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ] : null,
            onDetailsPressed: onProfileTap,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
            ),
          ),
          
          // Menu items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: menuItems.map((item) {
                final isActive = item.isActive;
                
                return ListTile(
                  leading: Icon(
                    item.icon,
                    color: isActive ? activeItemColor : null,
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      color: isActive ? activeItemColor : null,
                    ),
                  ),
                  trailing: item.badge != null ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 2.0,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      item.badge!,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ) : null,
                  tileColor: isActive ? theme.colorScheme.primaryContainer.withOpacity(0.2) : null,
                  onTap: () {
                    // Close drawer
                    Navigator.pop(context);
                    
                    // Execute the callback
                    item.onTap();
                  },
                );
              }).toList(),
            ),
          ),
          
          // Divider
          const Divider(),
          
          // Logout button
          if (onLogout != null)
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: onLogout,
            ),
          
          // Optional footer
          if (footer != null) footer!,
          
          // Bottom padding
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
  
  /// Get icon for user role
  IconData _getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'teacher':
        return Icons.school;
      case 'student':
        return Icons.person;
      case 'parent':
        return Icons.family_restroom;
      case 'clerk':
        return Icons.person_pin;
      default:
        return Icons.person;
    }
  }
}

/// Model class for drawer menu items
class DrawerMenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;
  final String? badge;

  const DrawerMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.isActive = false,
    this.badge,
  });
}