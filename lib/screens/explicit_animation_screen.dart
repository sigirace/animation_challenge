import 'package:flutter/material.dart';

class ExplicitAnimationScreen extends StatefulWidget {
  const ExplicitAnimationScreen({super.key});

  @override
  State<ExplicitAnimationScreen> createState() =>
      _ExplicitAnimationScreenState();
}

class _ExplicitAnimationScreenState extends State<ExplicitAnimationScreen>
    with TickerProviderStateMixin {
  final int _boxCount = 25;
  final int _crossAxisCount = 5;
  final int _delayBetweenBoxes = 100;

  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      _boxCount,
      (index) {
        return AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 500),
        );
      },
    );

    _animations = _controllers
        .map((controller) => Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(controller))
        .toList();

    _startZigzagAnimation();
  }

  Future<void> _startZigzagAnimation() async {
    while (mounted) {
      final zigzagOrder = _getZigzagOrder();

      for (var i = 0; i < zigzagOrder.length; i++) {
        Future.delayed(
          Duration(milliseconds: i * _delayBetweenBoxes),
          () async {
            final index = zigzagOrder[i];
            final controller = _controllers[index];

            await controller.forward();
            await controller.reverse();
          },
        );
      }

      await Future.delayed(
        Duration(milliseconds: zigzagOrder.length * _delayBetweenBoxes + 500),
      );
    }
  }

  List<int> _getZigzagOrder() {
    List<int> order = [];

    for (int row = _crossAxisCount - 1; row >= 0; row--) {
      List<int> rowIndexes = [];

      for (int col = 0; col < _crossAxisCount; col++) {
        int index = row * _crossAxisCount + col;
        rowIndexes.add(index);
      }

      if (row % 2 == 0) {
        rowIndexes = rowIndexes.reversed.toList();
      }

      order.addAll(rowIndexes);
    }

    return order;
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explicit Animation')),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: GridView.count(
              crossAxisCount: _crossAxisCount,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              shrinkWrap: true,
              children: List.generate(
                _boxCount,
                (index) {
                  return FadeTransition(
                    opacity: _animations[index],
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
