import 'package:baahbox/games/balloon/balloonGame.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class BalloonComponent extends SpriteComponent with HasGameRef<BalloonGame> {
  BalloonComponent() : super(size: Vector2.all(16.0), anchor: Anchor.center);

  final balloonstartSprite =
      Sprite(Flame.images.fromCache('Jeux/Balloon/ballon_00@2x.png'));
  final balloonlowSprite =
      Sprite(Flame.images.fromCache('Jeux/Balloon/ballon_01@2x.png'));
  final balloonmediumSprite =
      Sprite(Flame.images.fromCache('Jeux/Balloon/ballon_02@2x.png'));
  final balloonhighSprite =
      Sprite(Flame.images.fromCache('Jeux/Balloon/ballon_03@2x.png'));
  final balloonexplodeSprite =
      Sprite(Flame.images.fromCache('Jeux/Balloon/ballon_04@2x.png'));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    initialize();
  }

  void initialize() {
    this.sprite = balloonstartSprite;
    size = balloonstartSprite.srcSize / 4;
    position = Vector2(gameRef.size.x / 2,
        (gameRef.size.y) / 2 + balloonstartSprite.srcSize.y / 4);
    this.anchor = Anchor.bottomCenter;
  }

  @override
  void update(double dt) {
    super.update(dt);
    updateSprite(dt);
  }

  updateSprite(double dt) {
    int coeff = (gameRef.input / 100).toInt();
    switch (coeff) {
      case 0 || 1:
        setTo(balloonstartSprite, 0);
      case 2 || 3 || 4 || 5 || 6 || 7:
        setTo(balloonlowSprite, gameRef.input);
      case 8 || 9 || 10:
        setTo(balloonexplodeSprite, 0);
    }
  }

  setTo(Sprite newSprite, int coeff) {
    if (this.sprite != newSprite) {
      this.sprite = newSprite;
      final newSize = newSprite.srcSize;
      this.size = newSize / 4;
    } else if (coeff > 0) {
      var newSize = this.sprite?.srcSize ?? Vector2(400, 600);
      this.size = newSize * (coeff / 1000).toDouble();
    }
  }
}
