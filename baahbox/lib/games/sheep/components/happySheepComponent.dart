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
import 'package:baahbox/games/sheep/sheepGame.dart';

class HappySheepComponent extends SpriteAnimationComponent
    with HasGameRef<SheepGame> {
  final happySprite1 =
      Sprite(Flame.images.fromCache('Jeux/Sheep/happy_sheep_01.png'));
  final happySprite2 =
      Sprite(Flame.images.fromCache('Jeux/Sheep/happy_sheep_02.png'));

  HappySheepComponent({required super.position, super.size})
      : super(anchor: Anchor.topLeft);

  @override
  Future<void> onLoad() async {
    setAlpha(0);
    final sprites = [
      happySprite2,
      happySprite1,
      happySprite1,
      happySprite1,
      happySprite1,
      happySprite1,
      happySprite1,
      happySprite1,
      happySprite1
    ].toList();
    animation = SpriteAnimation.spriteList(
      sprites,
      stepTime: 0.2,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    var alpha = gameRef.isWon ? 255 : 0;
    setAlpha(alpha);
  }
}
