import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';

class BimComponent extends SpriteComponent {
  static final Vector2 initialSize = Vector2.all(10);
  final bimSprite = Sprite(Flame.images.fromCache('Jeux/Sheep/bang.png'));

  BimComponent({required super.position}): super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    initialize();
  }

  void initialize() {
    this.sprite = bimSprite;
    this.size = bimSprite.originalSize/10;
    blink();
  }

  void blink() {
    add(OpacityEffect.to(
        255, EffectController(duration: 0.5, reverseDuration: 20)));
  }
}
