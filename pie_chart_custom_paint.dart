import 'dart:math' as math;

import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pie Chart"),
      ),
      body: Center(
        child: Row(
          children: [
            Expanded(
              child: RichText(
                textAlign: TextAlign.end,
                text: const TextSpan(
                  text: "988",
                  children: [
                    TextSpan(text: "\nFollowes"),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 150,
              width: 150,
              child: CustomPaint(
                painter: PiePainter(stats: [
                  PieValue(value: 988, color: const Color(0xffa79df1)),
                  PieValue(value: 1282, color: const Color(0xFF6c5ce7)),
                ]),
              ),
            ),
            Expanded(
              child: RichText(
                textAlign: TextAlign.start,
                text: const TextSpan(
                  text: "988",
                  children: [
                    TextSpan(text: "\nFollowes"),
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

//Data Class for holding the value for the stat
class PieValue {
  final double value;
  final Color color;

  PieValue({required this.value, required this.color});
}

class PiePainter extends CustomPainter {
  PiePainter({required this.stats});
  final List<PieValue> stats;

  @override
  void paint(Canvas canvas, Size size) {
    //Short Hand
    final width = size.width;
    final height = size.height;

    final paint = Paint()..style = PaintingStyle.fill;

    //Rectangle object required for drawArc method
    final rect = Rect.fromCenter(
        center: Offset(width / 2, height / 2), width: width, height: height);

    //Sum is used to calculate the radian of each stats
    final sum = stats.fold(
      0.0,
      (previousValue, element) => previousValue + element.value,
    );

    //Used this to change startAngle after drawing each arc
    double totalRadian = 0.0;

    for (var stat in stats) {
      paint.color = stat.color;

      // Calculate degree by (value/sum) * 360 = degree
      // and to convert degree we can do degree * (pi/180)
      final sweepAngle = (stat.value / sum) * 360 * (math.pi / 180);

      double startAngle = (-math.pi / 2) + totalRadian;

      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      totalRadian += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
