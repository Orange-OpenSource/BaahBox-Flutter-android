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

import 'dart:math' as math;
import 'dart:math';
import 'dart:ui';
import 'package:baahbox/constants/utils.dart';
import 'package:baahbox/games/toad/components/flyScoreComponent.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:get/get.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/games/BBGame.dart';
import 'package:baahbox/games/toad/components/toadComponent.dart';
import 'package:baahbox/services/settings/settingsController.dart';
import 'package:baahbox/games/toad/components/flyComponent.dart';
import 'package:baahbox/games/toad/components/tongueComponent.dart';
import 'package:baahbox/games/toad/components/flyManager.dart';

import '../../model/GameInput.dart';
import '../../model/sensorInput.dart';


class ToadGame extends BBGame with TapCallbacks, HasCollisionDetection {
  final Controller appController = Get.find();
  final SettingsController settingsController = Get.find();

  late final Image spriteImage;
  late final ToadComponent toad;
  late final TongueComponent tongue;
  late final FlyManager flyManager;
  late final SpawnComponent flyLauncher;
  late final FlyComponent myFly;

  int score = 0;
  var goLeft = false;
  var goRight = false;
  late GameInput gameInput;
  var shoot = false;
  var isToadShooting = false;
  double floorY = 0.0;
  var flyNet = Map<double, double>();
  var instructionTitle = 'Gobe les mouches';
  var instructionSubtitleMuscle = 'en contractant tes muscles';
  var instructionSubtitleJoystick = 'pousse le joystick à gauche ou à droite';
  var instructionSubtitleFinger = 'glisse le doigt à gauche ou à droite';
  var instructionSubtitleHandle = 'tire la poignée vers le haut';

  @override
  Color backgroundColor() => BBGameList.toad.baseColor.color;

  @override
  Future<void> onLoad() async {
    initializeParams();
    title = instructionTitle;
    setInstructions();
    await loadAssetsInCache();
    await loadComponents();
    loadInfoComponents();
    initializeUI();
    super.onLoad();
  }

  Future<void> loadComponents() async {
    await add(toad = ToadComponent());
    await add(tongue = TongueComponent(position: toad.position));
    var skyLimit = toad.position.y - toad.size.y;

    flyLauncher = loadFlyLauncher(skyLimit);
    await add(flyManager = FlyManager());
  }

  SpawnComponent loadFlyLauncher(double yLimit) {
    var top = max(0.0, yLimit - (4 * toad.size.y));
    return SpawnComponent.periodRange(
        factory: (i) => FlyComponent(settingsController
            .toadSettings.flySteadyTime),
       minPeriod: 1,
        maxPeriod: 3,
        area:  Rectangle.fromLTWH(size.x/20, top, size.x-(size.x/10), yLimit - top));
  }

  void loadInfoComponents() {}

  Future<void> loadAssetsInCache() async {
    await Flame.images.loadAll(<String>[
      'Games/Toad/fly.png',
      'Games/Toad/fly50.png',
      'Games/Toad/fly_score_empty.png',
      'Games/Toad/fly_score_full.png',
      'Games/Toad/toad.png',
      'Games/Toad/toad_blink.png',
      'Games/Toad/tongue.png',
    ]);
  }

  void initializeParams() {
    isToadShooting = false;
    // force handle settings to be centered to 0
    gameInput = GameInput(
        axes: GameInputAxes.both,
        musclesSettings: settingsController.toadSettings.muscleSettings,
        handleSettings: HandleSettings(
            prefs: settingsController.handleSettings.prefs,
            prefsPrefix: settingsController.handleSettings.prefsPrefix)
          ..isCenteredToZero = true);
  }

  void initializeUI() {
    title = '';
    setInstructions();
    floorY = size.y - 150.0;
  }

  // ===================
  // MARK: - Game loop
  // ===================

  @override
  void update(double dt) {
    super.update(dt);
    if (appController.isActive) {

      if (state == GameState.running) {
        refreshInput();

        if (settingsController.toadSettings.iShootingModeAutomatic) {
          toad.checkFlies();
        }
      } else {
       setInstructions();
      }
    }
  }

  void refreshInput() {

    goLeft = false;
    goRight = false;

    if (checkCompatibleSensor(BBGameList.toad.compatibleSensorsList)) {
      shoot = gameInput.direction==GameInputDirection.up && !isToadShooting;
      switch (gameInput.directionType) {
        case GameInputDirectionType.analogic:
          if (shoot && !settingsController.toadSettings.iShootingModeAutomatic) {
            startShooting();
          }
          else {
            toad.rotateTo(gameInput.delta.x);
          }
        case GameInputDirectionType.digital:
          var currentInputDirection = gameInput.direction;
          goLeft = currentInputDirection==GameInputDirection.left;
          goRight = currentInputDirection==GameInputDirection.right;
          transformInputInAction();
      }



    }
  }

  void startShooting() {
    if (!toad.checkFlies(automaticMode: false)) {
      toad.shoot();
    }
  }

  void transformInputInAction() {
    if (appController.isConnectedToBox) {
      // Todo handle strengthValue et hardnessCoeff
      if (!goLeft && !goRight && !shoot) {
        return;
      }
      if (shoot && !settingsController.toadSettings.iShootingModeAutomatic) {
        startShooting();
      } else {
        var deltaAngle = goLeft ? -2 : 2;
        toad.rotateBy(deltaAngle);
      }
    }
  }


  void looseScore() {
    if (state == GameState.running) {
      flyManager.looseOneScore();

    }
  }

// Game State management
  void resetComponents() async {
    toad.initialize();
    clearTheSky();
    flyNet = Map();
    add(flyLauncher);
    clearScore();
    flyManager.createScores();
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

    if (paused) {
      resumeEngine();
    }
  }

  @override
  void endGame() {
    state = GameState.won;
    clearTheSky();
    remove(flyLauncher);
    //  toad.hide();
    super.endGame();
  }

  @override
  void onDispose() {
    // TODO: implement onDispose
    super.onDispose();
  }

  // Demo mode
  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (!appController.isConnectedToBox && state == GameState.running) {
      var xTouch = info.eventPosition.global.x;
      var coeff = (xTouch > size.x / 2) ? 1 : -1;
      toad.rotateBy(coeff * 2);
      toad.checkFlies();
    }
  }

  void clearTheSky() {
    for (var child in children) {
      if (child is FlyComponent) {
        child.disappear();
      }
    }
  }

  void clearScore() {
    for (var child in children) {
      if (child is FlyScoreComponent) {
        child.disappear();
      }
    }
  }
  void registerToFlyNet(Vector2 position) {
    flyNet[position.y] = position.x; //todo mettre l'angle et la distance
  }

  void unRegisterFromFlyNet(Vector2 position) {
    flyNet.remove(position.y); //todo mettre l'angle et la distance
  }

  double coordToGradian(double x, double y) {
    return x * y;
  }
}
