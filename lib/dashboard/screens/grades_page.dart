import 'package:flutter/material.dart';

import '../widgets/page_components.dart';

class GradesPage extends StatefulWidget {
  const GradesPage({super.key});

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  final Map<String, bool> _expandedGrades = {};

  @override
  void initState() {
    super.initState();
    // Expand Grade 10 by default to provide an interactive and premium experience
    _expandedGrades['Grade 10'] = true;
  }

  // Structured Academic History mock data from Grade 6 to Grade 10
  final List<GradeLevelHistory> _academicHistory = const [
    GradeLevelHistory(
      gradeName: 'Grade 10',
      academicYear: '2025 - 2026',
      semesters: [
        SemesterHistory(
          semesterName: '1st Semester',
          generalAverage: 92.3,
          subjects: [
            SubjectGrade(
              subjectName: 'Mathematics',
              finalGrade: 96,
              remarks: 'Passed',
              icon: Icons.calculate_rounded,
            ),
            SubjectGrade(
              subjectName: 'Science',
              finalGrade: 91,
              remarks: 'Passed',
              icon: Icons.science_rounded,
            ),
            SubjectGrade(
              subjectName: 'English',
              finalGrade: 88,
              remarks: 'Passed',
              icon: Icons.menu_book_rounded,
            ),
            SubjectGrade(
              subjectName: 'History',
              finalGrade: 94,
              remarks: 'Passed',
              icon: Icons.history_edu_rounded,
            ),
          ],
        ),
        SemesterHistory(
          semesterName: '2nd Semester',
          generalAverage: 93.5,
          subjects: [
            SubjectGrade(
              subjectName: 'Mathematics',
              finalGrade: 95,
              remarks: 'Passed',
              icon: Icons.calculate_rounded,
            ),
            SubjectGrade(
              subjectName: 'Science',
              finalGrade: 93,
              remarks: 'Passed',
              icon: Icons.science_rounded,
            ),
            SubjectGrade(
              subjectName: 'English',
              finalGrade: 90,
              remarks: 'Passed',
              icon: Icons.menu_book_rounded,
            ),
            SubjectGrade(
              subjectName: 'Social Studies',
              finalGrade: 96,
              remarks: 'Passed',
              icon: Icons.public_rounded,
            ),
          ],
        ),
      ],
    ),
    GradeLevelHistory(
      gradeName: 'Grade 9',
      academicYear: '2024 - 2025',
      semesters: [
        SemesterHistory(
          semesterName: '1st Semester',
          generalAverage: 91.5,
          subjects: [
            SubjectGrade(
              subjectName: 'Algebra',
              finalGrade: 93,
              remarks: 'Passed',
              icon: Icons.calculate_rounded,
            ),
            SubjectGrade(
              subjectName: 'Biology',
              finalGrade: 90,
              remarks: 'Passed',
              icon: Icons.science_rounded,
            ),
            SubjectGrade(
              subjectName: 'Literature',
              finalGrade: 89,
              remarks: 'Passed',
              icon: Icons.menu_book_rounded,
            ),
            SubjectGrade(
              subjectName: 'Art & Design',
              finalGrade: 94,
              remarks: 'Passed',
              icon: Icons.palette_rounded,
            ),
          ],
        ),
        SemesterHistory(
          semesterName: '2nd Semester',
          generalAverage: 92.8,
          subjects: [
            SubjectGrade(
              subjectName: 'Geometry',
              finalGrade: 94,
              remarks: 'Passed',
              icon: Icons.architecture_rounded,
            ),
            SubjectGrade(
              subjectName: 'Chemistry',
              finalGrade: 91,
              remarks: 'Passed',
              icon: Icons.biotech_rounded,
            ),
            SubjectGrade(
              subjectName: 'Composition',
              finalGrade: 90,
              remarks: 'Passed',
              icon: Icons.edit_note_rounded,
            ),
            SubjectGrade(
              subjectName: 'Computer Science',
              finalGrade: 96,
              remarks: 'Passed',
              icon: Icons.computer_rounded,
            ),
          ],
        ),
      ],
    ),
    GradeLevelHistory(
      gradeName: 'Grade 8',
      academicYear: '2023 - 2024',
      semesters: [
        SemesterHistory(
          semesterName: '1st Semester',
          generalAverage: 90.3,
          subjects: [
            SubjectGrade(
              subjectName: 'Pre-Algebra',
              finalGrade: 91,
              remarks: 'Passed',
              icon: Icons.calculate_rounded,
            ),
            SubjectGrade(
              subjectName: 'Earth Science',
              finalGrade: 88,
              remarks: 'Passed',
              icon: Icons.public_rounded,
            ),
            SubjectGrade(
              subjectName: 'Grammar',
              finalGrade: 92,
              remarks: 'Passed',
              icon: Icons.title_rounded,
            ),
          ],
        ),
        SemesterHistory(
          semesterName: '2nd Semester',
          generalAverage: 91.0,
          subjects: [
            SubjectGrade(
              subjectName: 'Pre-Algebra',
              finalGrade: 90,
              remarks: 'Passed',
              icon: Icons.calculate_rounded,
            ),
            SubjectGrade(
              subjectName: 'Physical Science',
              finalGrade: 89,
              remarks: 'Passed',
              icon: Icons.science_rounded,
            ),
            SubjectGrade(
              subjectName: 'Creative Writing',
              finalGrade: 94,
              remarks: 'Passed',
              icon: Icons.draw_rounded,
            ),
          ],
        ),
      ],
    ),
    GradeLevelHistory(
      gradeName: 'Grade 7',
      academicYear: '2022 - 2023',
      semesters: [
        SemesterHistory(
          semesterName: '1st Semester',
          generalAverage: 89.5,
          subjects: [
            SubjectGrade(
              subjectName: 'General Math',
              finalGrade: 88,
              remarks: 'Passed',
              icon: Icons.calculate_rounded,
            ),
            SubjectGrade(
              subjectName: 'Life Science',
              finalGrade: 87,
              remarks: 'Passed',
              icon: Icons.eco_rounded,
            ),
            SubjectGrade(
              subjectName: 'Reading',
              finalGrade: 93,
              remarks: 'Passed',
              icon: Icons.book_rounded,
            ),
          ],
        ),
        SemesterHistory(
          semesterName: '2nd Semester',
          generalAverage: 90.8,
          subjects: [
            SubjectGrade(
              subjectName: 'General Math',
              finalGrade: 91,
              remarks: 'Passed',
              icon: Icons.calculate_rounded,
            ),
            SubjectGrade(
              subjectName: 'Life Science',
              finalGrade: 89,
              remarks: 'Passed',
              icon: Icons.eco_rounded,
            ),
            SubjectGrade(
              subjectName: 'Writing & Speaking',
              finalGrade: 92,
              remarks: 'Passed',
              icon: Icons.record_voice_over_rounded,
            ),
          ],
        ),
      ],
    ),
    GradeLevelHistory(
      gradeName: 'Grade 6',
      academicYear: '2021 - 2022',
      semesters: [
        SemesterHistory(
          semesterName: '1st Semester',
          generalAverage: 88.3,
          subjects: [
            SubjectGrade(
              subjectName: 'Elementary Math',
              finalGrade: 87,
              remarks: 'Passed',
              icon: Icons.calculate_rounded,
            ),
            SubjectGrade(
              subjectName: 'Intro to Science',
              finalGrade: 86,
              remarks: 'Passed',
              icon: Icons.lightbulb_rounded,
            ),
            SubjectGrade(
              subjectName: 'English Basics',
              finalGrade: 92,
              remarks: 'Passed',
              icon: Icons.abc_rounded,
            ),
          ],
        ),
        SemesterHistory(
          semesterName: '2nd Semester',
          generalAverage: 89.7,
          subjects: [
            SubjectGrade(
              subjectName: 'Elementary Math',
              finalGrade: 89,
              remarks: 'Passed',
              icon: Icons.calculate_rounded,
            ),
            SubjectGrade(
              subjectName: 'Intro to Science',
              finalGrade: 88,
              remarks: 'Passed',
              icon: Icons.lightbulb_rounded,
            ),
            SubjectGrade(
              subjectName: 'English Basics',
              finalGrade: 92,
              remarks: 'Passed',
              icon: Icons.abc_rounded,
            ),
          ],
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return StudentPageScaffold(
      title: 'Grades',
      subtitle: 'Track your scores and subject progress.',
      icon: Icons.assessment_rounded,
      children: [
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            MetricCard(
              title: 'Average',
              value: '92%',
              icon: Icons.star_rounded,
              colors: [Color(0xFF9B7BFF), Color(0xFF6D5DFB)],
            ),
            MetricCard(
              title: 'Class Rank',
              value: '#4',
              icon: Icons.emoji_events_rounded,
              colors: [Color(0xFFFFB86B), Color(0xFFFF8E53)],
            ),
          ],
        ),
        const SizedBox(height: 20),
        const SoftInfoCard(
          title: 'Mathematics',
          subtitle: '96% - Excellent problem solving',
          icon: Icons.calculate_rounded,
          trailing: Text('A+', style: _badgeStyle),
        ),
        const SoftInfoCard(
          title: 'Science',
          subtitle: '91% - Lab report improved',
          icon: Icons.science_rounded,
          trailing: Text('A', style: _badgeStyle),
        ),
        const SoftInfoCard(
          title: 'English',
          subtitle: '88% - Essay feedback available',
          icon: Icons.menu_book_rounded,
          trailing: Text('B+', style: _badgeStyle),
        ),
        const SizedBox(height: 22),
        const Text(
          'Academic History',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF27364A),
          ),
        ),
        const SizedBox(height: 12),
        ..._academicHistory.map((history) {
          final isExpanded = _expandedGrades[history.gradeName] ?? false;
          return GradeLevelCard(
            history: history,
            isExpanded: isExpanded,
            onTap: () {
              setState(() {
                _expandedGrades[history.gradeName] = !isExpanded;
              });
            },
          );
        }),
      ],
    );
  }
}

class GradeLevelCard extends StatelessWidget {
  final GradeLevelHistory history;
  final bool isExpanded;
  final VoidCallback onTap;

  const GradeLevelCard({
    required this.history,
    required this.isExpanded,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Determine unique premium color scheme for each grade icon
    final Color themeColor;
    switch (history.gradeName) {
      case 'Grade 10':
        themeColor = const Color(0xFF6D5DFB);
        break;
      case 'Grade 9':
        themeColor = const Color(0xFFFF8E53);
        break;
      case 'Grade 8':
        themeColor = const Color(0xFF32A89D);
        break;
      case 'Grade 7':
        themeColor = const Color(0xFF2F80ED);
        break;
      default:
        themeColor = const Color(0xFF9B7BFF);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.1),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(Icons.school_rounded, color: themeColor),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          history.gradeName,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF26364A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'AY ${history.academicYear}',
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Avg: ${_calculateYearlyAverage()}%',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: themeColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF66778A),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isExpanded
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: scheme.outlineVariant,
                          indent: 18,
                          endIndent: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                          child: Column(
                            children: history.semesters
                                .map((sem) => _buildSemesterView(context, sem, themeColor))
                                .toList(),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  String _calculateYearlyAverage() {
    if (history.semesters.isEmpty) return '0';
    double total = history.semesters.fold(0.0, (sum, sem) => sum + sem.generalAverage);
    return (total / history.semesters.length).toStringAsFixed(1);
  }

  Widget _buildSemesterView(BuildContext context, SemesterHistory sem, Color themeColor) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              sem.semesterName,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF26364A),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Sem Avg: ${sem.generalAverage}%',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2F80ED),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...sem.subjects.map((sub) => _buildSubjectRow(context, sub)),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildSubjectRow(BuildContext context, SubjectGrade sub) {
    final scheme = Theme.of(context).colorScheme;
    final isPassed = sub.remarks.toLowerCase() == 'passed';
    final remarksColor = isPassed ? const Color(0xFF27AE60) : const Color(0xFFEB5757);
    final remarksBg = isPassed ? const Color(0xFFEBF7EE) : const Color(0xFFFDF0F0);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant, width: 1),
      ),
      child: Row(
        children: [
          Icon(sub.icon, size: 18, color: const Color(0xFF66778A)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              sub.subjectName,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF26364A),
              ),
            ),
          ),
          Text(
            '${sub.finalGrade}%',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF26364A),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: remarksBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              sub.remarks,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: remarksColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GradeLevelHistory {
  final String gradeName;
  final String academicYear;
  final List<SemesterHistory> semesters;

  const GradeLevelHistory({
    required this.gradeName,
    required this.academicYear,
    required this.semesters,
  });
}

class SemesterHistory {
  final String semesterName;
  final List<SubjectGrade> subjects;
  final double generalAverage;

  const SemesterHistory({
    required this.semesterName,
    required this.subjects,
    required this.generalAverage,
  });
}

class SubjectGrade {
  final String subjectName;
  final int finalGrade;
  final String remarks;
  final IconData icon;

  const SubjectGrade({
    required this.subjectName,
    required this.finalGrade,
    required this.remarks,
    required this.icon,
  });
}

const TextStyle _badgeStyle = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 18,
  fontWeight: FontWeight.w900,
  color: Color(0xFF2F80ED),
);
