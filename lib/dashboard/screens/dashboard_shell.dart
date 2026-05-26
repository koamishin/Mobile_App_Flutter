import 'package:flutter/material.dart';

import '../widgets/floating_navigation_bar.dart';
import 'attendance_page.dart';
import 'balance_page.dart';
import 'grades_page.dart';
import 'home_page.dart';
import 'schedule_page.dart';

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onDashboardCardSelected: _selectPage),
      const GradesPage(),
      const BalancePage(),
      const AttendancePage(),
      const SchedulePage(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFCFE8FF),
      body: Stack(
        children: [
          const Positioned.fill(child: ColoredBox(color: Color(0xFFCFE8FF))),
          Positioned.fill(
            child: IndexedStack(index: _selectedIndex, children: pages),
          ),
          if (_selectedIndex != 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: FloatingNavigation(
                selectedIndex: _selectedIndex,
                onItemSelected: _selectPage,
              ),
            ),
        ],
      ),
    );
  }

  void _selectPage(int index) {
    setState(() => _selectedIndex = index);
  }
}
