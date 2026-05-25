import 'package:flutter/material.dart';

class FloatingNavigation extends StatefulWidget {
  const FloatingNavigation({super.key});

  @override
  State<FloatingNavigation> createState() => _FloatingNavigationState();
}

class _FloatingNavigationState extends State<FloatingNavigation> {
  int selectedIndex = 0;

  // Updated icons:
  // Home, Grades, Balance, Attendance, Schedule
  final List<IconData> navIcons = [
    Icons.home_rounded, // Home
    Icons.assessment_rounded, // Grades
    Icons.monetization_on_rounded, // Balance
    Icons.how_to_reg_rounded, // Attendance
    Icons.calendar_month_rounded, // Schedule
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(navIcons.length, (index) {
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 20),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color.fromARGB(255, 191, 226, 255)
                    : const Color.fromARGB(0, 0, 0, 0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                navIcons[index],
                color: isSelected
                    ? const Color.fromARGB(255, 0, 170, 255)
                    : Colors.grey,
                size: 28,
              ),
            ),
          );
        }),
      ),
    );
  }
}
