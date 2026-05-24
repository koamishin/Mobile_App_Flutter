import 'package:flutter/material.dart';

class GridviewBox extends StatelessWidget {
  const GridviewBox({super.key});

  @override
  Widget build(BuildContext context) {
    // List of items for the grid with rich, non-pastel vibrant gradients and pure white text/icons
    final List<GridItemData> items = [
      GridItemData(
        title: 'Grades',
        icon: Icons.assessment_rounded,
        textColor: Colors.white,
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 176, 130, 255),
            Color.fromARGB(255, 176, 128, 255),
          ], // Rich Royal Purple
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      GridItemData(
        title: 'Balance',
        icon: Icons.account_balance_wallet_rounded,
        textColor: Colors.white,
        gradient: const LinearGradient(
          colors: [Color(0xFF0D9488), Color(0xFF0F766E)], // Rich Teal
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      GridItemData(
        title: 'Attendance',
        icon: Icons.how_to_reg_rounded,
        textColor: Colors.white,
        gradient: const LinearGradient(
          colors: [Color(0xFFEA580C), Color(0xFFC2410C)], // Rich Coral/Orange
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      GridItemData(
        title: 'Schedule',
        icon: Icons.calendar_month_rounded,
        textColor: Colors.white,
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)], // Rich Royal Blue
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: item.gradient,
            boxShadow: [
              BoxShadow(
                color: item.gradient.colors.first.withValues(alpha: 0.25),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Premium Overlapping Texture in the Upper Left in subtle white highlights
                Positioned(
                  top: -20,
                  left: -20,
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                ),
                Positioned(
                  top: -6,
                  left: -32,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                Positioned(
                  top: -34,
                  left: 12,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                ),

                // Card Content - Positioned.fill guarantees the Column occupies the full space
                // allowing perfect horizontal and vertical centering.
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          item.icon,
                          color: item.textColor,
                          size: 48, // Visually balanced large size
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.title,
                          style: TextStyle(
                            color: item.textColor,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.2,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class GridItemData {
  final String title;
  final IconData icon;
  final Color textColor;
  final LinearGradient gradient;

  GridItemData({
    required this.title,
    required this.icon,
    required this.textColor,
    required this.gradient,
  });
}
