import 'package:flame/components.dart';
import 'package:flame/sprite.dart';


class StarPlayer extends SpriteAnimationComponent with HasGameRef {
  StarPlayer() : super(size: Vector2.all(100.0), anchor: Anchor.center);
  @override
  Future<void> onLoad() async {
    super.onLoad();
    //sprite = await gameRef.loadSprite('../../../assets/images/Jeux/Etoile/jeu_etoile_01@2x.png');
    //position = gameRef.size / 2;
  }

  @override
  void update(double dt) {
    super.update(dt);
    updatePosition(dt);
  }

  updatePosition(double dt) {
  }
}
