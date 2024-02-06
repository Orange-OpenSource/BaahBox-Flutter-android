import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/effects.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:baahbox/games/sheep/components/gateComponent.dart';
import 'package:baahbox/games/sheep/sheepGame.dart';
import '../../../constants/enums.dart';

class SheepComponent extends SpriteComponent //AnimationComponent
    with HasGameRef<SheepGame>, CollisionCallbacks {
  SheepComponent({required super.position}): super(size: Vector2(75, 100), anchor: Anchor.bottomCenter);

  final walkingImages = [
    Flame.images.fromCache('Jeux/Sheep/sheep_01.png'),
    Flame.images.fromCache('Jeux/Sheep/sheep_02.png'),
  ];
  var walking1 = true;

  final walkingSprite1 =
  Sprite(Flame.images.fromCache('Jeux/Sheep/sheep_01.png'));
  final walkingSprite2 =
  Sprite(Flame.images.fromCache('Jeux/Sheep/sheep_02.png'));
  final jumpSprite =
  Sprite(Flame.images.fromCache('Jeux/Sheep/sheep_03.png'));
  final oupsSprite =
  Sprite(Flame.images.fromCache('Jeux/Sheep/sheep_04.png'));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    initialize();
    add(RectangleHitbox());
    //animation = await getAnimation();
  }
  void initialize() {
    this.sprite = walkingSprite1;
    size = walkingSprite1.srcSize / 10;
   // animation = getAnimation();
  }
  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.state == GameState.running) {
      checkCostume();
      }
    goDown();
  }

  void goDown() {
    var yPos = position.y +1;
    position.y = min(yPos,gameRef.floorY);
    }

  void moveTo(double yPos) {
    if (isPosInFrame(yPos)) {
      position.y = yPos;
    }
  }

  bool isPosInFrame(double y) {
    return (y <= gameRef.floorY) &&
        ((y - size.y) > 0);
  }

 void checkCostume() {
    if (position.y < gameRef.floorY) {
   setSpriteTo(2);
    }
    else if (position.y == gameRef.floorY) {
       var rng = new Random();
       var i = rng.nextInt(2);
      setSpriteTo(i);
    }
 }

  void setSpriteTo(int spriteNb) {
    switch (spriteNb) {
      case 1:
        sprite = walkingSprite2;
        walking1 = true;
      case 2:
        sprite = jumpSprite;
      case 3:
        sprite = oupsSprite;
      default:
        sprite = walkingSprite1;
        walking1 = false;
    }
  }

  SpriteAnimation getWalkingAnimation() {
    final sprites = walkingImages.map((image) => Sprite(image)).toList();
    return SpriteAnimation.spriteList(sprites, stepTime: 0.2);
  }

  void takeHit() {
   setSpriteTo(3);
   gameRef.setGameStateToWon(false);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints,
      PositionComponent other,
      ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is GateComponent) {
      takeHit();
    }
  }
}
