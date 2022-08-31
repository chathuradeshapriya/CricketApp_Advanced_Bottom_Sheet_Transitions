import 'package:flutter/material.dart';
import 'package:flutter_advanced_bottomsheet_transitions/player.dart';

class PlayerContainer extends StatelessWidget {
  final Player player;
  final double topMargin;
  final double leftMargin;
  final double imgSize;
  final bool isCompleted;

  PlayerContainer(
      {required this.player,
      required this.topMargin,
      required this.leftMargin,
      required this.imgSize,
      required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topMargin,
      left: leftMargin,
      right: 0,
      child: Row(
        children: [
          Container(
            height: imgSize,
            width: imgSize,
            child: Image.asset(
              'assets/${player.image}',
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
              child: isCompleted
                  ? Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            player.title,
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            player.year,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink())
        ],
      ),
    );
  }
}
