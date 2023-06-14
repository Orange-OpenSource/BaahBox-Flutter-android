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

  var title = TextComponent(
    text: 'Fais briller l\'étoile',
    textRenderer: _bold,
  );
  var subtitle = TextComponent(
    text: 'en contractant ton muscle',
    textRenderer: _regular,
  );
  var feedback =
      TextComponent(text: 'encore un effort!', textRenderer: _regular);
  var bravo = TextComponent(text: 'Bravo', textRenderer: _bold);

  var playButton = PlayButtonComponent(
    'Jouer',
    _bold,
  );
  var replayButton = PlayButtonComponent(
    'rejouer',
    _bold,
  );

  @override
  Color backgroundColor() => BBGameList.star.baseColor.color;

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    print("state : $state ");
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    await Flame.images.loadAll(<String>[
      'jeu_etoile_01@2x.png',
      'jeu_etoile_02@2x.png',
    ]);
    _star = StarSprite();
    addAll([
      title
        ..anchor = Anchor.topCenter
        ..x = size.x / 2
        ..y = size.y - 120.0,
      subtitle
        ..anchor = Anchor.topCenter
        ..x = size.x / 2
        ..y = size.y - 90.0,
      playButton
        ..anchor = Anchor.bottomCenter
        ..x = size.x / 2
        ..y = size.y - 30,
      _star
        ..x = size.x / 2
        ..y = size.y / 2,
    ]);
    overlays.add('PreGame');
  }

  @override
  void update(double dt) {
    super.update(dt);
    refreshInput();
    updateTitles();
    updateState();
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

  void updateState() {
    switch (state) {
      case GameState.initializing:
        overlays.clear();
        break;
      case GameState.running:
        overlays.remove('PreGame');
      case GameState.paused:
        break;
      case GameState.won || GameState.lost:
      //  add(replayButton
      //   ..anchor = Anchor.bottomCenter
      //   ..x = size.x / 2
      //   ..y = size.y - 30);
        overlays.clear();
        overlays.add('PostGame');
    }
  }


  void updateTitles() {
    int coeff = (input / 100).toInt();
    print("input : ${coeff}");
    switch (coeff) {
      case 0 || 1 || 2:
        break;
      case 3 || 4:
      //remove(title);
      //title.
      //remove(subtitle);
      // add(feedback);
      case 5 || 6 || 7 || 8:
      // remove(title);
      // remove(subtitle);
      // remove(feedback);
      case 9 || 10:
        state = GameState.ended;
        break;
    }
  }

  void resize(Size size) {
    screenSize = size;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (appController.isConnectedToBox) {
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

