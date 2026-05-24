import 'dart:ui';
import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 12,
          sigmaY: 12,
        ), // Glassmorphism frosted effect
        child: Container(
          height: 80,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
          decoration: BoxDecoration(
            color: const Color(
              0xFFF7FBFF,
            ).withValues(alpha: 0.35), // Transparent Ice White
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF5DAEFF,
                ).withValues(alpha: 0.08), // Soft sky blue shadow
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Side: Profile Picture and Welcome Text
                Row(
                  children: [
                    // Profile Picture Placeholder with Primary Blue -> Deep Accent Blue gradient ring
                    Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF5DAEFF),
                            Color(0xFF2F80ED),
                          ], // Primary Blue to Deep Accent Blue
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF5DAEFF,
                            ).withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(2.5),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFF2F80ED),
                                child: const Center(
                                  child: Text(
                                    'SJ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Greetings Column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 2),
                        const Text(
                          'Sarah Jenkins',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 50, 50, 50), // Deep Navy
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Right Side: Notification Icon with Badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF5DAEFF).withValues(
                          alpha: 0.15,
                        ), // Primary Blue transparent tint
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          color: Color(0xFF2F80ED), // Deep Accent Blue
                          size: 26,
                        ),
                        onPressed: () {
                          // Notification actions
                        },
                      ),
                    ),
                    // Glowing indicator for notifications in Soft Peach matching the accent colors
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD6B3), // Peach accent color
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFFFD6B3,
                              ).withValues(alpha: 0.6),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
