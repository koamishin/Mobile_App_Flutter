import 'package:flutter/material.dart';

class TimeLabel extends StatelessWidget {
  final String time;
  final bool isActive;

  const TimeLabel({
    required this.time,
    this.isActive = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF2F80ED).withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        time,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
          color: isActive ? const Color(0xFF2F80ED) : const Color(0xFF8696A8),
        ),
      ),
    );
  }
}
