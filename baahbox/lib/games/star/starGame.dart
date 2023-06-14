import 'dart:ui';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/model/components.dart';
import 'package:baahbox/games/BBGame.dart';
import 'starSprite.dart';

class StarGame extends BBGame with TapCallbacks {
  late Size screenSize;
  late StarSprite _star;
  var panInput = 0;
  var input = 0;
  var instructionTitle = 'Fais briller l\'étoile';
  var instructionSubtitle = 'en contractant ton muscle';
  var feedback = 'encore un effort!';
  var bravo = TextComponent(text: 'Bravo', textRenderer: _bold);

  @override
  Color backgroundColor() => BBGameList.star.baseColor.color;

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    print("state : $state ");
  }

  @override
  Future<void> onLoad() async {
    title = instructionTitle;
    subTitle = instructionSubtitle;

    await super.onLoad();
    await Flame.images.loadAll(<String>[
      'jeu_etoile_01@2x.png',
      'jeu_etoile_02@2x.png',
    ]);
    _star = StarSprite();
    add(_star);
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
}

//======================================================
// TODO à mettre dans une enum de style

final _regularTextStyle =
    TextStyle(fontSize: 18, color: BasicPalette.white.color);
final _boldTextStyle = TextStyle(
    fontSize: 18, color: BasicPalette.white.color, fontWeight: FontWeight.bold);

final _regular = TextPaint(style: _regularTextStyle);
final _bold = TextPaint(style: _boldTextStyle);
