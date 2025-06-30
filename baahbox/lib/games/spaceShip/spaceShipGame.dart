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
import 'package:baahbox/constants/utils.dart';
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

import '../../model/GameInput.dart';
import '../../model/sensorInput.dart';

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

  var goLeft = false;
  var goRight = false;
  var instructionTitle = 'Evite les météorites';
  var instructionSubtitleMuscle = 'en contractant tes muscles';
  var instructionSubtitleJoystick = 'pousse le joystick à gauche ou à droite';
  var instructionSubtitleFinger = 'glisse le doigt à gauche ou à droite';
  var instructionSubtitleHandle = 'tire la poignée vers le haut';

  double threshold = 0.1;
  late GameInput gameInput;

  @override
  Color backgroundColor() => BBGameList.starship.baseColor.color;

  // Loading Game
  @override
  Future<void> onLoad() async {
    title = instructionTitle;
    setInstructions();
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
      'Games/Spaceship/spaceship_left@3x.png',
      'Games/Spaceship/spaceship_right@3x.png',
      'Games/Spaceship/spaceship_nml@3x.png',
      'Games/Spaceship/meteor_01@3x.png',
      'Games/Spaceship/meteor_02@3x.png',
      'Games/Spaceship/meteor_03@3x.png',
      'Games/Spaceship/meteor_04@3x.png',
      'Games/Spaceship/meteor_05@3x.png',
      'Games/Spaceship/meteor_06@3x.png',
      'Games/Spaceship/space_life@3x.png',
      'Games/Spaceship/crash.png',
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

        scoreText.text = 'Score: $score';
      } else {
        setInstructions();
      }
    }
  }

  // Box input
  void refreshInput() {
    // todo deal with joystick input

    goLeft = false;
    goRight = false;

    if (checkCompatibleSensor(BBGameList.starship.compatibleSensorsList)) {
      switch (gameInput.directionType) {
        case GameInputDirectionType.analogic:
          var deltaX = gameInput.delta.x;
          if (deltaX.abs() > threshold) {
            ship.moveTo(deltaX);
          } else {
            ship.setSpriteTo(0);
          }
        case GameInputDirectionType.digital:
          var currentInputDirection = gameInput.direction;
          goLeft = currentInputDirection == GameInputDirection.left;
          goRight = currentInputDirection == GameInputDirection.right;
          transformInputInOffset();
      }
    }
  }

  void transformInputInOffset() {
    if (!goLeft && !goRight) {
      ship.setSpriteTo(0);
      return;
    }
    var offset = goLeft ? -2.0 : 2.0;
    ship.moveBy(offset);
  }

  void looseLife() {
    if (state == GameState.running) {
      lifeManager.looseOneLife();
    }
  }

  void addLife() {
    if (state == GameState.running) {
      lifeManager.addOneLife();
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
    // force handle settings to be centered to 0
    gameInput = GameInput(
        axes: GameInputAxes.horizontal,
        musclesSettings: settingsController.spaceShipSettings.muscleSettings,
        handleSettings: HandleSettings(
            prefs: settingsController.handleSettings.prefs,
            prefsPrefix: settingsController.handleSettings.prefsPrefix)
          ..isCenteredToZero = true);
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
