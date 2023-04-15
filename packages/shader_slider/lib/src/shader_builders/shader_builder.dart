import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:shader_slider/src/extensions/extensions.dart';

class ShaderBuilderPage extends StatefulWidget {
  const ShaderBuilderPage({
    Key? key,
    required this.imagesPaths,
    this.sliderHeight = 300.0,
  }) : super(key: key);

  final List<String> imagesPaths;
  final double sliderHeight;

  @override
  State<ShaderBuilderPage> createState() => _ShaderBuilderPageState();
}

class _ShaderBuilderPageState extends State<ShaderBuilderPage> {
  var updateTime = 0.0;
  late Timer timer;

  ui.FragmentProgram? program;

  List<ui.Image> images = [];

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

  var current = 0;
  var next = 1;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return program != null
          ? Center(
              child: RepaintBoundary(
                child: SizedBox(
                  height: widget.sliderHeight,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _ShaderPainter(
                      program!.fragmentShader(),
                      images[current],
                      images[next],
                      updateTime,
                      widget.sliderHeight,
                    ),
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            );
    });
  }

  void _initShader() async {
    for (var e in widget.imagesPaths) {
      images.add(await context.loadUiImage(e));
    }

    program =
        await ui.FragmentProgram.fromAsset("shaders/square_transition.frag");

    setState(() {});
  }
}

class _ShaderPainter extends CustomPainter {
  _ShaderPainter(this.shader, this.image1, this.image2, this.updateTime,
      this.sliderHeight);

  final ui.FragmentShader shader;
  final ui.Image image1;
  final ui.Image image2;
  final double updateTime;
  final double sliderHeight;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, 300)
      ..setFloat(2, updateTime)
      ..setImageSampler(0, image1)
      ..setImageSampler(1, image2);

    final Rect rect = Rect.fromLTWH(0, 0, size.width, sliderHeight);

    final Paint paint = Paint()..shader = shader;
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
