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
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isBreak = schedule.subjectName == 'Break Time';

    // Use scaffold background for better contrast in dark mode
    final cardColor = isActive 
        ? schedule.color 
        : (isDark ? scheme.surface : Colors.transparent);
    
    // Ensure border has enough contrast
    final borderColor = isActive
        ? schedule.color.withValues(alpha: isDark ? 0.7 : 0.5)
        : (isDark ? scheme.outline.withValues(alpha: 0.5) : scheme.outlineVariant.withValues(alpha: 0.3));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: borderColor,
          width: isActive ? 2.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isActive 
                ? schedule.color 
                : (isDark ? scheme.surface : scheme.shadow))
                .withValues(alpha: isDark ? 0.25 : 0.32),
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
                      color: schedule.color.withValues(alpha: isDark ? 0.7 : 0.85),
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
                                color: schedule.color.withValues(alpha: isDark ? 0.25 : 0.16),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    schedule.icon,
                                    size: 14,
                                    color: schedule.color.withValues(alpha: isDark ? 0.9 : 1.0),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    isBreak ? 'Break' : 'Subject',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: schedule.color.withValues(alpha: isDark ? 0.9 : 1.0),
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
                                  color: const Color(0xFF27AE60).withValues(alpha: isDark ? 0.25 : 0.16),
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
                                      'LIVE',
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w700,
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
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isActive ? Colors.white : scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (!isBreak) ...[
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline_rounded,
                                size: 14,
                                color: isActive ? Colors.white70 : scheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                schedule.teacherName,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isActive ? Colors.white70 : scheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: isActive ? Colors.white70 : scheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                schedule.roomNumber,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isActive ? Colors.white70 : scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Icon(
                                Icons.restaurant_rounded,
                                size: 14,
                                color: schedule.color.withValues(alpha: isDark ? 0.7 : 0.85),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                schedule.roomNumber,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isActive ? Colors.white : scheme.onSurfaceVariant,
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
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                              color: isActive ? Colors.white70 : schedule.color.withValues(alpha: isDark ? 0.8 : 0.85),
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
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isActive ? Colors.white : scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Icon(
                        Icons.arrow_downward_rounded,
                        size: 14,
                        color: isActive ? Colors.white70 : scheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        schedule.timeRangeString.split(' - ').last,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isActive ? Colors.white70 : scheme.onSurfaceVariant,
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