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

import 'dart:io';
import 'dart:math' as math;
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:baahbox/games/toad/toadGame.dart';

class TongueComponent extends SpriteComponent
    with  HasVisibility, HasGameRef<ToadGame>, CollisionCallbacks {
  TongueComponent({required super.position}) : super(anchor: Anchor.bottomCenter);

  final tongueSprite = Sprite(Flame.images.fromCache('Games/Toad/tongue.png'));
  late final _timer = TimerComponent(
    period: .25,
    onTick: hide,
    autoStart: false,
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await add(_timer);
    initialize();
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  void initialize() {
    this.sprite = tongueSprite;
    var ratio = tongueSprite.srcSize.x / tongueSprite.srcSize.y;
    var width = gameRef.size.x/30;
    size = Vector2(width,width/ratio*5);
    priority = 2;
    hide();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  void hide() {
    isVisible = false;
  }

  void show() {
    isVisible = true;
  }

  void showAtAngle(double destAngle, double distance) {
    angle = destAngle;
    scale = Vector2(1.0 ,distance/size.y);
    show();
    _timer.timer.start();

  }
  void takeHit() {
  //  disappear();
  }

  void disappear() {
    this.add(OpacityEffect.fadeOut(EffectController(duration: 0.25)));
    //removeFromParent();
  }
}


