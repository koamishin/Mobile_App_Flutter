import 'package:flutter/material.dart';

enum AcademicEventType {
  exam,
  holiday,
  schoolEvent,
}

class ClassSchedule {
  final String id;
  final String subjectName;
  final String teacherName;
  final String roomNumber;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int dayOfWeek; // 1 = Monday, 6 = Saturday
  final Color color;
  final IconData icon;
  final String notes;

  const ClassSchedule({
    required this.id,
    required this.subjectName,
    required this.teacherName,
    required this.roomNumber,
    required this.startTime,
    required this.endTime,
    required this.dayOfWeek,
    required this.color,
    required this.icon,
    required this.notes,
  });

  // Helper to format times elegantly
  String get timeRangeString {
    final startHour = startTime.hour == 12 ? 12 : startTime.hour % 12;
    final startPeriod = startTime.period == DayPeriod.am ? 'AM' : 'PM';
    final startMinute = startTime.minute.toString().padLeft(2, '0');

    final endHour = endTime.hour == 12 ? 12 : endTime.hour % 12;
    final endPeriod = endTime.period == DayPeriod.am ? 'AM' : 'PM';
    final endMinute = endTime.minute.toString().padLeft(2, '0');

    return '$startHour:$startMinute $startPeriod - $endHour:$endMinute $endPeriod';
  }

  // Returns exact double value representation for grid scheduling height calculations
  double get startDecimal => startTime.hour + startTime.minute / 60.0;
  double get endDecimal => endTime.hour + endTime.minute / 60.0;
  double get durationHours => endDecimal - startDecimal;
}

class AcademicEvent {
  final String id;
  final DateTime date;
  final String title;
  final String description;
  final AcademicEventType type;
  final IconData icon;
  final Color color;

  const AcademicEvent({
    required this.id,
    required this.date,
    required this.title,
    required this.description,
    required this.type,
    required this.icon,
    required this.color,
  });
}
