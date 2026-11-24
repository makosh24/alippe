import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AquariumBackground extends StatefulWidget {
  final Widget child;

  const AquariumBackground({Key? key, required this.child}) : super(key: key);

  @override
  State<AquariumBackground> createState() => _AquariumBackgroundState();
}

class _AquariumBackgroundState extends State<AquariumBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF7BE7FF),
            Color(0xFF1E88E5),
            Color(0xFF0A3A66),
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.2),
                radius: 0.9,
                colors: [
                  Color(0x66FFF4C2),
                  Color(0x00000000),
                ],
              ),
            ),
          ),
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final side = min(constraints.maxWidth, constraints.maxHeight) * 0.96;
                return Container(
                  width: side,
                  height: side,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: const Color(0xF2FFFFFF), width: 7),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xAA7DF9FF),
                        blurRadius: 36,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Transform.scale(
                    scale: 2.45,
                    child: Lottie.asset(
                      'assets/images/blue-aquarium.json',
                      fit: BoxFit.cover,
                      repeat: true,
                    ),
                  ),
                );
              },
            ),
          ),
          IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: _BubblePainter(_controller.value),
                );
              },
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _BubblePainter extends CustomPainter {
  _BubblePainter(this.t);

  final double t;

  static final List<_Bubble> _bubbles = List.generate(22, (index) {
    final random = Random(index * 17 + 3);
    return _Bubble(
      x: random.nextDouble(),
      radius: 6 + random.nextDouble() * 16,
      speed: 0.35 + random.nextDouble() * 0.8,
      phase: random.nextDouble(),
    );
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = const Color(0x88FFFFFF);
    final stroke = Paint()
      ..color = const Color(0xEEFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (final bubble in _bubbles) {
      final progress = (t * bubble.speed + bubble.phase) % 1;
      final dx = bubble.x * size.width;
      final dy = size.height * (1 - progress) - bubble.radius;
      canvas.drawCircle(Offset(dx, dy), bubble.radius, fill);
      canvas.drawCircle(Offset(dx, dy), bubble.radius, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant _BubblePainter oldDelegate) => oldDelegate.t != t;
}

class _Bubble {
  final double x;
  final double radius;
  final double speed;
  final double phase;

  const _Bubble({
    required this.x,
    required this.radius,
    required this.speed,
    required this.phase,
  });
}
