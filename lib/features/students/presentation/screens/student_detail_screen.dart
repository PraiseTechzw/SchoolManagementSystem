import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../config/constants.dart';
import '../../../../config/routes.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/providers/connectivity_provider.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../data/models/student_model.dart';
import '../../data/repositories/student_repository.dart';

// Provider for student detail
final studentDetailProvider = FutureProvider.family<StudentModel?, String>((ref, id) async {
  final studentRepository = ref.watch(studentRepositoryProvider);
  return await studentRepository.getStudentById(id);
});

class StudentDetailScreen extends ConsumerWidget {
  final String studentId;
  
  const StudentDetailScreen({
    Key? key,
    required this.studentId,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    
    final studentAsync = ref.watch(studentDetailProvider(studentId));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.studentDetails),
        actions: [
          // Display connectivity status
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ref.watch(connectivityIndicatorProvider),
          ),
        ],
      ),
      body: studentAsync.when(
        data: (student) {
          if (student == null) {
            return const Center(
              child: Text('Student not found'),
            );
          }
          
          return RefreshIndicator(
            onRefresh: () async {
              ref.refresh(studentDetailProvider(studentId));
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Student profile card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Student photo and basic information
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Student photo
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: student.gender == Gender.male 
                                    ? Colors.blue.shade100 
                                    : Colors.pink.shade100,
                                child: Text(
                                  student.fullName.substring(0, 1).toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: student.gender == Gender.male 
                                        ? Colors.blue.shade800 
                                        : Colors.pink.shade800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              
                              // Student basic information
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      student.fullName,
                                      style: theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Class: ${student.fullClassName}',
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Roll Number: ${student.rollNumber}',
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Gender: ${student.gender.displayName}',
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Age: ${student.age} years',
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const Divider(height: 32),
                          
                          // Quick action buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildActionButton(
                                context: context,
                                icon: Icons.payment,
                                label: 'Fee Details',
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.payment,
                                    arguments: {'studentId': student.id},
                                  );
                                },
                              ),
                              _buildActionButton(
                                context: context,
                                icon: Icons.assignment,
                                label: 'Grades',
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.reportCard,
                                    arguments: {
                                      'studentId': student.id,
                                      'termId': 'term1',
                                    },
                                  );
                                },
                              ),
                              _buildActionButton(
                                context: context,
                                icon: Icons.person,
                                label: 'Profile',
                                onTap: () {
                                  // Show detailed information dialog
                                  _showDetailedInfoDialog(context, student);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Detailed sections in tabs or accordions
                  DefaultTabController(
                    length: 4,
                    child: Column(
                      children: [
                        // Tab bar
                        TabBar(
                          tabs: const [
                            Tab(text: 'Personal'),
                            Tab(text: 'Attendance'),
                            Tab(text: 'Fees'),
                            Tab(text: 'Grades'),
                          ],
                          labelColor: theme.primaryColor,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: theme.primaryColor,
                        ),
                        
                        // Tab content
                        SizedBox(
                          height: 300,
                          child: TabBarView(
                            children: [
                              // Personal information tab
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoItem('Full Name', student.fullName),
                                    _buildInfoItem('Date of Birth', DateFormat('MMMM d, yyyy').format(student.dateOfBirth)),
                                    _buildInfoItem('Age', '${student.age} years'),
                                    _buildInfoItem('Gender', student.gender.displayName),
                                    _buildInfoItem('Address', student.address ?? 'Not provided'),
                                    _buildInfoItem('Guardian Name', student.guardianName ?? 'Not provided'),
                                    _buildInfoItem('Guardian Phone', student.guardianPhone ?? 'Not provided'),
                                    _buildInfoItem('Admission Date', DateFormat('MMMM d, yyyy').format(student.admissionDate)),
                                  ],
                                ),
                              ),
                              
                              // Attendance tab
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Attendance summary
                                    Card(
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            _buildAttendanceStats('Present', '42', Colors.green),
                                            _buildAttendanceStats('Absent', '3', Colors.red),
                                            _buildAttendanceStats('Late', '5', Colors.orange),
                                          ],
                                        ),
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 16),
                                    
                                    // Attendance percentage
                                    Text(
                                      'Attendance Rate: 92%',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    
                                    const SizedBox(height: 8),
                                    
                                    LinearProgressIndicator(
                                      value: 0.92,
                                      backgroundColor: Colors.grey[200],
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                      minHeight: 8,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    
                                    const SizedBox(height: 24),
                                    
                                    // Recent attendance
                                    Text(
                                      'Recent Attendance',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    
                                    const SizedBox(height: 8),
                                    
                                    // List of recent attendance records
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: 5,
                                      itemBuilder: (context, index) {
                                        final date = DateTime.now().subtract(Duration(days: index));
                                        final status = index == 1 ? 'Absent' : (index == 3 ? 'Late' : 'Present');
                                        final color = status == 'Present' 
                                            ? Colors.green 
                                            : (status == 'Late' ? Colors.orange : Colors.red);
                                        
                                        return ListTile(
                                          dense: true,
                                          title: Text(DateFormat('EEEE, MMMM d').format(date)),
                                          trailing: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: color.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              status,
                                              style: TextStyle(
                                                color: color,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Fees tab
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Fee summary
                                    Card(
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Total Fees',
                                                  style: theme.textTheme.bodyLarge,
                                                ),
                                                Text(
                                                  'USD 450.00',
                                                  style: theme.textTheme.titleMedium?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Amount Paid',
                                                  style: theme.textTheme.bodyLarge,
                                                ),
                                                Text(
                                                  'USD 350.00',
                                                  style: theme.textTheme.titleMedium?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Balance',
                                                  style: theme.textTheme.bodyLarge,
                                                ),
                                                Text(
                                                  'USD 100.00',
                                                  style: theme.textTheme.titleMedium?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            LinearProgressIndicator(
                                              value: 0.78,
                                              backgroundColor: Colors.grey[200],
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                              minHeight: 8,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            const SizedBox(height: 8),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Text('78% paid'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 24),
                                    
                                    // Recent payments
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Recent Payments',
                                          style: theme.textTheme.titleMedium,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              AppRoutes.payment,
                                              arguments: {'studentId': student.id},
                                            );
                                          },
                                          child: const Text('View All'),
                                        ),
                                      ],
                                    ),
                                    
                                    // List of recent payments
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: 3,
                                      itemBuilder: (context, index) {
                                        final date = DateTime.now().subtract(Duration(days: index * 15));
                                        final amount = index == 0 ? 'USD 100.00' : (index == 1 ? 'USD 150.00' : 'USD 100.00');
                                        final method = index == 0 ? 'Cash' : (index == 1 ? 'Bank Transfer' : 'Mobile Money');
                                        
                                        return ListTile(
                                          dense: true,
                                          title: Text(DateFormat('MMMM d, yyyy').format(date)),
                                          subtitle: Text(method),
                                          trailing: Text(
                                            amount,
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              AppRoutes.receipt,
                                              arguments: {'paymentId': 'payment$index'},
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    
                                    const SizedBox(height: 16),
                                    
                                    // Add payment button
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            AppRoutes.payment,
                                            arguments: {'studentId': student.id},
                                          );
                                        },
                                        icon: const Icon(Icons.add),
                                        label: const Text('Add Payment'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Grades tab
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Grade summary
                                    Card(
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Current Term Average',
                                              style: theme.textTheme.titleMedium,
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '82.5',
                                                  style: theme.textTheme.headlineMedium?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: const Text(
                                                    'A',
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Class Rank: 7 of 35',
                                              style: theme.textTheme.bodyLarge,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 24),
                                    
                                    // Subject grades
                                    Text(
                                      'Subject Grades',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    
                                    const SizedBox(height: 16),
                                    
                                    // List of subject grades
                                    ListView(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      children: [
                                        _buildSubjectGradeItem('Mathematics', 88, 'A'),
                                        _buildSubjectGradeItem('English', 76, 'B'),
                                        _buildSubjectGradeItem('Science', 92, 'A+'),
                                        _buildSubjectGradeItem('History', 81, 'A'),
                                        _buildSubjectGradeItem('Geography', 85, 'A'),
                                      ],
                                    ),
                                    
                                    const SizedBox(height: 16),
                                    
                                    // View report card button
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            AppRoutes.reportCard,
                                            arguments: {
                                              'studentId': student.id,
                                              'termId': 'term1',
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.description),
                                        label: const Text('View Report Card'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }
  
  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAttendanceStats(String label, String value, Color color) {
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
              value,
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
  
  Widget _buildSubjectGradeItem(String subject, int score, String grade) {
    Color gradeColor;
    if (grade.startsWith('A')) {
      gradeColor = Colors.green;
    } else if (grade.startsWith('B')) {
      gradeColor = Colors.blue;
    } else if (grade.startsWith('C')) {
      gradeColor = Colors.orange;
    } else if (grade.startsWith('D')) {
      gradeColor = Colors.deepOrange;
    } else {
      gradeColor = Colors.red;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              subject,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '$score%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: gradeColor,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: gradeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              grade,
              style: TextStyle(
                color: gradeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showDetailedInfoDialog(BuildContext context, StudentModel student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(student.fullName),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoItem('Full Name', student.fullName),
              _buildInfoItem('Date of Birth', DateFormat('MMMM d, yyyy').format(student.dateOfBirth)),
              _buildInfoItem('Age', '${student.age} years'),
              _buildInfoItem('Gender', student.gender.displayName),
              _buildInfoItem('Class', student.fullClassName),
              _buildInfoItem('Roll Number', student.rollNumber.toString()),
              _buildInfoItem('Address', student.address ?? 'Not provided'),
              _buildInfoItem('Guardian Name', student.guardianName ?? 'Not provided'),
              _buildInfoItem('Guardian Phone', student.guardianPhone ?? 'Not provided'),
              _buildInfoItem('Guardian Email', student.guardianEmail ?? 'Not provided'),
              _buildInfoItem('Guardian Relation', student.guardianRelation ?? 'Not provided'),
              _buildInfoItem('Admission Date', DateFormat('MMMM d, yyyy').format(student.admissionDate)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
