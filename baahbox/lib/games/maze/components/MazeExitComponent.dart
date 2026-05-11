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
import 'package:flame/experimental.dart';

import '../mazeGame.dart';

class MazeExitComponent extends SpriteComponent with CollisionCallbacks,
    HasGameReference<MazeGame> {

  late final RectangleHitbox hitbox;


  late final Rectangle endCell;


  MazeExitComponent({  required this.endCell})
      : super(anchor: Anchor.topLeft,
      position: Vector2(endCell.left, endCell.top),
      size:Vector2(endCell.width,endCell.height));
  @override
  Future<void> onLoad() async {
    initialize();
  }

  Future<void> initialize() async {
    sprite = await game.loadSprite('Games/Maze/trefle.png');
    var ratio = (sprite?.srcSize.x ?? endCell.width) / (sprite?.srcSize.y ?? endCell.height);
    var width = endCell.width/2;
    var height = width/ratio;
    size = Vector2(width,height);
    position = Vector2(endCell.left+(endCell.width-width)/2, endCell.top+(endCell.height-height)/2);
    hitbox = RectangleHitbox(position: Vector2(0,0), size: size)
      ..collisionType= CollisionType.passive
      ..renderShape = false;
    add(hitbox);

  }

}
