import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:baahbox/games/sheep/sheepGame.dart';

class HappySheepComponent extends SpriteAnimationComponent
    with HasGameRef<SheepGame> {
  final happySprite1 =
      Sprite(Flame.images.fromCache('Jeux/Sheep/happy_sheep_01.png'));
  final happySprite2 =
      Sprite(Flame.images.fromCache('Jeux/Sheep/happy_sheep_02.png'));

  HappySheepComponent({required super.position, super.size})
      : super(anchor: Anchor.topLeft);

  @override
  Future<void> onLoad() async {
    setAlpha(0);
    final sprites = [
      happySprite2,
      happySprite1,
      happySprite1,
      happySprite1,
      happySprite1,
      happySprite1,
      happySprite1,
      happySprite1,
      happySprite1
    ].toList();
    animation = SpriteAnimation.spriteList(
      sprites,
      stepTime: 0.2,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    var alpha = gameRef.isWon ? 255 : 0;
    setAlpha(alpha);
  }
}
