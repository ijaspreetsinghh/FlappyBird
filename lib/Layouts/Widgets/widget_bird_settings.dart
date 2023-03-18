// ignore_for_file: prefer_const_constructors

import 'package:flappy_bird/Database/database.dart';
import 'package:flappy_bird/Global/constant.dart';
import 'package:flappy_bird/Resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Global/functions.dart';

class BirdSettings extends StatelessWidget {
  BirdSettings({Key? key}) : super(key: key);
  final GameState gameState = Get.put(GameState());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: myText("Characters", Colors.black, 20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(() => GestureDetector(
                  onTap: () {
                    Str.bird = "assets/pics/bird.png";
                    gameState.bird.value = Str.bird;
                    write("bird", Str.bird);
                  },
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: gameState.bird.value == "assets/pics/bird.png"
                              ? Colors.black
                              : Colors.transparent,
                          width: 2),
                    ),
                    child: Image.asset(
                      "assets/pics/bird.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                )),
            Obx(() => GestureDetector(
                  onTap: () {
                    Str.bird = "assets/pics/blue.png";
                    gameState.bird.value = Str.bird;
                    write("bird", Str.bird);
                  },
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: gameState.bird.value == "assets/pics/blue.png"
                              ? Colors.black
                              : Colors.transparent,
                          width: 2),
                    ),
                    child: Image.asset(
                      "assets/pics/blue.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                )),
            Obx(
              () => GestureDetector(
                onTap: () {
                  Str.bird = "assets/pics/green.png";
                  gameState.bird.value = Str.bird;
                  write("bird", Str.bird);
                },
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: gameState.bird.value == "assets/pics/green.png"
                            ? Colors.black
                            : Colors.transparent,
                        width: 2),
                  ),
                  child: Image.asset(
                    "assets/pics/green.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
