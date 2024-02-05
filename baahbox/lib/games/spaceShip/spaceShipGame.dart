import 'dart:ui';
import 'package:baahbox/games/spaceShip/components/scoreManager.dart';
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
import 'package:baahbox/games/spaceShip/components/starBackgroundCreator.dart';
import 'package:baahbox/games/spaceShip/components/lifeManager.dart';
import 'package:flame/input.dart';

class SpaceShipGame extends BBGame with TapCallbacks, HasCollisionDetection {
  final Controller appController = Get.find();

  late final ShipComponent ship;
  late final TextComponent scoreText;
  late final LifeManager lifeManager;
  late final ScoreManager scoreManager;
  late final MeteorManager meteorManager;
  late final StarBackGroundCreator backgroundManager;

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
    loadComponents();
    super.onLoad();
  }

  void loadComponents() async {
    await add(ship = ShipComponent());
    await add(lifeManager = LifeManager());
    await add(scoreManager = ScoreManager());
    await add(meteorManager = MeteorManager());
    await add(backgroundManager = StarBackGroundCreator());
  }

  void loadInfoComponents() {
    addAll([
      scoreText = TextComponent(
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
      'Jeux/Spaceship/crash.png',
    ]);
  }

// Game play
  @override
  void update(double dt) {
    super.update(dt);
    if (appController.isActive) {
      if (state == GameState.running) {
        refreshInput();
        transformInputInOffset();
        scoreText.text = 'Score: $score';
      }
    }
  }

  void onCollision() {
    if (state == GameState.running) {
      lifeManager.looseOneLife();
    }
  }

  void increaseScore() {
    if (state == GameState.running && appController.isActive) {
      print(score);
      score++;
    }
  }

  // Box input
  void refreshInput() {
    // todo deal with 2 muscles or joystick input
    inputL = 0;
    inputR = 0;
    goLeft = false;
    goRight = false;

    if (appController.isConnectedToBox) {
      // The strength is in range [0...1024] -> Have it fit into [0...100]
      inputL = (appController.musclesInput.muscle1 ~/ 10);
      inputR = (appController.musclesInput.muscle2 ~/ 10);
      goLeft = (inputL > 10) && (inputL > inputR);
      goRight = (inputR > 10) && (inputR > inputL);
    }
  }

// Game State management
  @override
  void resetGame() {
    super.resetGame();
    meteorManager.clearTheSky();
    score = 0;
    ship.initialize();
    lifeManager.createLifes();
    if (paused) {
      resumeEngine();
    }
  }

  @override
  void endGame() {
    state = GameState.lost;
    pauseEngine();
    super.endGame();
  }

  void transformInputInOffset() {
    if (!goLeft && !goRight) {
      return;
    }
    var offset = goLeft ? 2.0 : -2.0;
    ship.moveBy(offset);
  }

// tap input (Demo mode)
  @override
  void onTapDown(TapDownEvent event) {
    if (state == GameState.running) {
      ship.add(MoveEffect.to(Vector2(event.localPosition.x, ship.position.y),
          EffectController(duration: 0.3)));
    }
  }
}
