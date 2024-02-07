import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import '../background/cloud_manager.dart';
import '../random_extension.dart';
import '../sheepGame.dart';

class Cloud extends SpriteComponent
    with ParentIsA<CloudManager>, HasGameRef<SheepGame> {
  Cloud({required Vector2 position})
      : cloudGap = random.fromRange(
          minCloudGap,
          maxCloudGap,
        ),
        super(
          position: position,
          size: initialSize,
        );

  static Vector2 initialSize = Vector2(92.0, 28.0);

  static const double maxCloudGap = 200.0;
  static const double minCloudGap = 50.0;

  static const double maxSkyLevel = 200.0;
  static const double minSkyLevel = 100.0;

  final double cloudGap;

  @override
  Future<void> onLoad() async {
    sprite = Sprite(
        Flame.images.fromCache('trex.png'),
      srcPosition: Vector2(166.0, 2.0),
      srcSize: initialSize,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isRemoving) {
      return;
    }
    x -= 2;//(parent.cloudSpeed).ceil * dt;

    if (!isVisible) {
      removeFromParent();
    }
  }

  bool get isVisible {
    return x + width > 0;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
   // y = ((absolutePosition.y / 2 - (maxSkyLevel - minSkyLevel)) +
   //          random.fromRange(minSkyLevel, maxSkyLevel)) -
   //      absolutePositionOf(absoluteTopLeftPosition).y;
  }
}
