import 'dart:ui';
import 'package:baahbox/games/spaceShip/components/ship_component.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/text.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:get/get.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/games/BBGame.dart';

import 'package:flame/components.dart';
import 'package:baahbox/games/spaceShip/components/asteroid_creator.dart';
import 'package:baahbox/games/spaceShip/components/star_background_creator.dart';
import 'package:baahbox/games/spaceShip/components/lifeManager.dart';


class SpaceShipGame extends BBGame with TapCallbacks, PanDetector, HasCollisionDetection {
  final Controller appController = Get.find();

  late final ShipComponent ship;
  late final TextComponent componentCounter;
  late final TextComponent scoreText;
  late final LifeManager lifeManager;

  int score = 0;
  var panInput = 0;
  var input = 0;

  @override
  Color backgroundColor() => BBGameList.starship.baseColor.color;

  @override
  Future<void> onLoad() async {
    await loadAssetsInCache();
    loadInfoComponents();
    add(ship = ShipComponent());
    add(AsteroidCreator());
    add(StarBackGroundCreator());
    add(lifeManager = LifeManager());
    super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
   // if (state == GameState.running) {
      refreshInput();
      scoreText.text = 'Score: $score';
      componentCounter.text = 'Components: ${children.length}';
  //  }
  }

  void loadInfoComponents() {
    addAll([
      FpsTextComponent(
        position: size - Vector2(0,50),
        anchor: Anchor.bottomRight,
      ),
      scoreText = TextComponent(
        position: size - Vector2(0, 25),
        anchor: Anchor.bottomRight,
        priority: 1,
      ),
      componentCounter = TextComponent(
        position: size,
        anchor: Anchor.bottomRight,
        priority: 1,
      ),
    ]);

  }

  Future<void> loadAssetsInCache() async {
    await Flame.images.loadAll(<String>[
      'Jeux/Spaceship/spaceship_left@3x.png',
      'Jeux/Spaceship/spaceship_right@3x.png',
      'Jeux/Spaceship/spaceship_nml@3x.png',
      'Jeux/Spaceship/meteor_01@3x.png',
      'Jeux/Spaceship/meteor_02@3x.png',
      'Jeux/Spaceship/meteor_03@3x.png',
      'Jeux/Spaceship/meteor_04@3x.png',
      'Jeux/Spaceship/meteor_05@3x.png',
      'Jeux/Spaceship/meteor_06@3x.png',
      'Jeux/Spaceship/space_life@3x.png',
    ]);
  }

  void refreshInput() {
    // todo deal with 2 muscles or joystick input
    if (appController.isConnectedToBox) {
      // The strength is in range [0...1024] -> Have it fit into [0...100]
      input = appController.musclesInput.muscle1;
    } else {
      input = panInput;
    }
  }

  void onCollision() {
    lifeManager.looseOneLife();
    increaseScore();
  }

  @override
  void onTapDown(TapDownEvent event) {
    ship.add(
        MoveEffect.to(Vector2(event.localPosition.x,ship.position.y),
        EffectController(duration: 0.3)));
  }

  @override
  void resetGame() {
    // TODO: implement resetGame
    super.resetGame();
  }

  @override
  void endGame() {
    // TODO: implement resetGame
    state = GameState.lost;
   // super.endGame();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    // if (appController.isConnectedToBox || state != GameState.running) {
    //   panInput = 0;
    // } else {
      ship.position += info.delta.global;
      // var yPos = info.eventPosition.global.y;
      // panInput = ((canvasSize.y - yPos) * 1024.0 / canvasSize.y).toInt();
      // print(
      //     "panInput : ${panInput} :::  panY : ${yPos} vs game ${canvasSize.y}");
    // }
  }

  void increaseScore() {
    score++;
  }

  // @override
  // void onTapDown(TapDownEvent event) {
  //   super.onTapDown(event);
  //   print("state : $state ");
  // }
}