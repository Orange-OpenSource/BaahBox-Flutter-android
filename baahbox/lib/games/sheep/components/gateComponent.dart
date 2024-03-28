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

import 'package:baahbox/constants/enums.dart';
import 'package:flame/flame.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:baahbox/games/sheep/sheepGame.dart';


class GateComponent extends SpriteComponent
    with HasGameRef<SheepGame>, CollisionCallbacks {

  late ObjectVelocity speedScale;
  final Vector2 deltaPosition = Vector2.zero();
  final obstacleSprite = Sprite(Flame.images.fromCache('Jeux/Sheep/gate.png'));
  var isNewComer = true;
  late Vector2 speed;

  GateComponent({required this.speedScale}) :
       super(anchor: Anchor.bottomCenter, size: Vector2(10, 80));

  @override
  Future<void> onLoad() async {
    initialize();
    resetPosition();
  }

  void reset(ObjectVelocity speedScale) {
    resetPosition();
    this.speedScale = speedScale;
    speed = Vector2(-1, 0)..scale(this.speedScale.value * 50);
  }
  void resetPosition() {
    position = Vector2(gameRef.size.x + size.x / 2, gameRef.floorY);
    isNewComer = true;
  }

  void initialize() {
    this.sprite = obstacleSprite;
    this.size = obstacleSprite.originalSize / 10;
    add(RectangleHitbox(collisionType: CollisionType.passive));
    speed = Vector2(-1, 0)..scale(this.speedScale.value * 50);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.isRunning) {
      deltaPosition
        ..setFrom(speed)
        ..scale(dt);
      position += deltaPosition;

      if (x < -size.x / 2) {
        x = game.size.x + size.x;
        isNewComer = true;
        gameRef.nbDisplayedGates += 1;
      } else {
        isNewComer = false;
      }
    }
  }

  bool isVisible() {
    return (x + size.x / 2 > 0);
  }

  void takeHit() {}
}
