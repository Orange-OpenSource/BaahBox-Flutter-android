import 'dart:ui';
import 'package:baahbox/games/spaceShip/components/shipComponent.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/text.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:get/get.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/games/BBGame.dart';

import 'package:flame/components.dart';
import 'package:baahbox/games/spaceShip/components/MeteorManager.dart';
import 'package:baahbox/games/spaceShip/components/star_background_creator.dart';
import 'package:baahbox/games/spaceShip/components/lifeManager.dart';
import 'package:flame/input.dart';

class SpaceShipGame extends BBGame with TapCallbacks, PanDetector, HasCollisionDetection {
  final Controller appController = Get.find();

  late final ShipComponent ship;
  late final TextComponent componentCounter;
  late final TextComponent scoreText;
  late final LifeManager lifeManager;

  int score = 0;
  var panInput = 0;
  var inputL = 0;
  var inputR = 0;
  var goLeft = false;
  var goRight = false;
  var instructionTitle = 'Evite les météorites';
  var instructionSubtitle = 'en contractant le muscle de droite ou de gauche';

  @override
  Color backgroundColor() => BBGameList.starship.baseColor.color;

  // Loading Game
  @override
  Future<void> onLoad() async {
    title = instructionTitle;
    subTitle = instructionSubtitle;
    await loadAssetsInCache();

    loadInfoComponents();
    await add(ship = ShipComponent());
    await add(MeteorCreator());
    await add(StarBackGroundCreator());
    await add(lifeManager = LifeManager());
    super.onLoad();
  }

  void loadInfoComponents() {
    addAll([
      FpsTextComponent(
        position: size - Vector2(0,50),
        anchor: Anchor.bottomRight,
      ),
      scoreText = TextComponent(
        position: size - Vector2(0, 25),
        anchor: Anchor.bottomRight,
        priority: 1,
      ),
      componentCounter = TextComponent(
        position: size,
        anchor: Anchor.bottomRight,
        priority: 1,
      ),
    ]);

  }

  Future<void> loadAssetsInCache() async {
    await Flame.images.loadAll(<String>[
      'Jeux/Spaceship/spaceship_left@3x.png',
      'Jeux/Spaceship/spaceship_right@3x.png',
      'Jeux/Spaceship/spaceship_nml@3x.png',
      'Jeux/Spaceship/meteor_01@3x.png',
      'Jeux/Spaceship/meteor_02@3x.png',
      'Jeux/Spaceship/meteor_03@3x.png',
      'Jeux/Spaceship/meteor_04@3x.png',
      'Jeux/Spaceship/meteor_05@3x.png',
      'Jeux/Spaceship/meteor_06@3x.png',
      'Jeux/Spaceship/space_life@3x.png',
      'Jeux/Spaceship/crash@3x.png',
    ]);
  }


// Game play
  @override
  void update(double dt) {
    super.update(dt);
    if (state == GameState.running) {
      refreshInput();
      transformInputInPosition();
    }
    scoreText.text = 'Score: $score';
    componentCounter.text = 'Components: ${children.length}';
  }

  void onCollision() {
    lifeManager.looseOneLife();
    increaseScore();
  }

  void increaseScore() {
    score++;
  }



  // Box input
  void refreshInput() {
    // todo deal with 2 muscles or joystick input
    if (appController.isConnectedToBox) {
      // The strength is in range [0...1024] -> Have it fit into [0...100]
      inputL = (appController.musclesInput.muscle1/10).floor();
      inputR = (appController.musclesInput.muscle2/10).floor();
      goLeft = inputL > 50;
      goRight = inputR > 50;
    } else {
      inputL = 0;
      inputR = 0;
      goLeft = true;
      goRight = true; 
    }
  }

// Game State management
  @override
  void resetGame() {
    super.resetGame();
    ship.initialize();
    lifeManager.createLifes();
    if (paused) {
      resumeEngine();
    }
  }


  @override
  void endGame() {
    // TODO: implement resetGame
    state = GameState.lost;
    pauseEngine();
    super.endGame();
  }



  void transformInputInPosition() {
      if (goLeft && goRight) { return; }
      var offset = goRight ? 50 : -50;
      var offsetD = offset.toDouble();
      ship.add(MoveEffect.by(Vector2(offsetD, 0),
            EffectController(duration: 0.3)));
  }





// tap input (Demo mode)
  @override
  void onTapDown(TapDownEvent event) {
    ship.add(
        MoveEffect.to(Vector2(event.localPosition.x,ship.position.y),
            EffectController(duration: 0.3)));
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (appController.isConnectedToBox || state != GameState.running) {
      panInput = 0;
    } else {
      ship.position += info.delta.global;
      var yPos = info.eventPosition.global.y;
      panInput = ((canvasSize.y - yPos) * 1024.0 / canvasSize.y).toInt();
      print(
          "panInput : ${panInput} :::  panY : ${yPos} vs game ${canvasSize.y}");
    }
  }
}