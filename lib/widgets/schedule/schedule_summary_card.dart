import 'package:flutter/material.dart';
import '../../models/schedule_model.dart';

class ScheduleSummaryCard extends StatelessWidget {
  final ScheduleStatistics stats;

  const ScheduleSummaryCard({
    required this.stats,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Daily Overview',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF27364A),
              ),
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.45,
            children: [
              _buildMiniMetricCard(
                title: 'Total Classes',
                value: '${stats.totalClasses}',
                icon: Icons.school_rounded,
                colors: [const Color(0xFF9B7BFF), const Color(0xFF6D5DFB)],
              ),
              _buildMiniMetricCard(
                title: 'Free Periods',
                value: '${stats.freePeriods} hrs',
                icon: Icons.spa_rounded,
                colors: [const Color(0xFF51B3AA), const Color(0xFF32A89D)],
              ),
              _buildMiniMetricCard(
                title: 'Total Hours',
                value: '${stats.totalHours.toStringAsFixed(stats.totalHours % 1 == 0 ? 0 : 1)} hrs',
                icon: Icons.timer_rounded,
                colors: [const Color(0xFFFFB86B), const Color(0xFFFF8E53)],
              ),
              _buildMiniMetricCard(
                title: 'Top Subject',
                value: stats.mostFrequentSubject,
                icon: Icons.star_rounded,
                colors: [const Color(0xFF5DAEFF), const Color(0xFF2F80ED)],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required List<Color> colors,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.22),
            blurRadius: 12,
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
              Icon(icon, color: Colors.white, size: 24),
              Icon(
                Icons.trending_up_rounded,
                color: Colors.white.withValues(alpha: 0.4),
                size: 16,
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white.withValues(alpha: 0.88),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
