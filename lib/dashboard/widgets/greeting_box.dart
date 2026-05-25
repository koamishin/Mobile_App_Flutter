import 'package:flutter/material.dart';

class GreetingBox extends StatelessWidget {
  const GreetingBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/img/bg-greetings.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.25),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),

      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -40,
            right: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),

          Positioned(
            bottom: -60,
            left: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),

          // Content
          Row(
            children: [
              // LEFT SIDE
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,\nSarah! 👋',
                      style: const TextStyle(
                        fontFamily: 'Emberly',
                        fontSize: 48,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      'Keep up the excellent work!\nYou have 4 classes and\n2 assignments due today.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        height: 1.6,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.88),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // RIGHT SIDE GRAPHIC
            ],
          ),
        ],
      ),
    );
  }
}
