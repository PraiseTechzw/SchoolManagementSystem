import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../config/app_config.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/loading_indicator.dart';

/// Screen for viewing student report cards
class ReportCardScreen extends ConsumerStatefulWidget {
  final String studentId;
  final String termId;
  
  const ReportCardScreen({
    Key? key,
    required this.studentId,
    required this.termId,
  }) : super(key: key);

  @override
  ConsumerState<ReportCardScreen> createState() => _ReportCardScreenState();
}

class _ReportCardScreenState extends ConsumerState<ReportCardScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  
  String _selectedClass = '';
  String _selectedStudent = '';
  TermPeriod _selectedTerm = TermPeriod.term1;
  
  List<String> _students = [];
  List<_SubjectResult> _subjectResults = [];
  
  // Student details
  String _studentName = '';
  String _className = '';
  int _rank = 0;
  int _totalStudents = 0;
  double _averagePercentage = 0;
  String _overallGrade = '';
  String _classTeacherRemarks = '';
  String _principalRemarks = '';
  
  // Class details
  double _classAverage = 0;
  double _highestAverage = 0;
  double _lowestAverage = 0;
  
  // List of classes for dropdown
  final List<String> _classes = [
    'Grade 9A',
    'Grade 9B',
    'Grade 10A',
    'Grade 10B',
    'Grade 11A',
    'Grade 11B',
    'Grade 12A',
    'Grade 12B',
  ];
  
  @override
  void initState() {
    super.initState();
    
    // Set initial values from parameters
    if (_classes.isNotEmpty) {
      _selectedClass = _classes.first;
    }
    
    _loadStudents();
  }
  
  /// Load students for the selected class
  Future<void> _loadStudents() async {
    if (_selectedClass.isEmpty) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // TODO: Load actual data from repository
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data
      List<String> students = [
        'John Doe',
        'Jane Smith',
        'Michael Brown',
        'Emily Johnson',
        'David Williams',
      ];
      
      setState(() {
        _students = students;
        
        // If studentId is provided, set selected student
        if (widget.studentId.isNotEmpty) {
          _selectedStudent = _getStudentNameById(widget.studentId);
        } else if (students.isNotEmpty) {
          _selectedStudent = students.first;
        }
        
        _isLoading = false;
      });
      
      // Load report card for selected student
      if (_selectedStudent.isNotEmpty) {
        _loadReportCard();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading students: $e';
        _isLoading = false;
      });
    }
  }
  
  /// Load report card for selected student and term
  Future<void> _loadReportCard() async {
    if (_selectedStudent.isEmpty || _selectedClass.isEmpty) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // TODO: Load actual data from repository
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data
      List<_SubjectResult> subjectResults = [
        _SubjectResult(
          subject: 'Mathematics',
          marks: 85,
          totalMarks: 100,
          grade: 'A',
          teacherRemarks: 'Excellent work in problem-solving',
        ),
        _SubjectResult(
          subject: 'English',
          marks: 78,
          totalMarks: 100,
          grade: 'B',
          teacherRemarks: 'Good writing skills, needs work on grammar',
        ),
        _SubjectResult(
          subject: 'Science',
          marks: 92,
          totalMarks: 100,
          grade: 'A+',
          teacherRemarks: 'Outstanding performance in all areas',
        ),
        _SubjectResult(
          subject: 'History',
          marks: 65,
          totalMarks: 100,
          grade: 'C',
          teacherRemarks: 'Average understanding of concepts',
        ),
        _SubjectResult(
          subject: 'Geography',
          marks: 73,
          totalMarks: 100,
          grade: 'B-',
          teacherRemarks: 'Good effort, could improve on map work',
        ),
        _SubjectResult(
          subject: 'Computer Science',
          marks: 88,
          totalMarks: 100,
          grade: 'A',
          teacherRemarks: 'Excellent programming skills',
        ),
      ];
      
      setState(() {
        _subjectResults = subjectResults;
        
        // Student details
        _studentName = _selectedStudent;
        _className = _selectedClass;
        _rank = 2;
        _totalStudents = 25;
        _averagePercentage = _calculateAveragePercentage(subjectResults);
        _overallGrade = _getOverallGrade(_averagePercentage);
        _classTeacherRemarks = 'A hardworking student who has shown significant improvement this term. Keep up the good work!';
        _principalRemarks = 'Commendable performance. Shows great potential for further growth.';
        
        // Class details
        _classAverage = 72.5;
        _highestAverage = 94.2;
        _lowestAverage = 58.6;
        
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading report card: $e';
        _isLoading = false;
      });
    }
  }
  
  /// Calculate average percentage from subject results
  double _calculateAveragePercentage(List<_SubjectResult> results) {
    if (results.isEmpty) return 0;
    
    double totalPercentage = 0;
    for (var result in results) {
      totalPercentage += (result.marks / result.totalMarks) * 100;
    }
    
    return totalPercentage / results.length;
  }
  
  /// Get overall grade based on average percentage
  String _getOverallGrade(double percentage) {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 75) return 'B+';
    if (percentage >= 70) return 'B';
    if (percentage >= 65) return 'C+';
    if (percentage >= 60) return 'C';
    if (percentage >= 55) return 'D+';
    if (percentage >= 50) return 'D';
    return 'F';
  }
  
  /// Print report card
  Future<void> _printReportCard() async {
    // TODO: Implement printing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Printing functionality will be implemented soon.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  /// Share report card
  Future<void> _shareReportCard() async {
    // TODO: Implement sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing functionality will be implemented soon.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  /// Add new assessment
  void _addNewAssessment() {
    Navigator.of(context).pushNamed(
      AppRoutes.addEditGrade,
      arguments: {
        'studentId': widget.studentId,
      },
    );
  }
  
  /// Get class name by ID (mock implementation)
  String _getClassNameById(String classId) {
    // TODO: Implement actual lookup from repository
    return _classes.first;
  }
  
  /// Get student name by ID (mock implementation)
  String _getStudentNameById(String studentId) {
    // TODO: Implement actual lookup from repository
    return 'John Doe';
  }
  
  /// Format term period for display
  String _formatTermPeriod(TermPeriod period) {
    switch (period) {
      case TermPeriod.term1:
        return 'Term 1';
      case TermPeriod.term2:
        return 'Term 2';
      case TermPeriod.term3:
        return 'Term 3';
      case TermPeriod.yearEnd:
        return 'Year End';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Report Card',
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: _printReportCard,
            tooltip: 'Print Report Card',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareReportCard,
            tooltip: 'Share Report Card',
          ),
        ],
      ),
      body: LoadingContent(
        isLoading: _isLoading,
        loadingMessage: 'Loading report card...',
        child: Column(
          children: [
            // Selection controls
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Class dropdown
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedClass,
                      decoration: const InputDecoration(
                        labelText: 'Class',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      items: _classes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        if (value != null && value != _selectedClass) {
                          setState(() {
                            _selectedClass = value;
                          });
                          _loadStudents();
                        }
                      },
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Student dropdown
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedStudent,
                      decoration: const InputDecoration(
                        labelText: 'Student',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      items: _students.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        if (value != null && value != _selectedStudent) {
                          setState(() {
                            _selectedStudent = value;
                          });
                          _loadReportCard();
                        }
                      },
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Term dropdown
                  Expanded(
                    child: DropdownButtonFormField<TermPeriod>(
                      value: _selectedTerm,
                      decoration: const InputDecoration(
                        labelText: 'Term',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      items: TermPeriod.values.map((TermPeriod value) {
                        return DropdownMenuItem<TermPeriod>(
                          value: value,
                          child: Text(_formatTermPeriod(value)),
                        );
                      }).toList(),
                      onChanged: (TermPeriod? value) {
                        if (value != null && value != _selectedTerm) {
                          setState(() {
                            _selectedTerm = value;
                          });
                          _loadReportCard();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Error message
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            
            // Report card content
            Expanded(
              child: _subjectResults.isEmpty
                  ? const EmptyState(
                      title: 'No Results',
                      message: 'No assessment results found for this student and term.',
                      icon: Icons.assessment_outlined,
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Report card header
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  // School name
                                  Text(
                                    AppConfig.appName,
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'STUDENT REPORT CARD',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  Text(
                                    _formatTermPeriod(_selectedTerm),
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('MMMM yyyy').format(DateTime.now()),
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  const Divider(),
                                  const SizedBox(height: 16),
                                  
                                  // Student details
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildInfoRow(
                                          'Student:',
                                          _studentName,
                                          isBold: true,
                                        ),
                                      ),
                                      Expanded(
                                        child: _buildInfoRow(
                                          'Class:',
                                          _className,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildInfoRow(
                                          'Rank:',
                                          '$_rank / $_totalStudents',
                                        ),
                                      ),
                                      Expanded(
                                        child: _buildInfoRow(
                                          'Average:',
                                          '${_averagePercentage.toStringAsFixed(1)}%',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    'Grade:',
                                    _overallGrade,
                                    isBold: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Subject results
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
                                    'SUBJECT RESULTS',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Table header
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Subject',
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Marks',
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Grade',
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const Divider(height: 24),
                                  
                                  // Subject rows
                                  ..._subjectResults.map((result) => Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(result.subject),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${result.marks} / ${result.totalMarks}',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              result.grade,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: _getGradeColor(result.grade),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (result.teacherRemarks != null && result.teacherRemarks!.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                                          child: Row(
                                            children: [
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Text(
                                                  'Remarks: ${result.teacherRemarks}',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      const Divider(height: 16),
                                    ],
                                  )).toList(),
                                  
                                  // Summary
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            'Average',
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${_averagePercentage.toStringAsFixed(1)}%',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _overallGrade,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _getGradeColor(_overallGrade),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Class statistics
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
                                    'CLASS STATISTICS',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildInfoRow(
                                          'Class Average:',
                                          '${_classAverage.toStringAsFixed(1)}%',
                                        ),
                                      ),
                                      Expanded(
                                        child: _buildInfoRow(
                                          'Highest Average:',
                                          '${_highestAverage.toStringAsFixed(1)}%',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    'Lowest Average:',
                                    '${_lowestAverage.toStringAsFixed(1)}%',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Comments
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
                                    'COMMENTS',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  const Text(
                                    'Class Teacher:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(_classTeacherRemarks),
                                  
                                  const SizedBox(height: 16),
                                  
                                  const Text(
                                    'Principal:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(_principalRemarks),
                                  
                                  const SizedBox(height: 24),
                                  
                                  // Signature lines
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 120,
                                              height: 1,
                                              color: Colors.black,
                                            ),
                                            const SizedBox(height: 4),
                                            const Text(
                                              'Class Teacher',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 120,
                                              height: 1,
                                              color: Colors.black,
                                            ),
                                            const SizedBox(height: 4),
                                            const Text(
                                              'Principal',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      // Only show FAB for teachers/admin
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewAssessment,
        tooltip: 'Add Assessment',
        child: const Icon(Icons.add),
      ),
    );
  }
  
  /// Build an information row with label and value
  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Get color for grade display
  Color _getGradeColor(String grade) {
    if (grade.startsWith('A')) return Colors.green;
    if (grade.startsWith('B')) return Colors.blue;
    if (grade.startsWith('C')) return Colors.orange;
    if (grade.startsWith('D')) return Colors.deepOrange;
    return Colors.red;
  }
}

/// Subject result data model
class _SubjectResult {
  final String subject;
  final double marks;
  final double totalMarks;
  final String grade;
  final String? teacherRemarks;
  
  _SubjectResult({
    required this.subject,
    required this.marks,
    required this.totalMarks,
    required this.grade,
    this.teacherRemarks,
  });
}