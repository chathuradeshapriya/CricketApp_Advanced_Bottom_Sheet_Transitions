import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class BottomSheetTransition extends StatefulWidget {
  const BottomSheetTransition({Key? key}) : super(key: key);

  @override
  State<BottomSheetTransition> createState() => _BottomSheetTransitionState();
}

class _BottomSheetTransitionState extends State<BottomSheetTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double get maxHeight => MediaQuery.of(context).size.height - 40;
  double songImageStarSize = 45;
  double songImageEndSize = 120;
  double songVerticalSpace = 25;
  double songHorizontalSpace = 15;

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
  double? lerp(double min, double max) {
    return lerpDouble(min, max, _controller.value);
  }

  void toggle() {
    final bool isCompleted = _controller.status == AnimationStatus.completed;
    _controller.fling(velocity: isCompleted ? -1 : 1);
  }

  void verticalDragUpdate(DragUpdateDetails details) {
    _controller.value -= (details.primaryDelta!/maxHeight);

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
                  color: Color(0xff068bff),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),

                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Stack(
                  children: [
                    Positioned(
                        left: 0,
                        right: 0,
                        top: lerp(20, 40),
                        child: Row(
                      children: [
                        Text("Popular Cricketers",style: TextStyle(
                          color: Colors.white,
                          fontSize: lerp(15, 25),
                          fontWeight: FontWeight.w500,
                        ),),
                        Icon(

                            _controller.status == AnimationStatus.completed
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,

                        color: Colors.white,
                            size: lerp(15, 25),
                        )
                        
                      ],
                    ))
                  ],
                ),
              ),
            ),
          );
        });
  }
}
