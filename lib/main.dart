import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shader_slider/shader_slider.dart';
import 'package:shader_test_app/examples/example2_page.dart';
import 'package:shader_test_app/examples/slider_example.dart';
import 'package:shader_test_app/examples/transition_example_page.dart';
import 'package:shader_test_app/examples/square_example_page.dart';

import 'examples/example3_page.dart';

void main() {
  debugRepaintRainbowEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Builder(builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _ButtonWidget(
                title: 'Квадратики',
                child: SquareExamplePage(),
              ),
              _ButtonWidget(
                title: 'Смена картинок',
                child: TransitionExamplePage(),
              ),
              _ButtonWidget(
                title: 'Смена картинок 2',
                child: Example2Page(),
              ),
              _ButtonWidget(
                title: 'Смена цвета',
                child: Example3Page(),
              ),
              _ButtonWidget(
                title: 'Слайдер',
                child: SliderExample(),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _ButtonWidget extends StatelessWidget {
  const _ButtonWidget({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => child));
              },
              child: Text(title),
            ),
          ),
        ),
      ],
    );
  }
}
