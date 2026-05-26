import 'package:flutter/material.dart';

import '../../models/class_schedule_model.dart';
import '../../services/schedule_service.dart';
import 'schedule_card.dart';
import 'time_label.dart';

class DailyScheduleTimeline extends StatelessWidget {
  final List<ClassSchedule> classes;
  final ScheduleService scheduleService;

  const DailyScheduleTimeline({
    required this.classes,
    required this.scheduleService,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (classes.isEmpty) {
      return _buildEmptyState();
    }

    final mockNow = DateTime(2026, 5, 26, 13, 15, 29); // Consistent with current class
    final currentClass = scheduleService.getCurrentClass(mockNow);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Timeline Schedule',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF27364A),
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: classes.length,
          itemBuilder: (context, index) {
            final schedule = classes[index];
            final isActive = currentClass?.id == schedule.id;
            final isLast = index == classes.length - 1;

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Left Side: Schedule Card details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: ScheduleCard(
                        schedule: schedule,
                        isActive: isActive,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // 2. Middle-Right: Timeline Vertical Line & Connection Dot
                  Column(
                    children: [
                      // Top Line chunk
                      Container(
                        width: 3,
                        height: 24,
                        color: index == 0
                            ? Colors.transparent
                            : const Color(0xFF2F80ED).withValues(alpha: 0.3),
                      ),
                      // Dot Node
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFF27AE60) : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isActive ? Colors.white : schedule.color,
                            width: isActive ? 2.5 : 3,
                          ),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF27AE60).withValues(alpha: 0.5),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  )
                                ]
                              : null,
                        ),
                      ),
                      // Bottom Line chunk
                      Expanded(
                        child: Container(
                          width: 3,
                          color: isLast
                              ? Colors.transparent
                              : const Color(0xFF2F80ED).withValues(alpha: 0.3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  // 3. Right Side: Time Labels (Aligned to the start of the card)
                  Container(
                    width: 74,
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(top: 14),
                    child: TimeLabel(
                      time: _formatTimeOfDay(schedule.startTime),
                      isActive: isActive,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour == 12 ? 12 : time.hour % 12;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4B8BD6).withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: const [
          Icon(
            Icons.event_busy_rounded,
            size: 58,
            color: Color(0xFF8696A8),
          ),
          SizedBox(height: 14),
          Text(
            'No Classes Scheduled',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF26364A),
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Enjoy your free day! Relax or catch up on homework.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF66778A),
            ),
          ),
        ],
      ),
    );
  }
}
