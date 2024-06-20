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

import 'dart:math' as math;
import 'dart:math';
import 'dart:core';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:baahbox/games/toad/toadGame.dart';
import 'package:flame/geometry.dart';

class ToadComponent extends SpriteComponent
    with  HasVisibility,
        HasGameRef<ToadGame> {
  ToadComponent()
      : super(size: Vector2(100, 100), anchor: Anchor.bottomCenter);

  final toadSprite = Sprite(Flame.images.fromCache('Games/Toad/toad.png'));
  final toadBlinkSprite = Sprite(Flame.images.fromCache('Games/Toad/toad_blink.png'));

  final blinkingImages = [
    Flame.images.fromCache('Games/Toad/toad.png'),
    Flame.images.fromCache('Games/Toad/toad_blink.png'),
  ];

  late final _binkTimer = TimerComponent(
    period: .25,
    onTick: setSpriteTo,
    autoStart: false,
  );

  late final _shootTimer = TimerComponent(
    period: 1.0,
    onTick: resetToadShooting,
    autoStart: false,
  );
  final Vector2 deltaPosition = Vector2.zero();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await add(_binkTimer);
    await add(_shootTimer);
    initialize();
  }

  void initialize() {
    this.sprite = toadSprite;
    var ratio = toadSprite.srcSize.x / toadSprite.srcSize.y;
    var width = gameRef.size.x * 3/8;
    size = Vector2(width,width/ratio);
    anchor = Anchor.center;
    position =  Vector2(gameRef.size.x / 2, gameRef.size.y - size.y -150);
    angle = nativeAngle;
    show();
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

  void blink() {
    setSpriteTo(spriteNb: 1);
    _binkTimer.timer.start();
  }

  void jump() {}
  void resetToadShooting() {
    gameRef.isToadShooting = false;
  }

  void rotateBy(int deltaAngle) {
    {
      var delta = (deltaAngle/ 180 * math.pi/2);
      var newAngle = angle + delta;
      if ( newAngle> tau/4 || newAngle < -tau/4) { return ;}
      for (double interAngle = 0; interAngle < delta; interAngle++) {
        angle = angle + interAngle;
      }
      angle = newAngle;

    }
  }

  bool checkFlies({bool automaticMode = true}) {
   bool gotOne = false;
    for (double x in gameRef.flyNet.keys) {
      var _flyX = gameRef.flyNet[x]!;
      var target = Vector2(x, _flyX);
      var angleToTarget = angleTo(target);
       var deltaAngle = automaticMode ?  pi / 360 : pi/ 90;
      if (angleToTarget.abs() <= deltaAngle) {
        shoot(distance: position.distanceTo(target));
        gotOne = true;
      }
    }
    return gotOne;
  }

  void setSpriteTo({int spriteNb = 0}) {
    switch (spriteNb) {
      case 1:
        sprite = toadBlinkSprite;
      default:
        sprite = toadSprite;
    }
  }

  SpriteAnimation getBlinkAnimation() {
    final sprites = blinkingImages.map((image) => Sprite(image)).toList();
    return SpriteAnimation.spriteList(sprites, stepTime: 1);
  }

  void shoot({double distance = 300.0}) {
    gameRef.isToadShooting = true;
    gameRef.tongue.priority = -1;
    gameRef.tongue.showAtAngle(angle, distance);
    blink();
    _shootTimer.timer.start();
    // animateToadForShooting();
    //setSpriteTo(3);
  }
}
