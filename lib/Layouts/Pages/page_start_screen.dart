// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables
import 'package:flappy_bird/Layouts/Widgets/widget_bird.dart';
import 'package:flappy_bird/Resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';
import '../../Global/constant.dart';
import '../../Global/functions.dart';
import '../Widgets/widget_gradient_button.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final myBox = Hive.box('user');
  BannerAd? startBanner;

  @override
  void initState() {
    init();
    startBanner = BannerAd(
        size: AdSize.mediumRectangle,
        adUnitId: 'ca-app-pub-8262174744018997/9304617093',
        listener: BannerAdListener(
          onAdFailedToLoad: (ad, error) {},
        ),
        request: AdRequest());
    startBanner!.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AdWidget adWidget = AdWidget(
      ad: startBanner!,
    );

    final SizedBox adContainer = SizedBox(
      width: startBanner!.size.width.toDouble(),
      height: startBanner!.size.height.toDouble(),
      child: adWidget,
    );
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: background(
          Str.image,
        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            // Flappy bird text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(
                        top: size.height * 0.15, left: 16, right: 16),
                    child:
                        myText("Super Bird".toUpperCase(), Colors.white, 40)),
              ],
            ),
            Bird(yAxis.value, birdWidth, birdHeight),
            SizedBox(
              height: 48,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 230,
                  child: _buttons(),
                ),
              ],
            ),
            SizedBox(
              height: 32,
            ),
            adContainer,
          ],
        ),
      ),
    );
  }
}

// three buttons
Column _buttons() {
  return Column(
    children: [
      Button(
        buttonType: "text",
        height: 50,
        width: 230,
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_arrow_rounded,
              size: 32,
              color: Colors.green,
            ),
            SizedBox(
              width: 4,
            ),
            myText("Play", Colors.green, 28)
          ],
        ),
        page: Str.gamePage,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Button(
            buttonType: "icon",
            height: 50,
            width: 100,
            icon: Icon(
              Icons.settings,
              size: 28,
              color: Colors.grey.shade900,
            ),
            page: Str.settings,
          ),
          InkWell(
            child: Container(
                width: 100,
                height: 50,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.share_rounded,
                  size: 28,
                  color: Colors.blue.shade300,
                )),
            onTap: () {
              Share.share(
                  "Hey look! I found this amazing game. Let's play it together. Follow this link https://jsdev.page.link/flappyBird",
                  subject:
                      "Hey look! I found this amazing game. Let's play it together.");
            },
          )
        ],
      ),
    ],
  );
}
