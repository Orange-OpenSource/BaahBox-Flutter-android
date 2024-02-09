import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';

class MarkComponent extends SpriteComponent
    with HasGameRef {

  MarkComponent({required Vector2 position})
      : super(
    size: Vector2(75, 100),
    position: position,
    anchor: Anchor.bottomLeft,
  );

  final _sprite = Sprite(Flame.images.fromCache('Jeux/Sheep/gate.png'));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    this.sprite = _sprite;
    size = _sprite.srcSize /25;
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
