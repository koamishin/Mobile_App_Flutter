import 'package:flutter/material.dart';

import '../widgets/floating_navigation_bar.dart';
import '../widgets/navbar_top.dart';
import '../widgets/profile_drawer.dart';
import 'attendance_page.dart';
import 'balance_page.dart';
import 'grades_page.dart';
import 'home_page.dart';
import 'preferences_page.dart';
import 'schedule_page.dart';

/// Top-level metadata for each tab in the bottom navigation.
///
/// This drives the shared top header so the title/subtitle update when the
/// user switches pages, keeping the header consistent everywhere.
class _TabInfo {
  const _TabInfo({required this.title, required this.subtitle});
  final String title;
  final String subtitle;
}

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late final AnimationController _transitionController;
  int _lastIndex = 0;

  /// Number of routes pushed above the dashboard (e.g. 1 when the
  /// preferences page is on top). Drives the back-arrow visibility on
  /// the top header so a tapped back button pops the pushed route.
  int _pushedRouteCount = 0;

  static const List<_TabInfo> _tabs = [
    _TabInfo(
      title: 'Home',
      subtitle: 'Welcome back, Sarah!',
    ),
    _TabInfo(
      title: 'Grades',
      subtitle: 'Track your scores and progress',
    ),
    _TabInfo(
      title: 'Account',
      subtitle: 'Tuition fees and payments',
    ),
    _TabInfo(
      title: 'Attendance',
      subtitle: 'Weekly presence overview',
    ),
    _TabInfo(
      title: 'Class Schedule',
      subtitle: 'Daily classes and exams',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build every page so AnimatedSwitcher can cross-fade between them.
    final pages = <Widget>[
      HomePage(onDashboardCardSelected: _selectPage),
      const GradesPage(),
      const BalancePage(),
      const AttendancePage(),
      const SchedulePage(),
    ];

    final currentTab = _tabs[_selectedIndex];
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      // Wrap the entire body in a Stack so the header + floating nav stay
      // visually pinned while only the page content cross-fades.
      body: SafeArea(
        child: Stack(
          children: [
            // 0. Theme-aware background so dark mode gets a dark surface.
            Positioned.fill(child: ColoredBox(color: scheme.surface)),
            // 1. Page content with cross-fade + slide transition
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 380),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: _buildPageTransition,
                layoutBuilder: (currentChild, previousChildren) {
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey<int>(_selectedIndex),
                  child: _PageWrapper(
                    isHome: _selectedIndex == 0,
                    child: pages[_selectedIndex],
                  ),
                ),
              ),
            ),

            // 2. Persistent top header (consistent title style across all pages)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
                child: CustomNavBar(
                  key: ValueKey('header-${currentTab.title}'),
                  title: currentTab.title,
                  subtitle: currentTab.subtitle,
                  onAvatarTap: _openProfileDrawer,
                  showBackButton: _pushedRouteCount > 0,
                  onBackPressed: _popPushedRoute,
                ),
              ),
            ),

            // 3. Persistent floating bottom nav menu (always visible, including home)
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
      ),
    );
  }

  /// Fade + directional slide transition between pages.
  ///
  /// If the user navigates forward (e.g. Home -> Grades), the new page slides
  /// in from the right. If they go back, it slides in from the left.
  Widget _buildPageTransition(Widget child, Animation<double> animation) {
    final isForward = _selectedIndex >= _lastIndex;
    final beginOffset = isForward
        ? const Offset(0.08, 0)
        : const Offset(-0.08, 0);

    final offsetTween = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeOutCubic));

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(position: animation.drive(offsetTween), child: child),
    );
  }

  void _selectPage(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _lastIndex = _selectedIndex;
      _selectedIndex = index;
    });
    _transitionController.forward(from: 0);
  }

  /// Pops the most recently pushed route (e.g. the preferences page)
  /// when the user taps the back button in the top header. Falls
  /// back to a system back if for some reason no route is on top.
  void _popPushedRoute() {
    if (_pushedRouteCount > 0) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  Future<void> _openProfileDrawer() async {
    final messenger = ScaffoldMessenger.of(context);
    final action = await ProfileDrawer.show(context);
    if (action == null || !mounted) return;

    switch (action) {
      case ProfileAction.profile:
        messenger.showSnackBar(SnackBar(
          content: const Text('Opening profile…'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ));
        break;
      case ProfileAction.settings:
        messenger.showSnackBar(SnackBar(
          content: const Text('Opening settings…'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ));
        break;
      case ProfileAction.preferences:
        // Slide the preferences page over the dashboard with a
        // smooth Material 3 transition.
        if (!mounted) break;
        setState(() => _pushedRouteCount = 1);
        await Navigator.of(context).push(
          PageRouteBuilder(
            opaque: true,
            transitionDuration: const Duration(milliseconds: 380),
            reverseTransitionDuration: const Duration(milliseconds: 280),
            pageBuilder: (_, _, _) => const PreferencesPage(),
            transitionsBuilder: (_, animation, _, child) {
              final slide = Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: slide, child: child),
              );
            },
          ),
        );
        // After the route pops, hide the back button again.
        if (mounted) {
          setState(() => _pushedRouteCount = 0);
        }
        break;
      case ProfileAction.logout:
        messenger.showSnackBar(SnackBar(
          content: const Text('Signed out'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ));
        break;
    }
  }
}

/// Wraps each page with padding so the page content does not slide under
/// the top header or the floating bottom nav.
class _PageWrapper extends StatelessWidget {
  const _PageWrapper({required this.isHome, required this.child});

  final bool isHome;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Top: 80 (header height) + 12 gap
      // Bottom: 80 (gooey nav) + 20 (margin) + 12 gap
      padding: EdgeInsets.only(
        top: isHome ? 92 : 88,
        bottom: 112,
      ),
      child: child,
    );
  }
}
