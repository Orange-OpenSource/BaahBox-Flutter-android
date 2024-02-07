import 'package:flame/components.dart';
import '../background/cloud.dart';
import '../random_extension.dart';
import '../sheepGame.dart';

class CloudManager extends PositionComponent with HasGameRef<SheepGame> {
  final double cloudFrequency = 0.5;
  final int maxClouds = 20;
  final double bgCloudSpeed = 1;

  void addCloud() {
    final cloudPosition = Vector2(
      gameRef.size.x/2, //+ Cloud.initialSize.x + 10,
      (gameRef.floorY - (Cloud.maxSkyLevel - Cloud.minSkyLevel)
          - random.fromRange(Cloud.minSkyLevel, Cloud.maxSkyLevel)),
         // -absolutePosition.y,
    );
    add(Cloud(position: cloudPosition));
  }

  double get cloudSpeed => bgCloudSpeed ;//gameRef.currentSpeed;

  @override
  void update(double dt) {
    super.update(dt);
    final numClouds = children.length;
    if (numClouds > 0) {
      final lastCloud = children.last as Cloud;
      if (numClouds < maxClouds &&
          (gameRef.size.x / 2 - lastCloud.x) > lastCloud.cloudGap) {
        addCloud();
      }
    } else {
      addCloud();
    }
  }

  void reset() {
    removeAll(children);
  }
}
