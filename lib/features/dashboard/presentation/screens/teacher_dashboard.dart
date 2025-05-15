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

class TeacherDashboard extends ConsumerStatefulWidget {
  const TeacherDashboard({Key? key}) : super(key: key);

  @override
  ConsumerState<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends ConsumerState<TeacherDashboard> {
  final DateTime _selectedDay = DateTime.now();
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    final isConnected = ref.watch(connectivityStatusProvider);
    
    return Theme(
      data: AppThemes.getRoleTheme('teacher'),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Teacher Dashboard'),
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
        drawer: AppDrawer(currentRoute: AppRoutes.teacherDashboard),
        body: user.when(
          data: (userData) {
            return userData == null
                ? const Center(child: Text('User not found'))
                : _buildDashboard(context, userData?.fullName ?? 'Teacher');
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
                        Icons.school,
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
                            DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
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
            
            // Class overview section
            Text(
              'My Classes',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isSmallScreen ? 1 : 2,
              childAspectRatio: isSmallScreen ? 2.5 : 2.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildClassCard(
                  context,
                  'Form 3A',
                  'Mathematics',
                  28,
                  2,
                  const Color(0xFF1565C0),
                  () => Navigator.pushNamed(
                    context, 
                    AppRoutes.attendance,
                    arguments: {'classId': 'form3a'},
                  ),
                ),
                _buildClassCard(
                  context,
                  'Form 4B',
                  'Mathematics',
                  32,
                  0,
                  const Color(0xFF43A047),
                  () => Navigator.pushNamed(
                    context,
                    AppRoutes.attendance,
                    arguments: {'classId': 'form4b'},
                  ),
                ),
                _buildClassCard(
                  context,
                  'Form 2A',
                  'Mathematics',
                  35,
                  1,
                  const Color(0xFFE53935),
                  () => Navigator.pushNamed(
                    context,
                    AppRoutes.attendance,
                    arguments: {'classId': 'form2a'},
                  ),
                ),
                _buildClassCard(
                  context,
                  'Form 3B',
                  'Mathematics',
                  30,
                  3,
                  const Color(0xFFFB8C00),
                  () => Navigator.pushNamed(
                    context,
                    AppRoutes.attendance,
                    arguments: {'classId': 'form3b'},
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Today's schedule section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Schedule',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('View Full'),
                ),
              ],
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
                itemCount: 4,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return _buildScheduleItem(context, index);
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
                    'Take Attendance',
                    Icons.fact_check,
                    () => Navigator.pushNamed(context, AppRoutes.attendance),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionButton(
                    context,
                    'Enter Grades',
                    Icons.grade,
                    () => Navigator.pushNamed(
                      context,
                      AppRoutes.gradeEntry,
                      arguments: {'classId': 'form3a', 'subjectId': 'mathematics'},
                    ),
                  ),
                ),
                if (!isSmallScreen) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionButton(
                      context,
                      'View Reports',
                      Icons.bar_chart,
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
                'View Reports',
                Icons.bar_chart,
                () {},
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Upcoming assignments
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
                          'Upcoming Assignments',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Add New'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildAssignmentItem(
                      context,
                      'Form 3A Quiz',
                      'Probability and Statistics',
                      DateTime.now().add(const Duration(days: 2)),
                    ),
                    const Divider(),
                    _buildAssignmentItem(
                      context,
                      'Form 4B Test',
                      'Calculus',
                      DateTime.now().add(const Duration(days: 5)),
                    ),
                    const Divider(),
                    _buildAssignmentItem(
                      context,
                      'Form 2A Assignment',
                      'Algebra',
                      DateTime.now().add(const Duration(days: 7)),
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

  Widget _buildClassCard(
    BuildContext context,
    String className,
    String subject,
    int totalStudents,
    int absences,
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
          child: Row(
            children: [
              Container(
                width: 8,
                height: 80,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      className,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subject,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.person, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '$totalStudents students',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: absences > 0 ? Colors.amber : Colors.transparent,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          absences > 0 ? '$absences absences' : 'No absences',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: absences > 0 ? Colors.amber[700] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleItem(BuildContext context, int index) {
    final schedules = [
      {
        'class': 'Form 3A',
        'subject': 'Mathematics',
        'time': '08:00 - 09:30',
        'room': 'Room 12',
      },
      {
        'class': 'Form 2A',
        'subject': 'Mathematics',
        'time': '10:00 - 11:30',
        'room': 'Room 8',
      },
      {
        'class': 'Form 4B',
        'subject': 'Mathematics',
        'time': '12:00 - 13:30',
        'room': 'Room 15',
      },
      {
        'class': 'Form 3B',
        'subject': 'Mathematics',
        'time': '14:00 - 15:30',
        'room': 'Room 10',
      },
    ];

    final schedule = schedules[index];
    final now = DateTime.now();
    final currentHour = now.hour;
    final isCurrentClass = index == 0 && currentHour >= 8 && currentHour < 10 ||
                          index == 1 && currentHour >= 10 && currentHour < 12 ||
                          index == 2 && currentHour >= 12 && currentHour < 14 ||
                          index == 3 && currentHour >= 14 && currentHour < 16;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isCurrentClass ? Colors.green : Colors.grey[200],
        child: Text(
          schedule['time']!.substring(0, 2),
          style: TextStyle(
            color: isCurrentClass ? Colors.white : Colors.black,
          ),
        ),
      ),
      title: Text(
        '${schedule['class']} - ${schedule['subject']}',
        style: TextStyle(
          fontWeight: isCurrentClass ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text('${schedule['time']} • ${schedule['room']}'),
      trailing: isCurrentClass
          ? const Chip(
              label: Text('Now'),
              backgroundColor: Colors.green,
              labelStyle: TextStyle(color: Colors.white),
            )
          : null,
      onTap: () {},
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

  Widget _buildAssignmentItem(
    BuildContext context,
    String title,
    String description,
    DateTime dueDate,
  ) {
    final daysLeft = dueDate.difference(DateTime.now()).inDays;
    
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(description),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            DateFormat('MMM d, yyyy').format(dueDate),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: daysLeft < 3 ? Colors.red[50] : Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: daysLeft < 3 ? Colors.red : Colors.blue,
                width: 1,
              ),
            ),
            child: Text(
              daysLeft == 0
                  ? 'Due today'
                  : daysLeft == 1
                      ? 'Due tomorrow'
                      : 'Due in $daysLeft days',
              style: TextStyle(
                color: daysLeft < 3 ? Colors.red : Colors.blue,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      onTap: () {},
    );
  }
}
