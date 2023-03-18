// ignore_for_file: prefer_const_constructors
import 'package:flappy_bird/Database/database.dart';
import 'package:flappy_bird/Global/constant.dart';
import 'package:flappy_bird/Resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Global/functions.dart';

class ThemesSettings extends StatelessWidget {
  ThemesSettings({Key? key}) : super(key: key);
  final GameState gameState = Get.put(GameState());
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Center(
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text("Themes",
                    style: TextStyle(fontSize: 20, fontFamily: "DiloWorld"))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(
                () => GestureDetector(
                  onTap: () {
                    Str.image = "0";
                    gameState.theme.value = Str.image;
                    write("background", Str.image);
                    background(Str.image);
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: gameState.theme.value == '0'
                              ? Colors.black
                              : Colors.transparent,
                          width: 2),
                    ),
                    child: Image.asset(
                      "assets/pics/0.png",
                      // width: 60,
                      height: 70,
                    ),
                  ),
                ),
              ),
              Obx(
                () => GestureDetector(
                  onTap: () {
                    Str.image = "1";
                    gameState.theme.value = Str.image;
                    write("background", Str.image);
                    background(Str.image);
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: gameState.theme.value == '1'
                              ? Colors.black
                              : Colors.transparent,
                          width: 2),
                    ),
                    child: Image.asset(
                      "assets/pics/1.png",
                      height: 70,
                    ),
                  ),
                ),
              ),
              Obx(
                () => GestureDetector(
                  onTap: () {
                    Str.image = "2";
                    gameState.theme.value = Str.image;
                    write("background", Str.image);
                    background(Str.image);
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: gameState.theme.value == '2'
                              ? Colors.black
                              : Colors.transparent,
                          width: 2),
                    ),
                    child: Image.asset(
                      "assets/pics/2.png",
                      width: 63,
                      height: 66,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
