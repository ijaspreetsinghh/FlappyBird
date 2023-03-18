// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, avoid_unnecessary_containers, avoid_print
import 'dart:async';
import 'package:flappy_bird/Layouts/Widgets/widget_bird.dart';
import 'package:flappy_bird/Layouts/Widgets/widget_barrier.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../Database/database.dart';
import '../../Global/constant.dart';
import '../../Global/functions.dart';
import '../../Resources/strings.dart';

class GamePage extends StatefulWidget {
  GamePage({Key? key}) : super(key: key);
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Future<bool> canGoBack() async {
    Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      myText("Exit Game?", Colors.blue[900], 35),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  gameButton(
                    () {
                      hideOverlay();
                      Get.back();
                    },
                    "Exit",
                    Colors.blue.shade300,
                  ),
                  gameButton(() {
                    hideOverlay();
                  }, "Keep Playing", Colors.green)
                      .marginOnly(top: 8)
                ]),
          ),
        ),
        barrierDismissible: false);

    return false;
  }

  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;
  final int maxFailedLoadAttempts = 3;

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: 'ca-app-pub-8262174744018997/3265536948',
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedAd();
            }
            resetGame();
          },
        ));
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      resetGame();
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        hideOverlay(); // dismisses the alert dialog

        gameHasStarted.value = true;
        yAxis.value = 0;

        time.value = 0;

        initialHeight = yAxis.value;
        barrierX[0] = 2;
        barrierX[1] = 3.4;
        retryLeft--;

        startGame();
        ad.dispose();

        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        resetGame();
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    _rewardedAd = null;
  }

  int retryLeft = 3;
  @override
  void initState() {
    retryLeft = 3;
    _createRewardedAd();

    yAxis.value = 0;
    gameHasStarted.value = false;
    time.value = 0;
    score.value = 0;
    initialHeight = yAxis.value;
    barrierX[0] = 2;
    barrierX[1] = 3.4;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => canGoBack(),
      child: GestureDetector(
        onTap: () {
          if (gameHasStarted.value) {
            jump();
          } else {
            startGame();
          }
        },
        child: Scaffold(
          body: Column(children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: background(Str.image),
                child: Stack(
                  children: [
                    Obx(() => Bird(yAxis.value, birdWidth, birdHeight)),
                    // Tap to play text
                    Obx(
                      () => Container(
                        alignment: Alignment(0, -0.3),
                        child: myText(
                            gameHasStarted.value ? '' : 'TAP TO START',
                            Colors.white,
                            25),
                      ),
                    ),
                    Obx(() => Barrier(barrierHeight[0][0], barrierWidth.value,
                        barrierX[0], true)),
                    Obx(
                      () => Barrier(barrierHeight[0][1], barrierWidth.value,
                          barrierX[0], false),
                    ),
                    Obx(() => Barrier(barrierHeight[1][0], barrierWidth.value,
                        barrierX[1], true)),
                    Obx(() => Barrier(barrierHeight[1][1], barrierWidth.value,
                        barrierX[1], false)),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.brown,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Obx(() => Text(
                              "Score : ${score.value}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontFamily: "DiloWorld"),
                            )), // Best TEXT
                        Obx(() => Text("Best : ${topScore.value}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontFamily: "DiloWorld"))),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Difficulty : ${read('level') == 0.05 ? 'Easy' : read('level') == 0.08 ? 'Medium' : 'Hard'} ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: "DiloWorld"),
                        ), // Best TEXT
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // Jump Function:
  void jump() {
    time.value = 0;
    initialHeight = yAxis.value;
  }

  //Start Game Function:
  void startGame() {
    gameHasStarted.value = true;
    Timer.periodic(Duration(milliseconds: 35), (timer) {
      height = gravity * time.value * time.value + velocity * time.value;

      yAxis.value = initialHeight - height;

      /* <  Barriers Movements  > */

      if (barrierX[0] < screenEnd) {
        barrierX[0] += screenStart;
      } else {
        barrierX[0] -= barrierMovement;
      }

      if (barrierX[1] < screenEnd) {
        barrierX[1] += screenStart;
      } else {
        barrierX[1] -= barrierMovement;
      }

      if (birdIsDead()) {
        timer.cancel();

        showGameOverDialog();
      }
      time.value += 0.032;
    });
    /* <  Calculate Score  > */
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (birdIsDead()) {
        // Todo : save the top score in the database  <---
        write("score", topScore.value);
        timer.cancel();
        // score = 0;
      } else {
        if (score.value == topScore.value) {
          topScore.value++;
        }
        score.value++;
      }
    });
  }

  /// Make sure the [Bird] doesn't go out screen & hit the barrier
  bool birdIsDead() {
    // Screen
    if (yAxis.value > 1.26 || yAxis.value < -1.1) {
      return true;
    }

    /// Barrier hitBox
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          (barrierX[i] + (barrierWidth.value)) >= birdWidth &&
          (yAxis.value <= -1 + barrierHeight[i][0] ||
              yAxis.value + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    return false;
  }

  void resetGame() {
    hideOverlay();
    yAxis.value = 0;
    gameHasStarted.value = false;
    time.value = 0;
    score.value = 0;
    initialHeight = yAxis.value;
    barrierX[0] = 2;
    barrierX[1] = 3.4;
  }

  void onAdViewClick() {
    _showRewardedAd();
  }

  void showGameOverDialog() {
    RxInt delayVal = 2.obs;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (delayVal.value > 0) {
        delayVal.value--;
      } else {
        timer.cancel();
      }
    });

    Get.dialog(
        WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        myText("Game Over", Colors.blue[900], 35),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Column(children: [
                      Obx(() => delayVal.value > 0
                          ? gameButton(
                              () {},
                              "Restart in ${delayVal.value}",
                              Colors.grey,
                            )
                          : gameButton(
                              () {
                                resetGame();
                              },
                              'Restart',
                              Colors.blue.shade300,
                            )),
                      retryLeft > 0
                          ? gameButton(() {
                              onAdViewClick();
                            }, "Watch Ad", Colors.green)
                              .marginOnly(top: 8)
                          : SizedBox(),
                    ])
                  ]),
            ),
          ),
        ),
        useSafeArea: true,
        barrierDismissible: false);
  }
}
