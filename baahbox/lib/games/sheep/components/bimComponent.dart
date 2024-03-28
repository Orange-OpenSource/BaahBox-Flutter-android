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

class BimComponent extends SpriteComponent {
  static final Vector2 initialSize = Vector2.all(10);
  final bimSprite = Sprite(Flame.images.fromCache('Jeux/Sheep/bang.png'));

  BimComponent({required super.position}): super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    initialize();
  }

  void initialize() {
    this.sprite = bimSprite;
    this.size = bimSprite.originalSize/10;
    blink();
  }

  void blink() {
    add(OpacityEffect.to(
        255, EffectController(duration: 0.5, reverseDuration: 20)));
  }
}
