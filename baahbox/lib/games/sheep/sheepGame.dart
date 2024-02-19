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
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:get/get.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/games/BBGame.dart';
import 'package:baahbox/games/sheep/components/sheepComponent.dart';
import 'package:baahbox/games/sheep/components/gateComponent.dart';
import 'package:baahbox/games/sheep/components/floorComponent.dart';
import 'package:baahbox/games/sheep/components/bimComponent.dart';
import 'package:baahbox/games/sheep/components/happySheepComponent.dart';
import 'package:baahbox/games/sheep/components/counterManager.dart';
import 'package:baahbox/games/sheep/background/cloud_manager.dart';
import 'package:baahbox/services/settings/settingsController.dart';

class SheepGame extends BBGame with TapCallbacks, HasCollisionDetection {
  final Controller appController = Get.find();
  final SettingsController settingsController = Get.find();

  late final Image spriteImage;
  late final CloudManager cloudManager = CloudManager();
  late final CounterManager counterManager = CounterManager();

  late final SheepComponent sheep;
  late final GateComponent gate;
  late final FloorComponent floor;
  late final BimComponent collision;
  late final HappySheepComponent happySheep;
  late final TextComponent progressionText;

  int gameObjective = 1;
  int successfulJumps = 0;
  int nbDisplayedGates = 0;
  bool hasSheepStartedJumping = false;
  bool sheepDidJumpOverGate = false;
  int strengthValue = 0;
  var gateVelocity = ObjectVelocity.low;

  int panInput = 0;
  int input = 0;
  double floorY = 0;
  var instructionTitle = '';
  var instructionSubtitle = '';
  var endTitle = 's';
  var feedbackTitleWon = 'Bravo! \ntu as sauté toutes les barrières';
  var feedbackTitleLost = "Tu n'as pas sauté toutes les barrières";

  @override
  Color backgroundColor() => BBGameList.sheep.baseColor.color;

  Future<void> loadAssetsInCache() async {
    await Flame.images.loadAll(<String>[
      'Jeux/Sheep/bang.png',
      'Jeux/Sheep/bim.png',
      'Jeux/Sheep/gate.png',
      'Jeux/Sheep/floor.png',
      'Jeux/Sheep/sheep_01.png',
      'Jeux/Sheep/sheep_02.png',
      'Jeux/Sheep/sheep_jumping.png',
      'Jeux/Sheep/sheep_bump.png',
      'Jeux/Sheep/happy_sheep_01.png',
      'Jeux/Sheep/happy_sheep_02.png',
      'trex.png',
    ]);
  }

  Future<void> loadComponents() async {
    await add(gate = GateComponent(speedScale: this.gateVelocity));
    await add(cloudManager);
    await add(counterManager);

    await add(
        sheep = SheepComponent(position: Vector2(size.x * 2 / 5, floorY)));
    await add(floor = FloorComponent(
        position: Vector2(size.x / 2, floorY),
        size: Vector2(size.x + 10, 5.0)));
    await add(happySheep = HappySheepComponent(
        position: Vector2(0, 0), size: Vector2(size.x / 2, size.y / 2)));
  }

  void loadInfoComponents() {
    addAll([
      progressionText = TextComponent(
        position: Vector2(size.x / 2, floorY + 50),
        anchor: Anchor.topCenter,
        priority: 1,
      ),
    ]);
  }

  @override
  Future<void> onLoad() async {
    floorY = (size.y * 0.7);
    initializeParams();
    await loadAssetsInCache();
    await loadComponents();
    loadInfoComponents();
    initializeUI();
    super.onLoad();
  }

  void initializeParams() {
    successfulJumps = 0;
    hasSheepStartedJumping = false;
    sheepDidJumpOverGate = false;
    var params = settingsController.sheepSettings;
    gameObjective = settingsController.sheepSettings["numberOfGates"];
    gateVelocity = settingsController.sheepSettings["gateVelocity"];
  }

  void initializeUI() {
    title = 'Essaie de sauter $gameObjective barrière';
    if (gameObjective > 1) {
      title += 's';
    }
    subTitle = instructionSubtitle;
    progressionText.text = "";
    counterManager.createMarks(gameObjective);
  }

  void resetComponents() {
    counterManager.createMarks(gameObjective);
    progressionText.text = "";
    sheep.initialize();
    gate.reset(gateVelocity);
    floor.show();
  }

  @override
  void startGame() {
    initializeParams();
    resetComponents();
    super.startGame();
  }

  @override
  void resetGame() {
    super.resetGame();
    initializeParams();
    resetComponents();
    cloudManager.start();
    sheep.tremble();
    if (paused) {
      resumeEngine();
    }
  }

// ===================
  // MARK: - Game loop
  // ===================

  @override
  void update(double dt) {
    super.update(dt);
    if (appController.isActive) {
      if (isRunning) {
        refreshInput();
        transformInputInMove();
        if (isNewGateOnQueue()) {
          if (!isSheepOnFloor() && !sheepDidJumpOverGate) {
            setGameStateToWon(false);
            feedback = "Il faut atterrir après la barrière!";
            progressionText.text = feedback;
          } else if (successfulJumps == gameObjective) {
            counterManager.looseOneMark();
            setGameStateToWon(true);
          }
          sheepDidJumpOverGate = false;
          progressionText.text = "";
        } else {
          checkSheepAndGatePositions();
        }
      }
    }
  }

  void transformInputInMove() {
    if (appController.isConnectedToBox) {
      //   if input <= threshold { return }
      //   var heightConstraint = (CGFloat(strengthValue) - CGFloat (hardnessCoeff*350)) / 1000
//   if heightConstraint < 0 { heightConstraint = 0 }
      var sensorType = settingsController.usedSensor;
      switch (sensorType) {
        case SensorType.muscle:
          final jumpHeigth = floorY * (1 - (input / 100));
          // print("floorY: $floorY, height: $jumpHeigth");
          sheep.moveTo(jumpHeigth);
        case SensorType.arcadeJoystick:
          var joystickInput = appController.joystickInput;
          if (joystickInput.up) {
            sheep.moveTo(sheep.y - 3);
          } else if (joystickInput.down) {
            sheep.moveTo(sheep.y + 3);
          }
        default:
      }
    }
// let jumpheightWithConstraint = groundPosition.y + (maxHeigthJump * heightConstraint)
// jumpTo(sprite: sheep, height: jumpheightWithConstraint)
  }

//  var heightConstraint = (CGFloat(strengthValue) - CGFloat (hardnessCoeff*350)) / 1000
//  if heightConstraint < 0 { heightConstraint = 0 }
// let jumpheightWithConstraint = groundPosition.y + (maxHeigthJump * heightConstraint)
// jumpTo(sprite: sheep, height: jumpheightWithConstraint)

  void refreshInput() {
    // todo deal with 2 muscles or joystick input
    if (appController.isConnectedToBox) {
      // The strength is in range [0...1024] -> Have it fit into [0...100]
      input = (appController.musclesInput.muscle1 ~/ 10);
    } else {
      input = panInput;
    }
  }

  void checkSheepAndGatePositions() {
    if (isSheepOnFloor()) {
      if ((isSheepBeyondTheGate()) &&
          hasSheepStartedJumping &&
          !sheepDidJumpOverGate) {
        counterManager.looseOneMark();
        sheepDidJumpOverGate = true;
        successfulJumps += 1;
        configureLabelsForCongrats();
      }
      hasSheepStartedJumping = false;
      // startWalkingSheepAnimation()
      configureLabelsForWalking();
    } else {
      hasSheepStartedJumping = true;
      if (isSheepBeyondTheGate()) {
        sheepDidJumpOverGate = false;
        configureLabelsToGoDown();
      } else {
        configureLabelsForJumpInProgress();
      }
    }
  }

  void configureLabelsForCongrats() {
    progressionText.text = "congrats!";
  }

  void configureLabelsForWalking() {
    progressionText.text = "";
  }

  void configureLabelsToGoDown() {
    progressionText.text = "Atterris après la barrière !";
  }

  void configureLabelsForJumpInProgress() {
    progressionText.text = "Hop!";
  }

  bool isNewGateOnQueue() {
    return gate.isNewComer;
  }

  bool isSheepOnFloor() {
    return sheep.isOnFloor(floorY);
  }

  bool isSheepBeyondTheGate() {
    return sheep.isBeyond(gate.position.x);
  }

  void setGameStateToWon(bool win) {
    state = win ? GameState.won : GameState.lost;
    feedback = win ? feedbackTitleWon : feedbackTitleLost;
    if (win) {
      sheep.hide();
      floor.hide();
      counterManager.counterText.text = "";
    }
    progressionText.text = ""; //feedback;
    endGame();
  }

  @override
  void endGame() {
    cloudManager.pause();
    super.endGame();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (appController.isConnectedToBox || state != GameState.running) {
      panInput = 0;
    } else {
      var yPos = info.eventPosition.global.y;
      var nextY = min(yPos, floorY);
      sheep.moveTo(nextY);
    }
  }

  @override
  void onDispose() {
    // TODO: implement onDispose
    super.onDispose();
  }
}
