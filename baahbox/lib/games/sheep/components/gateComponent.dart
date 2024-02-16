import 'package:baahbox/constants/enums.dart';
import 'package:flame/flame.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:baahbox/games/sheep/sheepGame.dart';


class GateComponent extends SpriteComponent
    with HasGameRef<SheepGame>, CollisionCallbacks {

  late ObjectVelocity speedScale;
  final Vector2 deltaPosition = Vector2.zero();
  final obstacleSprite = Sprite(Flame.images.fromCache('Jeux/Sheep/gate.png'));
  var isNewComer = true;
  late Vector2 speed;

  GateComponent({required this.speedScale}) :
       super(anchor: Anchor.bottomCenter, size: Vector2(10, 80));

  @override
  Future<void> onLoad() async {
    initialize();
    resetPosition();
  }

  void reset(ObjectVelocity speedScale) {
    resetPosition();
    this.speedScale = speedScale;
    speed = Vector2(-1, 0)..scale(this.speedScale.value * 50);
  }
  void resetPosition() {
    position = Vector2(gameRef.size.x + size.x / 2, gameRef.floorY);
    isNewComer = true;
  }

  void initialize() {
    this.sprite = obstacleSprite;
    this.size = obstacleSprite.originalSize / 10;
    add(RectangleHitbox(collisionType: CollisionType.passive));
    speed = Vector2(-1, 0)..scale(this.speedScale.value * 50);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.isRunning) {
      deltaPosition
        ..setFrom(speed)
        ..scale(dt);
      position += deltaPosition;

      if (x < -size.x / 2) {
        x = game.size.x + size.x;
        isNewComer = true;
        gameRef.nbDisplayedGates += 1;
      } else {
        isNewComer = false;
      }
    }
  }

  bool isVisible() {
    return (x + size.x / 2 > 0);
  }

  void takeHit() {}
}
