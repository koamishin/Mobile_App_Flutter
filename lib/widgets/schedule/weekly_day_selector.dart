import 'package:flutter/material.dart';

class WeeklyDaySelector extends StatelessWidget {
  final int selectedDayOfWeek; // 1 = Monday, 6 = Saturday
  final ValueChanged<int> onDaySelected;

  const WeeklyDaySelector({
    required this.selectedDayOfWeek,
    required this.onDaySelected,
    super.key,
  });

  // Mock mapping of weekday to date and classes info for the week of May 25 - May 30, 2026
  static const List<Map<String, dynamic>> _daysInfo = [
    {
      'dayNum': 1,
      'name': 'Mon',
      'date': '25',
      'indicator': '5 Subj',
    },
    {
      'dayNum': 2,
      'name': 'Tue',
      'date': '26', // Current day in mock context
      'indicator': '4 Subj',
    },
    {
      'dayNum': 3,
      'name': 'Wed',
      'date': '27',
      'indicator': '4 Subj',
    },
    {
      'dayNum': 4,
      'name': 'Thu',
      'date': '28',
      'indicator': '4 Subj',
    },
    {
      'dayNum': 5,
      'name': 'Fri',
      'date': '29',
      'indicator': '4 Subj',
    },
    {
      'dayNum': 6,
      'name': 'Sat',
      'date': '30',
      'indicator': '2 Subj',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 98,
      margin: const EdgeInsets.only(bottom: 18),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _daysInfo.length,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        itemBuilder: (context, index) {
          final info = _daysInfo[index];
          final dayNum = info['dayNum'] as int;
          final isSelected = dayNum == selectedDayOfWeek;
          final isToday = dayNum == 2; // Tue May 26 is today in mock

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.only(right: 12),
            width: 78,
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [scheme.primary, scheme.tertiary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : scheme.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : (isToday
                        ? scheme.primary.withValues(alpha: 0.6)
                        : Colors.transparent),
                width: isToday ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? scheme.primary.withValues(alpha: 0.35)
                      : scheme.shadow.withValues(alpha: 0.12),
                  blurRadius: isSelected ? 16 : 10,
                  offset: isSelected ? const Offset(0, 6) : const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onDaySelected(dayNum),
                borderRadius: BorderRadius.circular(22),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Day Name (e.g. Mon)
                      Text(
                        info['name'] as String,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: isSelected
                              ? scheme.onPrimary
                              : (isToday
                                  ? scheme.primary
                                  : scheme.onSurfaceVariant),
                        ),
                      ),
                      // Date Number (e.g. 26)
                      Text(
                        info['date'] as String,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: isSelected ? scheme.onPrimary : scheme.onSurface,
                        ),
                      ),
                      // Indicator chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.22)
                              : scheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          info['indicator'] as String,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            color: isSelected
                                ? scheme.onPrimary
                                : scheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
