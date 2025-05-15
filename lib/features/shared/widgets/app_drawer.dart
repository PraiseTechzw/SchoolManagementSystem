import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/constants.dart';
import '../../../config/routes.dart';
import '../../../core/providers/auth_provider.dart';

/// Main navigation drawer for the application
class AppDrawer extends ConsumerWidget {
  final String currentRoute;

  const AppDrawer({
    Key? key,
    required this.currentRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);

    return Drawer(
      child: Column(
        children: [
          // Drawer header with user info
          UserAccountsDrawerHeader(
            accountName: Text(
              user.value?.fullName ?? 'User',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              user.value?.email ?? '',
              style: const TextStyle(fontSize: 12),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: theme.colorScheme.secondary,
              child: Text(
                (user.value?.fullName?.isNotEmpty ?? false) 
                    ? user.value!.fullName![0].toUpperCase() 
                    : 'U',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: theme.primaryColor,
            ),
          ),
          
          // Navigation items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  'Dashboard',
                  Icons.dashboard,
                  AppRoutes.adminDashboard,
                ),
                _buildDrawerItem(
                  context,
                  'Students',
                  Icons.school,
                  AppRoutes.studentList,
                ),
                _buildDrawerItem(
                  context,
                  'Teachers',
                  Icons.people,
                  '#', // Placeholder until teachersList is defined
                ),
                _buildDrawerItem(
                  context,
                  'Classes',
                  Icons.class_,
                  '#', // Placeholder until classesList is defined
                ),
                _buildDrawerItem(
                  context,
                  'Attendance',
                  Icons.fact_check,
                  AppRoutes.attendance,
                ),
                _buildDrawerItem(
                  context,
                  'Fees & Payments',
                  Icons.payment,
                  AppRoutes.payment,
                ),
                _buildDrawerItem(
                  context,
                  'Grades',
                  Icons.grade,
                  AppRoutes.gradeEntry,
                ),
                _buildDrawerItem(
                  context,
                  'Announcements',
                  Icons.announcement,
                  AppRoutes.announcement,
                ),
                _buildDrawerItem(
                  context,
                  'Reports',
                  Icons.bar_chart,
                  '#', // Placeholder until reports is defined
                ),
                _buildDrawerItem(
                  context,
                  'Settings',
                  Icons.settings,
                  '#', // Placeholder until settings is defined
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  'Logout',
                  Icons.logout,
                  AppRoutes.login,
                  onTap: () {
                    // TODO: Implement signOut using the correct provider
                    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                  },
                ),
              ],
            ),
          ),
          
          // App version at the bottom
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    String title,
    IconData icon,
    String route, {
    VoidCallback? onTap,
  }) {
    final isSelected = currentRoute == route;
    final theme = Theme.of(context);
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? theme.primaryColor : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? theme.primaryColor : null,
        ),
      ),
      selected: isSelected,
      onTap: onTap ?? () {
        Navigator.pop(context); // Close drawer
        if (route != currentRoute) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }
} 