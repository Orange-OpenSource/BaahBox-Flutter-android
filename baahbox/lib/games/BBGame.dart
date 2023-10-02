import 'package:get/get.dart';
import 'package:flame/game.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:flame/palette.dart';
import 'dart:ui';
import 'package:flame/events.dart';
import 'package:flame/components.dart';

class BBGame extends FlameGame with PanDetector {
  final Controller appController = Get.find();
  GameState state = GameState.initializing;
  final double reactivity = 0.2; //todo enum (hardnesscoeff in ios)
  String title = "titre";
  String subTitle = "sous titre";
  String feedback = "encore un effort";

  Future<void> onLoad() async {
    await super.onLoad();
    overlays.clear();
    overlays.add('Instructions');
    overlays.add('PreGame');
    state = GameState.ready;
  }

  void startGame() {
    if (overlays.isActive('PreGame')) {
      overlays.remove('PreGame');
    }
    state = GameState.running;
  }

  void displayFeedBack() {
    overlays.add('FeedBack');
  }

  void endGame() {
    overlays.clear();
    overlays.add('PostGame');
  }

  void resetGame() {
    overlays.clear();
    overlays.add('Instructions');
    state = GameState.running;
  }
}
