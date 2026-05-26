import 'package:flutter/material.dart';

import '../widgets/gridview_box.dart';
import '../widgets/greeting_box.dart';
import '../widgets/navbar_top.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.onDashboardCardSelected, super.key});

  final ValueChanged<int> onDashboardCardSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFCFE8FF),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomNavBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const GreetingBox(),
                    const SizedBox(height: 24),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dashboard',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Color.fromARGB(255, 89, 89, 89),
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'Quick Overview',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(94, 107, 225, 1),
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GridviewBox(onItemSelected: onDashboardCardSelected),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
