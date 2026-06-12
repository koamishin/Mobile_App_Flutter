import 'package:flutter/material.dart';

import '../widgets/page_components.dart';
import '../../models/class_schedule_model.dart';
import '../../services/schedule_service.dart';
import '../../widgets/schedule/academic_calendar.dart';
import '../../widgets/schedule/current_class_card.dart';
import '../../widgets/schedule/daily_schedule_timeline.dart';
import '../../widgets/schedule/schedule_summary_card.dart';
import '../../widgets/schedule/subject_progress_indicator.dart';
import '../../widgets/schedule/weekly_day_selector.dart';
import '../../widgets/schedule/weekly_schedule_grid.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final ScheduleService _scheduleService = ScheduleService();
  int _selectedDayOfWeek =
      2; // Default to Tuesday in mock context (May 26, 2026)
  int _currentTab = 0; // 0 = Daily View, 1 = Weekly Grid View

  @override
  Widget build(BuildContext context) {
    final classesToday = _scheduleService.getClassesForDay(_selectedDayOfWeek);
    final statsToday = _scheduleService.getScheduleStatistics(
      _selectedDayOfWeek,
    );

    return StudentPageScaffold(
      title: 'Class Schedule',
      subtitle: 'Easily track daily classes, schedules, and exams.',
      icon: Icons.calendar_month_rounded,
      children: [
        // 1. Premium Sliding View Switcher Tabs
        _buildViewSwitcher(),
        const SizedBox(height: 18),

        // 2. Tab-dependent Content with Cross-fade transition
        AnimatedCrossFade(
          firstChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Horizontal Weekly Navigator
              WeeklyDaySelector(
                selectedDayOfWeek: _selectedDayOfWeek,
                onDaySelected: (day) {
                  setState(() {
                    _selectedDayOfWeek = day;
                  });
                },
              ),
              // Current Session Card
              CurrentClassCard(scheduleService: _scheduleService),
              // Daily Schedule Timeline
              DailyScheduleTimeline(
                classes: classesToday,
                scheduleService: _scheduleService,
              ),
              const SizedBox(height: 22),
              // Daily Summary
              ScheduleSummaryCard(stats: statsToday),
              // Calendar event checker
              AcademicCalendar(scheduleService: _scheduleService),
              // Subject Progress Indicators
              _buildSubjectProgressSection(),
            ],
          ),
          secondChild: WeeklyScheduleGrid(scheduleService: _scheduleService),
          crossFadeState: _currentTab == 0
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }

  Widget _buildViewSwitcher() {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: scheme.primary.withValues(alpha: 0.12),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentTab = 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: _currentTab == 0
                      ? LinearGradient(
                          colors: [scheme.primary, scheme.tertiary],
                        )
                      : null,
                  color: _currentTab == 0 ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _currentTab == 0
                      ? [
                          BoxShadow(
                            color: scheme.primary.withValues(alpha: 0.24),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  'Daily Timeline',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: _currentTab == 0
                        ? scheme.onPrimary
                        : scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentTab = 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: _currentTab == 1
                      ? LinearGradient(
                          colors: [scheme.primary, scheme.tertiary],
                        )
                      : null,
                  color: _currentTab == 1 ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _currentTab == 1
                      ? [
                          BoxShadow(
                            color: scheme.primary.withValues(alpha: 0.24),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  'Weekly Timetable',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: _currentTab == 1
                        ? scheme.onPrimary
                        : scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectProgressSection() {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12, top: 12),
          child: Text(
            'Subject Progress',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
            ),
          ),
        ),
        const SubjectProgressIndicator(
          subjectName: 'Programming',
          progress: 0.94,
          color: Color(0xFF5DAEFF),
          icon: Icons.computer_rounded,
          statusText: '15/16 lectures complete • Midterm passed',
        ),
        const SubjectProgressIndicator(
          subjectName: 'Mathematics',
          progress: 0.82,
          color: Color(0xFF6D5DFB),
          icon: Icons.calculate_rounded,
          statusText: '13/16 lectures complete • Exam complete',
        ),
        const SubjectProgressIndicator(
          subjectName: 'English',
          progress: 0.75,
          color: Color(0xFF2F80ED),
          icon: Icons.menu_book_rounded,
          statusText: '12/16 lectures complete • Essay draft done',
        ),
        const SubjectProgressIndicator(
          subjectName: 'Science Lab',
          progress: 0.68,
          color: Color(0xFFFF8E53),
          icon: Icons.science_rounded,
          statusText: '11/16 lectures complete • 3 lab reports complete',
        ),
        const SubjectProgressIndicator(
          subjectName: 'History',
          progress: 0.56,
          color: Color(0xFF32A89D),
          icon: Icons.history_edu_rounded,
          statusText: '9/16 lectures complete • Mapping project due',
        ),
        const SubjectProgressIndicator(
          subjectName: 'Robotics Club',
          progress: 0.88,
          color: Color(0xFF51B3AA),
          icon: Icons.smart_toy_rounded,
          statusText: '14/16 sessions complete • Chassis complete',
        ),
      ],
    );
  }
}
