import 'package:flutter/material.dart';

class FloatingNavigation extends StatelessWidget {
  const FloatingNavigation({
    required this.selectedIndex,
    required this.onItemSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  static const List<_NavigationItem> _items = [
    _NavigationItem(icon: Icons.home_rounded, label: 'Home'),
    _NavigationItem(icon: Icons.assessment_rounded, label: 'Grades'),
    _NavigationItem(icon: Icons.monetization_on_rounded, label: 'Balance'),
    _NavigationItem(icon: Icons.how_to_reg_rounded, label: 'Attend'),
    _NavigationItem(icon: Icons.calendar_month_rounded, label: 'Schedule'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2F80ED).withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final isSelected = selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              key: ValueKey('nav-${item.label.toLowerCase()}'),
              onTap: () => onItemSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFDDF0FF)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      color: isSelected
                          ? const Color(0xFF2F80ED)
                          : const Color(0xFF9AA8B8),
                      size: 26,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? const Color(0xFF2F80ED)
                            : const Color(0xFF9AA8B8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavigationItem {
  const _NavigationItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
