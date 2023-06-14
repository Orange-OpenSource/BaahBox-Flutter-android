import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:get/get.dart';
import 'package:flame/events.dart';

class Square extends RectangleComponent with TapCallbacks {
  static const speed = 3;
  static const squareSize = 128.0;
  static const indicatorSize = 6.0;

  Square(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(squareSize),
          anchor: Anchor.center,
        );
}

class StarSprite extends SpriteComponent with HasGameRef {
  final Controller c = Get.find();
  StarSprite() : super(size: Vector2.all(16.0), anchor: Anchor.center);

  final starSprite = Sprite(Flame.images.fromCache('jeu_etoile_01@2x.png'));
  final shiningStarSprite =
      Sprite(Flame.images.fromCache('jeu_etoile_02@2x.png'));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    this.sprite = starSprite;
    position = gameRef.canvasSize / 2;
    size = Vector2(100, 100);
  }

  setTo(Sprite newSprite) {
    this.sprite = newSprite;
    final newSize = newSprite.srcSize;
    this.size = newSize / 5;
  }

  updateSprite(double dt) {
    if (c.musclesInput.muscle1 > 500) {
      setTo(shiningStarSprite);
    } else {
      setTo(starSprite);
    }
  }

  updateOnPan(DragUpdateInfo info) {
    var panPosition = info.eventPosition.game.y;
    print("panY : ${panPosition} vs game ${size.y}");
    if (panPosition < size.y / 2) {
      setTo(shiningStarSprite);
   } else {
      setTo(starSprite);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
   // updateSprite(dt);
  }
}
