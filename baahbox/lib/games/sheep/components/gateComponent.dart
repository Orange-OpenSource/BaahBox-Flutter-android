import 'package:baahbox/constants/enums.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:baahbox/games/sheep/components/bimComponent.dart';
import 'package:baahbox/games/sheep/sheepGame.dart';
import 'package:flame/flame.dart';

class GateComponent extends SpriteComponent
    with HasGameRef<SheepGame>, CollisionCallbacks {
  static const speed = 50.0;
  late final Vector2 velocity;
  static final Vector2 initialSize = Vector2.all(100);
  final Vector2 deltaPosition = Vector2.zero();
  final obstacleSprite = Sprite(Flame.images.fromCache('Jeux/Sheep/gate.png'));

  GateComponent({required super.position})
      : super(anchor: Anchor.bottomCenter, size: Vector2(10,80));

  @override
  Future<void> onLoad() async {
    initialize();
  }

  void initialize() {
    this.sprite = obstacleSprite;
    this.size = obstacleSprite.originalSize/10;
    add(RectangleHitbox(collisionType: CollisionType.passive));
    velocity = Vector2(-1, 0)
      ..scale(speed);

  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.state == GameState.running) {
      deltaPosition
        ..setFrom(velocity)
        ..scale(dt);
      position += deltaPosition;
      if (x < -size.x / 2) {
        x = game.size.x + size.x;
      }
    }
  }

  bool isVisible() {
    return (x+size.x/2 > 0);
  }

  void takeHit() {
    velocity = Vector2(0, 0);
  }
}
