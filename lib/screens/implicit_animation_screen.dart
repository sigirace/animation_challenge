import 'dart:async';
import 'package:flutter/material.dart';

class ImplicitAnimationScreen extends StatefulWidget {
  const ImplicitAnimationScreen({super.key});

  @override
  State<ImplicitAnimationScreen> createState() =>
      _ImplicitAnimationScreenState();
}

class _ImplicitAnimationScreenState extends State<ImplicitAnimationScreen> {
  bool forward = false;
  bool reverseState = false;
  final duration = const Duration(seconds: 1);
  final shortDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startInitialAnimation();
    _loopAnimation();
  }

  void _startInitialAnimation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      setState(() {
        forward = !forward;
      });
    });
  }

  Future<void> _loopAnimation() async {
    while (mounted) {
      await Future.delayed(duration);

      if (!mounted) break;

      setState(() {
        forward = !forward;
        reverseState = !reverseState;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Implicit Animation with Timer'),
      ),
      body: AnimatedContainer(
        duration: shortDuration,
        width: size.width,
        height: size.height,
        color: reverseState ? Colors.white : Colors.black,
        child: Center(
          child: AnimatedContainer(
            duration: shortDuration,
            width: size.width * 0.5,
            height: size.width * 0.5,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: reverseState ? BoxShape.circle : BoxShape.rectangle,
            ),
            child: AnimatedAlign(
              duration: duration,
              alignment: forward ? Alignment.centerRight : Alignment.centerLeft,
              curve: Curves.easeInOut,
              child: Container(
                width: size.width * 0.02,
                height: size.width * 0.5,
                decoration: BoxDecoration(
                  color: reverseState ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
