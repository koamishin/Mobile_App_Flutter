import 'package:flutter/material.dart';

import 'dashboard/widgets/gridview_box.dart';
import 'dashboard/widgets/greeting_box.dart';
import 'dashboard/widgets/navbar_top.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Emberly',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontWeight: FontWeight.w900),
          headlineMedium: TextStyle(fontWeight: FontWeight.w800),
          bodyLarge: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: Color.fromARGB(255, 203, 229, 255),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomNavBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const GreetingBox(),
                        const SizedBox(height: 24),
                        const Text(
                          'Dashboard Actions',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Color.fromARGB(255, 89, 89, 89),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const GridviewBox(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
