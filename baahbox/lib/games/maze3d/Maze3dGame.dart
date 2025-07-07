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

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:baahbox/games/maze/MazeFactory.dart';
import 'package:baahbox/games/maze3d/engine/render/MinimapPainter.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../constants/enums.dart';
import '../../model/GameInput.dart';
import '../BBGame.dart';
import 'engine/models/Player.dart';
import 'engine/models/Target.dart';
import 'engine/render/RayCastingPainter.dart';

Future<ui.Image> getImageFromPath(String path) async {
  final ByteData data = await rootBundle.load(path);
  final Completer<ui.Image> completer = Completer();
  ui.decodeImageFromList(data.buffer.asUint8List(), (ui.Image img) {
    return completer.complete(img);
  });
  return completer.future;
}

class Maze3dGame extends BBGame {
  @override
  Color backgroundColor() => BBGameList.maze.baseColor.color;
  var instructionTitle = 'Traverse le labyrinthe';
  var instructionSubtitleJoystick =
      'pousse le joystick à gauche, à droite, en haut ou en bas';
  var instructionSubtitleFinger =
      'pousse le joystick virtuel à gauche, à droite, en haut ou en bas';

  late final JoystickComponent joystick;
  late final Paint joyStickKnobPaint;
  late final Paint joyStickBackgroundPaint;
  late GameInput gameInput;

  final MazeFactory factory = MazeFactory();
  late List<List<int>> mazeMap;
  late Player player;
  late Target target;
  late RayCastingPainter rayCastingPainter;
  late MinimapPainter miniMapPainter;
  // Loading Game
  @override
  Future<void> onLoad() async {
    title = instructionTitle;

    setInstructions();
    factory.makeMaze(5, 5);
    mazeMap = factory.convertToMatrixMap();

    player = Player(
        x: 1.5,
        y: 1.5,
        angle: mazeMap[1][2] == 1 ? pi / 2 : 0.0,
        miniMapImage: await getImageFromPath(
            'assets/images/Games/Maze/mouton_labyrinthe.png'));
    target = Target(
        x: mazeMap[0].length - 1.5,
        y: mazeMap.length - 1.5,
        angle: 0.0,
        image: await getImageFromPath('assets/images/Games/Maze/trefle.png'));
    rayCastingPainter = RayCastingPainter(
        map: mazeMap, player: player, target: target, wallTexture: null);
    miniMapPainter =
        MinimapPainter(map: mazeMap, player: player, target: target);

    createTouchJoystick();
    if (!appController.isConnectedToBox) {
      add(joystick);
    }

    super.onLoad();
  }

  void createTouchJoystick() {
    var radius = size.y / 4;
    if (radius > 30 || radius < 10) {
      radius = 20;
    }
    joyStickKnobPaint = Paint()
      ..color = BBColor.pinky.color.withAlpha(200)
      ..style = PaintingStyle.fill;
    joyStickBackgroundPaint = Paint()
      ..color = BBColor.greyGreen.color.withAlpha(200)
      ..style = PaintingStyle.fill;

    joystick = JoystickComponent(
      anchor: Anchor.bottomCenter,
      knob: CircleComponent(radius: radius, paint: joyStickKnobPaint),
      background:
          CircleComponent(radius: radius * 3, paint: joyStickBackgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
  }

  void move(double moveSpeed) {
    final newX = player.x + cos(player.angle) * moveSpeed * 0.05;
    final newY = player.y + sin(player.angle) * moveSpeed * 0.05;

    // Collision detection
    if (mazeMap[newY.toInt()][newX.toInt()] == 0) {
      /// If the player walks in the permitted area, update the player's position
      // Collision detection with target
      bool collisionWithTarget = false;

      double dx = target.x - newX;
      double dy = target.y - newY;
      double distance = sqrt(dx * dx + dy * dy);

      if (distance < 0.5) {
        collisionWithTarget = true;
      }

      if (!collisionWithTarget) {
        // If no collision, update the player's position
        player.x = newX;
        player.y = newY;
      }
    }
  }

  void rotate(double rotSpeed) {
    player.angle += rotSpeed * 0.05;
  }

  @override
  void render(Canvas canvas) {
    rayCastingPainter.paint(canvas, size.toSize());
    miniMapPainter.paint(canvas, Size(150, 150));
    super.render(canvas);
  }

  // Game play
  @override
  void update(double dt) {
    super.update(dt);

    if (appController.isActive) {
      if (state == GameState.running) {
        refreshInput();
      } else {
        setInstructions();
      }
    }
  }

  void refreshInput() {
    if (checkCompatibleSensor(BBGameList.maze.compatibleSensorsList)) {
      if (gameInput.directionType == GameInputDirectionType.analogic) {
        move(-1.0 * gameInput.delta.y);
        rotate(gameInput.delta.x);
      } else {
        switch (gameInput.direction) {
          case GameInputDirection.up:
          case GameInputDirection.upLeft:
          case GameInputDirection.upRight:
            move(1);
          case GameInputDirection.right:
            rotate(1);
          case GameInputDirection.down:
          case GameInputDirection.downRight:
          case GameInputDirection.downLeft:
            move(-1);
          case GameInputDirection.left:
            rotate(-1);
          case GameInputDirection.idle:
        }
      }
    } else {
      if (!contains(joystick)) {
        add(joystick);
      }
      move(-1.0 * joystick.relativeDelta.y);
      rotate(joystick.relativeDelta.x);
    }
  }

  void setGameStateToWon(bool win) {
    state = win ? GameState.won : GameState.lost;

    endGame();
  }

// Game State management
  @override
  void startGame() {
    super.startGame();
  }

  @override
  void endGame() {
    super.endGame();
  }

  @override
  void resetGame() async {
    super.resetGame();

    if (paused) {
      resumeEngine();
    }
  }
}
