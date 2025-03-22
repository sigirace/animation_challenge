import 'dart:ui';

import 'package:animation_challenge/data/slamdunk_data.dart';
import 'package:animation_challenge/screens/widgets/star_rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SlamDunkScreen extends StatefulWidget {
  const SlamDunkScreen({super.key});

  @override
  State<SlamDunkScreen> createState() => _SlamDunkScreenState();
}

class _SlamDunkScreenState extends State<SlamDunkScreen> {
  int _currentId = 0;
  bool _isLocked = false;

  final PageController _pageController = PageController(viewportFraction: 0.8);

  void _onPageChanged(int id) {
    setState(() {
      _currentId = id;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _slideDown() {
    setState(() {
      _isLocked = true;
    });
  }

  void _slideUp() {
    setState(() {
      _isLocked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: Container(
              key: ValueKey(_currentId),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(players[_currentId].background),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  color: Colors.black.withOpacity(_isLocked ? 0.5 : 0.2),
                ).animate(target: _isLocked ? 1 : 0).fadeIn(duration: 300.ms),
              ),
            ),
          ),
          AbsorbPointer(
            absorbing: _isLocked,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0) {
                  _slideDown();
                } else {
                  _slideUp();
                }
              },
              child: PageView.builder(
                controller: _pageController,
                physics: _isLocked
                    ? const NeverScrollableScrollPhysics()
                    : const PageScrollPhysics(),
                itemCount: players.length,
                scrollDirection: Axis.horizontal,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      if (!_isLocked)
                        Positioned(
                          top: 70,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              Icon(Icons.arrow_upward, color: Colors.white),
                              Text(
                                'Scroll to see more',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                              .animate(
                                onPlay: (controller) =>
                                    controller.repeat(reverse: true),
                              )
                              .moveY(begin: 0, end: -10, duration: 600.ms)
                              .fadeIn(duration: 600.ms),
                        ),
                      Positioned(
                        bottom: _isLocked ? -450 : 30,
                        left: 10,
                        right: 10,
                        child: Container(
                          height: 500,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withAlpha(200)),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                SizedBox(height: 150),
                                Text(
                                  players[index].name,
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 20),
                                StarRating(rating: players[index].rating),
                                SizedBox(height: 20),
                                Text(
                                  players[index].quote,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).animate(target: _isLocked ? 1 : 0).moveY(
                              begin: 0,
                              end: 450,
                              duration: 300.ms,
                              curve: Curves.easeInOut,
                            ),
                      ),
                      Align(
                        alignment: Alignment(0, _isLocked ? 5 : -0.2),
                        child: Container(
                          height: 250,
                          width: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(80),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                            image: DecorationImage(
                              image: AssetImage(players[index].image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ).animate(target: _isLocked ? 1 : 0).moveY(
                            begin: 0,
                            end: 5 * screenHeight * 0.1,
                            duration: 300.ms),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          if (_isLocked)
            Center(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.85,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(50),
                        child: Column(
                          children: [
                            SizedBox(height: 50),
                            Text(
                              players[_currentId].name,
                              style: TextStyle(
                                fontSize: 50,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            StarRating(rating: players[_currentId].rating),
                            SizedBox(height: 20),
                            Divider(color: Colors.white),
                            Column(
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      players[_currentId].team,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      players[_currentId].height,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      players[_currentId].position,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      players[_currentId].weight,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                            Divider(color: Colors.white),
                            SizedBox(height: 20),
                            Text(
                              players[_currentId].description,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _slideUp();
                    },
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms)
                .slideY(begin: 0.1, end: 0, duration: 300.ms),
        ],
      ),
    );
  }
}
