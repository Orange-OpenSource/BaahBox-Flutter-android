import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:get/get.dart';

class BalloonSprite extends SpriteComponent with HasGameRef {
  final Controller c = Get.find();
  BalloonSprite() : super(size: Vector2.all(16.0), anchor: Anchor.center);
  final balloonstartSprite = Sprite(Flame.images.fromCache('ballon_00@2x.png'));
  final balloonlowSprite = Sprite(Flame.images.fromCache('ballon_01@2x.png'));
  final balloonmediumSprite = Sprite(Flame.images.fromCache('ballon_02@2x.png'));
  final balloonhighSprite = Sprite(Flame.images.fromCache('ballon_03@2x.png'));
  final balloonexplodeSprite= Sprite(Flame.images.fromCache('ballon_04@2x.png'));


  @override
  Future<void> onLoad() async {
    super.onLoad();
    this.sprite = balloonstartSprite;
    position = gameRef.size / 2;
    size = Vector2(100, 100);
  }

  @override
  void update(double dt) {
    super.update(dt);
    updateSprite(dt);
  }

  updateSprite(double dt) {
    int coeff = (c.musclesInput.muscle1 / 100).toInt();
    switch(coeff) {
   case 0 || 1 || 2:
    setTo(balloonstartSprite,1);
    case 3 || 4:
      setTo(balloonlowSprite,1);
      case 5 || 6 || 7 || 8 :
        setTo(balloonhighSprite, coeff /10);
      case 9 || 10:
    setTo(balloonexplodeSprite, 1);
    }
  }

  setTo(Sprite newSprite, double coeff) {
    this.sprite = newSprite;
    final newSize = newSprite.srcSize;
   this.size = newSize * coeff/4 ;
   print("new size: ${this.size}");
   this.anchor = Anchor.center;
  }
}

// final image = await images.load('flame.png');
//
// final resized = await image.resize(sizeTarget);
// add(
// SpriteComponent(
// sprite: Sprite(resized),
// position: size / 2,
// size: resized.size,
// anchor: Anchor.center,
// ),
// );