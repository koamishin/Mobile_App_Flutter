import 'package:flutter/material.dart';
import '../../models/class_schedule_model.dart';

class ClassTile extends StatelessWidget {
  final ClassSchedule schedule;
  final VoidCallback? onTap;

  const ClassTile({
    required this.schedule,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isBreak = schedule.subjectName == 'Break Time';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: schedule.color.withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Subject Color Strip Indicator
              Container(
                width: 5,
                height: 38,
                decoration: BoxDecoration(
                  color: schedule.color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 12),
              // Subject Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.subjectName,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF26364A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isBreak
                          ? schedule.roomNumber
                          : '${schedule.teacherName} • ${schedule.roomNumber}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF66778A),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Time Duration
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    schedule.timeRangeString.split(' - ').first,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2F80ED),
                    ),
                  ),
                  Text(
                    schedule.timeRangeString.split(' - ').last,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF66778A),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
