import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/utils/validators.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/loading_indicator.dart';

/// Screen for entering student grades
class GradeEntryScreen extends ConsumerStatefulWidget {
  final String? classId;
  final String? subjectId;
  final String? assessmentId;
  
  const GradeEntryScreen({
    Key? key,
    this.classId,
    this.subjectId,
    this.assessmentId,
  }) : super(key: key);

  @override
  ConsumerState<GradeEntryScreen> createState() => _GradeEntryScreenState();
}

class _GradeEntryScreenState extends ConsumerState<GradeEntryScreen> {
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  
  String _selectedClass = '';
  String _selectedSubject = '';
  String _assessmentTitle = '';
  DateTime _assessmentDate = DateTime.now();
  double _totalMarks = 100.0;
  GradeType _gradeType = GradeType.test;
  String _description = '';
  
  List<_StudentGrade> _students = [];
  bool _gradesExist = false;
  
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
  
  // List of subjects for dropdown
  final List<String> _subjects = [
    'Mathematics',
    'English',
    'Science',
    'Physics',
    'Chemistry',
    'Biology',
    'History',
    'Geography',
    'Computer Science',
    'Art',
    'Physical Education',
  ];
  
  // Form controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _totalMarksController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    super.initState();
    
    // Set initial values from parameters
    if (widget.classId != null) {
      _selectedClass = _getClassNameById(widget.classId!);
    } else if (_classes.isNotEmpty) {
      _selectedClass = _classes.first;
    }
    
    if (widget.subjectId != null) {
      _selectedSubject = _getSubjectNameById(widget.subjectId!);
    } else if (_subjects.isNotEmpty) {
      _selectedSubject = _subjects.first;
    }
    
    if (widget.assessmentId != null) {
      _loadExistingAssessment();
    } else {
      _titleController.text = 'Test ${DateFormat('d MMM yyyy').format(_assessmentDate)}';
      _totalMarksController.text = _totalMarks.toString();
      _loadStudents();
    }
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _totalMarksController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  /// Load existing assessment data
  Future<void> _loadExistingAssessment() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _gradesExist = true;
    });
    
    try {
      // TODO: Load actual data from repository
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data
      setState(() {
        _assessmentTitle = 'Midterm Test';
        _titleController.text = 'Midterm Test';
        _assessmentDate = DateTime.now().subtract(const Duration(days: 7));
        _totalMarks = 100.0;
        _totalMarksController.text = '100.0';
        _gradeType = GradeType.test;
        _description = 'Comprehensive test covering chapters 1-5';
        _descriptionController.text = 'Comprehensive test covering chapters 1-5';
        
        _students = [
          _StudentGrade(
            id: '1',
            name: 'John Doe',
            marks: 85,
            comment: 'Excellent work',
          ),
          _StudentGrade(
            id: '2',
            name: 'Jane Smith',
            marks: 92,
            comment: 'Outstanding',
          ),
          _StudentGrade(
            id: '3',
            name: 'Michael Brown',
            marks: 68,
            comment: 'Needs improvement',
          ),
          _StudentGrade(
            id: '4',
            name: 'Emily Johnson',
            marks: 76,
            comment: 'Good effort',
          ),
          _StudentGrade(
            id: '5',
            name: 'David Williams',
            marks: 88,
            comment: 'Very good',
          ),
        ];
        
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading assessment data: $e';
        _isLoading = false;
      });
    }
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
      List<_StudentGrade> students = [
        _StudentGrade(id: '1', name: 'John Doe'),
        _StudentGrade(id: '2', name: 'Jane Smith'),
        _StudentGrade(id: '3', name: 'Michael Brown'),
        _StudentGrade(id: '4', name: 'Emily Johnson'),
        _StudentGrade(id: '5', name: 'David Williams'),
      ];
      
      setState(() {
        _students = students;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading students: $e';
        _isLoading = false;
      });
    }
  }
  
  /// Save assessment and grades
  Future<void> _saveGrades() async {
    if (!_validateForm()) return;
    
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });
    
    try {
      // TODO: Save actual data to repository
      await Future.delayed(const Duration(seconds: 1));
      
      // Navigate back or to report
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Grades saved successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.reportCard,
          arguments: {
            'classId': widget.classId,
            'studentId': null, // View all students
          },
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error saving grades: $e';
        _isSaving = false;
      });
    }
  }
  
  /// Validate the form
  bool _validateForm() {
    bool isValid = _formKey.currentState!.validate();
    
    // Check if any student has invalid grade
    for (var student in _students) {
      if (student.marks != null) {
        if (student.marks! < 0 || student.marks! > _totalMarks) {
          setState(() {
            _errorMessage = 'Marks must be between 0 and $_totalMarks';
          });
          isValid = false;
          break;
        }
      }
    }
    
    return isValid;
  }
  
  /// Show date picker for assessment date
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _assessmentDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _assessmentDate) {
      setState(() {
        _assessmentDate = picked;
      });
    }
  }
  
  /// Get class name by ID (mock implementation)
  String _getClassNameById(String classId) {
    // TODO: Implement actual lookup from repository
    return _classes.first;
  }
  
  /// Get subject name by ID (mock implementation)
  String _getSubjectNameById(String subjectId) {
    // TODO: Implement actual lookup from repository
    return _subjects.first;
  }
  
  /// Show comment dialog for a student
  Future<void> _showCommentDialog(int index) async {
    final TextEditingController controller = TextEditingController(
      text: _students[index].comment,
    );
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Comment for ${_students[index].name}'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter comment',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _students[index].comment = controller.text;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.assessmentId != null
            ? 'Edit Assessment'
            : 'New Assessment',
      ),
      body: LoadingContent(
        isLoading: _isLoading,
        loadingMessage: 'Loading assessment data...',
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Assessment details
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Class and Subject dropdowns
                    Row(
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
                            onChanged: widget.classId != null || _gradesExist
                                ? null // Disable if editing or specified in args
                                : (String? value) {
                                    if (value != null &&
                                        value != _selectedClass) {
                                      setState(() {
                                        _selectedClass = value;
                                      });
                                      _loadStudents();
                                    }
                                  },
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Subject dropdown
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedSubject,
                            decoration: const InputDecoration(
                              labelText: 'Subject',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            items: _subjects.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: widget.subjectId != null || _gradesExist
                                ? null // Disable if editing or specified in args
                                : (String? value) {
                                    if (value != null &&
                                        value != _selectedSubject) {
                                      setState(() {
                                        _selectedSubject = value;
                                      });
                                    }
                                  },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Assessment title and date
                    Row(
                      children: [
                        // Title
                        Expanded(
                          flex: 2,
                          child: CustomTextField(
                            labelText: 'Assessment Title',
                            hintText: 'Enter title',
                            controller: _titleController,
                            validator: Validators.validateNotEmpty,
                            prefixIcon: const Icon(Icons.title),
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Date picker
                        Expanded(
                          child: InkWell(
                            onTap: _selectDate,
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Date',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.calendar_today),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              child: Text(
                                DateFormat('dd/MM/yyyy').format(_assessmentDate),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Assessment type and total marks
                    Row(
                      children: [
                        // Grade type
                        Expanded(
                          child: DropdownButtonFormField<GradeType>(
                            value: _gradeType,
                            decoration: const InputDecoration(
                              labelText: 'Assessment Type',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            items: GradeType.values.map((GradeType value) {
                              return DropdownMenuItem<GradeType>(
                                value: value,
                                child: Text(_formatGradeType(value)),
                              );
                            }).toList(),
                            onChanged: (GradeType? value) {
                              if (value != null) {
                                setState(() {
                                  _gradeType = value;
                                });
                              }
                            },
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Total marks
                        Expanded(
                          child: CustomTextField(
                            labelText: 'Total Marks',
                            hintText: 'Enter total marks',
                            controller: _totalMarksController,
                            validator: Validators.validateNumber,
                            keyboardType: TextInputType.number,
                            prefixIcon: const Icon(Icons.score),
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                try {
                                  _totalMarks = double.parse(value);
                                } catch (e) {
                                  // Handle parsing error
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Description
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description (Optional)',
                        hintText: 'Enter assessment description',
                        prefixIcon: const Icon(Icons.description),
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 2,
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
              
              // Students list
              Expanded(
                child: _students.isEmpty
                    ? const EmptyState(
                        title: 'No Students',
                        message: 'There are no students in this class.',
                        icon: Icons.people_outline,
                      )
                    : ListView.builder(
                        itemCount: _students.length,
                        itemBuilder: (context, index) {
                          final student = _students[index];
                          return _buildStudentGradeItem(student, index);
                        },
                      ),
              ),
              
              // Save button
              if (_students.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  child: CustomButton(
                    text: _gradesExist ? 'Update Grades' : 'Save Grades',
                    onPressed: _saveGrades,
                    isLoading: _isSaving,
                    isFullWidth: true,
                    icon: Icons.save,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Build a student grade item
  Widget _buildStudentGradeItem(_StudentGrade student, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Student name
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (student.comment != null && student.comment!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Comment: ${student.comment}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Marks entry
            SizedBox(
              width: 80,
              child: TextFormField(
                initialValue: student.marks?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Marks',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    try {
                      setState(() {
                        _students[index].marks = double.parse(value);
                      });
                    } catch (e) {
                      // Handle parsing error
                    }
                  } else {
                    setState(() {
                      _students[index].marks = null;
                    });
                  }
                },
              ),
            ),
            
            // Comment button
            IconButton(
              icon: const Icon(Icons.comment),
              onPressed: () => _showCommentDialog(index),
              tooltip: 'Add Comment',
            ),
          ],
        ),
      ),
    );
  }
  
  /// Format grade type for display
  String _formatGradeType(GradeType type) {
    switch (type) {
      case GradeType.test:
        return 'Test';
      case GradeType.exam:
        return 'Exam';
      case GradeType.assignment:
        return 'Assignment';
      case GradeType.project:
        return 'Project';
      case GradeType.classwork:
        return 'Classwork';
      case GradeType.homework:
        return 'Homework';
      case GradeType.quiz:
        return 'Quiz';
      case GradeType.practical:
        return 'Practical';
      case GradeType.other:
        return 'Other';
    }
  }
}

/// Student grade data model
class _StudentGrade {
  final String id;
  final String name;
  double? marks;
  String? comment;
  
  _StudentGrade({
    required this.id,
    required this.name,
    this.marks,
    this.comment,
  });
}