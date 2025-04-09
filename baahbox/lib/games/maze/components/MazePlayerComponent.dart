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
import 'package:flame/experimental.dart';
import 'package:flutter/rendering.dart';

import '../../../constants/enums.dart';
import '../mazeGame.dart';
import 'WallComponent.dart';

class MazePlayerComponent extends SpriteComponent with CollisionCallbacks, HasVisibility,
    HasGameRef<MazeGame> {
  static const double speed = 20;
  static const double movementSpeed = 50;
  MovingState state = MovingState.none;
  MovingState collisionState = MovingState.none;
  bool isOut = false;
  late final CircleHitbox hitbox;

  late final Rectangle startCell;
  late final bool isVerticalScreen;


  MazePlayerComponent({  required this.startCell, required this.isVerticalScreen})
      : super(anchor: Anchor.center,
      position: Vector2(startCell.left, startCell.top),
      size:Vector2(startCell.width,startCell.height));

  @override
  Future<void> onLoad() async {
    super.onLoad();

    sprite = await gameRef.loadSprite('Games/Maze/mouton_labyrinthe.png');
    var ratio = (sprite?.srcSize.x ?? startCell.width) / (sprite?.srcSize.y ?? startCell.height);

    var height = startCell.width/3*2;
    var width = height*ratio;

    size = Vector2(width,height);
    resetToStartCellPosition();

    var radius = min(width/2,height/2);
    hitbox = CircleHitbox(position: Vector2(width/2,height/2), radius: radius)
    ..anchor=Anchor.center
      ..renderShape = false;
    add(hitbox);
  }

  void resetToStartCellPosition() {
    position = Vector2(startCell.left+(startCell.width)/2, startCell.top+(startCell.height)/2);
    if(!isVerticalScreen) {
      angle = -pi/2;
    }
  }

  void hide() {
    isVisible = false;
  }

  void show() {
    isVisible = true;
  }
  @override
  void update(double dt) {
    super.update(dt);

      var onStartCell = position.x>startCell.left && position.x<startCell.right &&
          position.y>startCell.top && position.y<startCell.bottom;
      if(!isOut && state!=MovingState.none && collisionState!=state) {
        switch (state) {
          case MovingState.left:
            if(!onStartCell) {
              moveLeft(dt);
            }
            break;
          case MovingState.right:
            if(!isVerticalScreen || !onStartCell) {
              moveRight(dt);
            }
            break;
          case MovingState.up:
            if(!onStartCell) {
              moveUp(dt);
            }
            break;
          case MovingState.down:
            if(isVerticalScreen || !onStartCell) {
              moveDown(dt);
            }
            break;
          case MovingState.none:
            break;
        }
      }
  }

  void resetToStartPosition() {
    resetToStartCellPosition();
    state=MovingState.none;
    isOut = false;
    collisionState=MovingState.none;

  }
  void moveLeft(double dt) {
    position.x -= movementSpeed * dt;
    angle = pi/2;
  }

  void moveRight(double dt) {
    position.x += movementSpeed * dt;
    angle = -pi/2;
  }

  void moveUp(double dt) {
    position.y -= movementSpeed * dt;
    angle = pi;
  }

  void moveDown(double dt) {
    position.y += movementSpeed * dt;
    angle = 0;
  }
  Vector2 _cornerBumpDistance(
      Vector2 directionVector, Vector2 pointA, Vector2 pointB) {
    var dX = pointA.x - pointB.x;
    var dY = pointA.y - pointB.y;
    // The order of the two intersection points differs per corner
    // The following if statements negates the necessary values to make the
    // player move back to the right position
    if (directionVector.x > 0 && directionVector.y < 0) {
      // Top right corner
      dX = -dX;
    } else if (directionVector.x > 0 && directionVector.y > 0) {
      // Bottom right corner
      dX = -dX;
    } else if (directionVector.x < 0 && directionVector.y > 0) {
      // Bottom left corner
      dY = -dY;
    } else if (directionVector.x < 0 && directionVector.y < 0) {
      // Top left corner
      dY = -dY;
    }
    // The absolute smallest of both values determines from which side the player bumps
    // and therefor determines the needed displacement
    if (dX.abs() < dY.abs()) {
      return Vector2(dX, 0);
    } else {
      return Vector2(0, dY);
    }
  }
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if( !isOut && other is MazeExitComponent)
      {
        isOut=true;
      }
    else if (other is WallComponent) {
      if (collisionState == MovingState.none) {
          if (intersectionPoints.length == 2) {

            var pointA = intersectionPoints.elementAt(0);
            var pointB = intersectionPoints.elementAt(1);
            final mid = (pointA + pointB) / 2;
            final collisionVector = absoluteCenter - mid;
            if (pointA.x == pointB.x || pointA.y == pointB.y) {
              // Hitting a side without touching a corner
              double penetrationDepth = (size.x / 2) - collisionVector.length;
              collisionVector.normalize();
              position += collisionVector.scaled(penetrationDepth);
            } else {
              position += _cornerBumpDistance(collisionVector, pointA, pointB);
            }

            //collisionState = state;
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