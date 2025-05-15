import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../config/constants.dart';
import '../../../../config/routes.dart';
import '../../../../config/themes.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/connectivity_provider.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../widgets/sync_status_widget.dart';

class ParentDashboard extends ConsumerStatefulWidget {
  const ParentDashboard({Key? key}) : super(key: key);

  @override
  ConsumerState<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends ConsumerState<ParentDashboard> {
  int _selectedChildIndex = 0;
  
  // Mock children data - in a real app, this would come from a repository
  final List<Map<String, dynamic>> _children = [
    {
      'id': 'child1',
      'name': 'Tinotenda Moyo',
      'class': 'Form 3A',
      'imageUrl': null,
      'attendance': 92,
      'fees': {
        'total': 450.0,
        'paid': 350.0,
        'balance': 100.0,
        'currency': 'USD',
      },
      'grades': {
        'average': 78.5,
        'rank': 7,
        'totalStudents': 35,
      },
    },
    {
      'id': 'child2',
      'name': 'Farai Moyo',
      'class': 'Form 1B',
      'imageUrl': null,
      'attendance': 96,
      'fees': {
        'total': 400.0,
        'paid': 400.0,
        'balance': 0.0,
        'currency': 'USD',
      },
      'grades': {
        'average': 85.2,
        'rank': 3,
        'totalStudents': 32,
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    final isConnected = ref.watch(connectivityStatusProvider);
    
    return Theme(
      data: AppThemes.getRoleTheme('parent'),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Parent Dashboard'),
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
        drawer: AppDrawer(currentRoute: AppRoutes.parentDashboard),
        body: user.when(
          data: (userData) {
            return userData == null
                ? const Center(child: Text('User not found'))
                : _buildDashboard(context, userData?.fullName ?? 'Parent');
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
    
    // Get current child data
    final currentChild = _children[_selectedChildIndex];
    
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
            // Welcome section with child selector
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
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: theme.primaryColor.withOpacity(0.2),
                          child: Icon(
                            Icons.family_restroom,
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
                                'Stay updated with your child\'s progress',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _selectedChildIndex,
                      decoration: InputDecoration(
                        labelText: 'Select Child',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      items: List.generate(
                        _children.length,
                        (index) => DropdownMenuItem(
                          value: index,
                          child: Text(_children[index]['name']),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedChildIndex = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Child info section
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
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey[200],
                          child: Text(
                            currentChild['name'].toString().substring(0, 1),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentChild['name'],
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Class: ${currentChild['class']}',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.studentDetail,
                              arguments: {'studentId': currentChild['id']},
                            );
                          },
                          icon: const Icon(Icons.visibility),
                          label: const Text('View Profile'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Quick stats for the selected child
            Text(
              'Quick Overview',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isSmallScreen ? 2 : 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildStatCard(
                  context,
                  'Attendance',
                  '${currentChild['attendance']}%',
                  Icons.calendar_today,
                  Colors.blue,
                  () {},
                ),
                _buildStatCard(
                  context,
                  'Average Grade',
                  currentChild['grades']['average'].toString(),
                  Icons.assessment,
                  Colors.green,
                  () {},
                ),
                _buildStatCard(
                  context,
                  'Class Rank',
                  '${currentChild['grades']['rank']}/${currentChild['grades']['totalStudents']}',
                  Icons.leaderboard,
                  Colors.purple,
                  () {},
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Fee details
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
                    Text(
                      'Fee Information',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFeeInfoItem(
                            'Total Fee',
                            '${currentChild['fees']['currency']} ${currentChild['fees']['total']}',
                            Colors.grey[700]!,
                          ),
                        ),
                        Expanded(
                          child: _buildFeeInfoItem(
                            'Amount Paid',
                            '${currentChild['fees']['currency']} ${currentChild['fees']['paid']}',
                            Colors.green,
                          ),
                        ),
                        Expanded(
                          child: _buildFeeInfoItem(
                            'Balance',
                            '${currentChild['fees']['currency']} ${currentChild['fees']['balance']}',
                            currentChild['fees']['balance'] > 0 ? Colors.red : Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: currentChild['fees']['paid'] / currentChild['fees']['total'],
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 16),
                    if (currentChild['fees']['balance'] > 0)
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.payment,
                            arguments: {'studentId': currentChild['id']},
                          );
                        },
                        icon: const Icon(Icons.payment),
                        label: const Text('Make Payment'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Recent reports section
            Text(
              'Recent Reports',
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
                itemCount: 3,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return _buildReportItem(context, index);
                },
              ),
            ),
            
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
                          'School Announcements',
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

  Widget _buildFeeInfoItem(String title, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildReportItem(BuildContext context, int index) {
    final reports = [
      {
        'title': 'End of Term Report',
        'date': '28 Apr 2023',
        'type': 'PDF',
      },
      {
        'title': 'Mid-term Assessment',
        'date': '15 Mar 2023',
        'type': 'PDF',
      },
      {
        'title': 'Beginning of Year Report',
        'date': '20 Jan 2023',
        'type': 'PDF',
      },
    ];

    final report = reports[index];

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.red[100],
        child: const Icon(
          Icons.picture_as_pdf,
          color: Colors.red,
        ),
      ),
      title: Text(report['title']!),
      subtitle: Text('Date: ${report['date']}'),
      trailing: OutlinedButton.icon(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.reportCard,
            arguments: {
              'studentId': _children[_selectedChildIndex]['id'],
              'termId': 'term${index + 1}',
            },
          );
        },
        icon: const Icon(Icons.visibility),
        label: const Text('View'),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.reportCard,
          arguments: {
            'studentId': _children[_selectedChildIndex]['id'],
            'termId': 'term${index + 1}',
          },
        );
      },
    );
  }
}
