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


import 'package:baahbox/games/maze/mazeGame.dart';
import 'package:flame/components.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:baahbox/services/settings/settingsController.dart';

import 'MazeLifeComponent.dart';

class MazeLifeManager extends PositionComponent with HasGameRef<MazeGame>, HasVisibility {
  final SettingsController settingsController = Get.find();
  final lifeArray = [];
  final gapSize = 5;
  late  Vector2 lifeSize;

  MazeLifeManager({required this.lifeSize, required super.position})
      : super(
    anchor: Anchor.bottomRight,
    priority:1
  );
  @override
  Future<void> onLoad() async {
    super.onLoad();

    var sprite = await gameRef.loadSprite('Games/Maze/mouton_labyrinthe.png');
    var ratio = (sprite.srcSize.x) / (sprite.srcSize.y );

    /*var height =  lifeSize.x / 3 * 2;
    var width = height * ratio;*/
    var height =  lifeSize.y;
    var width = height * ratio;


    lifeSize = Vector2(width, height);

    createLifes();
  }
  void hide() {
    isVisible = false;
  }

  void show() {
    isVisible = true;
  }


  void createLifes() {

    while(lifeArray.isNotEmpty)
      {
        remove(lifeArray.first);
        lifeArray.removeAt(0);
      }
    var maxTouch =  settingsController.mazeSettings["maxTouches"];
    size = Vector2((lifeSize.x+gapSize)*maxTouch, lifeSize.y);

    for (var i = 0; i <maxTouch; i++) {
      var xpos = (lifeSize.x+gapSize) * i;
      _createLifeAt(xpos, 0);
    }
  }

  void _createLifeAt(double x, double y) {
    final life = MazeLifeComponent(position: Vector2(x, y), size:lifeSize);
    lifeArray.add(life);
    add(life);
  }

  void looseOneLife() {
    if (lifeArray.isNotEmpty) {
      lifeArray.first.disappear();
      lifeArray.removeAt(0);
    } else {
      (game as MazeGame).setGameStateToWon(false);
    }
  }
}
