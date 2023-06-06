import 'dino_game.dart';
import 'helpers/navigation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flame/game.dart';
import 'package:baahbox/controllers/appController.dart';



class DinoGameScene extends StatelessWidget {

  final Controller c = Get.find();
  final game = DinoGame();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          GameWidget(
            game: game,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: NavigationKeys(
              onDirectionChanged: game.onArrowKeyChanged,
            ),
          )]),
        floatingActionButton: FloatingActionButton(
            onPressed: () => Get.back(),
            tooltip: 'Go back',
            child: const Icon(Icons.arrow_back)
        )
    );
  }
}
