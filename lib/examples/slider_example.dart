import 'package:flutter/material.dart';
import 'package:shader_slider/shader_slider.dart';

class SliderExample extends StatelessWidget {
  const SliderExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ShaderSlider(
      imagesPaths: [
        'assets/bird.jpg',
        'assets/tower.jpg',
        'assets/sky_1.jpg',
        'assets/dash.png',
      ],
    );
  }
}
