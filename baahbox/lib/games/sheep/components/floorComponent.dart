import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';

class FloorComponent extends SpriteComponent {
  final _floorSprite = Sprite(Flame.images.fromCache('Jeux/Sheep/floor.png'));

  FloorComponent({required super.position, super.size})
      : super(anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    this.sprite = _floorSprite;
  }

  void show() {
    setAlpha(255);
  }

  void hide() {
    setAlpha(0);
  }
  @override
  void update(double dt) {
    super.update(dt);
  }
}
