import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:baahbox/games/spaceShip/spaceShipGame.dart';

class ScoreManager extends TimerComponent with HasGameRef<SpaceShipGame> {
  ScoreManager() : super(period: 1, repeat: true);

  @override
  void onTick() {
    game.increaseScore();
  }
}
