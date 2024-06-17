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
import 'dart:ui';
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

class ToadGame extends BBGame with TapCallbacks, HasCollisionDetection {
  final Controller appController = Get.find();
  final SettingsController settingsController = Get.find();

  late final Image spriteImage;
  late final ToadComponent toad;
  late final TongueComponent tongue;
  // late final FlyScoreManager flyScoreManager;
  late final SpawnComponent flyLauncher;
  late final FlyComponent myFly;

  int score = 0;
  int threshold = 10;
  var panInput = 0;
  var inputL = 0;
  var inputR = 0;
  var goLeft = false;
  var goRight = false;
  var shoot = false;
  var isToadShooting = false;
  double floorY = 0.0;
  var flyNet = Map<double, double>();
  var instructionTitle = 'Gobe les mouches';
  var instructionSubtitle = '';

  @override
  Color backgroundColor() => BBGameList.toad.baseColor.color;

  @override
  Future<void> onLoad() async {
    initializeParams();
    title = instructionTitle;
    subTitle = instructionSubtitle;
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
    //  myFly = FlyComponent(size: Vector2(50,50));
    // myFly = FlyComponent();

    // await add(flyScoreManager = FlyScoreManager());
  }

  SpawnComponent loadFlyLauncher(double yLimit) {
    return SpawnComponent.periodRange(
        factory: (i) => FlyComponent(settingsController
            .toadSettings["flySteadyTime"]), //size: Vector2(50, 50)),
        minPeriod: 1,
        maxPeriod: 3,
        area: Rectangle.fromCenter(
          center: Vector2(size.x / 2, yLimit / 3),
          size: Vector2(size.x - 50, 2 * yLimit / 3 - 50),
        ));
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
  }

  void initializeUI() {
    title = '';
    subTitle = '';
    floorY = size.y - 150.0;
  }

  // ===================
  // MARK: - Game loop
  // ===================

  @override
  void update(double dt) {
    super.update(dt);
    if (appController.isActive) {
      appController.updateConnectionState();
      if (state == GameState.running) {
        refreshInput();
        transformInputInAction();
        if (settingsController.toadSettings["iShootingModeAutomatic"]) {
          toad.checkFlies();
        }
      }
    }
  }

  void refreshInput() {
    inputL = 0;
    inputR = 0;
    goLeft = false;
    goRight = false;

    if (appController.isConnectedToBox) {
      var sensorType = settingsController.currentSensor;
      switch (sensorType) {
        case Sensor.muscle: // The strength is in range [0...1024] -> Have it fit into [0...100]
          inputR = (appController.musclesInput.muscle1 ~/ 10);
          inputL = (appController.musclesInput.muscle2 ~/ 10);
          print("toad: inputL= $inputL, inputR = $inputR");
          goLeft = (inputL > threshold) && (inputL > inputR) && !isToadShooting;
          goRight = (inputR > threshold) && !goLeft && !isToadShooting;
          shoot = (inputL > 99 && inputR > 99 && !isToadShooting);

        case Sensor.arcadeJoystick:
          var joystickInput = appController.joystickInput;
          goLeft = joystickInput.left && !isToadShooting;
          goRight = joystickInput.right && !isToadShooting;
          shoot = joystickInput.up && !isToadShooting;

        default:
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
      // Todo gérer strengthValue et hardnessCoeff
      if (!goLeft && !goRight && !shoot) {
        return;
      }
      if (shoot && !settingsController.toadSettings["iShootingModeAutomatic"]) {
        startShooting();
      } else {
        var deltaAngle = goLeft ? -1 : 1;
        toad.rotateBy(deltaAngle);
        // if (settingsController.toadSettings["iShootingModeAutomatic"]) {
        //   toad.checkFlies();
       // }
      }
    }
  }

  void increaseScore() {
    if ((state == GameState.running) && (appController.isActive)) {
      //    flyScoreManager.addOnefly();
    }
  }

// Game State management
  void resetComponents() async {
    toad.initialize();
    clearTheSky();
    flyNet = Map();
    add(flyLauncher);
  }

  @override
  void startGame() {
    initializeParams();
    resetComponents();
    //add(myFly);
    //myFly.setPositionTo(Vector2(200, 100));
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

  // doubletap
  @override
  void onLongTapDown(TapDownEvent) {
    if (state == GameState.running) {
      startShooting();
    }
  }

  // tap input (Demo mode)
  @override
  void onTapDown(TapDownEvent event) {
    if (state == GameState.running) {
      var xTouch = event.localPosition.x;
      var coeff = xTouch > size.x / 2 ? 1 : -1;
      var newAngle = toad.angle + (coeff * 5 / 180 * math.pi);
      if (newAngle < tau / 4 && newAngle > -tau / 4) {
        toad.add(RotateEffect.to(newAngle, EffectController(duration: 0.5)));
      }
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (appController.isConnectedToBox || state != GameState.running) {
      panInput = 0;
    } else {
      var xTouch = info.eventPosition.global.x;
      var coeff = (xTouch > size.x / 2) ? 1 : -1;
      toad.rotateBy(coeff * 5);
      // var newAngle = toad.angle + ((coeff * 5)/ 180 * math.pi);
      // if ( newAngle <  15/9 && newAngle > -15/9) {
      //   toad.add(RotateEffect.to(newAngle, EffectController(duration: 0.3)));
      // }
      var nAngle = toad.angle;
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

  void registerToFlyNet(Vector2 position) {
    flyNet[position.x] = position.y; //todo mettre l'angle et la distance
  }

  void unRegisterFromFlyNet(Vector2 position) {
    flyNet.remove(position.x); //todo mettre l'angle et la distance
  }

  double coordToGradian(double x, double y) {
    return x * y;
  }
}
