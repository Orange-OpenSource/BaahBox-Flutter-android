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

import 'package:baahbox/games/maze/components/MazeExitComponent.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:get/get.dart';
import '../../../services/settings/settingsController.dart';
import '../mazeGame.dart';
import 'WallComponent.dart';

class MazePlayerComponent extends SpriteComponent
    with CollisionCallbacks, HasVisibility, HasGameReference<MazeGame> {
  final SettingsController settingsController = Get.find();

  late double movementSpeed = 30;
  MovingState state = MovingState.none;
  MovingState collisionState = MovingState.none;
  bool isOut = false;
  late final CircleHitbox hitbox;

  late Rectangle startCell;
  late final bool isVerticalScreen;
  late final double spriteRatio;

  bool isBlinkMode = false;
  Vector2 relativeMovementDelta = Vector2(0,0);
  Vector2 lastValidPosition = Vector2(0,0);
  Vector2 lastPosition = Vector2(0,0);

  MazePlayerComponent({required this.startCell, required this.isVerticalScreen})
      : super(
            anchor: Anchor.center,
            position: Vector2(startCell.left, startCell.top),
            size: Vector2(startCell.width, startCell.height));

  @override
  Future<void> onLoad() async {
    super.onLoad();

    sprite = await game.loadSprite('Games/Maze/mouton_labyrinthe.png');
    spriteRatio = (sprite?.srcSize.x ?? startCell.width) /
        (sprite?.srcSize.y ?? startCell.height);

    var height = startCell.width / 3 * 2;
    var width = height * spriteRatio;

    size = Vector2(width, height);
    resetToStart();

    var radius = min(width / 2, height / 2);
    hitbox =
        CircleHitbox(position: Vector2(width / 2, height / 2), radius: radius)
          ..anchor = Anchor.center
          ..renderShape = false;
    add(hitbox);
  }

  void hide() {
    isVisible = false;
  }

  void show() {
    isVisible = true;
  }

  void updateStartCell(Rectangle newStartCell) {
    startCell=newStartCell;

    var height = startCell.width / 3 * 2;
    var width = height * spriteRatio;

    size = Vector2(width, height);
    resetToStart();
    var radius = min(width / 2, height / 2);
    hitbox.radius = radius;
    hitbox.position = Vector2(width / 2, height / 2);


  }

  @override
  void update(double dt) {
    super.update(dt);


    if (game.isRunning && !game.isGameOver) {
      position.copyInto(lastPosition);
      var onStartCell = position.x > startCell.left &&
          position.x < startCell.right &&
          position.y > startCell.top &&
          position.y < startCell.bottom;
      if (!isOut) {
        if (settingsController.mazeSettings["isFineDirection"]) {
          if (onStartCell) {
            if (isVerticalScreen) {
              relativeMovementDelta.x = 0;
              if(relativeMovementDelta.y<0) {
                relativeMovementDelta.y=0;
              }
            }
            else {
              relativeMovementDelta.y = 0;
              if(relativeMovementDelta.x<0) {
                relativeMovementDelta.x=0;
              }
            }
          }
          if(relativeMovementDelta.x.abs()<=0.005) {
            relativeMovementDelta.x=0;
          }
          if(relativeMovementDelta.y.abs()<=0.005) {
            relativeMovementDelta.y=0;
          }
          if(relativeMovementDelta.x!=0 || relativeMovementDelta.y!=0) {
            position.add(relativeMovementDelta * movementSpeed * dt);
            angle = relativeMovementDelta.screenAngle() + pi;
          }
        }
        else if (state != MovingState.none && collisionState != state) {
          switch (state) {
            case MovingState.left:
              if (!onStartCell) {
                moveLeft(dt);
              }
              break;
            case MovingState.right:
              if (!isVerticalScreen || !onStartCell) {
                moveRight(dt);
              }
              break;
            case MovingState.up:
              if (!onStartCell) {
                moveUp(dt);
              }
              break;
            case MovingState.down:
              if (isVerticalScreen || !onStartCell) {
                moveDown(dt);
              }
              break;
            case MovingState.none:
              break;
          }
        }
      }

      if(position.x != lastPosition.x || position.y != lastPosition.y)
        {
          lastValidPosition = lastPosition;
        }
    }
  }

  void takeHit() {
    blink();
  }

  void blink() {
    isBlinkMode = true;
    add(OpacityEffect.to(0, EffectController(duration: 1, reverseDuration: 1),
        onComplete: () {
      isBlinkMode = false;
    }));
  }

  void resetToStart() {

    movementSpeed = settingsController.mazeSettings["speedMovement"];
    state = MovingState.none;
    isOut = false;
    collisionState = MovingState.none;

    position = Vector2(startCell.left + (startCell.width) / 2,
        startCell.top + (startCell.height) / 2);
    if (!isVerticalScreen) {
      angle = -pi / 2;
    }

  }



  void moveDelta(Vector2 relativeDelta) {
    relativeMovementDelta = relativeDelta;
  }

  void moveLeft(double dt) {
    position.x -= movementSpeed * dt;
    angle = pi / 2;
  }

  void moveRight(double dt) {
    position.x += movementSpeed * dt;
    angle = -pi / 2;
  }

  void moveUp(double dt) {
    position.y -= movementSpeed * dt;
    angle = pi;
  }

  void moveDown(double dt) {
    position.y += movementSpeed * dt;
    angle = 0;
  }


  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (game.isRunning && !game.isGameOver) {
      if (!isOut && other is MazeExitComponent) {
        isOut = true;
      } else if (other is WallComponent) {
        if (collisionState == MovingState.none) {
          collisionState = state;
          if (!isBlinkMode) {
            takeHit();
            game.looseLife();
          }
          position = lastValidPosition;
        }
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is WallComponent) {
      collisionState = MovingState.none;
    }
  }
}
