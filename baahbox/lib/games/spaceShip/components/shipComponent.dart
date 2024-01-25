import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:baahbox/games/spaceShip/components/meteorComponent.dart';
import 'package:baahbox/games/spaceShip/components/explosion_component.dart';
import 'package:flame/flame.dart';
import 'package:flame/effects.dart';

class ShipComponent extends SpriteComponent
    with HasGameRef, CollisionCallbacks {
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
    this.sprite = normalShipSprite;
    size = normalShipSprite.srcSize / 10;
    position = Vector2(gameRef.size.x / 2,
    (gameRef.size.y) / 2 + normalShipSprite.srcSize.y / 4);
    this.anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    initialize();
    add(CircleHitbox());
  }

  void takeHit() {
    disappear();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is MeteorComponent) {
      other.takeHit();
      // takeHit();
    }
    appear();
  }

  void disappear() {
    this.add(OpacityEffect.fadeOut(EffectController(duration: 0.75)));
  }

  void appear() {
    this.add(OpacityEffect.fadeIn(EffectController(duration: 0.2)));
  }
}
