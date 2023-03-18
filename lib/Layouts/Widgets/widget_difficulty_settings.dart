// ignore_for_file: prefer_const_constructors

import 'package:flappy_bird/Database/database.dart';
import 'package:flappy_bird/Global/functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Global/constant.dart';

class DifficultySettings extends StatelessWidget {
  DifficultySettings({Key? key}) : super(key: key);
  final GameState gameState = Get.put(GameState());
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(() => Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: gameState.level.value == 0.05
                              ? Colors.black
                              : Colors.transparent,
                          width: 2),
                    ),
                    child: gameButton(() {
                      barrierMovement = 0.05;
                      gameState.level.value = barrierMovement;
                      write("level", barrierMovement);
                    }, "Easy", Colors.green.shade800),
                  )),
              Obx(
                () => Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: gameState.level.value == 0.08
                            ? Colors.black
                            : Colors.transparent,
                        width: 2),
                  ),
                  child: gameButton(() {
                    barrierMovement = 0.08;
                    gameState.level.value = barrierMovement;
                    write("level", barrierMovement);
                  }, "Medium", Colors.yellow.shade800),
                ),
              ),
              Obx(() => Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: gameState.level.value == 0.1
                              ? Colors.black
                              : Colors.transparent,
                          width: 2),
                    ),
                    child: gameButton(() {
                      barrierMovement = 0.1;
                      gameState.level.value = barrierMovement;
                      write("level", barrierMovement);
                    }, "Hard", Colors.red.shade800),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
