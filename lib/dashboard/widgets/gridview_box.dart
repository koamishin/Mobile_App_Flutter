import 'package:flutter/material.dart';

/// Clean Grid Dashboard Cards following Material 3 Design System.
///
/// Balanced card proportions with dynamic surface fills, high-contrast
/// tonal badges, and clear hierarchy.
class GridviewBox extends StatelessWidget {
  const GridviewBox({required this.onItemSelected, super.key});

  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cards = [
      _ItemData(
        title: 'Grades',
        stat: '3.85',
        statLabel: 'Current GPA',
        badge: 'Top 5%',
        icon: Icons.auto_graph_rounded,
        color: scheme.primary,
        containerColor: scheme.primaryContainer,
        onContainerColor: scheme.onPrimaryContainer,
        pageIndex: 1,
      ),
      _ItemData(
        title: 'Account',
        stat: '\$1,240',
        statLabel: 'Pending Balance',
        badge: 'Due Soon',
        icon: Icons.account_balance_wallet_rounded,
        color: scheme.tertiary,
        containerColor: scheme.tertiaryContainer,
        onContainerColor: scheme.onTertiaryContainer,
        pageIndex: 2,
      ),
      _ItemData(
        title: 'Attendance',
        stat: '94%',
        statLabel: 'Term Presence',
        badge: 'Excellent',
        icon: Icons.verified_user_rounded,
        color: scheme.secondary,
        containerColor: scheme.secondaryContainer,
        onContainerColor: scheme.onSecondaryContainer,
        pageIndex: 3,
      ),
      _ItemData(
        title: 'Schedule',
        stat: '4 Classes',
        statLabel: 'Next: 10:00 AM',
        badge: 'Today',
        icon: Icons.calendar_today_rounded,
        color: scheme.primary,
        containerColor: scheme.surfaceContainerHigh,
        onContainerColor: scheme.onSurface,
        pageIndex: 4,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.88,
      ),
      itemBuilder: (context, i) {
        final card = cards[i];

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onItemSelected(card.pageIndex),
            borderRadius: BorderRadius.circular(24),
            splashColor: card.color.withValues(alpha: 0.12),
            highlightColor: card.color.withValues(alpha: 0.05),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? scheme.surfaceContainerHigh
                    : scheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: scheme.outlineVariant
                      .withValues(alpha: isDark ? 0.35 : 0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: scheme.shadow
                        .withValues(alpha: isDark ? 0.18 : 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Row: Themed Icon Box + Pill Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: card.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          card.icon,
                          size: 22,
                          color: card.color,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: card.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          card.badge,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: card.color,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Bottom Info Block
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        card.stat,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                          color: card.color,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            card.statLabel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: scheme.onSurfaceVariant
                                .withValues(alpha: 0.7),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ItemData {
  const _ItemData({
    required this.title,
    required this.stat,
    required this.statLabel,
    required this.badge,
    required this.icon,
    required this.color,
    required this.containerColor,
    required this.onContainerColor,
    required this.pageIndex,
  });

  final String title;
  final String stat;
  final String statLabel;
  final String badge;
  final IconData icon;
  final Color color;
  final Color containerColor;
  final Color onContainerColor;
  final int pageIndex;
}
