import 'dart:ui';

import 'package:flutter/material.dart';

// Floating glass navigation bar pinned over the bottom of the dashboard.
class FloatingNavigationBar extends StatelessWidget {
  const FloatingNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 18,
      right: 18,
      bottom: 24,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
          child: Container(
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF171129).withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x40171129),
                  blurRadius: 30,
                  offset: Offset(0, 18),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavItem(icon: Icons.home_rounded, label: 'Home', active: true),
                NavItem(icon: Icons.calendar_today_rounded, label: 'Schedule'),
                NavItem(icon: Icons.task_alt_rounded, label: 'Tasks'),
                NavItem(icon: Icons.leaderboard_rounded, label: 'Ranks'),
                NavItem(icon: Icons.person_rounded, label: 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// One item inside the floating bottom navigation bar.
class NavItem extends StatelessWidget {
  const NavItem({
    required this.icon,
    required this.label,
    this.active = false,
    super.key,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: active ? 44 : 38,
            height: active ? 34 : 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: active
                  ? const LinearGradient(
                      colors: [Color(0xFF8D5BFF), Color(0xFFFF8A3D)],
                    )
                  : null,
            ),
            child: Icon(
              icon,
              color: active
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.55),
              size: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: active
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.55),
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
