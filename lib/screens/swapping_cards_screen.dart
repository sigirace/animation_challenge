import 'dart:math';

import 'package:animation_challenge/data/card_data.dart';
import 'package:flutter/material.dart';

class CardSwapScreen extends StatefulWidget {
  const CardSwapScreen({super.key});

  @override
  State<CardSwapScreen> createState() => _CardSwapScreenState();
}

class _CardSwapScreenState extends State<CardSwapScreen>
    with TickerProviderStateMixin {
  int _index = 1;
  late final size = MediaQuery.of(context).size;
  late final AnimationController _position = AnimationController(
    vsync: this,
    lowerBound: (size.width + 100) * -1,
    upperBound: size.width + 100,
    value: 0,
    duration: Duration(seconds: 3),
  );

  late final AnimationController _flip = AnimationController(
    vsync: this,
    duration: Duration(seconds: 1),
  );

  late final Animation<double> _flipAnimation;

  late final TweenSequence<Color?> _colorTween = TweenSequence<Color?>([
    TweenSequenceItem(
      tween: ColorTween(
        begin: Colors.red.shade300,
        end: Colors.blue.shade300,
      ),
      weight: 50,
    ),
    TweenSequenceItem(
      tween: ColorTween(
        begin: Colors.blue.shade300,
        end: Colors.green.shade300,
      ),
      weight: 50,
    ),
  ]);

  late final ColorTween _flipColorTween = ColorTween(
    begin: Colors.white,
    end: const Color.fromARGB(221, 70, 70, 70),
  );

  late final Tween<double> _rotation = Tween(
    begin: -15,
    end: 15,
  );

  late final Tween<double> _scale = Tween(
    begin: 0.8,
    end: 1,
  );

  @override
  void initState() {
    super.initState();
    _flipAnimation = Tween<double>(begin: 0.0, end: pi)
        .animate(CurvedAnimation(parent: _flip, curve: Curves.easeInOut));
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = size.width - 150;
    if (_position.value.abs() > bound) {
      final factor = _position.value.isNegative ? -1 : 1;
      _position
          .animateTo(
        (size.width + 100) * factor,
        curve: Curves.easeOut,
      )
          .whenComplete(() {
        _position.value = 0;
        setState(() {
          _index = _index == 5 ? 1 : _index + 1;
          _flip.value = 0;
        });
      });
    } else {
      _position.animateTo(0, curve: Curves.bounceOut);
    }
  }

  void _onTap() {
    if (_flip.isAnimating) return;

    if (_flip.status == AnimationStatus.completed) {
      _flip.reverse();
    } else {
      _flip.forward();
    }
  }

  @override
  void dispose() {
    _position.dispose();
    _flip.dispose();
    super.dispose();
  }

  Color _getBrightnessAdjustedColor(double positionFactor) {
    final baseColor = Colors.white;

    double normalized = (positionFactor - 0.5).abs() * 2;

    final lightness = 0.5 + (normalized * 0.5);

    final hsl =
        HSLColor.fromColor(baseColor).withLightness(lightness.clamp(0.0, 1.0));
    return hsl.toColor();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_position, _flip]),
      builder: (context, child) {
        final positionFactor = (_position.value + size.width / 2) / size.width;
        final angle = _rotation.transform(positionFactor);
        final color = _colorTween.transform(positionFactor.clamp(0.0, 1.0));
        final scale = _scale.transform(_position.value.abs() / size.width);
        final backFlipValue = 1 - _flip.value;

        return Scaffold(
          backgroundColor: color,
          body: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Opacity(
                          opacity: ((0.5 - positionFactor) * 2).clamp(0.0, 1.0),
                          child: Text(
                            'Need to review',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: ((positionFactor - 0.5) * 2).clamp(0.0, 1.0),
                          child: Text(
                            'I got it right',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              if (_flip.value == 0 || _flip.value == 1)
                Positioned(
                  top: 200,
                  child: Transform.scale(
                    scale: min(scale, 1.0),
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(20),
                      color: _getBrightnessAdjustedColor(positionFactor),
                      child: Container(
                        width: size.width * 0.8,
                        height: size.height * 0.5,
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            quizCards
                                .firstWhere((card) =>
                                    card.id == (_index == 5 ? 1 : _index + 1))
                                .question,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 200,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  onTap: _onTap,
                  child: Transform.translate(
                    offset: Offset(_position.value, 0),
                    child: Transform.rotate(
                      angle: angle * pi / 180,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..translate(_position.value, 0.0)
                          ..rotateY(_flipAnimation.value),
                        child: _flipAnimation.value <= pi / 2
                            ? Material(
                                elevation: 10,
                                borderRadius: BorderRadius.circular(20),
                                color: _flipColorTween.transform(_flip.value),
                                child: Container(
                                  width: size.width * 0.8,
                                  height: size.height * 0.5,
                                  padding: const EdgeInsets.all(24),
                                  child: Center(
                                    child: Text(
                                      quizCards
                                          .firstWhere(
                                              (card) => card.id == _index)
                                          .question,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 32,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Transform.flip(
                                flipX: true,
                                child: Material(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      _flipColorTween.transform(backFlipValue),
                                  child: Container(
                                    width: size.width * 0.8,
                                    height: size.height * 0.5,
                                    padding: const EdgeInsets.all(24),
                                    child: Center(
                                      child: Text(
                                        quizCards
                                            .firstWhere(
                                                (card) => card.id == _index)
                                            .answer,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 32,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 60,
                child: CustomPaint(
                  painter: ProgressBarPainter(
                    progress: _index,
                  ),
                  size: Size(size.width * 0.8, 20),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Custom Painter
class ProgressBarPainter extends CustomPainter {
  final int progress;

  ProgressBarPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.blue[100]!
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    final progressPaint = Paint()
      ..color = Colors.blue[800]!
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    final barHeight = size.height;

    /// 배경 바 전체
    final backgroundRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      barHeight,
      Radius.circular(barHeight / 2),
    );
    canvas.drawRRect(backgroundRect, backgroundPaint);

    /// 진행 바
    final progressWidth = size.width * progress / 5;
    final progressRect = RRect.fromLTRBR(
      0,
      0,
      progressWidth,
      barHeight,
      Radius.circular(barHeight / 2),
    );
    canvas.drawRRect(progressRect, progressPaint);
  }

  @override
  bool shouldRepaint(covariant ProgressBarPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
