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
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';

class MarkComponent extends SpriteComponent
    with HasGameRef {

  MarkComponent({required Vector2 position})
      : super(
    size: Vector2(75, 100),
    position: position,
    anchor: Anchor.bottomLeft,
  );

  final _sprite = Sprite(Flame.images.fromCache('Jeux/Sheep/gate.png'));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    this.sprite = _sprite;
    size = _sprite.srcSize /25;
  }

  void disappear() {
    this.add(
    OpacityEffect.fadeOut(
    EffectController(duration: 0.75)
    ));
    removeFromParent();
  }

  void appear() {
    this.add(
        OpacityEffect.fadeIn(
            EffectController(duration: 0.75)
        ));
  }

}
