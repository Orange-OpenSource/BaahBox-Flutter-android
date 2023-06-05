import 'package:baahbox/games/Dino/dino_game.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:baahbox/controllers/appController.dart';
import 'dart:ui';
import 'starSprite.dart';

class StarGame extends StatelessWidget {

  final Controller c = Get.find();
  final game = DinoGame();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      GameWidget(
        game: game,
      ),
    ]));
  }
}
