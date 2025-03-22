import 'package:animation_challenge/screens/explicit_animation_screen.dart';
import 'package:animation_challenge/screens/implicit_animation_screen.dart';
import 'package:animation_challenge/screens/slamdunk_screen.dart';
import 'package:animation_challenge/screens/pomodoro_screen.dart';
import 'package:animation_challenge/screens/swapping_cards_screen.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _goToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Animation'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const ImplicitAnimationScreen(),
                );
              },
              child: Text('Implicit Animation'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const ExplicitAnimationScreen(),
                );
              },
              child: Text('Explicit Animation'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const PomodoroScreen(),
                );
              },
              child: Text('Pomodoro'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const CardSwapScreen(),
                );
              },
              child: Text('Swap Card'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  SlamDunkScreen(),
                );
              },
              child: Text('Slam Dunk'),
            ),
          ],
        ),
      ),
    );
  }
}
