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

class FlyScoreComponent extends SpriteComponent with HasVisibility, HasGameReference<ToadGame> {
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

  void setSpriteTo() {

    var startPosition = Vector2(game.toad.position.x, game.toad.position.y+game.toad.height/2);
    var animSprite = SpriteComponent(sprite:fullScoreSprite, position:startPosition,
    size: size, scale: Vector2(0.1,0.1), anchor: Anchor.bottomLeft,);
    game.add(animSprite);
    animSprite.add(ScaleEffect.to(Vector2(1, 1),
    EffectController(duration: 0.5, startDelay:0.3)));
    animSprite.add(SequenceEffect([MoveEffect.to(position,
        EffectController(duration: 0.5, startDelay:0.3),
    ),
    RemoveEffect()],onComplete: ()=>{sprite=fullScoreSprite}));
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
