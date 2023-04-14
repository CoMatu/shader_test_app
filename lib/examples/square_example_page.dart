import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class SquareExamplePage extends StatefulWidget {
  const SquareExamplePage({Key? key}) : super(key: key);

  @override
  State<SquareExamplePage> createState() => _SquareExamplePageState();
}

class _SquareExamplePageState extends State<SquareExamplePage> {
  var updateTime = 0.0;
  late Timer timer;

  ui.FragmentProgram? program;

  @override
  void initState() {
    super.initState();
    _initTimer();
    _initShader();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _initTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        updateTime += 1 / 60;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return program != null
          ? SizedBox(
              child: CustomPaint(
                size: MediaQuery.of(context).size,
                painter: _ShaderPainter(program!.fragmentShader(), updateTime),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            );
    });
  }

  void _initShader() async {
    program = await ui.FragmentProgram.fromAsset("shaders/test_2.frag");

    setState(() {});
  }
}

class _ShaderPainter extends CustomPainter {
  _ShaderPainter(this.shader, this.updateTime);

  final ui.FragmentShader shader;
  final double updateTime;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, updateTime) /*  ..setImageSampler(0, image) */;

    const Rect rect = Rect.largest;

    final Paint paint = Paint()..shader = shader;
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
