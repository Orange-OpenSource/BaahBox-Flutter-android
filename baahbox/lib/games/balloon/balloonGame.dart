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
import 'package:baahbox/constants/utils.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:get/get.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/games/BBGame.dart';
import '../../model/GameInput.dart';
import '../../model/sensorInput.dart';
import 'balloonComponent.dart';
import 'package:baahbox/services/settings/settingsController.dart';

class BalloonGame extends BBGame with TapCallbacks {
  final Controller appController = Get.find();
  final SettingsController settingsController = Get.find();
  late BalloonComponent _balloon;

  late GameInput gameInput;

  int inflation = 0;
  double threshold = 0.0;
  double gameLoopDt = 0.0;
  double gameLoopDuration = .02; // 20 ms

  var instructionTitle = 'Gonfle le ballon';
  var instructionSubtitleMuscle = 'en contractant ton muscle';
  var instructionSubtitleJoystick = 'pousse le joystick en haut';
  var instructionSubtitleFinger = 'glisse le doigt de bas en haut';
  var instructionSubtitleHandle = 'tire la poignée vers le haut';
  var feedback1 = "C'est parti !";
  var feedback2 = 'Encore un petit effort!';
  var feedback3 = 'On y est presque !';

  @override
  Color backgroundColor() => BBGameList.balloon.baseColor.color;

  @override
  Future<void> onLoad() async {
    title = instructionTitle;
    setInstructions();
    feedback = "";
    super.onLoad();
    await Flame.images.loadAll(<String>[
      'Games/Balloon/ballon_00@2x.png',
      'Games/Balloon/ballon_01@2x.png',
      'Games/Balloon/ballon_02@2x.png',
      'Games/Balloon/ballon_03@2x.png',
      'Games/Balloon/ballon_04@2x.png',
    ]);
    inflation = 0;
    _balloon = BalloonComponent();
    await add(_balloon);
  }

  @override
  void update(double dt) {
    super.update(dt);
    gameLoopDt += dt;
    if (gameLoopDt >= gameLoopDuration) {
      if (appController.isActive) {
        if (isRunning) {
          refreshInput();
          updateOverlaysAndState();
        } else {
          setInstructions();
        }
      }
      gameLoopDt = 0.0;
    }
  }

  void refreshInput() {
    if (checkCompatibleSensor(BBGameList.balloon.compatibleSensorsList)) {
      processInput();
    }
  }

  void processInput() {
    var handleInput = appController.analogInputs;
    inflation = calibrateAnalogInput(handleInput.analog1,
         settingsController.handleSettings.rangeForHandleLower, 
         settingsController.handleSettings.rangeForHandleUpper);
  }

  void updateOverlaysAndState() {
    if (inflation < 300) {
      feedback = feedback1;
    } else if (inflation < 500) {
      feedback = feedback2;
    } else if (inflation < 800) {
      feedback = feedback3;
    } else {
      endGame();
    }
    refreshWidget();
  }

  @override
  void startGame() {
    inflation = 0;
    gameInput = GameInput(
        axes: GameInputAxes.vertical,
        musclesSettings: settingsController.musclesSettings,
        handleSettings: settingsController.handleSettings);
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
      inflation = 0;
    } else {
      var yPos = info.eventPosition.global.y;
      inflation = (1000 * (canvasSize.y - yPos) / canvasSize.y).toInt();
      debugLog(
          "panInput : ${inflation} :::  panY : ${yPos} vs game ${canvasSize.y}");
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    debugLog("state : $state ");
  }
}
