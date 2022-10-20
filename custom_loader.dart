import 'dart:math' as math;

import 'package:flutter/material.dart';

class CustomLoader extends StatefulWidget {
  const CustomLoader({super.key});

  @override
  State<CustomLoader> createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _animation = Tween(begin: -math.pi, end: math.pi).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Custom Loader"),
      ),
      body: Center(
        child: SizedBox(
          width: 60,
          height: 60,
          child: AnimatedBuilder(
            builder: (context, child) {
              return CustomPaint(
                painter: LoaderPainter(colors: [
                  const Color(0xFF34A853),
                  const Color(0xFFEA4335),
                  const Color(0xFF4285F4),
                  const Color(0xFFFBBC05),
                ], animation: _animation.value),
              );
            },
            animation: _animation,
          ),
        ),
      ),
    );
  }
}

class LoaderPainter extends CustomPainter {
  LoaderPainter({required this.colors, required this.animation});
  final List<Color> colors;
  final double animation;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );

    var startAngle = animation;
    final sweepAngle = math.pi * 2 / colors.length;

    for (var color in colors) {
      paint.color = color;
      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle + animation.clamp(-math.pi, 0),
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
