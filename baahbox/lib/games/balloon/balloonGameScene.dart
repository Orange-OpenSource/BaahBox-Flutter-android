import 'balloonGame.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flame/game.dart';
import 'package:baahbox/controllers/appController.dart';

class BalloonGameScene extends StatelessWidget {
  final Controller c = Get.find();
  final game = BalloonGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          GameWidget(
            game: game,
          )
          ]),
        floatingActionButton: FloatingActionButton(
            onPressed: () => Get.back(),
            tooltip: 'Go back',
            child: const Icon(Icons.arrow_back)
        )
    );
  }
}
