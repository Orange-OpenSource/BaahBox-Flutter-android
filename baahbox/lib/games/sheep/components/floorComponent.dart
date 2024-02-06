import 'package:flame/components.dart';
import 'package:baahbox/games/sheep/sheepGame.dart';
import 'package:flame/flame.dart';

class FloorComponent extends SpriteComponent
    with HasGameRef<SheepGame> {


  final floorSprite = Sprite(Flame.images.fromCache('Jeux/Sheep/floor.png'));

  FloorComponent({required super.position, super.size})
      : super(anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    this.sprite = floorSprite;
    //this.size = Vector2(gameRef.size.x,floorSprite.originalSize.y/10);
  }

}
