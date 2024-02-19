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
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:baahbox/games/sheep/components/markComponent.dart';
import 'package:baahbox/games/sheep/sheepGame.dart';
import 'package:flame/text.dart';

class CounterManager extends Component with HasGameRef<SheepGame> {
  final markArray = [];
  var gateNumber = 1;
  final gapSize = 5;
  late final TextComponent counterText;

  @override
  Future<void> onLoad() async {
    showCount();
    createMarks(gateNumber);
  }

  void showCount() async {
    await gameRef.addAll([
      counterText = TextComponent(
          position: Vector2(5, game.size.y - 40),
          anchor: Anchor.bottomLeft,
          priority: 1,
          size: Vector2(50, 20)),
    ]);
  }

  void createMarks(int nbGates) {
    clearTheFields();
    gateNumber = nbGates;
    counterText.text = "Barrières: ";
    const gapSize = 2;
    for (var i = 0; i < gateNumber; i++) {
      var xpos = (10 + gapSize) * i;
      _createMarkAt(xpos + 10, game.size.y - 10);
    }
  }

  void _createMarkAt(double x, double y) {
    final mark = MarkComponent(position: Vector2(x, y));
    markArray.add(mark);
    gameRef.add(mark);
  }

  void looseOneMark() {
    if (markArray.length > 0) {
      markArray.last.disappear();
      markArray.removeLast();
    } else {
      counterText.text = "";
    }
  }

  void clearTheFields() {
    for (var i = 0; i <= markArray.length+1; i++)
     looseOneMark();
    }
  }

