import 'dart:math';
import 'package:baahbox/games/spaceShip/spaceShipGame.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/effects.dart';
import 'package:flame/geometry.dart';
import 'package:baahbox/games/spaceShip/components/meteorComponent.dart';

class MeteorManager extends TimerComponent with HasGameRef<SpaceShipGame> {
  final Random random = Random();
  final meteor1Sprite =
      Sprite(Flame.images.fromCache('Jeux/Spaceship/meteor_01@3x.png'));

  MeteorManager() : super(period: 2, repeat: true);


  @override
  void onTick() {
     if (gameRef.appController.isActive && !gameRef.isGameOver) {
      final _halfWidth = meteor1Sprite.originalSize.x / 10;
      game.addAll(
        List.generate(
          1,
              (index) =>
          MeteorComponent(
            position: Vector2(
              _halfWidth + (game.size.x - _halfWidth) * random.nextDouble(),
              0,
            ),
          )
            ..add(RotateEffect.by(
                tau, EffectController(duration: 40, infinite: true))),
        ),
      );
     }
  }

  void clearTheSky() {
    for (var child in gameRef.children) {
      if (child is MeteorComponent) {
        child.removeFromParent();
      }
    }
  }
}
