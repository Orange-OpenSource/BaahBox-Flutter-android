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

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class JoystickPlayer extends SpriteComponent
    with HasGameRef, CollisionCallbacks {
  /// Pixels/s
  double maxSpeed = 300.0;
  late final Vector2 _lastSize = size.clone();
  late final Transform2D _lastTransform = transform.clone();

  final JoystickComponent joystick;

  JoystickPlayer(this.joystick)
      : super(size: Vector2.all(100.0), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('layers/player.png');
    position = gameRef.size / 2;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    if (!joystick.delta.isZero() && activeCollisions.isEmpty) {
      _lastSize.setFrom(size);
      _lastTransform.setFrom(transform);
      position.add(joystick.relativeDelta * maxSpeed * dt);
      angle = joystick.delta.screenAngle();
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints,
      PositionComponent other,
      ) {
    super.onCollisionStart(intersectionPoints, other);
    transform.setFrom(_lastTransform);
    size.setFrom(_lastSize);
  }
}