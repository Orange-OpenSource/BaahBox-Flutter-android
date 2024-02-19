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
import 'package:flame/flame.dart';
import '../background/cloud_manager.dart';
import '../random_extension.dart';
import '../sheepGame.dart';

class Cloud extends SpriteComponent
    with ParentIsA<CloudManager>, HasGameRef<SheepGame> {
  Cloud({required Vector2 position})
      : cloudGap = random.fromRange(
          minCloudGap,
          maxCloudGap,
        ),
        super(
          position: position,
          size: initialSize,
        );

  static Vector2 initialSize = Vector2(92.0, 28.0);

  static const double maxCloudGap = 400.0;
  static const double minCloudGap = 100.0;

  static const double maxSkyLevel = 300.0;
  static const double minSkyLevel = 100.0;

  final double cloudGap;

  @override
  Future<void> onLoad() async {
    sprite = Sprite(
        Flame.images.fromCache('trex.png'),
      srcPosition: Vector2(166.0, 2.0),
      srcSize: initialSize,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isRemoving) {
      return;
    }
    x -= 50 * dt;
    if (!isVisible) {
      removeFromParent();
    }
  }

  bool get isVisible {
    return x + width > 0;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
   // y = ((absolutePosition.y / 2 - (maxSkyLevel - minSkyLevel)) +
   //          random.fromRange(minSkyLevel, maxSkyLevel)) -
   //      absolutePositionOf(absoluteTopLeftPosition).y;
  }
}
