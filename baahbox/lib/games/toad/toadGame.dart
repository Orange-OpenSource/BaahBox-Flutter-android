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
import 'package:baahbox/games/toad/components/toadComponent.dart';
import 'package:baahbox/services/settings/settingsController.dart';

class ToadGame extends BBGame with TapCallbacks, HasCollisionDetection {
  final Controller appController = Get.find();
  final SettingsController settingsController = Get.find();

  late final Image spriteImage;
  int input = 0;
  int panInput = 0;
  late final ToadComponent toad;


  @override
  Color backgroundColor() => BBGameList.toad.baseColor.color;

  Future<void> loadAssetsInCache() async {
    await Flame.images.loadAll(<String>[
      //'Jeux/Toad/crapaud@2x.png)',
    'Jeux/Toad/crapaud@3x.png',
    'Jeux/Toad/crapaud_compteur_mouche_plein@2x.png',
    'Jeux/Toad/crapaud_compteur_mouche_plein@3x.png',
    'Jeux/Toad/crapaud_compteur_mouche_vide@2x.png',
    'Jeux/Toad/crapaud_compteur_mouche_vide@3x.png',
    'Jeux/Toad/crapaud_langue@2x.png',
    'Jeux/Toad/crapaud_langue@3x.png',
    'Jeux/Toad/crapaud_mouche@2x.png',
    'Jeux/Toad/crapaud_mouche@3x.png',
    'Jeux/Toad/fly@2x.png',
    'Jeux/Toad/fly@3x.png',
    'Jeux/Toad/fly_point_0@2x.png',
   'Jeux/Toad/fly_point_0@3x.png',
    'Jeux/Toad/fly_point_1@2x.png',
    'Jeux/Toad/fly_point_1@3x.png',
    'Jeux/Toad/toad@2x.png',
    'Jeux/Toad/toad@3x.png',
    'Jeux/Toad/toad_blink@2x.png',
    'Jeux/Toad/toad_blink@3x.png',
    'Jeux/Toad/toad_menu@2x.png',
    'Jeux/Toad/toad_menu@3x.png',
    'Jeux/Toad/tongue@2x.png',
    'Jeux/Toad/tongue@3x.png',
    ]);
  }

  Future<void> loadComponents() async {
    await add(toad = ToadComponent());
  }

  void loadInfoComponents() {
  }

  @override
  Future<void> onLoad() async {
    initializeParams();
    await loadAssetsInCache();
    await loadComponents();
    loadInfoComponents();
    initializeUI();
    super.onLoad();
  }

  void initializeParams() {
  }

  void initializeUI() {
    title = '';
    subTitle = '';
  }

  void resetComponents() {
    toad.initialize();
  }

  @override
  void startGame() {
    initializeParams();
    resetComponents();
    super.startGame();
  }

  @override
  void resetGame() {
    super.resetGame();
    initializeParams();
    resetComponents();
    if (paused) {
      resumeEngine();
    }
  }

// ===================
  // MARK: - Game loop
  // ===================

  @override
  void update(double dt) {
    super.update(dt);
    if (appController.isActive) {
      if (isRunning) {
        refreshInput();
      transformInputInMove();
      }
    }
  }

  void transformInputInMove() {
    if (appController.isConnectedToBox) { //   if input <= threshold { return }
      //   var heightConstraint = (CGFloat(strengthValue) - CGFloat (hardnessCoeff*350)) / 1000
//   if heightConstraint < 0 { heightConstraint = 0 }
      final angle = 15;
      // print("floorY: $floorY, height: $jumpHeigth");
      toad.rotateBy(angle);
    }
// let jumpheightWithConstraint = groundPosition.y + (maxHeigthJump * heightConstraint)
// jumpTo(sprite: sheep, height: jumpheightWithConstraint)

  }

//  var heightConstraint = (CGFloat(strengthValue) - CGFloat (hardnessCoeff*350)) / 1000
//  if heightConstraint < 0 { heightConstraint = 0 }
// let jumpheightWithConstraint = groundPosition.y + (maxHeigthJump * heightConstraint)
// jumpTo(sprite: sheep, height: jumpheightWithConstraint)


  void refreshInput() {
    // todo deal with 2 muscles or joystick input
    if (appController.isConnectedToBox) {
      // The strength is in range [0...1024] -> Have it fit into [0...100]
      input = (appController.musclesInput.muscle1 ~/ 10);
    } else {
      input = panInput;
    }
  }


  void setGameStateToWon(bool win) {
    state = win ? GameState.won : GameState.lost;
    feedback = win ? "won" : "lost";
    if (win) {
      toad.hide();
    }
    endGame();
  }

  @override
  void endGame() {
    super.endGame();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (appController.isConnectedToBox || state != GameState.running) {
      panInput = 0;
    } else {
      var xPos = info.eventPosition.global.x;
      var nextX = (xPos/360).toInt();
      toad.rotateBy(nextX);
    }
  }

  @override
  void onDispose() {
    // TODO: implement onDispose
    super.onDispose();
  }
}
