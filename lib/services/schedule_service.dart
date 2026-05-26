import 'package:flutter/material.dart';

import '../models/class_schedule_model.dart';
import '../models/schedule_model.dart';

class ScheduleService {
  // Hardcoded list of classes for the weekly schedule
  static const List<ClassSchedule> _allClasses = [
    // --- MONDAY (dayOfWeek = 1) ---
    ClassSchedule(
      id: 'mon1',
      subjectName: 'Mathematics',
      teacherName: 'Ms. Clara',
      roomNumber: 'Room 204',
      startTime: TimeOfDay(hour: 8, minute: 0),
      endTime: TimeOfDay(hour: 9, minute: 30),
      dayOfWeek: 1,
      color: Color(0xFF6D5DFB),
      icon: Icons.calculate_rounded,
      notes: 'Algebra review and quiz prep.',
    ),
    ClassSchedule(
      id: 'mon2',
      subjectName: 'Science Lab',
      teacherName: 'Ms. Clara',
      roomNumber: 'Lab 2',
      startTime: TimeOfDay(hour: 9, minute: 30),
      endTime: TimeOfDay(hour: 11, minute: 0),
      dayOfWeek: 1,
      color: Color(0xFFFF8E53),
      icon: Icons.science_rounded,
      notes: 'Bring safety goggles and lab notebooks.',
    ),
    ClassSchedule(
      id: 'mon_break',
      subjectName: 'Break Time',
      teacherName: 'N/A',
      roomNumber: 'Cafeteria',
      startTime: TimeOfDay(hour: 11, minute: 0),
      endTime: TimeOfDay(hour: 12, minute: 0),
      dayOfWeek: 1,
      color: Color(0xFFB0C4DE),
      icon: Icons.restaurant_rounded,
      notes: 'Recess and social interaction.',
    ),
    ClassSchedule(
      id: 'mon3',
      subjectName: 'English',
      teacherName: 'Mr. Santos',
      roomNumber: 'Room 118',
      startTime: TimeOfDay(hour: 13, minute: 0),
      endTime: TimeOfDay(hour: 14, minute: 30),
      dayOfWeek: 1,
      color: Color(0xFF2F80ED),
      icon: Icons.menu_book_rounded,
      notes: 'Group presentation on literature essays.',
    ),
    ClassSchedule(
      id: 'mon4',
      subjectName: 'History',
      teacherName: 'Ms. Davis',
      roomNumber: 'Room 305',
      startTime: TimeOfDay(hour: 14, minute: 30),
      endTime: TimeOfDay(hour: 15, minute: 30),
      dayOfWeek: 1,
      color: Color(0xFF32A89D),
      icon: Icons.history_edu_rounded,
      notes: 'WWII pacific theater checkpoint.',
    ),
    ClassSchedule(
      id: 'mon5',
      subjectName: 'Robotics Club',
      teacherName: 'Mr. Alex',
      roomNumber: 'Makerspace',
      startTime: TimeOfDay(hour: 15, minute: 30),
      endTime: TimeOfDay(hour: 17, minute: 0),
      dayOfWeek: 1,
      color: Color(0xFF51B3AA),
      icon: Icons.smart_toy_rounded,
      notes: 'Competition robot chassis assembly.',
    ),

    // --- TUESDAY (dayOfWeek = 2) ---
    ClassSchedule(
      id: 'tue1',
      subjectName: 'Programming',
      teacherName: 'Mr. Santos',
      roomNumber: 'Lab 3',
      startTime: TimeOfDay(hour: 8, minute: 0),
      endTime: TimeOfDay(hour: 9, minute: 30),
      dayOfWeek: 2,
      color: Color(0xFF5DAEFF),
      icon: Icons.computer_rounded,
      notes: 'Intro to Dart syntax and variables.',
    ),
    ClassSchedule(
      id: 'tue2',
      subjectName: 'Mathematics',
      teacherName: 'Ms. Clara',
      roomNumber: 'Room 204',
      startTime: TimeOfDay(hour: 9, minute: 30),
      endTime: TimeOfDay(hour: 11, minute: 0),
      dayOfWeek: 2,
      color: Color(0xFF6D5DFB),
      icon: Icons.calculate_rounded,
      notes: 'Equations and linear graphs.',
    ),
    ClassSchedule(
      id: 'tue_break',
      subjectName: 'Break Time',
      teacherName: 'N/A',
      roomNumber: 'Cafeteria',
      startTime: TimeOfDay(hour: 11, minute: 0),
      endTime: TimeOfDay(hour: 12, minute: 0),
      dayOfWeek: 2,
      color: Color(0xFFB0C4DE),
      icon: Icons.restaurant_rounded,
      notes: 'Recess.',
    ),
    ClassSchedule(
      id: 'tue3',
      subjectName: 'Science Lab',
      teacherName: 'Ms. Clara',
      roomNumber: 'Lab 2',
      startTime: TimeOfDay(hour: 13, minute: 0),
      endTime: TimeOfDay(hour: 14, minute: 30),
      dayOfWeek: 2,
      color: Color(0xFFFF8E53),
      icon: Icons.science_rounded,
      notes: 'Chemical reactions practical test.',
    ),
    ClassSchedule(
      id: 'tue4',
      subjectName: 'Physical Education',
      teacherName: 'Mr. Carter',
      roomNumber: 'Gymnasium',
      startTime: TimeOfDay(hour: 14, minute: 30),
      endTime: TimeOfDay(hour: 16, minute: 0),
      dayOfWeek: 2,
      color: Color(0xFFF77E4E),
      icon: Icons.sports_basketball_rounded,
      notes: 'Basketball drills and defensive stances.',
    ),

    // --- WEDNESDAY (dayOfWeek = 3) ---
    ClassSchedule(
      id: 'wed1',
      subjectName: 'English',
      teacherName: 'Mr. Santos',
      roomNumber: 'Room 118',
      startTime: TimeOfDay(hour: 8, minute: 0),
      endTime: TimeOfDay(hour: 9, minute: 30),
      dayOfWeek: 3,
      color: Color(0xFF2F80ED),
      icon: Icons.menu_book_rounded,
      notes: 'Creative writing critiques.',
    ),
    ClassSchedule(
      id: 'wed2',
      subjectName: 'History',
      teacherName: 'Ms. Davis',
      roomNumber: 'Room 305',
      startTime: TimeOfDay(hour: 9, minute: 30),
      endTime: TimeOfDay(hour: 11, minute: 0),
      dayOfWeek: 3,
      color: Color(0xFF32A89D),
      icon: Icons.history_edu_rounded,
      notes: 'Discussion on historical narratives.',
    ),
    ClassSchedule(
      id: 'wed_break',
      subjectName: 'Break Time',
      teacherName: 'N/A',
      roomNumber: 'Cafeteria',
      startTime: TimeOfDay(hour: 11, minute: 0),
      endTime: TimeOfDay(hour: 12, minute: 0),
      dayOfWeek: 3,
      color: Color(0xFFB0C4DE),
      icon: Icons.restaurant_rounded,
      notes: 'Recess.',
    ),
    ClassSchedule(
      id: 'wed3',
      subjectName: 'Programming',
      teacherName: 'Mr. Santos',
      roomNumber: 'Lab 3',
      startTime: TimeOfDay(hour: 13, minute: 0),
      endTime: TimeOfDay(hour: 15, minute: 0),
      dayOfWeek: 3,
      color: Color(0xFF5DAEFF),
      icon: Icons.computer_rounded,
      notes: 'Flutter UI basics, widgets, layout.',
    ),
    ClassSchedule(
      id: 'wed4',
      subjectName: 'Robotics Club',
      teacherName: 'Mr. Alex',
      roomNumber: 'Makerspace',
      startTime: TimeOfDay(hour: 15, minute: 0),
      endTime: TimeOfDay(hour: 16, minute: 30),
      dayOfWeek: 3,
      color: Color(0xFF51B3AA),
      icon: Icons.smart_toy_rounded,
      notes: 'Sensor calibration and code deployment.',
    ),

    // --- THURSDAY (dayOfWeek = 4) ---
    ClassSchedule(
      id: 'thu1',
      subjectName: 'Mathematics',
      teacherName: 'Ms. Clara',
      roomNumber: 'Room 204',
      startTime: TimeOfDay(hour: 8, minute: 0),
      endTime: TimeOfDay(hour: 9, minute: 30),
      dayOfWeek: 4,
      color: Color(0xFF6D5DFB),
      icon: Icons.calculate_rounded,
      notes: 'Functions and calculus primer.',
    ),
    ClassSchedule(
      id: 'thu2',
      subjectName: 'Science Lab',
      teacherName: 'Ms. Clara',
      roomNumber: 'Lab 2',
      startTime: TimeOfDay(hour: 9, minute: 30),
      endTime: TimeOfDay(hour: 11, minute: 0),
      dayOfWeek: 4,
      color: Color(0xFFFF8E53),
      icon: Icons.science_rounded,
      notes: 'Physics: electromagnetic experiments.',
    ),
    ClassSchedule(
      id: 'thu_break',
      subjectName: 'Break Time',
      teacherName: 'N/A',
      roomNumber: 'Cafeteria',
      startTime: TimeOfDay(hour: 11, minute: 0),
      endTime: TimeOfDay(hour: 12, minute: 0),
      dayOfWeek: 4,
      color: Color(0xFFB0C4DE),
      icon: Icons.restaurant_rounded,
      notes: 'Recess.',
    ),
    ClassSchedule(
      id: 'thu3',
      subjectName: 'English',
      teacherName: 'Mr. Santos',
      roomNumber: 'Room 118',
      startTime: TimeOfDay(hour: 13, minute: 0),
      endTime: TimeOfDay(hour: 14, minute: 30),
      dayOfWeek: 4,
      color: Color(0xFF2F80ED),
      icon: Icons.menu_book_rounded,
      notes: 'Grammar structure and essay outline peer reviews.',
    ),
    ClassSchedule(
      id: 'thu4',
      subjectName: 'History',
      teacherName: 'Ms. Davis',
      roomNumber: 'Room 305',
      startTime: TimeOfDay(hour: 14, minute: 30),
      endTime: TimeOfDay(hour: 16, minute: 0),
      dayOfWeek: 4,
      color: Color(0xFF32A89D),
      icon: Icons.history_edu_rounded,
      notes: 'Interactive history map quiz.',
    ),

    // --- FRIDAY (dayOfWeek = 5) ---
    ClassSchedule(
      id: 'fri1',
      subjectName: 'Programming',
      teacherName: 'Mr. Santos',
      roomNumber: 'Lab 3',
      startTime: TimeOfDay(hour: 8, minute: 0),
      endTime: TimeOfDay(hour: 9, minute: 30),
      dayOfWeek: 5,
      color: Color(0xFF5DAEFF),
      icon: Icons.computer_rounded,
      notes: 'Finalizing class programming projects.',
    ),
    ClassSchedule(
      id: 'fri2',
      subjectName: 'Physical Education',
      teacherName: 'Mr. Carter',
      roomNumber: 'Gymnasium',
      startTime: TimeOfDay(hour: 9, minute: 30),
      endTime: TimeOfDay(hour: 11, minute: 0),
      dayOfWeek: 5,
      color: Color(0xFFF77E4E),
      icon: Icons.sports_basketball_rounded,
      notes: 'Fun volleyball tournament.',
    ),
    ClassSchedule(
      id: 'fri_break',
      subjectName: 'Break Time',
      teacherName: 'N/A',
      roomNumber: 'Cafeteria',
      startTime: TimeOfDay(hour: 11, minute: 0),
      endTime: TimeOfDay(hour: 12, minute: 0),
      dayOfWeek: 5,
      color: Color(0xFFB0C4DE),
      icon: Icons.restaurant_rounded,
      notes: 'Recess.',
    ),
    ClassSchedule(
      id: 'fri3',
      subjectName: 'Mathematics',
      teacherName: 'Ms. Clara',
      roomNumber: 'Room 204',
      startTime: TimeOfDay(hour: 13, minute: 0),
      endTime: TimeOfDay(hour: 14, minute: 30),
      dayOfWeek: 5,
      color: Color(0xFF6D5DFB),
      icon: Icons.calculate_rounded,
      notes: 'Problem solving competition.',
    ),
    ClassSchedule(
      id: 'fri4',
      subjectName: 'Robotics Club',
      teacherName: 'Mr. Alex',
      roomNumber: 'Makerspace',
      startTime: TimeOfDay(hour: 14, minute: 30),
      endTime: TimeOfDay(hour: 16, minute: 0),
      dayOfWeek: 5,
      color: Color(0xFF51B3AA),
      icon: Icons.smart_toy_rounded,
      notes: 'Test runs on the school track.',
    ),

    // --- SATURDAY (dayOfWeek = 6) ---
    ClassSchedule(
      id: 'sat1',
      subjectName: 'Robotics Club',
      teacherName: 'Mr. Alex',
      roomNumber: 'Makerspace',
      startTime: TimeOfDay(hour: 8, minute: 0),
      endTime: TimeOfDay(hour: 10, minute: 30),
      dayOfWeek: 6,
      color: Color(0xFF51B3AA),
      icon: Icons.smart_toy_rounded,
      notes: 'Special design thinking workshop.',
    ),
    ClassSchedule(
      id: 'sat2',
      subjectName: 'Programming',
      teacherName: 'Mr. Santos',
      roomNumber: 'Lab 3',
      startTime: TimeOfDay(hour: 10, minute: 30),
      endTime: TimeOfDay(hour: 12, minute: 0),
      dayOfWeek: 6,
      color: Color(0xFF5DAEFF),
      icon: Icons.computer_rounded,
      notes: 'Hackathon preparation and brainstorming.',
    ),
  ];

  // Hardcoded academic calendar events (centered around May/June 2026 for demonstration)
  static final List<AcademicEvent> _academicEvents = [
    AcademicEvent(
      id: 'ev1',
      date: DateTime(2026, 5, 20),
      title: 'Science Fair Project Due',
      description: 'Submit lab journals and project posters to the science wing.',
      type: AcademicEventType.schoolEvent,
      icon: Icons.workspace_premium_rounded,
      color: const Color(0xFF32A89D),
    ),
    AcademicEvent(
      id: 'ev2',
      date: DateTime(2026, 5, 22),
      title: 'Mathematics Term Exam',
      description: 'Comprehensive exam covering algebra, calculus, and functions.',
      type: AcademicEventType.exam,
      icon: Icons.quiz_rounded,
      color: const Color(0xFF6D5DFB),
    ),
    AcademicEvent(
      id: 'ev3',
      date: DateTime(2026, 5, 25),
      title: 'Memorial Day Holiday',
      description: 'National Holiday - School closed. No classes.',
      type: AcademicEventType.holiday,
      icon: Icons.gavel_rounded,
      color: const Color(0xFFEB5757),
    ),
    AcademicEvent(
      id: 'ev4',
      date: DateTime(2026, 5, 28),
      title: 'Robotics Competition Prep',
      description: 'Final sensor testing and code freeze for regional qualifiers.',
      type: AcademicEventType.schoolEvent,
      icon: Icons.precision_manufacturing_rounded,
      color: const Color(0xFF51B3AA),
    ),
    AcademicEvent(
      id: 'ev5',
      date: DateTime(2026, 6, 2),
      title: 'Computer Science Lab Exam',
      description: 'Programming assessment: write and build an app layout.',
      type: AcademicEventType.exam,
      icon: Icons.computer_rounded,
      color: const Color(0xFF5DAEFF),
    ),
    AcademicEvent(
      id: 'ev6',
      date: DateTime(2026, 6, 5),
      title: 'Tuition Payment Due',
      description: 'Tuition installment due in balance sheet (\$1,450).',
      type: AcademicEventType.schoolEvent,
      icon: Icons.payment_rounded,
      color: const Color(0xFFFF8E53),
    ),
  ];

  // Retrieve classes for a specific day of the week
  List<ClassSchedule> getClassesForDay(int dayOfWeek) {
    return _allClasses.where((c) => c.dayOfWeek == dayOfWeek).toList()
      ..sort((a, b) => a.startDecimal.compareTo(b.startDecimal));
  }

  // Get currently active class based on custom date time
  ClassSchedule? getCurrentClass(DateTime dateTime) {
    final dayOfWeek = dateTime.weekday;
    final time = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    final double currentDecimal = time.hour + time.minute / 60.0;

    final classesToday = getClassesForDay(dayOfWeek);
    for (final c in classesToday) {
      if (currentDecimal >= c.startDecimal && currentDecimal < c.endDecimal) {
        // Skip break times from "current class" calculations if desired, but we can return it as well.
        if (c.subjectName == 'Break Time') continue;
        return c;
      }
    }
    return null;
  }

  // Get next upcoming class of the day
  ClassSchedule? getUpcomingClass(DateTime dateTime) {
    final dayOfWeek = dateTime.weekday;
    final time = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    final double currentDecimal = time.hour + time.minute / 60.0;

    final classesToday = getClassesForDay(dayOfWeek);
    for (final c in classesToday) {
      if (c.startDecimal > currentDecimal) {
        if (c.subjectName == 'Break Time') continue;
        return c;
      }
    }
    // If no more classes today, get the first class of the next school day (or Monday if Sat afternoon)
    int nextDay = dayOfWeek + 1;
    if (nextDay > 6) nextDay = 1; // Wrap to Monday
    int iterations = 0;
    while (iterations < 7) {
      final nextDayClasses = getClassesForDay(nextDay).where((c) => c.subjectName != 'Break Time').toList();
      if (nextDayClasses.isNotEmpty) {
        return nextDayClasses.first;
      }
      nextDay = nextDay + 1;
      if (nextDay > 6) nextDay = 1;
      iterations++;
    }
    return null;
  }

  // Calculate statistics for a given day
  ScheduleStatistics getScheduleStatistics(int dayOfWeek) {
    final classes = getClassesForDay(dayOfWeek);
    final schoolClasses = classes.where((c) => c.subjectName != 'Break Time').toList();

    int totalClasses = schoolClasses.length;
    double totalHours = schoolClasses.fold(0.0, (sum, c) => sum + c.durationHours);

    // Calculate free periods (gaps in timeline from 8 AM to 5 PM)
    int freePeriods = 0;
    if (classes.isEmpty) {
      freePeriods = 9; // Full day 8 AM - 5 PM is free (9 hours)
    } else {
      // Any hour between 8:00 AM and 5:00 PM without class
      // Let's count "Break Time" as free period, and any hours before/after scheduled times.
      final breakClasses = classes.where((c) => c.subjectName == 'Break Time').length;
      freePeriods = breakClasses;

      // Add gaps
      double startSchool = 8.0;
      double endSchool = 17.0;
      double scheduledTime = classes.fold(0.0, (sum, c) => sum + c.durationHours);
      double gapHours = (endSchool - startSchool) - scheduledTime;
      if (gapHours > 0) {
        freePeriods += gapHours.round();
      }
    }

    // Determine the most frequent subject overall in the week
    final Map<String, int> counts = {};
    for (final c in _allClasses) {
      if (c.subjectName == 'Break Time') continue;
      counts[c.subjectName] = (counts[c.subjectName] ?? 0) + 1;
    }
    String mostFrequent = 'None';
    int maxCount = 0;
    counts.forEach((subject, count) {
      if (count > maxCount) {
        maxCount = count;
        mostFrequent = subject;
      }
    });

    return ScheduleStatistics(
      totalClasses: totalClasses,
      freePeriods: freePeriods,
      totalHours: totalHours,
      mostFrequentSubject: mostFrequent,
    );
  }

  // Fetch academic calendar events for a specific date
  List<AcademicEvent> getEventsForDate(DateTime date) {
    return _academicEvents.where((e) {
      return e.date.year == date.year &&
             e.date.month == date.month &&
             e.date.day == date.day;
    }).toList();
  }

  // Fetch events in a specific month
  List<AcademicEvent> getEventsForMonth(DateTime date) {
    return _academicEvents.where((e) {
      return e.date.year == date.year && e.date.month == date.month;
    }).toList();
  }
}
