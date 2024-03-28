/*
 * Baah Box
 * Copyright (c) 2024. Orange SA
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 */

import 'dart:ui';
import 'package:baahbox/games/spaceShip/components/scoreManager.dart';
import 'package:baahbox/games/spaceShip/components/shipComponent.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
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
import 'package:baahbox/services/settings/settingsController.dart';

class SpaceShipGame extends BBGame with TapCallbacks, HasCollisionDetection {
  final Controller appController = Get.find();
  final SettingsController settingsController = Get.find();

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
  var instructionSubtitle = '';
  int threshold = 10;

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
        position: Vector2(size.x - 5, size.y - 10),
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

  void initializeParams() {}

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

  // Box input
  void refreshInput() {
    // todo deal with joystick input
    inputL = 0;
    inputR = 0;
    goLeft = false;
    goRight = false;

    if (appController.isConnectedToBox) {
      var sensorType = settingsController.usedSensor;
      switch (sensorType) {
        case SensorType.muscle:
          // The strength is in range [0...1024] -> Have it fit into [0...100]
          inputL = (appController.musclesInput.muscle1 ~/ 10);
          inputR = (appController.musclesInput.muscle2 ~/ 10);
          goLeft = (inputL > threshold) && (inputL > inputR);
          goRight = (inputR > threshold) && (inputR > inputL);

        case SensorType.arcadeJoystick:
          var joystickInput = appController.joystickInput;
          goLeft = joystickInput.right;
          goRight = joystickInput.left;
          print("joystick : " + joystickInput.describe());
          print("right : $goRight");
          print("left : $goLeft");

        default:
      }
    }
  }

  void transformInputInOffset() {
    if (!goLeft && !goRight) {
      return;
    }
    var offset = goLeft ? 2.0 : -2.0;
    ship.moveBy(offset);
  }

  void looseLife() {
    if (state == GameState.running) {
      lifeManager.looseOneLife();
    }
  }

  void increaseScore() {
    if ((state == GameState.running) && (appController.isActive)) {
      score++;
    }
  }

// Game State management
  @override
  void startGame() {
    initializeParams();
    super.startGame();
  }

  @override
  void endGame() {
    state = GameState.lost;
    super.endGame();
  }

  @override
  void resetGame() async {
    super.resetGame();
    initializeParams();
    score = 0;
    meteorManager.clearTheSky();
    ship.initialize();
    lifeManager.createLifes();
    if (paused) {
      resumeEngine();
    }
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
