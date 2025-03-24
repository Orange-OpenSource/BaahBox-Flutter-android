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

import 'package:baahbox/games/maze/components/MazeExitComponent.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';

import '../../../constants/enums.dart';
import '../mazeGame.dart';
import 'WallComponent.dart';

class MazePlayerComponent extends CircleComponent with CollisionCallbacks, HasVisibility,
    HasGameReference<MazeGame> {
  static const double speed = 20;
  static const double movementSpeed = 50;
  MovingState state = MovingState.none;
  MovingState collisionState = MovingState.none;
  bool isOut = false;
  late final CircleHitbox hitbox;
  late final Vector2 startPosition;


  MazePlayerComponent({required this.startPosition, required super.radius})
      : super(anchor: Anchor.topLeft, position: startPosition, paint:  Paint()
    ..color = BBColor.violet.color
    ..style = PaintingStyle.fill);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    hitbox = CircleHitbox()
    ..radius=radius
      ..anchor= Anchor.topLeft
      ..paint = paint
      ..renderShape = false;

    add(hitbox);
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


      if(!isOut && state!=MovingState.none && collisionState!=state) {
        switch (state) {
          case MovingState.left:
            moveLeft(dt);
            break;
          case MovingState.right:
            moveRight(dt);
            break;
          case MovingState.up:
            moveUp(dt);
            break;
          case MovingState.down:
            moveDown(dt);
            break;
          case MovingState.none:
            break;
        }
      }
  }

  void resetToStartPosition() {
    position = startPosition;
    state=MovingState.none;
    isOut = false;
    collisionState=MovingState.none;

  }
  void moveLeft(double dt) {
    position.x -= movementSpeed * dt;
  }

  void moveRight(double dt) {
    position.x += movementSpeed * dt;
  }

  void moveUp(double dt) {
    position.y -= movementSpeed * dt;
  }

  void moveDown(double dt) {
    position.y += movementSpeed * dt;
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