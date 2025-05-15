import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/constants.dart';
import '../../../../config/routes.dart';
import '../../../../config/themes.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/connectivity_provider.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../widgets/sync_status_widget.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    final isConnected = ref.watch(connectivityStatusProvider);
    
    return Theme(
      data: AppThemes.getRoleTheme('admin'),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.dashboard),
          actions: [
            // Display sync status
            SyncStatusWidget(),
            
            // Display connectivity status
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ref.watch(connectivityIndicatorProvider),
            ),
          ],
        ),
        drawer: AppDrawer(currentRoute: AppRoutes.adminDashboard),
        body: user.when(
          data: (userData) {
            return userData == null
                ? const Center(child: Text('User not found'))
                : _buildDashboard(context, userData?.fullName ?? 'Admin');
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error: ${error.toString()}'),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, String userName) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isSmallScreen = size.width < 600;
    
    return RefreshIndicator(
      onRefresh: () async {
        // Manually trigger a sync when the user pulls to refresh
        await ref.read(connectivityStatusProvider.notifier).manualSync();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: theme.primaryColor.withOpacity(0.2),
                      child: Icon(
                        Icons.admin_panel_settings,
                        size: 30,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, $userName',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'You have admin access to the system',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Quick stats section
            Text(
              'School Overview',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isSmallScreen ? 2 : 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildStatCard(
                  context,
                  'Students',
                  '256',
                  Icons.school,
                  Colors.blue,
                  () => Navigator.pushNamed(context, AppRoutes.studentList),
                ),
                _buildStatCard(
                  context,
                  'Teachers',
                  '28',
                  Icons.person,
                  Colors.green,
                  () {},
                ),
                _buildStatCard(
                  context,
                  'Classes',
                  '12',
                  Icons.class_,
                  Colors.orange,
                  () {},
                ),
                _buildStatCard(
                  context,
                  'Payments',
                  'USD 15,240',
                  Icons.attach_money,
                  Colors.purple,
                  () => Navigator.pushNamed(context, AppRoutes.payment),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Recent activities section
            Text(
              'Recent Activities',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return _buildActivityItem(context, index);
                },
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Quick actions section
            Text(
              'Quick Actions',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    'Add Student',
                    Icons.person_add,
                    () {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionButton(
                    context,
                    'Take Attendance',
                    Icons.fact_check,
                    () => Navigator.pushNamed(context, AppRoutes.attendance),
                  ),
                ),
                if (!isSmallScreen) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionButton(
                      context,
                      'Add Payment',
                      Icons.payment,
                      () {},
                    ),
                  ),
                ],
              ],
            ),
            if (isSmallScreen) ...[
              const SizedBox(height: 16),
              _buildActionButton(
                context,
                'Add Payment',
                Icons.payment,
                () {},
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Announcements section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Announcements',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.announcement);
                          },
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.announcement),
                      ),
                      title: Text('Parent-Teacher Meeting'),
                      subtitle: Text('Scheduled for next Friday at 2pm'),
                      trailing: Text('2 days ago'),
                    ),
                    const Divider(),
                    const ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.announcement),
                      ),
                      title: Text('End of Term Examinations'),
                      subtitle: Text('Starting from 15th August'),
                      trailing: Text('1 week ago'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color.withOpacity(0.2),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, int index) {
    final activities = [
      {
        'title': 'New student registered',
        'description': 'Tatenda Moyo was added to Form 3A',
        'time': '2 hours ago',
        'icon': Icons.person_add,
        'color': Colors.green,
      },
      {
        'title': 'Payment received',
        'description': 'USD 150 received for Chiedza Ndoro',
        'time': '4 hours ago',
        'icon': Icons.payment,
        'color': Colors.blue,
      },
      {
        'title': 'Attendance marked',
        'description': 'Form 4B attendance marked for today',
        'time': '5 hours ago',
        'icon': Icons.check_circle,
        'color': Colors.orange,
      },
      {
        'title': 'Grades uploaded',
        'description': 'Form 2A Mathematics grades uploaded',
        'time': 'Yesterday',
        'icon': Icons.grade,
        'color': Colors.purple,
      },
      {
        'title': 'Announcement posted',
        'description': 'New announcement for all parents',
        'time': 'Yesterday',
        'icon': Icons.announcement,
        'color': Colors.red,
      },
    ];

    final activity = activities[index];

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: (activity['color'] as Color).withOpacity(0.2),
        child: Icon(
          activity['icon'] as IconData,
          color: activity['color'] as Color,
        ),
      ),
      title: Text(activity['title'] as String),
      subtitle: Text(activity['description'] as String),
      trailing: Text(
        activity['time'] as String,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(height: 8),
          Text(title),
        ],
      ),
    );
  }
}
