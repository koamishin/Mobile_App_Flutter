import 'package:flutter/material.dart';

import '../widgets/page_components.dart';

class GradeLevelHistory {
  const GradeLevelHistory({
    required this.gradeName,
    required this.academicYear,
    required this.semesters,
  });

  final String gradeName;
  final String academicYear;
  final List<SemesterHistory> semesters;
}

class SemesterHistory {
  const SemesterHistory({
    required this.semesterName,
    required this.generalAverage,
    required this.subjects,
  });

  final String semesterName;
  final double generalAverage;
  final List<SubjectGrade> subjects;
}

class SubjectGrade {
  const SubjectGrade({
    required this.subjectName,
    required this.finalGrade,
    required this.remarks,
    required this.icon,
  });

  final String subjectName;
  final int finalGrade;
  final String remarks;
  final IconData icon;
}

/// Redesigned Grades Screen matching the Material 3 surface card design system.
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
    _expandedGrades['Grade 10'] = true;
  }

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
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return StudentPageScaffold(
      title: 'Grades',
      subtitle: 'Track your scores and subject progress.',
      icon: Icons.assessment_rounded,
      children: [
        // 1. Top Summary Hero Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: isDark
                ? scheme.surfaceContainerHigh
                : scheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: isDark ? 0.35 : 0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withValues(alpha: isDark ? 0.18 : 0.04),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          size: 15,
                          color: scheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'President\'s Honor Roll',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: scheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'AY 2025-2026',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'General Average',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '92.9',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                                color: scheme.primary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '%',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: scheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 48,
                    width: 1,
                    color: scheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Class Rank',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '#4',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                                color: scheme.secondary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'of 142',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 2. Section Heading: Current Subjects
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Current Subjects',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
                color: scheme.onSurface,
              ),
            ),
            Text(
              'Grade 10 • Sem 2',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: scheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 3. Subject List Cards
        _SubjectCard(
          title: 'Mathematics',
          grade: 96,
          remarks: 'Excellent problem solving',
          icon: Icons.calculate_rounded,
          letterGrade: 'A+',
          color: scheme.primary,
        ),
        _SubjectCard(
          title: 'Science',
          grade: 93,
          remarks: 'Lab report improved',
          icon: Icons.science_rounded,
          letterGrade: 'A',
          color: scheme.secondary,
        ),
        _SubjectCard(
          title: 'Social Studies',
          grade: 96,
          remarks: 'Outstanding research',
          icon: Icons.public_rounded,
          letterGrade: 'A+',
          color: scheme.tertiary,
        ),
        _SubjectCard(
          title: 'English',
          grade: 90,
          remarks: 'Essay feedback available',
          icon: Icons.menu_book_rounded,
          letterGrade: 'A-',
          color: scheme.primary,
        ),
        const SizedBox(height: 24),

        // 4. Section Heading: Academic History
        Text(
          'Academic History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),

        // 5. Expandable History Cards
        ..._academicHistory.map((history) {
          final isExpanded = _expandedGrades[history.gradeName] ?? false;
          return _AcademicHistoryCard(
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

/// Unified Material 3 Subject Card
class _SubjectCard extends StatelessWidget {
  const _SubjectCard({
    required this.title,
    required this.grade,
    required this.remarks,
    required this.icon,
    required this.letterGrade,
    required this.color,
  });

  final String title;
  final int grade;
  final String remarks;
  final IconData icon;
  final String letterGrade;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? scheme.surfaceContainerHigh
            : scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: isDark ? 0.3 : 0.45),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: isDark ? 0.12 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  remarks,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  letterGrade,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$grade%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Expandable Academic History Year Card
class _AcademicHistoryCard extends StatelessWidget {
  const _AcademicHistoryCard({
    required this.history,
    required this.isExpanded,
    required this.onTap,
  });

  final GradeLevelHistory history;
  final bool isExpanded;
  final VoidCallback onTap;

  double _calculateAverage() {
    if (history.semesters.isEmpty) return 0;
    final total = history.semesters.fold<double>(
      0,
      (sum, sem) => sum + sem.generalAverage,
    );
    return double.parse((total / history.semesters.length).toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avg = _calculateAverage();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark
            ? scheme.surfaceContainerHigh
            : scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: isDark ? 0.3 : 0.45),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: isDark ? 0.14 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(22),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.school_rounded,
                        color: scheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            history.gradeName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: scheme.onSurface,
                            ),
                          ),
                          Text(
                            'AY ${history.academicYear}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Avg: $avg%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: scheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 240),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: scheme.onSurfaceVariant,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOut,
              child: isExpanded
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        children: history.semesters.map((sem) {
                          return Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: scheme.surfaceContainerHighest
                                  .withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      sem.semesterName,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: scheme.onSurface,
                                      ),
                                    ),
                                    Text(
                                      'GPA: ${sem.generalAverage}%',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: scheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ...sem.subjects.map((sub) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        Icon(
                                          sub.icon,
                                          size: 16,
                                          color: scheme.onSurfaceVariant,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            sub.subjectName,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: scheme.onSurface,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${sub.finalGrade}%',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: scheme.onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
