// ignore_for_file: prefer_const_constructors

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class GameState extends GetxController {
  RxString bird = 'assets/pics/bird.png'.obs;
}

/// SCORE Variables calculated in function [startGame] in [GamePage]
RxInt score = 0.obs;
RxInt topScore = 0.obs;

/// [Bird] Variables
RxDouble yAxis = 0.0.obs;
double birdWidth = 0.183;
double birdHeight = 0.183;

/// Variables to calculate bird movements function [startGame] in [GamePage]
RxDouble time = 0.0.obs;
double height = 0;
double gravity = -3.9; // How strong the Gravity
double velocity = 2.5; // How strong the jump
double initialHeight = yAxis.value;
RxBool gameHasStarted = false.obs;

/// [Barrier] Variables
RxList<double> barrierX = [2.0, 3.4].obs;
RxDouble barrierWidth = 0.5.obs;
RxList<RxList<double>> barrierHeight = [
  [0.6, 0.4].obs,
  [0.4, 0.6].obs,
].obs;
double barrierMovement = 0.05;

/// Screen Boundary
double screenEnd = -1.9;
double screenStart = 3.5;

/// audio
final player = AudioPlayer();
bool play = true;
