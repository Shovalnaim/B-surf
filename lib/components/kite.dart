import 'package:flutter/material.dart';
import 'dart:math' as math;

class Kite extends StatefulWidget {
  const Kite({super.key});

  @override
  State<Kite> createState() => _KiteState();
}

class _KiteState extends State<Kite> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(seconds: 80),
  )..repeat();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: Center(
              child: CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('lib/images/cabrinaa.jpg'),
              ),
            ));
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}