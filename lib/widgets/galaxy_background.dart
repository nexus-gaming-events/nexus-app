import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nexus_app/constants.dart';

class GalaxyBackground extends StatefulWidget {
  final Widget child;

  const GalaxyBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<GalaxyBackground> createState() => _GalaxyBackgroundState();
}

class _GalaxyBackgroundState extends State<GalaxyBackground>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double _time = 0.0;
  ui.FragmentShader? _shader;

  @override
  void initState() {
    super.initState();
    _loadShader();
    _ticker = createTicker(_onTick)..start();
  }

  Future<void> _loadShader() async {
    // Skip shader loading in debug mode to avoid compilation issues
    if (kDebugMode) {
      return;
    }
    
    try {
      final program = await ui.FragmentProgram.fromAsset('shaders/galaxy.frag');
      setState(() {
        _shader = program.fragmentShader();
      });
    } catch (e) {
      debugPrint('Failed to load shader: $e');
    }
  }

  void _onTick(Duration elapsed) {
    setState(() {
      _time = elapsed.inMilliseconds / 1000.0;
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    _shader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_shader == null) {
      // Show a simple gradient while shader loads
      return Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 1.0,
            colors: [
              AppConstants.primaryBackgroundColor,
              AppConstants.secondaryBackgroundColor,
            ],
          ),
        ),
        child: widget.child,
      );
    }

    return CustomPaint(
      painter: _GalaxyPainter(
        shader: _shader!,
        time: _time,
      ),
      child: widget.child,
    );
  }
}

class _GalaxyPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final double time;

  _GalaxyPainter({
    required this.shader,
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, time);

    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _GalaxyPainter oldDelegate) {
    return oldDelegate.time != time;
  }
}
