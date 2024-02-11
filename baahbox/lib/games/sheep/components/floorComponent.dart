import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';

class FloorComponent extends SpriteComponent with HasVisibility {
  final _floorSprite = Sprite(Flame.images.fromCache('Jeux/Sheep/floor.png'));

  FloorComponent({required super.position, super.size})
      : super(anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    this.sprite = _floorSprite;
  }

  void show() {
    isVisible = true;
  }

  void hide() {
    isVisible = false;
  }
  @override
  void update(double dt) {
    super.update(dt);
  }
}
