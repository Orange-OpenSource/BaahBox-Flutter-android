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

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:baahbox/games/spaceShip/components/explosionComponent.dart';
import 'package:baahbox/games/spaceShip/spaceShipGame.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'dart:math';
import 'package:flame/effects.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:get/get.dart';

import '../../../constants/enums.dart';


class MeteorComponent extends SpriteComponent
    with HasGameRef<SpaceShipGame>, CollisionCallbacks {
  static const speed = 100;
  static final Vector2 initialSize = Vector2.all(100);
  final Controller appController = Get.find();

  MeteorComponent({required super.position}) : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    initialize();
    add(CircleHitbox(collisionType: CollisionType.passive));
  }

  void initialize() {
    var rng = new Random();
    var i = rng.nextInt(6) + 1;
    var imageName = 'Jeux/Spaceship/meteor_0$i@3x.png';
    final newSprite = Sprite(Flame.images.fromCache(imageName));
    this.sprite = newSprite;
    this.size = newSprite.originalSize / 10;
  }

  @override
  void update(double dt) {
    super.update(dt);
      y += speed * dt;
      if (isNotVisible() || !gameRef.appController.isActive || gameRef.state == GameState.lost ) {
        removeFromParent();
      }
  }

  bool isNotVisible() {
    return (y >= game.size.y);
  }

  void disappear() {
    game.add(ExplosionComponent(position: position));
    this.add(OpacityEffect.fadeOut(EffectController(duration: 0.75)));
    removeFromParent();
  }

  void takeHit() {
    disappear();
  }
}
