import 'package:flutter/material.dart';
import '../../models/class_schedule_model.dart';

class ScheduleCard extends StatelessWidget {
  final ClassSchedule schedule;
  final bool isActive;
  final VoidCallback? onTap;

  const ScheduleCard({
    required this.schedule,
    this.isActive = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isBreak = schedule.subjectName == 'Break Time';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: isActive ? 0.95 : 0.82),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isActive ? schedule.color : Colors.transparent,
          width: isActive ? 2.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? schedule.color.withValues(alpha: 0.28)
                : const Color(0xFF4B8BD6).withValues(alpha: 0.08),
            blurRadius: isActive ? 22 : 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  // Left Accent Pill
                  Container(
                    width: 6,
                    height: 80,
                    decoration: BoxDecoration(
                      color: schedule.color,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: schedule.color.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(2, 0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Subject Icon & Information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: schedule.color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    schedule.icon,
                                    size: 14,
                                    color: schedule.color,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    isBreak ? 'Break' : 'Subject',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: schedule.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isActive) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF27AE60).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: Color(0xFF27AE60),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'LIVE NOW',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 9,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF27AE60),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          schedule.subjectName,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF26364A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (!isBreak) ...[
                          Row(
                            children: [
                              const Icon(
                                Icons.person_outline_rounded,
                                size: 14,
                                color: Color(0xFF66778A),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                schedule.teacherName,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF66778A),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: Color(0xFF66778A),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                schedule.roomNumber,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF66778A),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          Row(
                            children: [
                              const Icon(
                                Icons.restaurant_rounded,
                                size: 14,
                                color: Color(0xFF66778A),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                schedule.roomNumber,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF66778A),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (schedule.notes.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Note: ${schedule.notes}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                              color: schedule.color.withValues(alpha: 0.8),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Right Time info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        schedule.timeRangeString.split(' - ').first,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF26364A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Icon(
                        Icons.arrow_downward_rounded,
                        size: 14,
                        color: Color(0xFF8696A8),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        schedule.timeRangeString.split(' - ').last,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF66778A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
