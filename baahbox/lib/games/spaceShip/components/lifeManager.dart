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

import 'package:flame/components.dart';
import 'package:baahbox/games/spaceShip/components/lifeComponent.dart';
import 'package:baahbox/games/spaceShip/spaceShipGame.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:baahbox/services/settings/settingsController.dart';

class LifeManager extends Component with HasGameRef<SpaceShipGame> {
  final SettingsController settingsController = Get.find();
  final lifeArray = [];
  final gapSize = 5;

  @override
  Future<void> onLoad() async {
    createLifes();
  }

  void createLifes() {
    const gapSize = 6;
    for (var i = 0; i < settingsController.spaceShipSettings.numberOfShips; i++) {
       var xpos = (25 + gapSize) * i;
      _createLifeAt(xpos + 10, game.size.y - 10);
    }
  }

  void _createLifeAt(double x, double y) {
    final life = LifeComponent(position: Vector2(x, y));
    lifeArray.add(life);
    game.add(life);
  }

  void looseOneLife() {
    if (lifeArray.length > 0) {
      lifeArray.last.disappear();
      lifeArray.removeLast();
    } else {
      game.endGame();
    }
  }
}
