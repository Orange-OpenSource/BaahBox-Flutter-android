import 'package:flame/components.dart';
import 'package:baahbox/games/sheep/sheepGame.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';

class BimComponent extends SpriteComponent
    with HasGameRef<SheepGame> {
  static final Vector2 initialSize = Vector2.all(100);
  final bimSprite = Sprite(Flame.images.fromCache('Jeux/Sheep/bang.png'));

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
    blink();
  }

  void blink() {
    add(OpacityEffect.to(
        255, EffectController(duration: 0.5, reverseDuration: 20)));
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
