import 'dart:ui';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:get/get.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/games/BBGame.dart';
import 'starSprite.dart';

class StarGame extends BBGame with TapCallbacks {
  final Controller appController = Get.find();
  late Size screenSize;
  late StarSprite _star;

  var panInput = 0;
  var input = 0;
  var instructionTitle = 'Fais briller l\'étoile';
  var instructionSubtitle = 'en contractant ton muscle';
  var feedback = 'encore un effort!';
  @override
  Color backgroundColor() => BBGameList.star.baseColor.color;

  @override
  Future<void> onLoad() async {
    title = instructionTitle;
    subTitle = instructionSubtitle;

    await super.onLoad();
    await Flame.images.loadAll(<String>[
      'Jeux/Star/jeu_etoile_01@2x.png',
      'Jeux/Star/jeu_etoile_02@2x.png',
    ]);
    _star = StarSprite();
   await add(_star);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (state == GameState.running) {
      refreshInput();
      updateOverlaysAndState();
    }
  }


  void refreshInput() {
    // todo deal with 2 muscles or joystick input
    if (appController.isConnectedToBox) {
      // The strength is in range [0...1024] -> Have it fit into [0...100]
      input = appController.musclesInput.muscle1;
    } else {
      input = panInput;
    }
  }

  void updateOverlaysAndState() {
    int coeff = (input / 100).toInt();
    if (input < 300) {
      title = instructionTitle;
      subTitle = instructionSubtitle;
    } else if (input < 750) {
      title = feedback;
      subTitle = '';
      refreshWidget();
    } else {
      title = "Bravo";
      subTitle = '';
      endGame();
    }
  }

  void resize(Size size) {
    screenSize = size;
  }

  @override
  void resetGame() {
    // TODO: implement resetGame
    super.resetGame();
    _star.initialize();
  }

  @override
  void endGame() {
    // TODO: implement resetGame
    state = GameState.won;
    super.endGame();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (appController.isConnectedToBox || state != GameState.running) {
      panInput = 0;
    } else {
      var yPos = info.eventPosition.global.y;
      panInput = ((canvasSize.y - yPos) * 1024.0 / canvasSize.y).toInt();
      print(
          "panInput : ${panInput} :::  panY : ${yPos} vs game ${canvasSize.y}");
    }
  }



  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    print("state : $state ");
  }
}
