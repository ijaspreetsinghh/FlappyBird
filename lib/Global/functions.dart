// ignore_for_file: prefer_const_constructors
import 'package:audioplayers/audioplayers.dart';
import 'package:flappy_bird/Resources/strings.dart';
import 'package:flutter/material.dart';
import '../Database/database.dart';
import 'constant.dart';

Text myText(String txt, Color? color, double size) {
  return Text(
    txt,
    style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w500,
        fontFamily: "DiloWorld",
        color: color),
  );
}

ElevatedButton gameButton(VoidCallback? onPress, String txt, Color color) {
  return ElevatedButton(
    onPressed: onPress,
    style: ElevatedButton.styleFrom(backgroundColor: color),
    child: myText(txt, Colors.white, 20),
  );
}

BoxDecoration frame() {
  return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.black, width: 2),
      color: Colors.white54,
      boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            blurRadius: 1.0,
            offset: Offset(5, 5))
      ]);
}

BoxDecoration background(String y) {
  return BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/pics/$y.png"),
      fit: BoxFit.fill,
    ),
  );
}

void init() {
  if (read("score") != null) {
    topScore = read("score");
  } else {
    write("score", topScore);
  }
  if (read("background") != null) {
    Str.image = read("background");
  } else {
    write("background", Str.image);
  }
  if (read("bird") != null) {
    Str.bird = read("bird");
  } else {
    write("bird", Str.bird);
  }
  if (read("level") != null) {
    barrierMovement = read("level");
  } else {
    write("level", barrierMovement);
  }
  if (read("audio") != null) {
    play = read("audio");
  } else {
    write("audio", play);
  }
  if (play) {
    player.play(
      AssetSource(
        "audio/Tintin.mp3",
      ),
      mode: PlayerMode.lowLatency,
    );
  } else {
    player.stop();
  }
  player.setReleaseMode(ReleaseMode.loop);
}

void navigate(context, navigate) {
  switch (navigate) {
    case Str.gamePage:
      Navigator.pushNamed(context, Str.gamePage);
      break;
    case Str.settings:
      Navigator.pushNamed(context, Str.settings);
      break;
    case Str.rateUs:
      Navigator.pushNamed(context, Str.rateUs);
      break;
  }
}
