import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

class Example2Page extends StatefulWidget {
  const Example2Page({Key? key}) : super(key: key);

  @override
  State<Example2Page> createState() => _Example2PageState();
}

class _Example2PageState extends State<Example2Page> {
  var updateTime = 0.0;
  late Timer timer;

  ui.Image? image1;
  ui.Image? image2;
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
    timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      setState(() {
        updateTime += 1 / 60;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return program != null && image1 != null
          ? CustomPaint(
              size: MediaQuery.of(context).size,
              painter: _ShaderPainter(
                  program!.fragmentShader(), image1!, image2!, updateTime),
            )
          : const Center(
              child: CircularProgressIndicator(),
            );
    });
  }

  void _initShader() async {
    final imageData = await rootBundle.load('assets/bird.jpg');
    image1 = await decodeImageFromList(imageData.buffer.asUint8List());
    final imageData2 = await rootBundle.load('assets/tower.jpg');
    image2 = await decodeImageFromList(imageData2.buffer.asUint8List());

    program = await ui.FragmentProgram.fromAsset("shaders/test_3.frag");

    setState(() {});
  }
}

class _ShaderPainter extends CustomPainter {
  _ShaderPainter(this.shader, this.image, this.image2, this.updateTime);

  final ui.FragmentShader shader;
  final ui.Image image;
  final ui.Image image2;
  final double updateTime;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, updateTime)
      ..setImageSampler(0, image)
      ..setImageSampler(1, image2);

    const Rect rect = Rect.largest;

    final Paint paint = Paint()..shader = shader;
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
