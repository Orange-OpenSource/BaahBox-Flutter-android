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
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:baahbox/games/maze/MazeFactory.dart';
import 'package:baahbox/games/maze3d/engine/render/MinimapPainter.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../constants/enums.dart';
import '../../constants/utils.dart';
import '../../controllers/appController.dart';
import '../../model/GameInput.dart';
import '../../services/settings/settingsController.dart';
import '../BBGame.dart';
import 'components/Maze3dWinComponent.dart';
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

  final Controller appController = Get.find();
  final SettingsController settingsController = Get.find();

  late final JoystickComponent joystick;
  late final Paint joyStickKnobPaint;
  late final Paint joyStickBackgroundPaint;
  late GameInput gameInput;
  late final Maze3dWinComponent winComponent;
  late final TextComponent durationText;
  final MazeFactory factory = MazeFactory();
  late List<List<int>> mazeMap;
  late Player player;
  late Target target;
  late RayCastingPainter rayCastingPainter;
  late RayCastingPainter rayCastingBackViewPainter;
  late MinimapPainter miniMapPainter;
  Paint hudPaint = Paint();
  double elapsedTime = 0.0;
  double deltaTime = 0.0;
  double playerMovementTime = 0.0;

  // Loading Game
  @override
  Future<void> onLoad() async {
    title = instructionTitle;

    hudPaint.color = Colors.black;
    hudPaint.colorFilter = ColorFilter.mode(
      Colors.black,
      BlendMode.multiply,
    );

    setInstructions();

    var mazeSize = settingsController.maze3dSettings.mazeSize;
    factory.makeMaze(mazeSize, mazeSize);
    mazeMap = factory.convertToMatrixMap();

    player = Player(
        x: 0,
        y: 0,
        angle: 0.0,
        miniMapImage: await getImageFromPath(
            'assets/images/Games/Maze/mouton_labyrinthe.png'),
        image:
            await getImageFromPath('assets/images/Games/Maze/sheep_fps.png'));
    resetPlayerPosition();
    target = Target(
        x: 0,
        y: 0,
        angle: 0.0,
        image: await getImageFromPath('assets/images/Games/Maze/trefle.png'));
    resetTargetPosition();
    rayCastingPainter = RayCastingPainter(
        map: mazeMap,
        player: player,
        target: target,
        wallTexture: null,
        isReverse: false);
    rayCastingBackViewPainter = RayCastingPainter(
        map: mazeMap,
        player: player,
        target: target,
        wallTexture: null,
        isReverse: true);
    miniMapPainter =
        MinimapPainter(map: mazeMap, player: player, target: target);

    createTouchJoystick();
    if (!appController.isConnectedToBox) {
      add(joystick);
    }
    createWinComponent();
    createChronoText();
    super.onLoad();
  }

  void resetMaze() {
    var mazeSize = settingsController.maze3dSettings.mazeSize;
    factory.makeMaze(mazeSize, mazeSize);
    mazeMap = factory.convertToMatrixMap();
    rayCastingPainter.map = mazeMap;
    rayCastingBackViewPainter.map = mazeMap;
    miniMapPainter.map = mazeMap;
  }

  void resetPlayerPosition() {
    player.x = 1.5;
    player.y = 1.5;
    player.angle = mazeMap[1][2] == 1 ? pi / 2 : 0.0;
  }

  void resetTargetPosition() {
    target.x = mazeMap[0].length - 1.5;
    target.y = mazeMap.length - 1.5;
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

  void createWinComponent() {
    winComponent = Maze3dWinComponent(
        position: Vector2(size.x / 2, size.y / 2),
        size: Vector2(size.x / 3, size.y / 3));
    winComponent.hide();
    add(winComponent);
  }

  void createChronoText() {
    durationText = TextComponent(
      position: Vector2(size.x - 5, size.y-10),
      anchor: Anchor.bottomRight,
      priority: 1,
    );
    add(durationText);
  }

  void move(double moveSpeed) {
    var speedFactor = settingsController.maze3dSettings.speedMovement / 100.0;
    final newX = player.x + cos(player.angle) * moveSpeed * speedFactor;
    final newY = player.y + sin(player.angle) * moveSpeed * speedFactor;

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
        if (newX != player.x) {
          player.x = newX;
          playerMovementTime += deltaTime;
        } else {
          playerMovementTime = 0.0;
        }
        if (newY != player.y) {
          player.y = newY;
        }
      } else {
        playerMovementTime = 0.0;
        setGameStateToWon(true);
      }
    }
  }

  void rotate(double rotSpeed) {
    var speedFactor = settingsController.maze3dSettings.speedMovement / 100.0;
    player.angle += rotSpeed * speedFactor;
  }

  @override
  void render(Canvas canvas) {
    if (state != GameState.lost && state != GameState.won) {
      rayCastingPainter.setFOV(settingsController.maze3dSettings.FOV);
      rayCastingPainter.paint(canvas, size.toSize());
      renderPlayer(canvas, size.toSize());
      if (settingsController.maze3dSettings.hasBackView) {
        canvas.save();
        canvas.drawRect(
          Rect.fromLTWH(
            0,
            0,
            160,
            160,
          ),
          hudPaint,
        );
        rayCastingBackViewPainter.setFOV(settingsController.maze3dSettings.FOV);
        canvas.translate(5, 5);
        rayCastingBackViewPainter.paint(canvas, Size(150, 150));
        canvas.restore();
        canvas.translate(size.x - 150, 0);
        miniMapPainter.paint(canvas, Size(150, 150));
        canvas.restore();
      } else {
        miniMapPainter.paint(canvas, Size(150, 150));
      }
    } else {
      canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y),
          Paint()..color = BBColor.sheepGray.color);
    }
    super.render(canvas);
  }

  void renderPlayer(Canvas canvas, Size size) {
    final screenWidth = size.width;
    final screenHeight = size.height;

    if (player.image != null) {
      var yOffest = 2.0;
      var movementTime =
          settingsController.maze3dSettings.speedMovement * playerMovementTime;
      var deltaXMovement = sin(movementTime) * 10.0;
      var deltaYMovement = sin(movementTime) * yOffest;

      var ratio = player.image!.height / player.image!.width;
      // Draw player image
      Paint paint = Paint();
      Rect srcRect = Rect.fromLTWH(
        0,
        0,
        player.image!.width.toDouble(),
        player.image!.height.toDouble(),
      );
      var playerImageWidth = screenWidth / 3;
      if (screenWidth > screenHeight) {
        playerImageWidth = screenHeight / 4 / ratio;
      }
      Rect dstRect = Rect.fromCenter(
          center: Offset(
              screenWidth / 2 + deltaXMovement,
              yOffest +
                  screenHeight -
                  (ratio * playerImageWidth) / 2 +
                  deltaYMovement),
          width: playerImageWidth,
          height: ratio * playerImageWidth);
      canvas.drawImageRect(player.image!, srcRect, dstRect, paint);
    }
  }

  // Game play
  @override
  void update(double dt) {
    super.update(dt);
    deltaTime = dt;
    if (state == GameState.running) {
      if (settingsController.maze3dSettings.hasChrono) {
        elapsedTime -= dt;
      } else {
        elapsedTime += dt;
      }
    }
    if (appController.isActive) {
      if (state == GameState.running) {
        durationText.text = prettyDuration(elapsedTime);
        if (settingsController.maze3dSettings.hasChrono && elapsedTime <= 0) {
          setGameStateToWon(false);
        }
        refreshInput();
      } else {
        setInstructions();
      }
    }
  }

  void refreshInput() {
    if (checkCompatibleSensor(BBGameList.maze3d.compatibleSensorsList)) {
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
    if (win) {
      winComponent.show();
    }
    endGame();
  }

// Game State management
  @override
  void startGame() {
    winComponent.hide();
    if (settingsController.maze3dSettings.hasChrono) {
      elapsedTime = settingsController.maze3dSettings.chronoMaxTime;
    } else {
      elapsedTime = 0.0;
    }
    gameInput = GameInput(
        axes: GameInputAxes.both,
        musclesSettings: settingsController.maze3dSettings.musclesSettings,
        handleSettings: settingsController.handleSettings);
    super.startGame();
  }

  @override
  void endGame() {
    super.endGame();
  }

  @override
  void resetGame() async {
    super.resetGame();
    if (settingsController.maze3dSettings.hasChrono) {
      elapsedTime = settingsController.maze3dSettings.chronoMaxTime;
    } else {
      elapsedTime = 0.0;
    }
    resetMaze();
    resetPlayerPosition();
    resetTargetPosition();
    if (paused) {
      resumeEngine();
    }
  }
}
