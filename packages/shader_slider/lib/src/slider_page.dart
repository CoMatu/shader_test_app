import 'package:flutter/material.dart';
import 'package:shader_slider/src/shader_builders/shader_builder.dart';

class ShaderSlider extends StatelessWidget {
  const ShaderSlider({super.key, required this.imagesPaths});

  final List<String> imagesPaths;

  @override
  Widget build(BuildContext context) {
    return ShaderBuilderPage(
      imagesPaths: imagesPaths,
    );
  }
}
