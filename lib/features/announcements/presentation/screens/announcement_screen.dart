import 'package:flutter/material.dart';

/// Screen for viewing and managing school/class announcements
class AnnouncementScreen extends StatelessWidget {
  final String schoolId;
  final String classId;

  const AnnouncementScreen({
    Key? key,
    required this.schoolId,
    required this.classId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
      ),
      body: Center(
        child: Text('Announcements for School: $schoolId, Class: $classId'),
      ),
    );
  }
} 