import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'trex_game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:baahbox/controllers/appController.dart';


class TRexGamePage extends StatelessWidget {

  final Controller c = Get.find();
  final game = TRexGame();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          GameWidget(
            game: game,
          )]),
        floatingActionButton: FloatingActionButton(
            onPressed: () => Get.back(),
            tooltip: 'Go back',
            child: const Icon(Icons.arrow_back)
        )
    );
  }
}
