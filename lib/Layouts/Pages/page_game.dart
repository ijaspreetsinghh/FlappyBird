// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, avoid_unnecessary_containers, avoid_print
import 'dart:async';
import 'package:flappy_bird/Layouts/Widgets/widget_bird.dart';
import 'package:flappy_bird/Layouts/Widgets/widget_barrier.dart';
import 'package:flutter/material.dart';
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              myText("Game Over", Colors.blue[900], 35),
            ],
          ),
          actionsPadding: EdgeInsets.only(right: 8, bottom: 8),
          content: SizedBox(
            height: 100,
            child: Column(children: [
              gameButton(
                () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                "Exit",
                Colors.blue.shade300,
              ),
              gameButton(() {
                Navigator.pop(context);
              }, "Keep Playing", Colors.green),
            ]),
          ),
        );
      },
    );

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
        print('$ad onAdDismissedFullScreenContent.');
        Navigator.pop(context); // dismisses the alert dialog
        setState(() {
          gameHasStarted = true;
          yAxis = 0;

          time = 0;

          initialHeight = yAxis;
          barrierX[0] = 2;
          barrierX[1] = 3.4;
          retryLeft--;
        });

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => canGoBack(),
      child: GestureDetector(
        onTap: () {
          if (gameHasStarted) {
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
                    Bird(yAxis, birdWidth, birdHeight),
                    // Tap to play text
                    Container(
                      alignment: Alignment(0, -0.3),
                      child: myText(gameHasStarted ? '' : 'TAP TO START',
                          Colors.white, 25),
                    ),
                    Barrier(
                        barrierHeight[0][0], barrierWidth, barrierX[0], true),
                    Barrier(
                        barrierHeight[0][1], barrierWidth, barrierX[0], false),
                    Barrier(
                        barrierHeight[1][0], barrierWidth, barrierX[1], true),
                    Barrier(
                        barrierHeight[1][1], barrierWidth, barrierX[1], false),
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
                        Text(
                          "Score : $score",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: "DiloWorld"),
                        ), // Best TEXT
                        Text("Best : $topScore",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontFamily: "DiloWorld")),
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
    setState(() {
      time = 0;
      initialHeight = yAxis;
    });
  }

  //Start Game Function:
  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 35), (timer) {
      height = gravity * time * time + velocity * time;
      setState(() {
        yAxis = initialHeight - height;
      });
      /* <  Barriers Movements  > */
      setState(() {
        if (barrierX[0] < screenEnd) {
          barrierX[0] += screenStart;
        } else {
          barrierX[0] -= barrierMovement;
        }
      });
      setState(() {
        if (barrierX[1] < screenEnd) {
          barrierX[1] += screenStart;
        } else {
          barrierX[1] -= barrierMovement;
        }
      });
      if (birdIsDead()) {
        timer.cancel();
        _showDialog();
      }
      time += 0.032;
    });
    /* <  Calculate Score  > */
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (birdIsDead()) {
        // Todo : save the top score in the database  <---
        write("score", topScore);
        timer.cancel();
        // score = 0;
      } else {
        setState(() {
          if (score == topScore) {
            topScore++;
          }
          score++;
        });
      }
    });
  }

  /// Make sure the [Bird] doesn't go out screen & hit the barrier
  bool birdIsDead() {
    // Screen
    if (yAxis > 1.26 || yAxis < -1.1) {
      return true;
    }

    /// Barrier hitBox
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          (barrierX[i] + (barrierWidth)) >= birdWidth &&
          (yAxis <= -1 + barrierHeight[i][0] ||
              yAxis + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    return false;
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      yAxis = 0;
      gameHasStarted = false;
      time = 0;
      score = 0;
      initialHeight = yAxis;
      barrierX[0] = 2;
      barrierX[1] = 3.4;
    });
  }

  void onAdViewClick() {
    _showRewardedAd();
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              myText("Game Over", Colors.blue[900], 35),
            ],
          ),
          actionsPadding: EdgeInsets.only(right: 8, bottom: 8),
          content: SizedBox(
            height: 100,
            child: Column(children: [
              gameButton(
                () {
                  resetGame();
                },
                "Restart",
                Colors.blue.shade300,
              ),
              retryLeft > 0
                  ? gameButton(() {
                      onAdViewClick();
                    }, "View Ad", Colors.green)
                  : SizedBox(),
            ]),
          ),
        );
      },
    );
  }
}
