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
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:get/get.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/games/BBGame.dart';
import 'balloonComponent.dart';
import 'package:baahbox/services/settings/settingsController.dart';

class BalloonGame extends BBGame with TapCallbacks {
  final Controller appController = Get.find();
  final SettingsController settingsController = Get.find();

  late BalloonComponent _balloon;

  var panInput = 0;
  var input = 0;
  var instructionTitle = 'Gonfle le ballon';
  var instructionSubtitle = 'en contractant ton muscle';
  var feedback1 = "C'est parti !";
  var feedback2 = 'Encore un petit effort!';
  var feedback3 = 'On y est presque !';

  @override
  Color backgroundColor() => BBGameList.balloon.baseColor.color;

  @override
  Future<void> onLoad() async {
    title = instructionTitle;
    subTitle = instructionSubtitle;
    feedback = "";
    super.onLoad();
    await Flame.images.loadAll(<String>[
      'Jeux/Balloon/ballon_00@2x.png',
      'Jeux/Balloon/ballon_01@2x.png',
      'Jeux/Balloon/ballon_02@2x.png',
      'Jeux/Balloon/ballon_03@2x.png',
      'Jeux/Balloon/ballon_04@2x.png',
    ]);
    input = 0;
    _balloon = BalloonComponent();
    await add(_balloon);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (appController.isActive) {
      if (isRunning) {
        refreshInput();
        updateOverlaysAndState();
      }
    }
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
      feedback = feedback1;
    } else if (input < 500) {
      feedback = feedback2;
    } else if (input < 800) {
      feedback = feedback3;
    } else {
      endGame();
    }
    refreshWidget();
  }

  @override
  void startGame() {
    input =0;
    _balloon.initialize();
    super.startGame();
    displayFeedBack();
  }

  @override
  void resetGame() {
    super.resetGame();

  }

  @override
  void endGame() {
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
