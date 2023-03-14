// ignore_for_file: prefer_const_constructors

import 'package:flappy_bird/Database/database.dart';
import 'package:flappy_bird/Global/functions.dart';
import 'package:flutter/material.dart';

import '../../Global/constant.dart';

class DifficultySettings extends StatelessWidget {
  const DifficultySettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.026),
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: myText("Difficulty", Colors.black, 20)),
          StatefulBuilder(builder: (context, setState) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: read('level') == 0.05
                            ? Colors.black
                            : Colors.transparent,
                        width: 2),
                  ),
                  child: gameButton(() {
                    barrierMovement = 0.05;
                    write("level", barrierMovement);
                    setState(() {});
                  }, "Easy", Colors.green.shade800),
                ),
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: read('level') == 0.08
                            ? Colors.black
                            : Colors.transparent,
                        width: 2),
                  ),
                  child: gameButton(() {
                    barrierMovement = 0.08;
                    write("level", barrierMovement);
                    setState(() {});
                  }, "Medium", Colors.yellow.shade800),
                ),
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: read('level') == 0.1
                            ? Colors.black
                            : Colors.transparent,
                        width: 2),
                  ),
                  child: gameButton(() {
                    barrierMovement = 0.1;
                    write("level", barrierMovement);
                    setState(() {});
                  }, "Hard", Colors.red.shade800),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
