// ignore_for_file: prefer_const_constructors

import 'package:flappy_bird/Database/database.dart';
import 'package:flappy_bird/Resources/strings.dart';
import 'package:flutter/material.dart';

import '../../Global/functions.dart';

class BirdSettings extends StatelessWidget {
  const BirdSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => Column(
        children: [
          Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: myText("Characters", Colors.black, 20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Str.bird = "assets/pics/bird.png";
                  write("bird", Str.bird);
                  setState(() {});
                },
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: read('bird') == "assets/pics/bird.png"
                            ? Colors.black
                            : Colors.transparent,
                        width: 2),
                  ),
                  child: Image.asset(
                    "assets/pics/bird.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Str.bird = "assets/pics/blue.png";
                  write("bird", Str.bird);
                  setState(() {});
                },
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: read('bird') == "assets/pics/blue.png"
                            ? Colors.black
                            : Colors.transparent,
                        width: 2),
                  ),
                  child: Image.asset(
                    "assets/pics/blue.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Str.bird = "assets/pics/green.png";
                  write("bird", Str.bird);
                  setState(() {});
                },
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: read('bird') == "assets/pics/green.png"
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
            ],
          ),
        ],
      ),
    );
  }
}
