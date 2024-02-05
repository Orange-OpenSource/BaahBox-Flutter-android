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
