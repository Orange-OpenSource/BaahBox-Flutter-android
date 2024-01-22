import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';

class LifeComponent extends SpriteComponent
    with HasGameRef {

  LifeComponent({required Vector2 position})
      : super(
    size: Vector2(75, 100),
    position: position,
    anchor: Anchor.bottomLeft,
  );

  final lifeSprite = Sprite(Flame.images.fromCache('Jeux/Spaceship/space_life@3x.png'));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    this.sprite = lifeSprite;
    size = lifeSprite.srcSize /10;
  }

  void disappear() {
    this.add(
    OpacityEffect.fadeOut(
    EffectController(duration: 0.75)
    ));
    removeFromParent();
  }

  void appear() {
    this.add(
        OpacityEffect.fadeIn(
            EffectController(duration: 0.75)
        ));
  }

}
