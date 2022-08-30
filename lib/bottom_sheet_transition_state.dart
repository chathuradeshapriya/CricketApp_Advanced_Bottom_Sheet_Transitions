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
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff920201),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
              ),
            ),
          );
        });
  }
}
