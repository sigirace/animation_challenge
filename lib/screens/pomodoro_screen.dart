import 'dart:math';

import 'package:animation_challenge/utils/time_util.dart';
import 'package:flutter/material.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progressAnimation;
  late final CurvedAnimation _curvedAnimation;
  final Duration _duration = const Duration(seconds: 15);
  int _currentIndex = 0;
  bool _isPlaying = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _duration,
    );
    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
    _progressAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_curvedAnimation);
  }

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      // Reset
      setState(() {
        _isPlaying = false;
      });
      _controller.reset();
    } else if (index == 1) {
      // Play
      if (_controller.value == 1.0) {
        return;
      }
      if (_isPlaying) {
        _controller.stop();
      } else {
        _controller.forward();
      }
      setState(() {
        _isPlaying = !_isPlaying;
      });
    } else if (index == 2) {
      // Stop
      setState(() {
        _isPlaying = false;
      });
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final circleSize = size.width * 0.5;
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            return CustomPaint(
              painter: PomodoroPainter(
                progress: _controller.value,
                duration: _duration,
                isPlaying: _isPlaying,
              ),
              size: Size(circleSize, circleSize),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.restart_alt,
              size: 36,
              color: _currentIndex == 0 ? Colors.black : Colors.grey,
            ),
            label: 'Reset',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              size: 36,
              color: _currentIndex == 1 ? Colors.black : Colors.grey,
            ),
            label: 'Play',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.stop,
              size: 36,
              color: _currentIndex == 2 ? Colors.black : Colors.grey,
            ),
            label: 'Stop',
          ),
        ],
      ),
    );
  }
}

class PomodoroPainter extends CustomPainter {
  final double progress;
  final Duration duration;
  final bool isPlaying;

  PomodoroPainter({
    required this.progress,
    required this.duration,
    required this.isPlaying,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final strokeWidth = 24.0;
    final startAngle = 3 / 2 * pi;

    final greyRadius = size.width * 0.8;
    final greyPaint = Paint()
      ..color = Colors.grey.withAlpha(50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, greyRadius, greyPaint);

    final redArcRect = Rect.fromCircle(center: center, radius: greyRadius);

    final redArcPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      redArcRect,
      startAngle,
      (1 - progress) * 2 * pi,
      false,
      redArcPaint,
    );

    final remainingTime = duration * (1 - progress);
    final remainingSeconds = remainingTime.inSeconds;

    TextStyle textStyle = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );

    bool shouldBlink = isPlaying && remainingSeconds <= 10;
    bool shouldScale = isPlaying && remainingSeconds <= 5;

    double fontSize = 32;
    if (shouldScale) {
      double scaleProgress =
          sin(DateTime.now().millisecondsSinceEpoch / 150) * 0.5 + 1.0;
      fontSize *= scaleProgress;
    }

    textStyle = textStyle.copyWith(fontSize: fontSize);

    final textSpan = TextSpan(
      text: remainingSeconds > 0 ? getTimerString(remainingTime) : "00:00",
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, textOffset);

    if (shouldBlink) {
      final backgroundPaint = Paint()
        ..color = Colors.red.withOpacity(
          0.3 * (sin(DateTime.now().millisecondsSinceEpoch / 200) * 0.5 + 0.5),
        );
      canvas.drawCircle(center, greyRadius - strokeWidth / 2, backgroundPaint);
    }
  }

  @override
  bool shouldRepaint(covariant PomodoroPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isPlaying != isPlaying;
  }
}
