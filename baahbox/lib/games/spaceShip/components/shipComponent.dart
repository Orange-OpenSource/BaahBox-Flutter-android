import 'package:flame/flame.dart';
import 'package:flame/effects.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:baahbox/games/spaceShip/components/meteorComponent.dart';
import 'package:baahbox/games/spaceShip/spaceShipGame.dart';

class ShipComponent extends SpriteComponent
    with HasGameRef<SpaceShipGame>, CollisionCallbacks {
  ShipComponent()
      : super(
          size: Vector2(75, 100),
          anchor: Anchor.center,
        );

  final normalShipSprite =
      Sprite(Flame.images.fromCache('Jeux/Spaceship/spaceship_nml@3x.png'));
  final rightShipSprite =
      Sprite(Flame.images.fromCache('Jeux/Spaceship/spaceship_right@3x.png'));
  final leftShipSprite =
      Sprite(Flame.images.fromCache('Jeux/Spaceship/spaceship_left@3x.png'));

  void initialize() {
    sprite = normalShipSprite;
    size = normalShipSprite.srcSize / 10;
    position = Vector2(gameRef.size.x / 2,
        (gameRef.size.y) / 2 + normalShipSprite.srcSize.y / 6);
    anchor = Anchor.center;
  }

  void moveBy(double offset) {
    var nextPositionX = position.x + offset;
    if (((offset > 0) && ((nextPositionX + (size.x / 2)) <= game.size.x)) ||
        ((offset < 0) && ((nextPositionX - (size.x / 2))) >= 0)) {
      setSpriteTo(offset > 0 ? 1 : 2);
      add(MoveEffect.by(Vector2(offset, 0), EffectController(duration: .3)));
    } else {
      setSpriteTo(0);
    }
  }

  void setSpriteTo(int spriteNb) {
    switch (spriteNb) {
      case 1:
        sprite = leftShipSprite;
      case 2:
        sprite = rightShipSprite;
      default:
        sprite = normalShipSprite;
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    initialize();
    add(CircleHitbox());
  }

  void takeHit() {
    blink();
  }

  void blink() {
    add(OpacityEffect.to(
        0, EffectController(duration: 0.5, reverseDuration: 1)));
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
      super.onCollisionStart(intersectionPoints, other);
      if (other is MeteorComponent) {
        other.takeHit();
        takeHit();
        gameRef.looseLife();
      }

  }
}
