import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Customized Material 3 Bottom Navigation Bar.
///
/// Features:
/// - Fully theme-adaptive: uses ColorScheme tokens (surfaceContainer, primary,
///   secondaryContainer, onSecondaryContainer, onSurfaceVariant, outlineVariant)
/// - Floating pill container with frosted backdrop blur
/// - Animated pill indicator that slides smoothly between items
/// - Scale + vertical shift micro-interaction on selected icon
/// - Subtle elevation and top border highlight matching M3 tonal specs
class StandardBottomNav extends StatelessWidget {
  const StandardBottomNav({
    required this.selectedIndex,
    required this.onItemSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  static const List<_NavDestination> _destinations = [
    _NavDestination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _NavDestination(
      icon: Icons.assessment_outlined,
      selectedIcon: Icons.assessment_rounded,
      label: 'Grades',
    ),
    _NavDestination(
      icon: Icons.account_balance_wallet_outlined,
      selectedIcon: Icons.account_balance_wallet_rounded,
      label: 'Balance',
    ),
    _NavDestination(
      icon: Icons.how_to_reg_outlined,
      selectedIcon: Icons.how_to_reg_rounded,
      label: 'Attend',
    ),
    _NavDestination(
      icon: Icons.calendar_month_outlined,
      selectedIcon: Icons.calendar_month_rounded,
      label: 'Schedule',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 6,
        bottom: bottomInset > 0 ? bottomInset : 12,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: scheme.surfaceContainer.withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: scheme.outlineVariant.withValues(alpha: 0.35),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: scheme.shadow.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                final itemCount = _destinations.length;
                final itemWidth = totalWidth / itemCount;

                return Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // Sliding indicator pill (Material 3 secondaryContainer style)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.fastOutSlowIn,
                      left: selectedIndex * itemWidth + (itemWidth - 56) / 2,
                      top: 8,
                      width: 56,
                      height: 32,
                      child: Container(
                        decoration: BoxDecoration(
                          color: scheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),

                    // Destination items row
                    Row(
                      children: List.generate(itemCount, (index) {
                        final item = _destinations[index];
                        final isSelected = selectedIndex == index;

                        return Expanded(
                          child: _NavItem(
                            item: item,
                            isSelected: isSelected,
                            scheme: scheme,
                            onTap: () {
                              if (index != selectedIndex) {
                                HapticFeedback.selectionClick();
                                onItemSelected(index);
                              }
                            },
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.scheme,
    required this.onTap,
  });

  final _NavDestination item;
  final bool isSelected;
  final ColorScheme scheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: scheme.primary.withValues(alpha: 0.12),
        highlightColor: scheme.primary.withValues(alpha: 0.06),
        child: SizedBox(
          height: 68,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon container with height matching indicator (32dp)
              SizedBox(
                height: 32,
                child: Center(
                  child: AnimatedScale(
                    scale: isSelected ? 1.08 : 1.0,
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutBack,
                    child: Icon(
                      isSelected ? item.selectedIcon : item.icon,
                      size: 22,
                      color: isSelected
                          ? scheme.onSecondaryContainer
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              // Label with animated weight & color
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.1,
                  color: isSelected
                      ? scheme.onSurface
                      : scheme.onSurfaceVariant,
                ),
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavDestination {
  const _NavDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
