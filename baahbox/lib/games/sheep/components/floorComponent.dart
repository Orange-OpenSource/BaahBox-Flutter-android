import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class FloorComponent extends SpriteComponent {
  final floorSprite = Sprite(Flame.images.fromCache('Jeux/Sheep/floor.png'));

  FloorComponent({required super.position, super.size})
      : super(anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    this.sprite = floorSprite;
  }
}
