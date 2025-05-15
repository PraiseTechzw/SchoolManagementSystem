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

class StudentDashboard extends ConsumerStatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  ConsumerState<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends ConsumerState<StudentDashboard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    final isConnected = ref.watch(connectivityStatusProvider);
    
    return Theme(
      data: AppThemes.getRoleTheme('student'),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Student Dashboard'),
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
        drawer: AppDrawer(currentRoute: AppRoutes.studentDashboard),
        body: user.when(
          data: (userData) {
            return userData == null
                ? const Center(child: Text('User not found'))
                : _buildDashboard(context, userData?.fullName ?? 'Student');
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
                            'Form 3A • Academic Year 2023',
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
            
            // Today's timetable
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
                          'Today\'s Classes',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('EEEE, MMMM d').format(DateTime.now()),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // List of today's classes
                    _buildTimeTableItem(
                      '08:00 - 09:30',
                      'Mathematics',
                      'Mr. Johnson',
                      'Room 12',
                      false,
                    ),
                    _buildTimeTableItem(
                      '09:45 - 11:15',
                      'English Language',
                      'Mrs. Smith',
                      'Room 15',
                      true,
                    ),
                    _buildTimeTableItem(
                      '11:30 - 13:00',
                      'Biology',
                      'Dr. Moyo',
                      'Laboratory 2',
                      false,
                    ),
                    _buildTimeTableItem(
                      '14:00 - 15:30',
                      'History',
                      'Mr. Ndlovu',
                      'Room 8',
                      false,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Academic progress section
            Text(
              'Academic Progress',
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
                _buildGradeCard(
                  'Mathematics',
                  88,
                  Icons.calculate,
                  Colors.blue,
                ),
                _buildGradeCard(
                  'English',
                  76,
                  Icons.menu_book,
                  Colors.green,
                ),
                _buildGradeCard(
                  'Science',
                  92,
                  Icons.science,
                  Colors.purple,
                ),
                _buildGradeCard(
                  'History',
                  81,
                  Icons.history_edu,
                  Colors.orange,
                ),
                _buildGradeCard(
                  'Geography',
                  85,
                  Icons.public,
                  Colors.teal,
                ),
                _buildGradeCard(
                  'Art',
                  94,
                  Icons.color_lens,
                  Colors.pink,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Upcoming assignments and tests
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
                      'Upcoming Assignments & Tests',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildAssignmentItem(
                      'Mathematics Quiz',
                      'Algebra and Functions',
                      DateTime.now().add(const Duration(days: 2)),
                      Colors.blue,
                    ),
                    const Divider(),
                    _buildAssignmentItem(
                      'English Essay',
                      'Critical Analysis of "Things Fall Apart"',
                      DateTime.now().add(const Duration(days: 5)),
                      Colors.green,
                    ),
                    const Divider(),
                    _buildAssignmentItem(
                      'Biology Practical',
                      'Cell Structure Observation',
                      DateTime.now().add(const Duration(days: 7)),
                      Colors.purple,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Attendance section
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
                      'Attendance',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildAttendanceItem('Present', 42, Colors.green),
                        _buildAttendanceItem('Absent', 3, Colors.red),
                        _buildAttendanceItem('Late', 5, Colors.orange),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Progress bar for attendance
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Overall Attendance',
                              style: theme.textTheme.bodyMedium,
                            ),
                            Text(
                              '92%',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 0.92,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                      title: Text('End of Term Examinations'),
                      subtitle: Text('Starting from 15th August'),
                      trailing: Text('1 week ago'),
                    ),
                    const Divider(),
                    const ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.sports_soccer),
                      ),
                      title: Text('Inter-School Sports Day'),
                      subtitle: Text('Bring your sports kit on Friday'),
                      trailing: Text('2 days ago'),
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

  Widget _buildTimeTableItem(
    String time,
    String subject,
    String teacher,
    String room,
    bool isCurrent,
  ) {
    final backgroundColor = isCurrent ? Colors.green.withOpacity(0.1) : Colors.transparent;
    final borderColor = isCurrent ? Colors.green : Colors.transparent;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '$teacher • $room',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Current',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGradeCard(
    String subject,
    int grade,
    IconData icon,
    Color color,
  ) {
    String letterGrade;
    if (grade >= 90) {
      letterGrade = 'A+';
    } else if (grade >= 80) {
      letterGrade = 'A';
    } else if (grade >= 70) {
      letterGrade = 'B';
    } else if (grade >= 60) {
      letterGrade = 'C';
    } else if (grade >= 50) {
      letterGrade = 'D';
    } else {
      letterGrade = 'F';
    }
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subject,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$grade%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    letterGrade,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentItem(
    String title,
    String description,
    DateTime dueDate,
    Color color,
  ) {
    final daysLeft = dueDate.difference(DateTime.now()).inDays;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(
              Icons.assignment,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Due: ${DateFormat('MMM d, yyyy').format(dueDate)}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceItem(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
