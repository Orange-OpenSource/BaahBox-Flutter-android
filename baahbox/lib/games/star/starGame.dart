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

import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
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
import 'package:baahbox/services/settings/settingsController.dart';

class StarGame extends BBGame with TapCallbacks {
  final Controller appController = Get.find();
  final SettingsController settingsController = Get.find();
  late final TextComponent scoreText;

  late Size screenSize;
  late StarSprite _star;

  var panInput = 0;
  var input = 0;
  final instructionTitle = 'Fais briller l\'étoile';
  final instructionSubtitle = 'en contractant ton muscle';
  final feedBackTitle = 'encore un effort!';
  @override
  Color backgroundColor() => BBGameList.star.baseColor.color;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await Flame.images.loadAll(<String>[
      'Jeux/Star/jeu_etoile_01@2x.png',
      'Jeux/Star/jeu_etoile_02@2x.png',
    ]);
    loadInfoComponents();
    title = instructionTitle;
    subTitle = instructionSubtitle;
    feedback = feedBackTitle;
    input = 0;
    _star = StarSprite();
    await add(_star);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (appController.isActive) {
      if (isRunning) {
        refreshInput();
        scoreText.text = 'Score: $input';
        updateOverlaysAndState();
      }
    }
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

  void refreshInput() {
    // Todo : deal with threshod and sensitivity
    if (appController.isConnectedToBox) {
      var sensorType = settingsController.usedSensor;
      switch (sensorType) {
        case SensorType.muscle:
        // The strength is in range [0...1024] -> Have it fit into [0...100]
          input = appController.musclesInput.muscle1;
        case SensorType.arcadeJoystick:
          var joystickInput = appController.joystickInput;
          if (joystickInput.up && input < 1000) {
            input += 8;
          } else if  (input >= 10) {
              input -= 5;
          }
        default:
      }
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
      displayFeedBack();
    } else {
      endGame();
    }
  }

  void resize(Size size) {
    screenSize = size;
  }

  @override
  void startGame() {
    _star.initialize();
    input =0;
    super.startGame();
  }

  @override
  void endGame() {
    state = GameState.won;
    super.endGame();
  }

  @override
  void resetGame() {
    super.resetGame();
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
