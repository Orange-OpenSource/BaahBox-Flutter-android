import 'package:flame/flame.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:baahbox/games/sheep/sheepGame.dart';


class GateComponent extends SpriteComponent
    with HasGameRef<SheepGame>, CollisionCallbacks {

  static const speed = 50.0;
  late final Vector2 velocity;
  final Vector2 deltaPosition = Vector2.zero();
  final obstacleSprite = Sprite(Flame.images.fromCache('Jeux/Sheep/gate.png'));
  var isNewComer = true;
  GateComponent() : super(anchor: Anchor.bottomCenter, size: Vector2(10, 80));

  @override
  Future<void> onLoad() async {
    initialize();
    resetPosition();
  }

  void resetPosition() {
    position = Vector2(gameRef.size.x + size.x / 2, gameRef.floorY);
    isNewComer = true;
  }

  void initialize() {
    this.sprite = obstacleSprite;
    this.size = obstacleSprite.originalSize / 10;
    add(RectangleHitbox(collisionType: CollisionType.passive));
    velocity = Vector2(-1, 0)..scale(speed);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.isRunning) {
      deltaPosition
        ..setFrom(velocity)
        ..scale(dt);
      position += deltaPosition;
      isNewComer = false;
      if (x < -size.x / 2) {
        x = game.size.x + size.x;
        isNewComer = true;
        gameRef.nbDisplayedGates += 1;
      }
    }
  }

  bool isVisible() {
    return (x + size.x / 2 > 0);
  }

  void takeHit() {}
}
