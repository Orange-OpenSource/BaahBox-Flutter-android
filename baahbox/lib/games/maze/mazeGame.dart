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
import 'package:baahbox/games/BBGame.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../constants/enums.dart';
import '../../controllers/appController.dart';
import '../../services/settings/settingsController.dart';
import 'MazeFactory.dart';
import 'components/MazeComponent.dart';
import 'components/MazeExitComponent.dart';
import 'components/MazeLifeManager.dart';
import 'components/MazePlayerComponent.dart';
import 'components/WallComponent.dart';

enum MovingState {
  none,
  up,
  down,
  right,
  left;
}

class MazeGame extends BBGame with TapCallbacks, HasCollisionDetection {
  final Controller appController = Get.find();
  final SettingsController settingsController = Get.find();
  final MazeFactory mazeController = MazeFactory();

  var instructionTitle = 'Traverse le labynthe';
  var instructionSubtitleJoystick =
      'pousse le joystick à gauche, à droite, en haut ou en bas';
  var instructionSubtitleFinger =
      'pousse le joystick virtuel à gauche, à droite, en haut ou en bas';
  var feedbackTitleWon = 'Bravo! \ntu as vaincu le labyrinthe !';
  var feedbackTitleLost = "Dommage, tu resteras dans le labyrinthe.";

  late int cellWidth;
  late int cellHeight;
  @override
  Color backgroundColor() => BBGameList.maze.baseColor.color;

  late final JoystickComponent joystick;
  late final Paint joyStickKnobPaint;
  late final Paint joyStickBackgroundPaint;
  late final MazePlayerComponent player;
  late final MazeComponent maze;
  late final TextComponent durationText;
  late final MazeLifeManager lifeManager;

  double elapsedTime = 0.0;

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
    mazeController.makeMaze();

    if (!appController.isConnectedToBox) {
      joyStickKnobPaint = Paint()
        ..color = BBColor.pinky.color.withAlpha(200)
        ..style = PaintingStyle.fill;
      joyStickBackgroundPaint = Paint()
        ..color = BBColor.greyGreen.color.withAlpha(200)
        ..style = PaintingStyle.fill;
    }

    durationText = TextComponent(
      position: Vector2(size.x - 5,  10),
      anchor: Anchor.topRight,
      priority: 1,
    );
    add(durationText);

    createMazeAndPlayer();
  }

  void createMazeAndPlayer() {
    if (!appController.isConnectedToBox) {
      var radius = size.y / 4;
      if (radius > 30 || radius < 10) {
        radius = 20;
      }
      joystick = JoystickComponent(
        anchor: Anchor.bottomCenter,
        knob: CircleComponent(radius: radius, paint: joyStickKnobPaint),
        background:
            CircleComponent(radius: radius * 3, paint: joyStickBackgroundPaint),
        margin: const EdgeInsets.only(left: 40, bottom: 40),
      );
      add(joystick);
    }
    //var mazeSize = min(size.x, size.y- durationText.size.y-10);
    var isVertical = (size.y - 10) >= size.x;
    var mazeSize = isVertical ? size.x : (size.y - 10);
    var mazePosition = Vector2((size.x - mazeSize) / 2, 0);

    maze = MazeComponent(
        mazeController: mazeController,
        isVertical: isVertical,
        position: mazePosition,
        size: Vector2(mazeSize, mazeSize));
    add(maze);

    player = MazePlayerComponent(
        isVerticalScreen: isVertical, startCell: maze.startCell);
    add(player);

    add(lifeManager = MazeLifeManager(
        lifeSize: player.size,
      position: Vector2(size.x - 15, size.y - 10)));
    if(settingsController.mazeSettings["hasMaxTouch"])
    {
      lifeManager.show();
    }
    else
    {
      lifeManager.hide();
    }


  }

  void loadInfoComponents() {}
  Future<void> loadAssetsInCache() async {}
  void looseLife() {
    if (state == GameState.running &&
        settingsController.mazeSettings["hasMaxTouch"]) {
      lifeManager.looseOneLife();
    }
  }

  // Game play
  @override
  void update(double dt) {
    super.update(dt);
    if (state == GameState.running) {
      if (settingsController.mazeSettings["hasChrono"]) {
        elapsedTime -= dt;
      } else {
        elapsedTime += dt;
      }
    }
    if (appController.isActive) {
      appController.updateConnectionState();
      if (state == GameState.running) {
        refreshInput();
        durationText.text = prettyDuration(elapsedTime);
        if (player.isOut) {
          setGameStateToWon(true);
        } else  if (settingsController.mazeSettings["hasChrono"] && elapsedTime <= 0) {
          setGameStateToWon(false);
        }
      } else {
        setInstructions();
      }
    }
  }

  // Box input
  void refreshInput() {
    if (appController.isConnectedToBox) {
      var sensorType = settingsController.currentSensor;
      switch (sensorType) {
        case Sensor.muscle:
        case Sensor.arcadeJoystick:
          var joystickInput = appController.joystickInput;

        default:
      }
    } else {
      if (settingsController.mazeSettings["isFineDirection"]) {
        player.moveDelta(joystick.relativeDelta);
      }
      else {
        var deltaX = joystick.relativeDelta.x;
        var deltaY = joystick.relativeDelta.y;

        if (deltaX.abs() > deltaY.abs() && deltaX != 0) {
          deltaX > 0
              ? player.state = MovingState.right
              : player.state = MovingState.left;
        } else if (deltaY != 0) {
          deltaY > 0
              ? player.state = MovingState.down
              : player.state = MovingState.up;
        } else {
          player.state = MovingState.none;
        }
        /* switch(joystick.direction)
            {
              case JoystickDirection.idle:
        case JoystickDirection.up: player.state = MovingState.up; break;
        case JoystickDirection.down:player.state = MovingState.down; break;
        case JoystickDirection.left:player.state = MovingState.up; break;
        case JoystickDirection.right:player.state = MovingState.up; break;
        case JoystickDirection.upLeft:player.state = MovingState.up; break;
        case JoystickDirection.downLeft:player.state = MovingState.up; break;
        case JoystickDirection.upRight:player.state = MovingState.up; break;
        case JoystickDirection.downRight:player.state = MovingState.up; break;
      }*/
      }
    }
  }

  void setGameStateToWon(bool win) {
    state = win ? GameState.won : GameState.lost;
    feedback = win ? feedbackTitleWon : feedbackTitleLost;
    if (win) {
      maze.hide();
      player.hide();
      lifeManager.hide();

    }
    endGame();
  }

// Game State management
  @override
  void startGame() {
    if(settingsController.mazeSettings["hasMaxTouch"])
    {
      lifeManager.show();
    }
    else
      {
        lifeManager.hide();
      }
    if (settingsController.mazeSettings["hasChrono"]) {
      elapsedTime = settingsController.mazeSettings["chronoMaxTime"] ?? 10.0;
    } else {
      elapsedTime = 0.0;
    }
    super.startGame();
  }

  @override
  void endGame() {
    state = GameState.won;
    super.endGame();
  }

  @override
  void resetGame() async {
    super.resetGame();
    if (settingsController.mazeSettings["hasChrono"]) {
      elapsedTime = settingsController.mazeSettings["chronoMaxTime"] ?? 10.0;
    } else {
      elapsedTime = 0.0;
    }
    lifeManager.createLifes();
    if(settingsController.mazeSettings["hasMaxTouch"])
    {
      lifeManager.show();
    }
    else
    {
      lifeManager.hide();
    }
    player.resetToStartPosition();
    maze.initialize();
    maze.show();
    player.show();
    if (paused) {
      resumeEngine();
    }
  }

  String prettyDuration(double durationInSec) {
    var components = <String>[];

    int seconds = durationInSec ~/ 1;
    int minutes = seconds ~/ 60;
    int hours = minutes ~/ 60;
    int days = hours ~/ 24;

    seconds %= 60;
    minutes %= 60;
    hours %= 24;

    if (days != 0) {
      components.add('${days}d');
    }
    if (hours != 0) {
      components.add('${hours}h');
    }

    if (minutes != 0) {
      components.add('${minutes}m');
    }

    components.add('$seconds');
    components.add('s');

    return components.join();
  }
}
