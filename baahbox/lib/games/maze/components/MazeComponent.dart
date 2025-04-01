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

import '../MazeFactory.dart';
import '../mazeGame.dart';
import 'MazeExitComponent.dart';
import 'WallComponent.dart';

class MazeComponent extends PositionComponent with HasVisibility,
    HasGameReference<MazeGame> {

  late final MazeFactory mazeController;
  late Vector2 exitPosition;
  late Vector2 startPosition;
  late Vector2 cellSize;


MazeComponent({  required this.mazeController, required super.position, super.size})
      : super(anchor: Anchor.topLeft);

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

    removeAll(children.query());

    var cellUnitX = (size.x-20) / MazeFactory.NB_COL;
    var cellUnitY = (size.y-20) / MazeFactory.NB_ROW;
    var cellRefUnit = cellUnitX < cellUnitY ? cellUnitX : cellUnitY;
    cellSize = Vector2(cellRefUnit, cellRefUnit);
    Vector2 wallSizeHorizontal = Vector2(cellRefUnit, cellRefUnit/10);
    Vector2 wallSizeVertical = Vector2(cellRefUnit/10, cellRefUnit);
    int currentCell = 0;

    exitPosition = Vector2(10,10);
    startPosition = Vector2(10+cellSize.x*(MazeFactory.NB_COL-1)+cellRefUnit/4,10+cellSize.y*(MazeFactory.NB_ROW-1)+cellRefUnit/4);

    for (int i = 0; i < MazeFactory.NB_COL; i++) {
      for (int j = 0; j < MazeFactory.NB_ROW; j++) {
        currentCell = mazeController.mazeCells[j][i];
        var cellX = 10+cellSize.x*i;
        var cellY = 10+cellSize.y*j;
        if (currentCell & MazeFactory.TOP !=0 && !(i==0 && j==0)) {
          await add(WallComponent(isHorizontal:true, position:Vector2(cellX, cellY), size:wallSizeHorizontal));
        }
        if (currentCell & MazeFactory.RIGHT !=0) {
          await add(WallComponent(isHorizontal:false, position:Vector2(cellX+cellSize.x-wallSizeVertical.x, cellY), size:wallSizeVertical));
        }
        if (currentCell & MazeFactory.BOTTOM !=0 /*&& !(i==(MazeFactory.NB_COL-1) && j==(MazeFactory.NB_ROW-1))*/) {
          await add(WallComponent(isHorizontal:true, position:Vector2(cellX, cellY+cellSize.y-wallSizeHorizontal.y), size:wallSizeHorizontal));
        }
        if (currentCell & MazeFactory.LEFT !=0) {
          await add(WallComponent( isHorizontal:false, position:Vector2(cellX, cellY), size:wallSizeVertical));
        }

      }
    }

    add(MazeExitComponent(position: exitPosition, size:Vector2(wallSizeHorizontal.x, wallSizeHorizontal.y)));

  }
}
