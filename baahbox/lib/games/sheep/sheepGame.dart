import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:get/get.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/games/BBGame.dart';
import 'package:baahbox/games/sheep/components/sheepComponent.dart';
import 'package:baahbox/games/sheep/components/gateComponent.dart';
import 'package:baahbox/games/sheep/components/floorComponent.dart';
import 'package:baahbox/games/sheep/components/bimComponent.dart';
import 'package:baahbox/games/sheep/components/statusSheepComponent.dart';

class SheepGame extends BBGame with TapCallbacks, HasCollisionDetection {
  final Controller appController = Get.find();

  late final SheepComponent sheep;
  late final GateComponent gate;
  late final FloorComponent floor;
  late final BimComponent collision;

  int score = 0;
  var panInput = 0;

  var input = 0;
  double floorY = 0;
  var instructionTitle = 'Saute les barrières';
  var instructionSubtitle = 'en contractant ton muscle';

  @override
  Color backgroundColor() => BBGameList.sheep.baseColor.color;

  @override
  Future<void> onLoad() async {
    title = instructionTitle;
    subTitle = instructionSubtitle;
    floorY = (size.y * 0.7);
    await loadAssetsInCache();
    loadComponents();
    super.onLoad();
  }

  Future<void> loadAssetsInCache() async {
    await Flame.images.loadAll(<String>[
      'Jeux/Sheep/bang.png',
      'Jeux/Sheep/bim.png',
      'Jeux/Sheep/gate.png',
      'Jeux/Sheep/floor.png',
      'Jeux/Sheep/sheep_01.png',
      'Jeux/Sheep/sheep_02.png',
      'Jeux/Sheep/sheep_03.png',
      'Jeux/Sheep/sheep_04.png',
      'Jeux/Sheep/welcome_sheep_01.png',
      'Jeux/Sheep/welcome_sheep_02.png',
    ]);
  }

  void loadComponents() async {
    await add(sheep = SheepComponent(position: Vector2(size.x / 3, floorY)));
    await add(gate = GateComponent(position: Vector2(size.x, floorY)));
    await add(floor = FloorComponent(position: Vector2(size.x / 2, floorY)));
    //await add(statusSheep = StatusSheepComponent());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (state == GameState.running) {
      refreshInput();
    }
  }

  void refreshInput() {
    // todo deal with 2 muscles or joystick input
    if (appController.isConnectedToBox) {
      // The strength is in range [0...1024] -> Have it fit into [0...100]
      input = (appController.musclesInput.muscle1 ~/ 10);
    } else {
      input = panInput;
    }
  }

  @override
  void resetGame() {
    // TODO: implement resetGame
    super.resetGame();
    sheep.initialize();
    gate.initialize();

  }

  @override
  void endGame() {
    // TODO: implement resetGame
    state = GameState.won;
    super.endGame();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (appController.isConnectedToBox || state != GameState.running) {
      panInput = 0;
    } else {
      var yPos = info.eventPosition.global.y;
      var nextY = min(yPos, floorY);
      sheep.moveTo(nextY);
    }
  }

}
