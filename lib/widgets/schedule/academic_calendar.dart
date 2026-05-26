import 'package:flutter/material.dart';
import '../../models/class_schedule_model.dart';
import '../../services/schedule_service.dart';

class AcademicCalendar extends StatefulWidget {
  final ScheduleService scheduleService;

  const AcademicCalendar({
    required this.scheduleService,
    super.key,
  });

  @override
  State<AcademicCalendar> createState() => _AcademicCalendarState();
}

class _AcademicCalendarState extends State<AcademicCalendar> {
  late DateTime _currentMonth;
  late DateTime _selectedDate;
  final DateTime _today = DateTime(2026, 5, 26); // Anchor to mock current time context

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(2026, 5, 1);
    _selectedDate = _today;
  }

  // Days in month calculator
  int _daysInMonth(DateTime date) {
    var nextMonth = DateTime(date.year, date.month + 1, 1);
    return nextMonth.difference(DateTime(date.year, date.month, 1)).inDays;
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final year = _currentMonth.year;
    final month = _currentMonth.month;
    final daysCount = _daysInMonth(_currentMonth);
    final firstDayOfWeek = DateTime(year, month, 1).weekday % 7; // 0 = Sunday, 6 = Saturday

    // Generate calendar cell list
    final List<DateTime?> cells = [];
    for (int i = 0; i < firstDayOfWeek; i++) {
      cells.add(null);
    }
    for (int i = 1; i <= daysCount; i++) {
      cells.add(DateTime(year, month, i));
    }

    // Month Label
    final List<String> monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final monthLabel = '${monthNames[month - 1]} $year';

    // Get selected date events
    final selectedEvents = widget.scheduleService.getEventsForDate(_selectedDate);

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
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Section title + Nav Arrows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Academic Calendar',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF26364A),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded, color: Color(0xFF2F80ED)),
                      onPressed: _previousMonth,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      monthLabel,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2F80ED),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded, color: Color(0xFF2F80ED)),
                      onPressed: _nextMonth,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Days of the week row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                  .map((d) => SizedBox(
                        width: 32,
                        child: Text(
                          d,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF8696A8),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
            // Calendar Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cells.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
              ),
              itemBuilder: (context, index) {
                final date = cells[index];
                if (date == null) {
                  return const SizedBox.shrink();
                }

                final isSelected = date.year == _selectedDate.year &&
                    date.month == _selectedDate.month &&
                    date.day == _selectedDate.day;

                final isCurrentToday = date.year == _today.year &&
                    date.month == _today.month &&
                    date.day == _today.day;

                final dayEvents = widget.scheduleService.getEventsForDate(date);

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF2F80ED)
                          : (isCurrentToday
                              ? const Color(0xFF2F80ED).withValues(alpha: 0.1)
                              : Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isCurrentToday && !isSelected
                            ? const Color(0xFF2F80ED)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: isSelected || isCurrentToday
                                ? FontWeight.w800
                                : FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : (isCurrentToday
                                    ? const Color(0xFF2F80ED)
                                    : const Color(0xFF26364A)),
                          ),
                        ),
                        if (dayEvents.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: dayEvents.take(3).map((e) {
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 1),
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.white : e.color,
                                  shape: BoxShape.circle,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
            // Events list section below calendar if selected day has events
            if (selectedEvents.isNotEmpty) ...[
              const SizedBox(height: 18),
              const Divider(color: Color(0xFFE2EBF6), height: 1),
              const SizedBox(height: 14),
              const Text(
                'Schedule Events',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF26364A),
                ),
              ),
              const SizedBox(height: 8),
              ...selectedEvents.map((e) => _buildEventItem(e)),
            ] else ...[
              const SizedBox(height: 14),
              const Divider(color: Color(0xFFE2EBF6), height: 1),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Icon(Icons.calendar_today_rounded, size: 14, color: Color(0xFF8696A8)),
                  SizedBox(width: 6),
                  Text(
                    'No exams or holidays on this date.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8696A8),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEventItem(AcademicEvent event) {
    String typeLabel = 'Event';
    if (event.type == AcademicEventType.exam) typeLabel = 'Exam Schedule';
    if (event.type == AcademicEventType.holiday) typeLabel = 'School Holiday';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: event.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: event.color.withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: event.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(event.icon, color: event.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF26364A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  event.description,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF66778A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: event.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              typeLabel,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 8,
                fontWeight: FontWeight.w800,
                color: event.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
