import 'package:flutter/material.dart';

class GridviewBox extends StatelessWidget {
  const GridviewBox({required this.onItemSelected, super.key});

  final ValueChanged<int> onItemSelected;

  final items = const [
    [
      'Grades',

      Icons.assessment_rounded,
      [Color.fromARGB(255, 182, 140, 255), Color(0xFFA269FF)],
      1,
    ],
    [
      'Balance',
      Icons.monetization_on_rounded,
      [Color.fromARGB(255, 81, 179, 170), Color.fromARGB(255, 73, 192, 182)],
      2,
    ],
    [
      'Attendance',
      Icons.how_to_reg_rounded,
      [Color(0xFFFFAE82), Color(0xFFF77E4E)],
      3,
    ],
    [
      'Schedule',
      Icons.calendar_month_rounded,
      [Color.fromARGB(255, 111, 155, 250), Color.fromARGB(255, 125, 125, 255)],
      4,
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemBuilder: (_, i) {
        final item = items[i];
        final gradient = LinearGradient(
          colors: item[2] as List<Color>,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        final title = item[0] as String;
        final pageIndex = item[3] as int;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: gradient,
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withValues(alpha: .25),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              ...[
                [-20.0, -20.0, 54.0, .15],
                [-6.0, -32.0, 48.0, .10],
                [-34.0, 12.0, 40.0, .06],
              ].map(
                (e) => Positioned(
                  top: e[0],
                  left: e[1],
                  child: Container(
                    width: e[2],
                    height: e[2],
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: e[3]),
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          // gradient: gradient,
                          color: Colors.white.withValues(alpha: .15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          item[1] as IconData,
                          color: Colors.white,
                          size: 70,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: ElevatedButton(
                          key: ValueKey('home-view-${title.toLowerCase()}'),
                          onPressed: () => onItemSelected(pageIndex),
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                            ),
                            minimumSize: const Size.fromHeight(48),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text('View'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
