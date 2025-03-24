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
import 'package:flutter/rendering.dart';

import '../mazeGame.dart';

class MazeExitComponent extends PositionComponent with CollisionCallbacks,
    HasGameReference<MazeGame> {

  late final RectangleHitbox hitbox;


  MazeExitComponent({  required super.position, super.size})
      : super(anchor: Anchor.topLeft);
  @override
  Future<void> onLoad() async {
    initialize();
  }

  void initialize() {

    hitbox = RectangleHitbox(position: Vector2(0,0), size: size)
      ..collisionType= CollisionType.passive
      ..renderShape = false;
    add(hitbox);

  }
}
