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
import 'package:baahbox/games/spaceShip/spaceShipGame.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:baahbox/games/spaceShip/components/starComponent.dart';

class StarBackGroundCreator extends Component with HasGameRef<SpaceShipGame> {
  final gapSize = 12;
  late final SpriteSheet spriteSheet;
  Random random = Random();

  StarBackGroundCreator();

  @override
  Future<void> onLoad() async {
    spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: await game.images.load('Jeux/rogue_shooter/stars.png'),
      rows: 4,
      columns: 4,
    );
    final starGapTime = (game.size.y / gapSize) / StarComponent.speed;
    add(
      TimerComponent(
        period: starGapTime,
        repeat: true,
        onTick: () => _createRowOfStars(0),
      ),
    );

    _createInitialStars();
  }

  void _createStarAt(double x, double y) {
    final animation = spriteSheet.createAnimation(
      row: random.nextInt(3),
      to: 4,
      stepTime: 0.1,
    )..variableStepTimes = [max(20, 100 * random.nextDouble()), 0.1, 0.1, 0.1];

    game.add(StarComponent(animation: animation, position: Vector2(x, y)));
  }

  void _createRowOfStars(double y) {
    const gapSize = 6;
    final starGap = game.size.x / gapSize;
    if (game.appController.isActive) {
      for (var i = 0; i < gapSize; i++) {
        _createStarAt(
          starGap * i + (random.nextDouble() * starGap),
          y + (random.nextDouble() * 20),
        );
      }
    }
  }

  void _createInitialStars() {
    final rows = game.size.y / gapSize;

    for (var i = 0; i < gapSize; i++) {
      _createRowOfStars(i * rows);
    }
  }
}
