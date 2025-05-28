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

class MazeWinComponent extends SpriteComponent with HasVisibility, HasGameReference<MazeGame> {

  MazeWinComponent({  super.position, required super.size})
      : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    initialize();
  }
  void hide() {
    isVisible = false;
  }

  void show() {
    isVisible = true;
  }
  Future<void> initialize() async {
    sprite = await game.loadSprite('Games/Maze/trefle.png');
    var ratio = (sprite?.srcSize.x ?? size.x) / (sprite?.srcSize.y ?? size.y);
    var width = size.x;
    var height = width/ratio;
    size = Vector2(width,height);

  }

}
