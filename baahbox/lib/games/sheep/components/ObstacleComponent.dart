import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
//import 'package:baahbox/games/sheep/components/bingComponent.dart';
import 'package:baahbox/games/sheep/sheepGame.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'dart:math';
import 'package:flame/effects.dart';

class ObstacleComponent extends SpriteComponent
    with HasGameRef<SheepGame>, CollisionCallbacks {
  static const speed = 100;
  static final Vector2 initialSize = Vector2.all(100);

  ObstacleComponent({required super.position})
      : super(anchor: Anchor.center);

  final obstacleSprite = Sprite(Flame.images.fromCache('Jeux/Sheep/gate.png'));


  @override
  Future<void> onLoad() async {
    initialize();
    add(RectangleHitbox(collisionType: CollisionType.passive));
    //super.onLoad();
  }

  void initialize() {
    this.sprite = obstacleSprite;
    this.size = obstacleSprite.originalSize/10;

  }

  @override
  void update(double dt) {
    super.update(dt);
    y += speed * dt;
    if (y >= game.size.y) {
      removeFromParent();
    }
  }

  bool isVisible() {
    return (x+size.x/2 > game.size.x);
  }

  void disappear() {
    this.add(
        OpacityEffect.fadeOut(
            EffectController(duration: 0.75)
        ));
    removeFromParent();
  }

  void takeHit() {
    disappear();
   // game.onCollision();
  }
}
