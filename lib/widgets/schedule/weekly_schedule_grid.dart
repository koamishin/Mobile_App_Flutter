import 'package:flutter/material.dart';

import '../../models/class_schedule_model.dart';
import '../../services/schedule_service.dart';

class WeeklyScheduleGrid extends StatelessWidget {
  final ScheduleService scheduleService;

  const WeeklyScheduleGrid({
    required this.scheduleService,
    super.key,
  });

  static const double hourHeight = 68.0;
  static const double dayColumnWidth = 110.0;
  static const double timeColumnWidth = 64.0;
  static const double startHour = 8.0; // 8:00 AM
  static const double endHour = 17.0;  // 5:00 PM (9 hours total)

  @override
  Widget build(BuildContext context) {
    final mockNow = DateTime(2026, 5, 26, 13, 15, 29); // Tue May 26, 2026
    final currentDayOfWeek = mockNow.weekday; // Tuesday = 2
    final activeClass = scheduleService.getCurrentClass(mockNow);

    final days = [
      {'num': 1, 'label': 'Mon', 'date': '25'},
      {'num': 2, 'label': 'Tue', 'date': '26'},
      {'num': 3, 'label': 'Wed', 'date': '27'},
      {'num': 4, 'label': 'Thu', 'date': '28'},
      {'num': 5, 'label': 'Fri', 'date': '29'},
      {'num': 6, 'label': 'Sat', 'date': '30'},
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4B8BD6).withValues(alpha: 0.1),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header title
              const Padding(
                padding: EdgeInsets.fromLTRB(18, 18, 18, 10),
                child: Text(
                  'Weekly Timetable',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF26364A),
                  ),
                ),
              ),
              // Double scrollable grid
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Time Column
                      _buildTimeColumn(),
                      const VerticalDivider(width: 1, color: Color(0xFFE2EBF6)),
                      // 2. Day Columns
                      ...days.map((day) {
                        final isCurrentDay = day['num'] == currentDayOfWeek;
                        return Row(
                          children: [
                            _buildDayColumn(
                              context,
                              dayNum: day['num'] as int,
                              label: day['label'] as String,
                              date: day['date'] as String,
                              isCurrentDay: isCurrentDay,
                              activeClassId: activeClass?.id,
                            ),
                            const VerticalDivider(width: 1, color: Color(0xFFE2EBF6)),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Draw vertical column for hourly times on left
  Widget _buildTimeColumn() {
    return Container(
      width: timeColumnWidth,
      padding: const EdgeInsets.only(top: 50), // alignment below day headers
      child: Column(
        children: List.generate((endHour - startHour).toInt() + 1, (index) {
          final hour = startHour.toInt() + index;
          final period = hour >= 12 ? 'PM' : 'AM';
          final displayHour = hour > 12 ? hour - 12 : hour;

          return Container(
            height: hourHeight,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '$displayHour:00\n$period',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Color(0xFF8696A8),
                height: 1.2,
              ),
            ),
          );
        }),
      ),
    );
  }

  // Draw day column containing stack of classes
  Widget _buildDayColumn(
    BuildContext context, {
    required int dayNum,
    required String label,
    required String date,
    required bool isCurrentDay,
    required String? activeClassId,
  }) {
    final classes = scheduleService.getClassesForDay(dayNum);
    final totalGridHeight = (endHour - startHour) * hourHeight;

    return Container(
      width: dayColumnWidth,
      color: isCurrentDay ? const Color(0xFF2F80ED).withValues(alpha: 0.04) : Colors.transparent,
      child: Column(
        children: [
          // Day Column Header
          Container(
            height: 50,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isCurrentDay
                  ? const Color(0xFF2F80ED).withValues(alpha: 0.1)
                  : Colors.transparent,
              border: Border(
                bottom: BorderSide(
                  color: isCurrentDay ? const Color(0xFF2F80ED) : const Color(0xFFE2EBF6),
                  width: isCurrentDay ? 2 : 1,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: isCurrentDay ? FontWeight.w800 : FontWeight.w600,
                    color: isCurrentDay ? const Color(0xFF2F80ED) : const Color(0xFF66778A),
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isCurrentDay ? const Color(0xFF2F80ED) : const Color(0xFF26364A),
                  ),
                ),
              ],
            ),
          ),
          // Day grid area containing class blocks positioned inside a Stack
          Container(
            height: totalGridHeight + 20, // pad at the bottom
            child: Stack(
              clipBehavior: Clip.none,
              children: classes.map((c) {
                final top = (c.startDecimal - startHour) * hourHeight;
                final height = c.durationHours * hourHeight;
                final isActive = c.id == activeClassId;

                return Positioned(
                  top: top,
                  left: 4,
                  right: 4,
                  height: height - 4, // tiny bottom margin
                  child: _buildClassCell(context, c, isActive),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Singular grid cell for a class block
  Widget _buildClassCell(BuildContext context, ClassSchedule schedule, bool isActive) {
    final isBreak = schedule.subjectName == 'Break Time';

    return GestureDetector(
      onTap: () => _showClassDetailsSheet(context, schedule),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isActive ? schedule.color : schedule.color.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: schedule.color,
            width: isActive ? 2.5 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: schedule.color.withValues(alpha: 0.24),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      schedule.subjectName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: isActive ? Colors.white : const Color(0xFF26364A),
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                isBreak ? 'Cafeteria' : schedule.roomNumber,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: isActive ? Colors.white70 : const Color(0xFF66778A),
                ),
              ),
              Text(
                schedule.startTime.format(context),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 7.5,
                  fontWeight: FontWeight.w800,
                  color: isActive ? Colors.white : schedule.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Open details bottom sheet
  void _showClassDetailsSheet(BuildContext context, ClassSchedule schedule) {
    final isBreak = schedule.subjectName == 'Break Time';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top notch indicator
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2EBF6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              // Subject Title
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: schedule.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(schedule.icon, color: schedule.color, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          schedule.subjectName,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF26364A),
                          ),
                        ),
                        Text(
                          isBreak ? 'School Recess' : 'Official Course Session',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF66778A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              // Time and Duration
              _buildDetailRow(
                icon: Icons.access_time_rounded,
                title: 'Time & Duration',
                value: '${schedule.timeRangeString} (${schedule.durationHours} hrs)',
                color: schedule.color,
              ),
              if (!isBreak) ...[
                const SizedBox(height: 12),
                _buildDetailRow(
                  icon: Icons.person_rounded,
                  title: 'Subject Instructor',
                  value: schedule.teacherName,
                  color: schedule.color,
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  icon: Icons.location_on_rounded,
                  title: 'Class Room Number',
                  value: schedule.roomNumber,
                  color: schedule.color,
                ),
              ] else ...[
                const SizedBox(height: 12),
                _buildDetailRow(
                  icon: Icons.restaurant_rounded,
                  title: 'Location Venue',
                  value: schedule.roomNumber,
                  color: schedule.color,
                ),
              ],
              const SizedBox(height: 12),
              _buildDetailRow(
                icon: Icons.sticky_note_2_rounded,
                title: 'Session Note / Remarks',
                value: schedule.notes.isNotEmpty ? schedule.notes : 'No extra session notes added.',
                color: schedule.color,
              ),
              const SizedBox(height: 24),
              // Close Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F80ED),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Close Details',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF66778A)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF66778A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF26364A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
