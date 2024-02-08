import 'package:flame/components.dart';
import '../background/cloud.dart';
import '../random_extension.dart';
import '../sheepGame.dart';

class CloudManager extends PositionComponent with HasGameRef<SheepGame> {
  final double cloudFrequency = 0.5;
  final int maxClouds = 20;
  final double cloudSpeed = 1;
  bool isRunning = false;

  @override
  Future<void> onLoad() async {
    start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.appController.isActive && isRunning) {
      final numClouds = children.length;
      if (numClouds > 0) {
        final lastCloud = children.last as Cloud;
        if (numClouds < maxClouds &&
            (gameRef.size.x - lastCloud.x) > lastCloud.cloudGap) {
          addCloud();
        }
      } else {
        addCloud();
      }
    } else {
      clearTheSky();
    }
  }


  void addCloud() {
    final cloudPosition = Vector2(
      gameRef.size.x,
      (gameRef.floorY - (Cloud.maxSkyLevel - Cloud.minSkyLevel)
          - random.fromRange(Cloud.minSkyLevel, Cloud.maxSkyLevel)),
    );
    add(Cloud(position: cloudPosition));
  }


  void clearTheSky() {
    removeAll(children);
  }

  void pause() {
    clearTheSky();
    isRunning = false;
  }

  void start() {
    isRunning = true;
  }
}
