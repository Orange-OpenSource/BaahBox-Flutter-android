import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:baahbox/games/spaceShip/components/explosion_component.dart';
import 'package:baahbox/games/spaceShip/spaceShipGame.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'dart:math';
import 'package:flame/effects.dart';

import 'package:flutter/cupertino.dart';

class MeteorComponent extends SpriteComponent
    with HasGameRef<SpaceShipGame>, CollisionCallbacks {
  static const speed = 100;
  static final Vector2 initialSize = Vector2.all(100);

  MeteorComponent({required super.position})
      : super(anchor: Anchor.center);

  final meteor1Sprite = Sprite(Flame.images.fromCache('Jeux/Spaceship/meteor_01@3x.png'));
  final meteor2Sprite = Sprite(Flame.images.fromCache('Jeux/Spaceship/meteor_02@3x.png'));
  final meteor3Sprite = Sprite(Flame.images.fromCache('Jeux/Spaceship/meteor_03@3x.png'));
  final meteor4Sprite = Sprite(Flame.images.fromCache('Jeux/Spaceship/meteor_04@3x.png'));
  final meteor5Sprite = Sprite(Flame.images.fromCache('Jeux/Spaceship/meteor_05@3x.png'));
  final meteor6Sprite = Sprite(Flame.images.fromCache('Jeux/Spaceship/meteor_06@3x.png'));

  @override
  Future<void> onLoad() async {
       initialize();
       add(CircleHitbox(collisionType: CollisionType.passive));
     //super.onLoad();
  }

  void initialize() {
    var rng = new Random();
    var i = rng.nextInt(6) + 1;
    var imageName = 'Jeux/Spaceship/meteor_0$i@3x.png';
    final newSprite = Sprite(Flame.images.fromCache(imageName));
    this.sprite = newSprite;
    this.size = newSprite.originalSize/10;
  }

  @override
  void update(double dt) {
    super.update(dt);
    y += speed * dt;
    if (y >= game.size.y) {
      removeFromParent();
    }
  }
  void disappear() {
    this.add(
        OpacityEffect.fadeOut(
            EffectController(duration: 0.75)
        ));
    removeFromParent();
  }

  void takeHit() {
   // game.add(ExplosionComponent(position: position));
    this.disappear();
    game.onCollision();
  }
}
