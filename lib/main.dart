import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  var updateTime = 0.0;

  ui.Image? image;

  @override
  void initState() {
    super.initState();
    createTicker((elapsed) {
      updateTime = elapsed.inMilliseconds / 1000;
      setState(() {});
    }).start();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<ui.FragmentProgram>(
          future: _initShader(),
          builder: (context, snapshot) {
            if (snapshot.hasData && image != null) {
              final shader = snapshot.data!.fragmentShader();
              return CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: _ShaderPainter(shader, image!, updateTime));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Future<ui.FragmentProgram> _initShader() async {
    final imageData = await rootBundle.load('assets/sky_1.jpg');
    image = await decodeImageFromList(imageData.buffer.asUint8List());

    final program = await ui.FragmentProgram.fromAsset("shaders/test_2.frag");

    return program;
  }
}

class _ShaderPainter extends CustomPainter {
  _ShaderPainter(this.shader, this.image, this.updateTime);

  final ui.FragmentShader shader;
  final ui.Image image;
  final double updateTime;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, updateTime)
      ..setImageSampler(0, image);

    const Rect rect = Rect.largest;

    final Paint paint = Paint()..shader = shader;
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
