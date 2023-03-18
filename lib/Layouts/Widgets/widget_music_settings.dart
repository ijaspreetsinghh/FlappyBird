// ignore_for_file: prefer_const_constructors

import 'package:flappy_bird/Database/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Global/constant.dart';
import '../../Global/functions.dart';

class MusicSettings extends StatelessWidget {
  MusicSettings({Key? key}) : super(key: key);
  final GameState gameState = Get.put(GameState());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: myText("Music", Colors.black, 20),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: myText(
                  read("audio") ? "Music On" : "Music Off", Colors.black, 16),
            ),
            Obx(() => Switch(
                value: gameState.audio.value,
                activeColor: Colors.black,
                inactiveThumbColor: Colors.grey.shade500,
                inactiveTrackColor: Colors.grey.shade100,
                onChanged: (v) async {
                  if (v) {
                    write("audio", true);
                    gameState.audio.value = true;
                    await player.resume();
                  } else {
                    write("audio", false);
                    gameState.audio.value = false;
                    await player.pause();
                  }
                })),
          ],
        )
      ],
    );
  }
}
