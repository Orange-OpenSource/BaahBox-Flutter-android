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
import 'package:flame/extensions.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../../../services/settings/settingsController.dart';
import '../MazeFactory.dart';
import '../mazeGame.dart';
import 'MazeExitComponent.dart';
import 'WallComponent.dart';

class MazeComponent extends PositionComponent
    with HasVisibility, HasGameReference<MazeGame> {
  final SettingsController settingsController = Get.find();

  late final MazeFactory mazeController;
  late Rectangle exitCell;
  late Rectangle startCell;
  late Vector2 cellSize;
  late double mazeWallWidth;
  late bool isVertical;

  MazeComponent(
      {required this.mazeController,
      required this.isVertical,
      required super.position,
      super.size})
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
    int nbCells = settingsController.mazeSettings.mazeSize;
    mazeController.makeMaze(nbCells, nbCells);
    removeAll(children.query());
    double startOffset = 10;
    double topOffset = 10;
    var cellUnitX = (size.x - 2 * startOffset) / MazeFactory.NB_COL;
    var cellUnitY = (size.y - topOffset) / MazeFactory.NB_ROW;
    var cellRefUnit = cellUnitX < cellUnitY ? cellUnitX : cellUnitY;

    if (isVertical) {
      if (cellRefUnit * (MazeFactory.NB_ROW + 2) >= size.y) {
        cellUnitY = (size.y - topOffset) / (MazeFactory.NB_COL + 2);
        cellRefUnit = cellUnitY;
      }
    } else {
      if (cellRefUnit * (MazeFactory.NB_COL + 2) >= size.x) {
        cellUnitX = (size.x - 2 * startOffset) / (MazeFactory.NB_ROW + 2);
        cellRefUnit = cellUnitX;
      }
    }


    mazeWallWidth = cellRefUnit / 10;
    if (isVertical) {
      startOffset =
          (size.x - MazeFactory.NB_COL * (cellRefUnit - mazeWallWidth)) / 2;
    } else {
      startOffset =
          (size.x - (MazeFactory.NB_COL + 2) * (cellRefUnit - mazeWallWidth)) /
              2;
    }

    cellSize = Vector2(cellRefUnit, cellRefUnit);
    Vector2 wallSizeHorizontal = Vector2(cellRefUnit, mazeWallWidth);
    Vector2 wallSizeVertical = Vector2(mazeWallWidth, cellRefUnit);
    int currentCell = 0;

    if (isVertical) {
      startCell = Rectangle.fromLTWH(
          startOffset + (cellSize.x - mazeWallWidth) * (MazeFactory.NB_COL - 1),
          topOffset +
              (cellSize.y - mazeWallWidth) * (MazeFactory.NB_ROW) +
              cellRefUnit,
          cellRefUnit,
          cellRefUnit);
      exitCell = Rectangle.fromLTWH(
          x + startOffset, y + topOffset, cellRefUnit, cellRefUnit);
    } else {
      exitCell = Rectangle.fromLTWH(
          startOffset, y + topOffset, cellRefUnit, cellRefUnit);
      startCell = Rectangle.fromLTWH(
          x +
              startOffset +
              (cellSize.x - mazeWallWidth) * (MazeFactory.NB_COL) +
              cellRefUnit,
          topOffset + (cellSize.y - mazeWallWidth) * (MazeFactory.NB_ROW - 1),
          cellRefUnit,
          cellRefUnit);
    }

    for (int i = 0; i < MazeFactory.NB_COL; i++) {
      for (int j = 0; j < MazeFactory.NB_ROW; j++) {
        currentCell = mazeController.mazeCells[j][i];
        var cellX = startOffset +
            (isVertical
                ? (cellSize.x - mazeWallWidth) * i
                : (cellSize.x - mazeWallWidth) * (i + 1));
        var cellY = topOffset +
            (isVertical
                ? (cellSize.y - mazeWallWidth) * (j + 1)
                : (cellSize.y - mazeWallWidth) * j);
        if (currentCell & MazeFactory.TOP != 0 &&
            !(i == 0 && j == 0 && isVertical)) {
          await add(WallComponent(
              isHorizontal: true,
              position: Vector2(cellX, cellY),
              size: wallSizeHorizontal));
        }
        if (currentCell & MazeFactory.RIGHT != 0 &&
            !(!isVertical &&
                i == (MazeFactory.NB_COL - 1) &&
                j == (MazeFactory.NB_ROW - 1))) {
          await add(WallComponent(
              isHorizontal: false,
              position: Vector2(cellX + cellSize.x - wallSizeVertical.x, cellY),
              size: wallSizeVertical));
        }
        if (currentCell & MazeFactory.BOTTOM != 0 &&
            !(isVertical &&
                i == (MazeFactory.NB_COL - 1) &&
                j == (MazeFactory.NB_ROW - 1))) {
          await add(WallComponent(
              isHorizontal: true,
              position:
                  Vector2(cellX, cellY + cellSize.y - wallSizeHorizontal.y),
              size: wallSizeHorizontal));
        }
        if (currentCell & MazeFactory.LEFT != 0 &&
            !(i == 0 && j == 0 && !isVertical)) {
          await add(WallComponent(
              isHorizontal: false,
              position: Vector2(cellX, cellY),
              size: wallSizeVertical));
        }
      }
    }

    add(MazeExitComponent(endCell: exitCell));
    add(RectangleComponent(
        paint: Paint()..color = Color(0X55ffff), size: size));
  }
}
