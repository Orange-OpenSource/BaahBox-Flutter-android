import 'dart:math';
import 'package:flame/flame.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:baahbox/games/sheep/components/gateComponent.dart';
import 'package:baahbox/games/toad/toadGame.dart';
import 'package:baahbox/games/sheep/components/bimComponent.dart';

class ToadComponent extends SpriteComponent
    with  HasVisibility,
        HasGameRef<ToadGame> {
  ToadComponent()
      : super(size: Vector2(100, 100), anchor: Anchor.bottomCenter);

  final toadSprite = Sprite(Flame.images.fromCache('Jeux/Toad/toad@2x.png'));
  final toadBlinkSprite = Sprite(Flame.images.fromCache('Jeux/Toad/toad_blink@2x.png'));


  final blinkingImages = [
    Flame.images.fromCache('Jeux/Toad/toad@2x.png'),
    Flame.images.fromCache('Jeux/Toad/toad_blink@2x.png'),
  ];

  @override
  Future<void> onLoad() async {
    super.onLoad();
    initialize();

  }

  void initialize() {
    this.sprite = toadSprite;
    var ratio = toadSprite.srcSize.x / toadSprite.srcSize.y;
    var width = gameRef.size.x/3;
    size = Vector2(width,width/ratio);
    position =  Vector2(gameRef.size.x / 3, gameRef.size.y - size.y -50);
    show();
  }



  @override
  void update(double dt) {
    super.update(dt);
  }


  void hide() {
    isVisible = false;
  }

  void show() {
    isVisible = true;
  }

  void rotateBy(int angle) {
    {
      final effect = RotateEffect.by(angle.toDouble(), EffectController(duration: 0.1));
      add(effect);
    }
  }

  void setSpriteTo(int spriteNb) {
    switch (spriteNb) {
      case 1:
        sprite = toadBlinkSprite;
      default:
        sprite = toadSprite;
    }
  }

  SpriteAnimation getBlinkAnimation() {
    final sprites = blinkingImages.map((image) => Sprite(image)).toList();
    return SpriteAnimation.spriteList(sprites, stepTime: 1);
  }

  void hit() {
    //setSpriteTo(3);
    game.add(BimComponent(
        position: Vector2(position.x + size.x/2, position.y - size.y - 20)));
  }

}
