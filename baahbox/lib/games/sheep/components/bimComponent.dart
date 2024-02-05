import 'package:flame/components.dart';
import 'package:baahbox/games/sheep/sheepGame.dart';
import 'package:flame/flame.dart';

class BimComponent extends SpriteComponent
    with HasGameRef<SheepGame> {
  static const speed = 100.0;
  static final Vector2 initialSize = Vector2.all(100);
  final bimSprite = Sprite(Flame.images.fromCache('Jeux/Sheep/bim.png'));

  BimComponent({required super.position})
      : super(anchor: Anchor.center, size: initialSize);

  @override
  Future<void> onLoad() async {
    initialize();
  }

  void initialize() {
    this.sprite = bimSprite;
    this.size = bimSprite.originalSize/10;
    setAlpha(0);
  }


  void show(){
    setAlpha(255);
  }

  void hide(){
    setAlpha(0);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
