import 'package:baahbox/games/star/starGame.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:get/get.dart';
import 'package:flame/events.dart';

class StarSprite extends SpriteComponent with HasGameRef<StarGame> {
  final Controller appController = Get.find();
  StarSprite() : super(size: Vector2.all(16.0), anchor: Anchor.center);

  final starSprite = Sprite(Flame.images.fromCache('jeu_etoile_01@2x.png'));
  final shiningStarSprite =
      Sprite(Flame.images.fromCache('jeu_etoile_02@2x.png'));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    initialize();
    // TODO: calculer automatiquement la taille de l'étoile en
    //  fonction de celle de l'écran.

  }

  void initialize() {
    this.sprite = starSprite;
    position = gameRef.canvasSize / 2;
    size = starSprite.srcSize / 5;
  }

  setTo(Sprite newSprite) {
    this.sprite = newSprite;
    final newSize = newSprite.srcSize;
    this.size = newSize / 5;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.input > 750) {
      setTo(shiningStarSprite);
    } else {
      setTo(starSprite);
    }
  }
}
