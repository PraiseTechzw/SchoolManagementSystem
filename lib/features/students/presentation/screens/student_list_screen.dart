import 'package:chikoro_pro/core/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../../../../config/constants.dart';
import '../../../../config/routes.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/providers/connectivity_provider.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../data/models/student_model.dart';
import '../../data/repositories/student_repository.dart';
import '../../../shared/widgets/custom_button.dart';

// Provider for student list
final studentListProvider = FutureProvider.autoDispose<List<StudentModel>>((ref) async {
  final studentRepository = ref.watch(studentRepositoryProvider);
  final activeSchoolId = ref.watch(activeSchoolProvider);
  return await studentRepository.getAllStudents(schoolId: activeSchoolId);
});

// Provider for filtered student list based on search query
final filteredStudentListProvider = StateProvider.autoDispose<List<StudentModel>>((ref) {
  final studentsAsync = ref.watch(studentListProvider);
  return studentsAsync.when(
    data: (students) => students,
    loading: () => [],
    error: (_, __) => [],
  );
});

// Provider for search query
final searchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

class StudentListScreen extends ConsumerStatefulWidget {
  const StudentListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends ConsumerState<StudentListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedClass = 'All Classes';
  
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }
  
  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
  
  void _onSearchChanged() {
    ref.read(searchQueryProvider.notifier).state = _searchController.text;
    _filterStudents();
  }
  
  void _filterStudents() {
    final searchQuery = ref.read(searchQueryProvider);
    final studentsAsync = ref.read(studentListProvider);
    
    studentsAsync.whenData((students) {
      List<StudentModel> filtered = students;
      
      // Filter by search query
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        filtered = filtered.where((student) {
          return student.fullName.toLowerCase().contains(query) ||
                 student.fullClassName.toLowerCase().contains(query) ||
                 student.rollNumber.toString().contains(query);
        }).toList();
      }
      
      // Filter by class
      if (_selectedClass != 'All Classes') {
        filtered = filtered.where((student) => student.fullClassName == _selectedClass).toList();
      }
      
      ref.read(filteredStudentListProvider.notifier).state = filtered;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    
    final studentsAsync = ref.watch(studentListProvider);
    final filteredStudents = ref.watch(filteredStudentListProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.students),
        actions: [
          // Display connectivity status
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ref.watch(connectivityIndicatorProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _searchController,
                        labelText: AppStrings.search,
                        hintText: 'Search by name, class, or roll number',
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(width: 16),
                    isSmallScreen 
                        ? IconButton(
                            onPressed: _showFilterDialog,
                            icon: const Icon(Icons.filter_list),
                            tooltip: AppStrings.filter,
                          )
                        : ElevatedButton.icon(
                            onPressed: _showFilterDialog,
                            icon: const Icon(Icons.filter_list),
                            label: const Text(AppStrings.filter),
                          ),
                  ],
                ),
                if (!isSmallScreen) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Chip(
                        label: Text(_selectedClass),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: _selectedClass != 'All Classes'
                            ? () {
                                setState(() {
                                  _selectedClass = 'All Classes';
                                });
                                _filterStudents();
                              }
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${filteredStudents.length} students',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: _clearFilters,
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear Filters'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          
          // Student list
          Expanded(
            child: studentsAsync.when(
              data: (students) {
                if (students.isEmpty) {
                  return const Center(
                    child: Text('No students found'),
                  );
                }
                
                if (filteredStudents.isEmpty) {
                  return const Center(
                    child: Text('No students match the current filters'),
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.refresh(studentListProvider);
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredStudents.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final student = filteredStudents[index];
                      return _buildStudentListItem(context, student);
                    },
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add student screen
          _showAddEditStudentDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildStudentListItem(BuildContext context, StudentModel student) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: student.gender == Gender.male 
            ? Colors.blue.shade100 
            : Colors.pink.shade100,
        child: Text(
          student.fullName.substring(0, 1).toUpperCase(),
          style: TextStyle(
            color: student.gender == Gender.male 
                ? Colors.blue.shade800 
                : Colors.pink.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        student.fullName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        'Class: ${student.fullClassName} • Roll: ${student.rollNumber} • Age: ${student.age}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: AppStrings.edit,
            onPressed: () {
              // Show edit student dialog
              _showAddEditStudentDialog(context, student: student);
            },
          ),
          IconButton(
            icon: const Icon(Icons.visibility),
            tooltip: AppStrings.view,
            onPressed: () {
              // Navigate to student detail screen
              Navigator.pushNamed(
                context,
                AppRoutes.studentDetail,
                arguments: {'studentId': student.id},
              );
            },
          ),
        ],
      ),
      onTap: () {
        // Navigate to student detail screen
        Navigator.pushNamed(
          context,
          AppRoutes.studentDetail,
          arguments: {'studentId': student.id},
        );
      },
    );
  }
  
  void _showFilterDialog() {
    // Get unique classes from students
    final studentsAsync = ref.read(studentListProvider);
    
    studentsAsync.whenData((students) {
      final classes = <String>{'All Classes'};
      
      for (final student in students) {
        classes.add(student.fullClassName);
      }
      
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Filter Students'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Class',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: classes.map((className) {
                      final isSelected = _selectedClass == className;
                      return ChoiceChip(
                        label: Text(className),
                        selected: isSelected,
                        onSelected: (selected) {
                          Navigator.pop(context);
                          setState(() {
                            _selectedClass = className;
                          });
                          _filterStudents();
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(AppStrings.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _clearFilters();
                },
                child: const Text('Clear All'),
              ),
            ],
          );
        },
      );
    });
  }
  
  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedClass = 'All Classes';
    });
    
    ref.read(searchQueryProvider.notifier).state = '';
    _filterStudents();
  }
  
  void _showAddEditStudentDialog(BuildContext context, {StudentModel? student}) {
    showDialog(
      context: context,
      builder: (context) => _AddEditStudentDialog(
        student: student,
        onSave: (newStudent) {
          // Refresh the student list
          ref.refresh(studentListProvider);
        },
      ),
    );
  }
}

class _AddEditStudentDialog extends ConsumerStatefulWidget {
  final StudentModel? student;
  final Function(StudentModel) onSave;
  
  const _AddEditStudentDialog({
    Key? key,
    this.student,
    required this.onSave,
  }) : super(key: key);
  
  @override
  ConsumerState<_AddEditStudentDialog> createState() => _AddEditStudentDialogState();
}

class _AddEditStudentDialogState extends ConsumerState<_AddEditStudentDialog> {
  final _formKey = GlobalKey<FormState>();
  
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _classNameController = TextEditingController();
  final _sectionController = TextEditingController();
  final _rollNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _guardianNameController = TextEditingController();
  final _guardianPhoneController = TextEditingController();
  
  DateTime _dateOfBirth = DateTime.now().subtract(const Duration(days: 365 * 6)); // Default to 6 years ago
  Gender _gender = Gender.male;
  bool _isEditing = false;
  bool _isSaving = false;
  
  @override
  void initState() {
    super.initState();
    _isEditing = widget.student != null;
    
    if (_isEditing) {
      // Fill form with student data
      _firstNameController.text = widget.student!.firstName;
      _lastNameController.text = widget.student!.lastName;
      _middleNameController.text = widget.student!.middleName ?? '';
      _classNameController.text = widget.student!.className;
      _sectionController.text = widget.student!.section;
      _rollNumberController.text = widget.student!.rollNumber.toString();
      _addressController.text = widget.student!.address ?? '';
      _guardianNameController.text = widget.student!.guardianName ?? '';
      _guardianPhoneController.text = widget.student!.guardianPhone ?? '';
      _dateOfBirth = widget.student!.dateOfBirth;
      _gender = widget.student!.gender;
    }
  }
  
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _classNameController.dispose();
    _sectionController.dispose();
    _rollNumberController.dispose();
    _addressController.dispose();
    _guardianNameController.dispose();
    _guardianPhoneController.dispose();
    super.dispose();
  }
  
  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isSaving = true;
    });
    
    try {
      final studentRepository = ref.read(studentRepositoryProvider);
      final activeSchoolId = ref.read(activeSchoolProvider) ?? '';
      
      // Create or update the student
      final student = StudentModel(
        id: _isEditing ? widget.student!.id : '',
        schoolId: activeSchoolId,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        middleName: _middleNameController.text.trim().isNotEmpty 
            ? _middleNameController.text.trim() 
            : null,
        dateOfBirth: _dateOfBirth,
        gender: _gender,
        address: _addressController.text.trim().isNotEmpty 
            ? _addressController.text.trim() 
            : null,
        classId: _isEditing ? widget.student!.classId : const Uuid().v4(),
        className: _classNameController.text.trim(),
        section: _sectionController.text.trim(),
        rollNumber: int.parse(_rollNumberController.text.trim()),
        guardianName: _guardianNameController.text.trim().isNotEmpty 
            ? _guardianNameController.text.trim() 
            : null,
        guardianPhone: _guardianPhoneController.text.trim().isNotEmpty 
            ? _guardianPhoneController.text.trim() 
            : null,
        admissionDate: _isEditing ? widget.student!.admissionDate : DateTime.now(),
      );
      
      final result = _isEditing 
          ? await studentRepository.updateStudent(student) 
          : await studentRepository.createStudent(student);
      
      if (result != null) {
        widget.onSave(result);
        Navigator.of(context).pop();
      } else {
        throw Exception('Failed to save student');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: Text(_isEditing ? AppStrings.editStudent : AppStrings.addStudent),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal information section
              Text(
                'Personal Information',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              
              // First name
              CustomTextField(
                controller: _firstNameController,
                labelText: 'First Name',
                hintText: 'Enter first name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Middle name
              CustomTextField(
                controller: _middleNameController,
                labelText: 'Middle Name (Optional)',
                hintText: 'Enter middle name',
              ),
              const SizedBox(height: 16),
              
              // Last name
              CustomTextField(
                controller: _lastNameController,
                labelText: 'Last Name',
                hintText: 'Enter last name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Date of birth
              Row(
                children: [
                  Expanded(
                    child: Text('Date of Birth: ${_dateOfBirth.toString().split(' ')[0]}'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _dateOfBirth,
                        firstDate: DateTime(1990),
                        lastDate: DateTime.now(),
                      );
                      
                      if (pickedDate != null) {
                        setState(() {
                          _dateOfBirth = pickedDate;
                        });
                      }
                    },
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Gender
              Text('Gender:'),
              Row(
                children: [
                  Radio<Gender>(
                    value: Gender.male,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                  const Text('Male'),
                  const SizedBox(width: 16),
                  Radio<Gender>(
                    value: Gender.female,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                  const Text('Female'),
                  const SizedBox(width: 16),
                  Radio<Gender>(
                    value: Gender.other,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                  const Text('Other'),
                ],
              ),
              const SizedBox(height: 16),
              
              // Address
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address (Optional)',
                  hintText: 'Enter address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              
              // Class information section
              Text(
                'Class Information',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              
              // Class
              CustomTextField(
                controller: _classNameController,
                labelText: 'Class',
                hintText: 'e.g. Form 1',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter class';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Section
              CustomTextField(
                controller: _sectionController,
                labelText: 'Section',
                hintText: 'e.g. A',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter section';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Roll number
              TextFormField(
                controller: _rollNumberController,
                decoration: InputDecoration(
                  labelText: 'Roll Number',
                  hintText: 'e.g. 12',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter roll number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Guardian information section
              Text(
                'Guardian Information',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              
              // Guardian name
              CustomTextField(
                controller: _guardianNameController,
                labelText: 'Guardian Name (Optional)',
                hintText: 'Enter guardian name',
              ),
              const SizedBox(height: 16),
              
              // Guardian phone
              CustomTextField(
                controller: _guardianPhoneController,
                labelText: 'Guardian Phone (Optional)',
                hintText: 'Enter guardian phone',
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving 
              ? null 
              : () => Navigator.of(context).pop(),
          child: const Text(AppStrings.cancel),
        ),
        CustomButton(
          onPressed: _saveStudent,
          text: AppStrings.save,
          isLoading: _isSaving,
        ),
      ],
    );
  }
}
