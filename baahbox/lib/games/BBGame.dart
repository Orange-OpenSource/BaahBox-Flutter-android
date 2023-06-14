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

  Future<void> resetGame() async {
    GameState state = GameState.initializing;
    overlays.remove(overlays.activeOverlays.first);
    overlays.add('PreGame');
  }


}