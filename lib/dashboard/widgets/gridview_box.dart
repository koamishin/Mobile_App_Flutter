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
      // Explicit aspect ratio so cards have enough vertical room for
      // icon + title + "View" button without overflowing.
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.82,
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Decorative bubbles
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
                // Content — uses a Column with mainAxisAlignment.spaceBetween
                // so children self-distribute within the available height
                // (defined by childAspectRatio) and never overflow.
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top: icon
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          item[1] as IconData,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                      // Bottom: title + button
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              key: ValueKey(
                                'home-view-${title.toLowerCase()}',
                              ),
                              onPressed: () => onItemSelected(pageIndex),
                              style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                                minimumSize: const Size.fromHeight(40),
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('View'),
                            ),
                          ),
                        ],
                      ),
                    ],
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
