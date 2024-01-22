import 'spaceShipGame.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flame/game.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:baahbox/games/overlayBuilder.dart';

class SpaceShipGamePage extends StatelessWidget {
  final Controller appController = Get.find();
  final game = SpaceShipGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          GameWidget(
            game: game,
            loadingBuilder: (_) => const Center(
              child: Text('Loading'),
            ),
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
