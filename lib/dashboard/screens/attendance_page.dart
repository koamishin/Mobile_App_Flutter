import 'package:flutter/material.dart';

import '../widgets/page_components.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late DateTime _selectedDate;

  // Mock Attendance records for May 2026
  final Map<DateTime, AttendanceRecord> _attendanceRecords = {
    DateTime(2026, 5, 20): const AttendanceRecord(
      status: AttendanceStatus.present,
      checkInTime: '7:42 AM',
      remarks: 'On Time',
      classes: [
        ClassCheckIn(
          className: 'Algebra',
          status: 'Present',
          time: '7:55 AM',
          isUpcoming: false,
        ),
        ClassCheckIn(
          className: 'Biology',
          status: 'Present',
          time: '9:35 AM',
          isUpcoming: false,
        ),
        ClassCheckIn(
          className: 'Literature',
          status: 'Present',
          time: '11:05 AM',
          isUpcoming: false,
        ),
      ],
    ),
    DateTime(2026, 5, 21): const AttendanceRecord(
      status: AttendanceStatus.present,
      checkInTime: '7:48 AM',
      remarks: 'On Time',
      classes: [
        ClassCheckIn(
          className: 'Geometry',
          status: 'Present',
          time: '7:50 AM',
          isUpcoming: false,
        ),
        ClassCheckIn(
          className: 'Chemistry',
          status: 'Present',
          time: '9:30 AM',
          isUpcoming: false,
        ),
        ClassCheckIn(
          className: 'Composition',
          status: 'Present',
          time: '11:15 AM',
          isUpcoming: false,
        ),
      ],
    ),
    DateTime(2026, 5, 22): const AttendanceRecord(
      status: AttendanceStatus.excused,
      checkInTime: '--',
      remarks: 'Excused - Family Event',
      classes: [
        ClassCheckIn(
          className: 'Algebra',
          status: 'Excused',
          time: '--',
          isUpcoming: false,
        ),
        ClassCheckIn(
          className: 'Biology',
          status: 'Excused',
          time: '--',
          isUpcoming: false,
        ),
      ],
    ),
    DateTime(2026, 5, 23): const AttendanceRecord(
      status: AttendanceStatus.noClass,
      checkInTime: '--',
      remarks: 'Weekend - No Class',
      classes: [],
    ),
    DateTime(2026, 5, 24): const AttendanceRecord(
      status: AttendanceStatus.noClass,
      checkInTime: '--',
      remarks: 'Weekend - No Class',
      classes: [],
    ),
    DateTime(2026, 5, 25): const AttendanceRecord(
      status: AttendanceStatus.late,
      checkInTime: '8:15 AM',
      remarks: 'Late - Heavy Traffic',
      classes: [
        ClassCheckIn(
          className: 'Mathematics',
          status: 'Late',
          time: '8:15 AM',
          isUpcoming: false,
        ),
        ClassCheckIn(
          className: 'Science Lab',
          status: 'Present',
          time: '9:40 AM',
          isUpcoming: false,
        ),
        ClassCheckIn(
          className: 'English',
          status: 'Present',
          time: '11:00 AM',
          isUpcoming: false,
        ),
      ],
    ),
    DateTime(2026, 5, 26): const AttendanceRecord(
      status: AttendanceStatus.present,
      checkInTime: '7:58 AM',
      remarks: 'On Time',
      classes: [
        ClassCheckIn(
          className: 'Mathematics',
          status: 'Present',
          time: '7:58 AM',
          isUpcoming: false,
        ),
        ClassCheckIn(
          className: 'Science Lab',
          status: 'Present',
          time: '9:31 AM',
          isUpcoming: false,
        ),
        ClassCheckIn(
          className: 'Physical Education',
          status: 'Upcoming',
          time: '2:00 PM',
          isUpcoming: true,
        ),
      ],
    ),
    DateTime(2026, 5, 27): const AttendanceRecord(
      status: AttendanceStatus.present,
      checkInTime: '7:35 AM',
      remarks: 'On Time',
      classes: [
        ClassCheckIn(
          className: 'Geometry',
          status: 'Present',
          time: '7:40 AM',
          isUpcoming: false,
        ),
        ClassCheckIn(
          className: 'Chemistry',
          status: 'Present',
          time: '9:25 AM',
          isUpcoming: false,
        ),
        ClassCheckIn(
          className: 'Computer Science',
          status: 'Upcoming',
          time: '1:30 PM',
          isUpcoming: true,
        ),
      ],
    ),
    DateTime(2026, 5, 28): const AttendanceRecord(
      status: AttendanceStatus.absent,
      checkInTime: '--',
      remarks: 'Absent - Medical Leave',
      classes: [
        ClassCheckIn(
          className: 'Mathematics',
          status: 'Absent',
          time: '--',
          isUpcoming: false,
        ),
        ClassCheckIn(
          className: 'Science Lab',
          status: 'Absent',
          time: '--',
          isUpcoming: false,
        ),
        ClassCheckIn(
          className: 'English',
          status: 'Absent',
          time: '--',
          isUpcoming: false,
        ),
      ],
    ),
    DateTime(2026, 5, 29): const AttendanceRecord(
      status: AttendanceStatus.present,
      checkInTime: '7:44 AM',
      remarks: 'On Time',
      classes: [
        ClassCheckIn(
          className: 'Geometry',
          status: 'Present',
          time: '7:50 AM',
          isUpcoming: false,
        ),
        ClassCheckIn(
          className: 'Composition',
          status: 'Present',
          time: '9:30 AM',
          isUpcoming: false,
        ),
        ClassCheckIn(
          className: 'Computer Science',
          status: 'Upcoming',
          time: '1:30 PM',
          isUpcoming: true,
        ),
      ],
    ),
    DateTime(2026, 5, 30): const AttendanceRecord(
      status: AttendanceStatus.noClass,
      checkInTime: '--',
      remarks: 'Weekend - No Class',
      classes: [],
    ),
  };

  // Mock subject attendance rates
  final List<SubjectAttendance> _subjectAttendance = const [
    SubjectAttendance(
      subjectName: 'Mathematics',
      percentage: 98,
      color: Color(0xFF6D5DFB),
    ),
    SubjectAttendance(
      subjectName: 'Science Lab',
      percentage: 95,
      color: Color(0xFF32A89D),
    ),
    SubjectAttendance(
      subjectName: 'English',
      percentage: 100,
      color: Color(0xFF2F80ED),
    ),
    SubjectAttendance(
      subjectName: 'Programming',
      percentage: 92,
      color: Color(0xFFFF8E53),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Default to May 26, 2026
    _selectedDate = DateTime(2026, 5, 26);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Generate dates for horizontal day selector (Mon May 25 to Sat May 30)
    final weeklyDates = List.generate(
      6,
      (index) => DateTime(2026, 5, 25).add(Duration(days: index)),
    );

    return StudentPageScaffold(
      title: 'Attendance',
      subtitle: 'Your weekly presence and class check-ins.',
      icon: Icons.how_to_reg_rounded,
      children: [
        // 1. Weekly Attendance Days Navigation (Top Section)
        Text('Weekly Navigator',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: scheme.onSurface,
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 96,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: weeklyDates.length,
            itemBuilder: (context, index) {
              final date = weeklyDates[index];
              final isSelected =
                  date.day == _selectedDate.day &&
                  date.month == _selectedDate.month;
              final record =
                  _attendanceRecords[date] ??
                  const AttendanceRecord(
                    status: AttendanceStatus.noClass,
                    checkInTime: '--',
                    remarks: '',
                  );
              return _buildWeeklyDayCard(date, isSelected, record);
            },
          ),
        ),
        const SizedBox(height: 20),

        // 2. Attendance Summary (Top Card)
        _buildSummaryCard(),
        const SizedBox(height: 20),

        // 3. Today's Attendance Detail Card
        _buildDetailCard(),
        const SizedBox(height: 20),

        // 4. Subject/Class Attendance
        _buildSubjectAttendanceSection(),
        const SizedBox(height: 20),

        // 5. Calendar View
        _buildCalendarSection(),
        const SizedBox(height: 20),

        // 6. Attendance History
        _buildHistorySection(),
        const SizedBox(height: 20),

        // 7. Monthly Statistics
        _buildMonthlyStatisticsSection(),
      ],
    );
  }

  // --- Sub-widgets Implementation ---

  Widget _buildWeeklyDayCard(
    DateTime date,
    bool isSelected,
    AttendanceRecord record,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayName = dayNames[date.weekday - 1];

    IconData statusIcon;
    Color statusColor;
    switch (record.status) {
      case AttendanceStatus.present:
        statusIcon = Icons.check_circle_rounded;
        statusColor = const Color(0xFF27AE60);
        break;
      case AttendanceStatus.absent:
        statusIcon = Icons.cancel_rounded;
        statusColor = const Color(0xFFEB5757);
        break;
      case AttendanceStatus.late:
        statusIcon = Icons.schedule_rounded;
        statusColor = const Color(0xFFFF8E53);
        break;
      case AttendanceStatus.excused:
        statusIcon = Icons.info_rounded;
        statusColor = const Color(0xFF2F80ED);
        break;
      case AttendanceStatus.noClass:
        statusIcon = Icons.calendar_today_rounded;
        statusColor = scheme.onSurfaceVariant;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(right: 12, bottom: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
          },
          borderRadius: BorderRadius.circular(22),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            width: 74,
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
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? scheme.primary.withValues(alpha: 0.35)
                      : scheme.shadow.withValues(alpha: 0.08),
                  blurRadius: isSelected ? 12 : 8,
                  offset: isSelected ? const Offset(0, 6) : const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dayName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white70
                        : scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? Colors.white : scheme.onSurface,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Icon(
                  statusIcon,
                  size: 14,
                  color: isSelected ? Colors.white : statusColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.26),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular Progress Indicator representing 96%
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 82,
                height: 82,
                child: CircularProgressIndicator(
                  value: 0.96,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.22),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '96%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Rate',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 22),
          // Statistics breakdown
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Attendance Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryStatItem('Present', '120'),
                    _buildSummaryStatItem('Absent', '3'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryStatItem('Late', '2'),
                    _buildSummaryStatItem('Excused', '1'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStatItem(String label, String value) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1.1,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: scheme.surface,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard() {
    final scheme = Theme.of(context).colorScheme;
    final record =
        _attendanceRecords[DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
        )] ??
        const AttendanceRecord(
          status: AttendanceStatus.noClass,
          checkInTime: '--',
          remarks: 'Weekend / No Classes Scheduled',
          classes: [],
        );

    final isToday = _selectedDate.day == 26 && _selectedDate.month == 5;
    final dayLabel = isToday ? "Today's Attendance" : "Attendance Details";

    String statusText;
    Color statusColor;
    IconData statusIcon;
    switch (record.status) {
      case AttendanceStatus.present:
        statusText = 'PRESENT';
        statusColor = const Color(0xFF27AE60);
        statusIcon = Icons.check_circle_rounded;
        break;
      case AttendanceStatus.absent:
        statusText = 'ABSENT';
        statusColor = const Color(0xFFEB5757);
        statusIcon = Icons.cancel_rounded;
        break;
      case AttendanceStatus.late:
        statusText = 'LATE';
        statusColor = const Color(0xFFFF8E53);
        statusIcon = Icons.schedule_rounded;
        break;
      case AttendanceStatus.excused:
        statusText = 'EXCUSED';
        statusColor = const Color(0xFF2F80ED);
        statusIcon = Icons.info_rounded;
        break;
      case AttendanceStatus.noClass:
        statusText = 'NO CLASS';
        statusColor = scheme.onSurfaceVariant;
        statusIcon = Icons.calendar_today_rounded;
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.1),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dayLabel,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 12, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Date: May ${_selectedDate.day}, 2026',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildDetailInfoCol('Time In', record.checkInTime, scheme),
              const SizedBox(width: 32),
              _buildDetailInfoCol(
                'Remarks',
                record.remarks.isNotEmpty ? record.remarks : 'None',
                scheme,
              ),
            ],
          ),
          if (record.classes.isNotEmpty) ...[
            SizedBox(height: 18),
            Divider(height: 1, thickness: 1, color: scheme.outlineVariant),
            SizedBox(height: 14),
            Text(
              'Class Breakdown',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: scheme.onSurface,
              ),
            ),
            SizedBox(height: 8),
            ...record.classes.map((cls) => _buildClassBreakdownRow(cls, scheme)),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailInfoCol(String label, String value, ColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: scheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: scheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildClassBreakdownRow(ClassCheckIn cls, ColorScheme scheme) {
    Color checkColor = const Color(0xFF27AE60);
    IconData checkIcon = Icons.check_circle_rounded;

    if (cls.status.toLowerCase() == 'late') {
      checkColor = const Color(0xFFFF8E53);
      checkIcon = Icons.schedule_rounded;
    } else if (cls.status.toLowerCase() == 'absent') {
      checkColor = const Color(0xFFEB5757);
      checkIcon = Icons.cancel_rounded;
    } else if (cls.status.toLowerCase() == 'excused') {
      checkColor = const Color(0xFF2F80ED);
      checkIcon = Icons.info_rounded;
    } else if (cls.isUpcoming) {
      checkColor = scheme.onSurfaceVariant;
      checkIcon = Icons.schedule_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant, width: 1),
      ),
      child: Row(
        children: [
          Icon(checkIcon, color: checkColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              cls.className,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
              ),
            ),
          ),
          Text(
            cls.isUpcoming ? cls.time : '${cls.status} - ${cls.time}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: cls.isUpcoming ? scheme.onSurfaceVariant : checkColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectAttendanceSection() {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.1),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Subject Attendance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
            ),
          ),
          SizedBox(height: 14),
          ..._subjectAttendance.map((sub) => _buildSubjectProgressItem(sub, scheme)),
        ],
      ),
    );
  }

  Widget _buildSubjectProgressItem(SubjectAttendance sub, ColorScheme scheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sub.subjectName,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
              Text(
                '${sub.percentage}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: sub.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: scheme.outlineVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: sub.percentage / 100.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [sub.color.withValues(alpha: 0.7), sub.color],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection() {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.1),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Attendance Calendar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface,
                ),
              ),
              Text(
                'May 2026',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: scheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          // Calendar Grid Header (Weekdays)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
              return SizedBox(
                width: 38,
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // Interactive May 2026 Calendar Grid
          _buildMayCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildMayCalendarGrid() {
    final scheme = Theme.of(context).colorScheme;
    // May 1, 2026 is a Friday.
    // Standard calendar grid construction for May 2026.
    // Total cells = 35 (5 rows of 7 days)
    // Offset for Friday is 5 empty cells (Sun, Mon, Tue, Wed, Thu)
    final cells = <Widget>[];

    // Empty cells at start of month (Sun-Thu)
    for (int i = 0; i < 5; i++) {
      cells.add(const SizedBox(width: 38, height: 44));
    }

    // Days in May 2026 (1 to 31)
    for (int day = 1; day <= 31; day++) {
      final date = DateTime(2026, 5, day);
      final record = _attendanceRecords[date];

      cells.add(_buildCalendarCell(day, date, record, scheme));
    }

    // Fill remaining cells to make a full 7x5 or 7x6 grid
    final remaining = 42 - cells.length;
    for (int i = 0; i < remaining; i++) {
      cells.add(SizedBox(width: 38, height: 44));
    }

    return Wrap(
      spacing: (MediaQuery.of(context).size.width - 290) / 7,
      runSpacing: 8,
      children: cells,
    );
  }

  Widget _buildCalendarCell(int day, DateTime date, AttendanceRecord? record, ColorScheme scheme) {
    final isSelected =
        date.day == _selectedDate.day && date.month == _selectedDate.month;

    Color? cellDotColor;
    if (record != null) {
      switch (record.status) {
        case AttendanceStatus.present:
          cellDotColor = const Color(0xFF27AE60);
          break;
        case AttendanceStatus.absent:
          cellDotColor = const Color(0xFFEB5757);
          break;
        case AttendanceStatus.late:
          cellDotColor = const Color(0xFFFF8E53);
          break;
        case AttendanceStatus.excused:
          cellDotColor = const Color(0xFF2F80ED);
          break;
        case AttendanceStatus.noClass:
          cellDotColor = null;
          break;
      }
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
        });
      },
      child: Container(
        width: 38,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? scheme.primary : null,
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.35),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : scheme.onSurface,
              ),
            ),
            const SizedBox(height: 3),
            if (cellDotColor != null)
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : cellDotColor,
                  shape: BoxShape.circle,
                ),
              )
            else
              const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    final scheme = Theme.of(context).colorScheme;
    // Generate static list of past records for display
    final historyDates = [
      DateTime(2026, 5, 26),
      DateTime(2026, 5, 25),
      DateTime(2026, 5, 22),
      DateTime(2026, 5, 21),
      DateTime(2026, 5, 20),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.1),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attendance Logs',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
            ),
          ),
          SizedBox(height: 14),
          ...historyDates.map((date) {
            final rec = _attendanceRecords[date]!;
            return _buildHistoryItem(date, rec, scheme);
          }),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(DateTime date, AttendanceRecord record, ColorScheme scheme) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final dateLabel = '${months[date.month - 1]} ${date.day}';

    String statusText;
    Color statusColor;
    switch (record.status) {
      case AttendanceStatus.present:
        statusText = 'Present';
        statusColor = const Color(0xFF27AE60);
        break;
      case AttendanceStatus.absent:
        statusText = 'Absent';
        statusColor = const Color(0xFFEB5757);
        break;
      case AttendanceStatus.late:
        statusText = 'Late';
        statusColor = const Color(0xFFFF8E53);
        break;
      case AttendanceStatus.excused:
        statusText = 'Excused';
        statusColor = const Color(0xFF2F80ED);
        break;
      case AttendanceStatus.noClass:
        statusText = 'No Class';
        statusColor = scheme.onSurfaceVariant;
        break;
    }
    final statusBg = statusColor.withValues(alpha: 0.12);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  color: scheme.onPrimaryContainer,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateLabel,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface,
                    ),
                  ),
                  Text(
                    record.remarks.isNotEmpty
                        ? record.remarks
                        : 'Daily log checked',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyStatisticsSection() {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.1),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Month Analytics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
            ),
          ),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMonthlyStatBox('Present', '20', const Color(0xFF27AE60), scheme),
              _buildMonthlyStatBox('Absent', '1', const Color(0xFFEB5757), scheme),
              _buildMonthlyStatBox('Late', '0', const Color(0xFFFF8E53), scheme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyStatBox(String label, String value, Color color, ColorScheme scheme) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: scheme.outlineVariant, width: 1),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: color,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Data Models & Enums ---

enum AttendanceStatus { present, absent, late, excused, noClass }

class AttendanceRecord {
  final AttendanceStatus status;
  final String checkInTime;
  final String remarks;
  final List<ClassCheckIn> classes;

  const AttendanceRecord({
    required this.status,
    required this.checkInTime,
    required this.remarks,
    this.classes = const [],
  });
}

class ClassCheckIn {
  final String className;
  final String status;
  final String time;
  final bool isUpcoming;

  const ClassCheckIn({
    required this.className,
    required this.status,
    required this.time,
    required this.isUpcoming,
  });
}

class SubjectAttendance {
  final String subjectName;
  final int percentage;
  final Color color;

  const SubjectAttendance({
    required this.subjectName,
    required this.percentage,
    required this.color,
  });
}
