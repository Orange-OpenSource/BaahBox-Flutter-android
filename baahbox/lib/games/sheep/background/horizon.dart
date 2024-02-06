import 'package:flame/components.dart';
import '../background/cloud_manager.dart';
import '../sheepGame.dart';

class Horizon extends PositionComponent with HasGameRef<SheepGame> {
  Horizon() : super();

  static final Vector2 lineSize = Vector2(1200, 24);
  late final CloudManager cloudManager = CloudManager();

  @override
  Future<void> onLoad() async {
    add(cloudManager);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final increment = 10 * dt;//gameRef.currentSpeed * dt;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    y = (size.y / 2) + 21.0;
  }

  void reset() {
    cloudManager.reset();
  }

}
