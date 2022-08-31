import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_bottomsheet_transitions/player.dart';

import 'player_container.dart';

class BottomSheetTransition extends StatefulWidget {
  @override
  _BottomSheetTransitionState createState() => _BottomSheetTransitionState();
}

class _BottomSheetTransitionState extends State<BottomSheetTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double get maxHeight => MediaQuery.of(context).size.height - 40;
  double playerImgStartSize = 45;
  double playerImgEndSize = 120;
  double playerVerticalSpace = 25;
  double playerHorizontalSpace = 15;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

   lerp(double min, double max) {
    return lerpDouble(min, max, _controller.value);


  }

  void toggle() {
    final bool isCompleted = _controller.status == AnimationStatus.completed;
    _controller.fling(velocity: isCompleted ? -1 : 1);

  }

  void verticalDragUpdate(DragUpdateDetails details) {
    _controller.value -= (details.primaryDelta! / maxHeight);


  }

  void verticalDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / maxHeight;

    if (flingVelocity < 0) {
      _controller.fling(velocity: math.max(1, -flingVelocity));
    } else if (flingVelocity > 0) {
      _controller.fling(velocity: math.min(-1, -flingVelocity));
    } else {
      _controller.fling(velocity: _controller.value < 0.5 ? -1 : 1);
    }

  }

  double playerTopMargin(int index) {
    return lerp(20, 10 + index * (playerVerticalSpace + playerImgEndSize));
  }

  double playerLeftMargin(int index) {
    return lerp(index * (playerHorizontalSpace + playerImgStartSize), 0);
  }

  Widget buildPlayerContainer(Player player) {
    int index = players.indexOf(player);
    return PlayerContainer(
      player: player,
      imgSize: lerp(playerImgStartSize, playerImgEndSize),
      topMargin: playerTopMargin(index),
      leftMargin: playerLeftMargin(index),
      isCompleted: _controller.status == AnimationStatus.completed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: lerp(120, maxHeight),
          child: GestureDetector(
            onTap: toggle,
            onVerticalDragUpdate: verticalDragUpdate,
            onVerticalDragEnd: verticalDragEnd,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff03A9F4),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Stack(
                children: [
                  Positioned(
                      left: 0,
                      right: 0,
                      top: lerp(10, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sri Lankan\nPopular Cricketers',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: lerp(15, 25),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Icon(
                            _controller.status == AnimationStatus.completed
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: Colors.white,
                            size: lerp(15, 25),
                          )
                        ],
                      )),
                  Positioned(
                    top: lerp(35, 80),
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SingleChildScrollView(
                      scrollDirection:
                      _controller.status == AnimationStatus.completed
                          ? Axis.vertical
                          : Axis.horizontal,
                      physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      child: Container(
                        height:
                        (playerImgEndSize + playerVerticalSpace) * players.length,
                        width: (playerImgStartSize + playerHorizontalSpace) *
                            players.length,
                        child: Stack(
                          children: [
                            for (Player player in players) buildPlayerContainer(player),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}