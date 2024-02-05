import 'dart:ui';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:get/get.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/games/BBGame.dart';
//import 'sheepComponent.dart';

class SheepGame extends BBGame with TapCallbacks {
  final Controller appController = Get.find();

  //late SheepComponent _sheep;

  var panInput = 0;
  var input = 0;
  var instructionTitle = 'Saute les barrières';
  var instructionSubtitle = 'en contractant ton muscle';

  @override
  Color backgroundColor() => BBGameList.sheep.baseColor.color;

  @override
  Future<void> onLoad() async {
    title = instructionTitle;
    subTitle = instructionSubtitle;
    super.onLoad();
    loadAssetsInCache();
    //_balloon = BalloonComponent();
    // await add(_balloon);
  }

  Future<void> loadAssetsInCache() async {
    await Flame.images.loadAll(<String>[
      'Jeux/Sheep/bang.png',
      'Jeux/Sheep/bim.png',
      'Jeux/Sheep/gate.png',
      'Jeux/Sheep/ground.png',
      'Jeux/Sheep/sheep_01.png',
      'Jeux/Sheep/sheep_02.png',
      'Jeux/Sheep/sheep_03.png',
      'Jeux/Sheep/sheep_04.png',
      'Jeux/Sheep/welcome_sheep_01.png',
      'Jeux/Sheep/welcome_sheep_02.png',
    ]);
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
    } else if (input < 800) {
      title = feedback;
      subTitle = '';
      refreshWidget();
    } else {
      title = "Bravo";
      subTitle = '';
      endGame();
    }
  }


  @override
  void resetGame() {
    // TODO: implement resetGame
    super.resetGame();
    // _balloon.initialize();
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