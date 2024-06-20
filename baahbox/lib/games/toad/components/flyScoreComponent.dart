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

import 'package:baahbox/games/toad/toadGame.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';

class FlyScoreComponent extends SpriteComponent with HasVisibility, HasGameRef<ToadGame> {
  FlyScoreComponent({required Vector2 position})
      : super(
    size: Vector2(100, 75),
    position: position,
    anchor: Anchor.bottomLeft,
  );

  final emptyScoreSprite = Sprite(Flame.images.fromCache('Games/Toad/fly_score_empty.png'));
  final fullScoreSprite = Sprite(Flame.images.fromCache('Games/Toad/fly_score_full.png'));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    this.sprite = emptyScoreSprite;
    size = emptyScoreSprite.srcSize /15;
  }

  void setSpriteTo({int spriteNb = 0}) {
    switch (spriteNb) {
      case 1:
        sprite = emptyScoreSprite;
      default:
        sprite = fullScoreSprite;
    }
  }

  void appear() {
    this.add(
        OpacityEffect.fadeIn(
            EffectController(duration: 0.75)
        ));
  }

  void disappear() {
    isVisible = false;
    this.add(
        OpacityEffect.fadeOut(
            EffectController(duration: 0.75)
        ));
    removeFromParent();
  }

}
