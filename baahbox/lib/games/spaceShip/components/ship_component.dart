import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:baahbox/games/spaceShip/components/asteroid_component.dart';
import 'package:baahbox/games/spaceShip/components/explosion_component.dart';
import 'package:flame/flame.dart';

class ShipComponent extends SpriteComponent
    with HasGameRef, CollisionCallbacks {

  ShipComponent()
      : super(
    size: Vector2(75, 100),
    position: Vector2(100, 500),
    anchor: Anchor.center,
  );

  final normalShipSprite = Sprite(Flame.images.fromCache('Jeux/Spaceship/spaceship_nml@3x.png'));
  final rightShipSprite = Sprite(Flame.images.fromCache('Jeux/Spaceship/spaceship_right@3x.png'));
  final leftShipSprite = Sprite(Flame.images.fromCache('Jeux/Spaceship/spaceship_left@3x.png'));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    this.sprite = normalShipSprite;
    size = normalShipSprite.srcSize /10;
    add(CircleHitbox());
  }

  void takeHit() {
    game.add(ExplosionComponent(position: position));
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints,
      PositionComponent other,
      ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is AsteroidComponent) {
      other.takeHit();
    }
  }
}
