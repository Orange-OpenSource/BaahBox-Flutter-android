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
import '../background/cloud.dart';
import '../random_extension.dart';
import '../sheepGame.dart';

class CloudManager extends PositionComponent with HasGameRef<SheepGame> {
  final double cloudFrequency = 0.5;
  final int maxClouds = 20;
  final double cloudSpeed = 1;
  bool isRunning = false;

  @override
  Future<void> onLoad() async {
    start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.appController.isActive && isRunning) {
      final numClouds = children.length;
      if (numClouds > 0) {
        final lastCloud = children.last as Cloud;
        if (numClouds < maxClouds &&
            (gameRef.size.x - lastCloud.x) > lastCloud.cloudGap) {
          addCloud();
        }
      } else {
        addCloud();
      }
    } else {
      clearTheSky();
    }
  }


  void addCloud() {
    final cloudPosition = Vector2(
      gameRef.size.x,
      (gameRef.floorY - (Cloud.maxSkyLevel - Cloud.minSkyLevel)
          - random.fromRange(Cloud.minSkyLevel, Cloud.maxSkyLevel)),
    );
    add(Cloud(position: cloudPosition));
  }


  void clearTheSky() {
    removeAll(children);
  }

  void pause() {
    clearTheSky();
    isRunning = false;
  }

  void start() {
    isRunning = true;
  }
}
