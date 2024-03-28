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

import 'package:baahbox/games/balloon/balloonGame.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class BalloonComponent extends SpriteComponent with HasGameRef<BalloonGame> {
  BalloonComponent() : super(size: Vector2.all(16.0), anchor: Anchor.center);

  final balloonstartSprite =
      Sprite(Flame.images.fromCache('Jeux/Balloon/ballon_00@2x.png'));
  final balloonlowSprite =
      Sprite(Flame.images.fromCache('Jeux/Balloon/ballon_01@2x.png'));
  final balloonmediumSprite =
      Sprite(Flame.images.fromCache('Jeux/Balloon/ballon_02@2x.png'));
  final balloonhighSprite =
      Sprite(Flame.images.fromCache('Jeux/Balloon/ballon_03@2x.png'));
  final balloonexplodeSprite =
      Sprite(Flame.images.fromCache('Jeux/Balloon/ballon_04@2x.png'));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    initialize();
  }

  void initialize() {
    this.sprite = balloonstartSprite;
    size = balloonstartSprite.srcSize / 4;
    position = Vector2(gameRef.size.x / 2,
        (gameRef.size.y) / 2 + balloonstartSprite.srcSize.y / 4);
    this.anchor = Anchor.bottomCenter;
  }

  @override
  void update(double dt) {
    super.update(dt);
    updateSprite(dt);
  }

  updateSprite(double dt) {
    int coeff = (gameRef.input / 100).toInt();
    switch (coeff) {
      case 0 || 1:
        setTo(balloonstartSprite, 0);
      case 2 || 3 || 4 || 5 || 6 || 7:
        setTo(balloonlowSprite, gameRef.input);
      case 8 || 9 || 10:
        setTo(balloonexplodeSprite, 0);
    }
  }

  setTo(Sprite newSprite, int coeff) {
    if (this.sprite != newSprite) {
      this.sprite = newSprite;
      final newSize = newSprite.srcSize;
      this.size = newSize / 4;
    } else if (coeff > 0) {
      var newSize = this.sprite?.srcSize ?? Vector2(400, 600);
      this.size = newSize * (coeff / 1000).toDouble();
    }
  }
}
