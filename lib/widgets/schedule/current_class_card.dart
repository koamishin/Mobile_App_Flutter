import 'dart:async';
import 'package:flutter/material.dart';

import '../../models/class_schedule_model.dart';
import '../../services/schedule_service.dart';

class CurrentClassCard extends StatefulWidget {
  final ScheduleService scheduleService;

  const CurrentClassCard({
    required this.scheduleService,
    super.key,
  });

  @override
  State<CurrentClassCard> createState() => _CurrentClassCardState();
}

class _CurrentClassCardState extends State<CurrentClassCard> with SingleTickerProviderStateMixin {
  late Timer _timer;
  late DateTime _mockNow;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    // Anchor to May 26, 2026, 13:15:29 (Tue) and simulate real-time ticking
    _mockNow = DateTime(2026, 5, 26, 13, 15, 29);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _mockNow = _mockNow.add(const Duration(seconds: 1));
        });
      }
    });

    // Create custom pulsing glow controller for live indicator
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer.cancel();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentClass = widget.scheduleService.getCurrentClass(_mockNow);
    final upcomingClass = widget.scheduleService.getUpcomingClass(_mockNow);

    if (currentClass == null && upcomingClass == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'Current Session',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF27364A),
              ),
            ),
          ),
          currentClass != null
              ? _buildCurrentClassView(currentClass, upcomingClass)
              : _buildOnlyUpcomingView(upcomingClass!),
        ],
      ),
    );
  }

  Widget _buildCurrentClassView(ClassSchedule current, ClassSchedule? upcoming) {
    // Calculate remaining duration
    final endHour = current.endTime.hour;
    final endMin = current.endTime.minute;
    final endDateTime = DateTime(_mockNow.year, _mockNow.month, _mockNow.day, endHour, endMin);
    final difference = endDateTime.difference(_mockNow);
    final remainingMinutes = difference.inMinutes;
    final remainingSeconds = difference.inSeconds % 60;

    String countdownText;
    if (remainingMinutes > 60) {
      countdownText = '${remainingMinutes ~/ 60}h ${remainingMinutes % 60}m remaining';
    } else if (remainingMinutes > 0) {
      countdownText = '$remainingMinutes mins remaining';
    } else if (remainingSeconds > 0) {
      countdownText = '$remainingSeconds secs remaining';
    } else {
      countdownText = 'Ending now';
    }

    return ScaleTransition(
      scale: Tween<double>(begin: 0.99, end: 1.01).animate(
        CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2F80ED), Color(0xFF5DAEFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2F80ED).withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Status, Glow, Countdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFF27AE60),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'LIVE NOW',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      countdownText,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Subject Title
              Text(
                current.subjectName,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              // Metadata Row: Room, Teacher, Time
              Row(
                children: [
                  const Icon(Icons.school_rounded, color: Colors.white70, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${current.teacherName} • ${current.roomNumber}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.schedule_rounded, color: Colors.white70, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    current.timeRangeString,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              // Optional Next Class Card embedded
              if (upcoming != null) ...[
                const SizedBox(height: 18),
                const Divider(color: Colors.white30, height: 1, thickness: 1),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.next_plan_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'UP NEXT',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white70,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '${upcoming.subjectName} in ${upcoming.roomNumber}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      upcoming.startTime.format(context),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnlyUpcomingView(ClassSchedule upcoming) {
    return Container(
      width: double.infinity,
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F4FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'SCHOOL SESSIONS DONE',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF2F80ED),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              'No Active Classes Right Now',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xFF26364A),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'All classes for today are complete. Rest up and prepare for your next sessions.',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xFF66778A),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            const Divider(color: Color(0xFFE2EBF6), height: 1),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: upcoming.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(upcoming.icon, color: upcoming.color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NEXT UPCOMING SESSION',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFF66778A),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${upcoming.subjectName} (${upcoming.roomNumber})',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFF26364A),
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      upcoming.startTime.format(context),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: upcoming.color,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'Tomorrow',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xFF66778A),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
