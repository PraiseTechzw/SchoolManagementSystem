import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/loading_indicator.dart';

/// Screen for recording and viewing student attendance
class AttendanceScreen extends ConsumerStatefulWidget {
  final String? classId;
  final DateTime date;
  
  AttendanceScreen({
    Key? key,
    this.classId,
    DateTime? date,
  }) : date = date ?? DateTime.now(),
      super(key: key);

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  String _selectedClass = '';
  DateTime _selectedDate = DateTime.now();
  List<_StudentAttendance> _students = [];
  bool _attendanceExists = false;
  
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
    if (widget.classId != null) {
      _selectedClass = _getClassNameById(widget.classId!);
    } else if (_classes.isNotEmpty) {
      _selectedClass = _classes.first;
    }
    
    if (widget.date != null) {
      _selectedDate = widget.date!;
    }
    
    _loadAttendanceData();
  }
  
  /// Load attendance data for selected class and date
  Future<void> _loadAttendanceData() async {
    if (_selectedClass.isEmpty) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // TODO: Load actual data from repository
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data - no existing attendance
      List<_StudentAttendance> students = [];
      bool attendanceExists = false;
      
      // If it's a past date, assume attendance exists
      if (_selectedDate.isBefore(DateTime.now())) {
        attendanceExists = true;
        
        // Mock data with attendance already taken
        students = [
          _StudentAttendance(
            id: '1',
            name: 'John Doe',
            status: AttendanceStatus.present,
          ),
          _StudentAttendance(
            id: '2',
            name: 'Jane Smith',
            status: AttendanceStatus.present,
          ),
          _StudentAttendance(
            id: '3',
            name: 'Michael Brown',
            status: AttendanceStatus.absent,
            reason: 'Sick',
          ),
          _StudentAttendance(
            id: '4',
            name: 'Emily Johnson',
            status: AttendanceStatus.late,
            reason: 'Traffic',
          ),
          _StudentAttendance(
            id: '5',
            name: 'David Williams',
            status: AttendanceStatus.excused,
            reason: 'Doctor appointment',
          ),
        ];
      } else {
        // Mock data with no attendance yet
        students = [
          _StudentAttendance(id: '1', name: 'John Doe'),
          _StudentAttendance(id: '2', name: 'Jane Smith'),
          _StudentAttendance(id: '3', name: 'Michael Brown'),
          _StudentAttendance(id: '4', name: 'Emily Johnson'),
          _StudentAttendance(id: '5', name: 'David Williams'),
        ];
      }
      
      setState(() {
        _students = students;
        _attendanceExists = attendanceExists;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading attendance data: $e';
        _isLoading = false;
      });
    }
  }
  
  /// Save attendance
  Future<void> _saveAttendance() async {
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });
    
    try {
      // TODO: Save actual data to repository
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _isSaving = false;
        _attendanceExists = true;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Attendance saved successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Error saving attendance data: $e';
        _isSaving = false;
      });
    }
  }

  /// Change attendance status for a student
  void _changeAttendanceStatus(int index, AttendanceStatus status) {
    setState(() {
      _students[index].status = status;
      
      // Clear reason if present
      if (status == AttendanceStatus.present) {
        _students[index].reason = null;
      }
    });
  }
  
  /// Show dialog to enter absence reason
  Future<void> _showReasonDialog(int index) async {
    // Only show for absent, late, or excused
    if (_students[index].status == AttendanceStatus.present) return;
    
    final TextEditingController controller = TextEditingController(
      text: _students[index].reason,
    );
    
    String title;
    switch (_students[index].status) {
      case AttendanceStatus.absent:
        title = 'Absence Reason';
        break;
      case AttendanceStatus.late:
        title = 'Late Reason';
        break;
      case AttendanceStatus.excused:
        title = 'Excuse Reason';
        break;
      default:
        title = 'Reason';
    }
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter reason',
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
                _students[index].reason = controller.text;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
  
  /// Show date picker
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      
      _loadAttendanceData();
    }
  }
  
  /// Get class name by ID (mock implementation)
  String _getClassNameById(String classId) {
    // TODO: Implement actual lookup from repository
    return _classes.first;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Attendance',
      ),
      body: Column(
        children: [
          // Class and date selection
          Container(
            padding: const EdgeInsets.all(16.0),
            color: theme.primaryColor.withOpacity(0.1),
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
                        _loadAttendanceData();
                      }
                    },
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
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                          const Icon(Icons.calendar_today, size: 16),
                        ],
                      ),
                    ),
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
          
          // Students list
          Expanded(
            child: LoadingContent(
              isLoading: _isLoading,
              loadingMessage: 'Loading students...',
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
                        return _buildStudentAttendanceItem(student, index);
                      },
                    ),
            ),
          ),
          
          // Save button
          if (_students.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              child: CustomButton(
                text: _attendanceExists ? 'Update Attendance' : 'Save Attendance',
                onPressed: _saveAttendance,
                isLoading: _isSaving,
                isFullWidth: true,
                icon: Icons.save,
              ),
            ),
        ],
      ),
    );
  }
  
  /// Build a student attendance item
  Widget _buildStudentAttendanceItem(_StudentAttendance student, int index) {
    final theme = Theme.of(context);
    final bool isEditable = !_attendanceExists || _selectedDate.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student name
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.primaryColor,
                  child: Text(
                    student.name.isNotEmpty ? student.name[0].toUpperCase() : 'S',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  student.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Attendance status buttons
            if (isEditable)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatusButton(
                    status: AttendanceStatus.present,
                    label: 'Present',
                    color: Colors.green,
                    icon: Icons.check_circle,
                    isSelected: student.status == AttendanceStatus.present,
                    onTap: () => _changeAttendanceStatus(index, AttendanceStatus.present),
                  ),
                  _buildStatusButton(
                    status: AttendanceStatus.absent,
                    label: 'Absent',
                    color: Colors.red,
                    icon: Icons.cancel,
                    isSelected: student.status == AttendanceStatus.absent,
                    onTap: () {
                      _changeAttendanceStatus(index, AttendanceStatus.absent);
                      _showReasonDialog(index);
                    },
                  ),
                  _buildStatusButton(
                    status: AttendanceStatus.late,
                    label: 'Late',
                    color: Colors.orange,
                    icon: Icons.access_time,
                    isSelected: student.status == AttendanceStatus.late,
                    onTap: () {
                      _changeAttendanceStatus(index, AttendanceStatus.late);
                      _showReasonDialog(index);
                    },
                  ),
                  _buildStatusButton(
                    status: AttendanceStatus.excused,
                    label: 'Excused',
                    color: Colors.purple,
                    icon: Icons.note_alt,
                    isSelected: student.status == AttendanceStatus.excused,
                    onTap: () {
                      _changeAttendanceStatus(index, AttendanceStatus.excused);
                      _showReasonDialog(index);
                    },
                  ),
                ],
              )
            else
              // Status display
              _buildStatusDisplay(student.status),
            
            // Reason (if applicable)
            if (student.reason != null && student.reason!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reason: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      student.reason!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  if (isEditable)
                    IconButton(
                      icon: const Icon(Icons.edit, size: 16),
                      onPressed: () => _showReasonDialog(index),
                      splashRadius: 20,
                      tooltip: 'Edit Reason',
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  /// Build a status button
  Widget _buildStatusButton({
    required AttendanceStatus status,
    required String label,
    required Color color,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.grey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build a status display
  Widget _buildStatusDisplay(AttendanceStatus status) {
    Color color;
    String label;
    IconData icon;
    
    switch (status) {
      case AttendanceStatus.present:
        color = Colors.green;
        label = 'Present';
        icon = Icons.check_circle;
        break;
      case AttendanceStatus.absent:
        color = Colors.red;
        label = 'Absent';
        icon = Icons.cancel;
        break;
      case AttendanceStatus.late:
        color = Colors.orange;
        label = 'Late';
        icon = Icons.access_time;
        break;
      case AttendanceStatus.excused:
        color = Colors.purple;
        label = 'Excused';
        icon = Icons.note_alt;
        break;
    }
    
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// Student attendance data model
class _StudentAttendance {
  final String id;
  final String name;
  AttendanceStatus status;
  String? reason;
  
  _StudentAttendance({
    required this.id,
    required this.name,
    this.status = AttendanceStatus.present,
    this.reason,
  });
}