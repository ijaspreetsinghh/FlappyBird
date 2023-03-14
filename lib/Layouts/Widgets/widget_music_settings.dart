// ignore_for_file: prefer_const_constructors

import 'package:flappy_bird/Database/database.dart';
import 'package:flutter/material.dart';

import '../../Global/constant.dart';
import '../../Global/functions.dart';

class MusicSettings extends StatefulWidget {
  const MusicSettings({Key? key}) : super(key: key);

  @override
  State<MusicSettings> createState() => _MusicSettingsState();
}

class _MusicSettingsState extends State<MusicSettings> {
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
            Switch(
                value: read("audio"),
                activeColor: Colors.black,
                inactiveThumbColor: Colors.grey.shade500,
                inactiveTrackColor: Colors.grey.shade100,
                onChanged: (v) async {
                  if (v) {
                    write("audio", true);
                    await player.resume();
                    setState(() {});
                  } else {
                    write("audio", false);
                    await player.pause();
                    setState(() {});
                  }
                }),
          ],
        )
      ],
    );
  }
}
