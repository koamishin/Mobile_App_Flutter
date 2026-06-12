import 'package:flutter/material.dart';

import '../widgets/gridview_box.dart';
import '../widgets/greeting_box.dart';

/// Home page content (greeting hero + dashboard quick actions).
///
/// The persistent top header and floating bottom navigation are rendered by
/// [DashboardShell], so this widget only contributes the scrollable body.
class HomePage extends StatelessWidget {
  const HomePage({required this.onDashboardCardSelected, super.key});

  final ValueChanged<int> onDashboardCardSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: scheme.surface,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GreetingBox(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dashboard',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Quick Overview',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: scheme.primary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridviewBox(onItemSelected: onDashboardCardSelected),
          ],
        ),
      ),
    );
  }
}
