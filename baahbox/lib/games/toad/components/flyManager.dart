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
import 'package:baahbox/games/toad/components/flyScoreComponent.dart';
import 'package:baahbox/games/toad/toadGame.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:baahbox/services/settings/settingsController.dart';

class FlyManager extends Component with HasGameRef<ToadGame> {
  final SettingsController settingsController = Get.find();
  var scoreArray = [];
  final gapSize = 5;

  @override
  Future<void> onLoad() async {
    createScores();
  }

  void createScores() {
    scoreArray = [];
    var nbFLies = settingsController.toadSettings["numberOfFlies"];
    var gap = (gameRef.size.x - 40.0 - (nbFLies*15)) / (nbFLies -1);
    for (var i = 0; i < nbFLies; i++) {
       var xPos = (20 + (gap+ 15.0) * i);
       _createScoreAt(xPos, gameRef.size.y - 10);
    }
  }

  void _createScoreAt(double x, double y) {
    final fly = FlyScoreComponent(position: Vector2(x, y));
    scoreArray.add(fly);
    gameRef.add(fly);
  }

  void looseOneScore() {
    var nbScores = scoreArray.length;
    if (nbScores > 0) {
      scoreArray.last.setSpriteTo();
      scoreArray.removeLast();
    } else {
      game.endGame();
    }
  }
}
