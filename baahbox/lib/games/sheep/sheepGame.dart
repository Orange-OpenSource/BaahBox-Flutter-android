import 'dart:math';
import 'dart:ui';
import 'package:baahbox/games/trex/game_over.dart';
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
import 'package:baahbox/games/sheep/components/happySheepComponent.dart';
import 'package:baahbox/games/sheep/components/counterManager.dart';
import 'package:baahbox/games/sheep/background/cloud_manager.dart';
import 'package:baahbox/services/settings/settingsController.dart';

class SheepGame extends BBGame with TapCallbacks, HasCollisionDetection {
  final Controller appController = Get.find();
  final SettingsController settingsController = Get.find();

  late final Image spriteImage;
  late final CloudManager cloudManager = CloudManager();
  late final CounterManager counterManager = CounterManager();

  late final SheepComponent sheep;
  late final GateComponent gate;
  late final FloorComponent floor;
  late final BimComponent collision;
  late final HappySheepComponent happySheep;
  late final TextComponent progressionText;

  int gameObjective = 1;
  int successfulJumps = 0;
  int nbDisplayedGates = 0;
  bool hasSheepStartedJumping = false;
  bool sheepDidJumpOverGate = false;
  int strengthValue = 0;
  int gateVelocity = 1;

  int panInput = 0;
  int input = 0;
  double floorY = 0;
  var instructionTitle = '';
  var instructionSubtitle = '';
  var endTitle = 's';
  var feedbackTitleWon = 'Bravo! \ntu as sauté toutes les barrières';
  var feedbackTitleLost = "Tu n'as pas sauté toutes les barrières";


  @override
  Color backgroundColor() => BBGameList.sheep.baseColor.color;

  Future<void> loadAssetsInCache() async {
    await Flame.images.loadAll(<String>[
      'Jeux/Sheep/bang.png',
      'Jeux/Sheep/bim.png',
      'Jeux/Sheep/gate.png',
      'Jeux/Sheep/floor.png',
      'Jeux/Sheep/sheep_01.png',
      'Jeux/Sheep/sheep_02.png',
      'Jeux/Sheep/sheep_jumping.png',
      'Jeux/Sheep/sheep_bump.png',
      'Jeux/Sheep/happy_sheep_01.png',
      'Jeux/Sheep/happy_sheep_02.png',
      'trex.png',
    ]);
  }

  Future<void> loadComponents() async {

    await add(gate = GateComponent(speedScale: this.gateVelocity));
    await add(cloudManager);
    await add(counterManager);

    await add(sheep = SheepComponent(position: Vector2(size.x / 3, floorY)));
    await add(floor = FloorComponent(
        position: Vector2(size.x / 2, floorY),
        size: Vector2(size.x + 10, 5.0)));
    await add(happySheep = HappySheepComponent(
        position: Vector2(0, 0), size: Vector2(size.x / 2, size.y / 2)));
  }

  void loadInfoComponents() {
    addAll([
      progressionText = TextComponent(
        position: Vector2(size.x / 2, floorY + 50),
        anchor: Anchor.topCenter,
        priority: 1,
      ),
    ]);
  }

  @override
  Future<void> onLoad() async {
    var params = settingsController.sheepParams;
   gameObjective = params["numberOfGates"];
   gateVelocity = params["gateVelocity"].value;
    title = 'Essaie de sauter $gameObjective barrière';
    if (gameObjective > 1) {
      title += 's';
    }
    subTitle = instructionSubtitle;
    floorY = (size.y * 0.7);

    await loadAssetsInCache();
    await loadComponents();
    loadInfoComponents();
    progressionText.text = "";
    counterManager.createMarks(gameObjective);
    super.onLoad();
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
        if (isNewGateOnQueue()) {
          if (!isSheepOnFloor() && !sheepDidJumpOverGate) {
            setGameStateToWon(false);
            feedback = "Il faut atterrir après la barrière!";
            progressionText.text = feedback;
          } else if (successfulJumps == gameObjective) {
            counterManager.looseOneMark();
            setGameStateToWon(true);
          }
          sheepDidJumpOverGate = false;
          progressionText.text = "";
        } else {
          checkSheepAndGatePositions();
        }
      }
    }
  }

  void transformInputInMove() {
    if (appController.isConnectedToBox) { //   if input <= threshold { return }
      //   var heightConstraint = (CGFloat(strengthValue) - CGFloat (hardnessCoeff*350)) / 1000
//   if heightConstraint < 0 { heightConstraint = 0 }
      final jumpHeigth = floorY * (1 - (input / 100));
      // print("floorY: $floorY, height: $jumpHeigth");
      sheep.moveTo(jumpHeigth);
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

  void checkSheepAndGatePositions() {
    if (isSheepOnFloor()) {
      if ((isSheepBeyondTheGate()) &&
          hasSheepStartedJumping &&
          !sheepDidJumpOverGate) {
        counterManager.looseOneMark();
        sheepDidJumpOverGate = true;
        successfulJumps += 1;
        configureLabelsForCongrats();
      }
      hasSheepStartedJumping = false;
      // startWalkingSheepAnimation()
      configureLabelsForWalking();
    } else {
      hasSheepStartedJumping = true;
      if (isSheepBeyondTheGate()) {
        sheepDidJumpOverGate = false;
        configureLabelsToGoDown();
      } else {
        configureLabelsForJumpInProgress();
      }
    }
  }

  void configureLabelsForCongrats() {
    progressionText.text = "congrats!";
  }

  void configureLabelsForWalking() {
    progressionText.text = "walking";
  }

  void configureLabelsToGoDown() {
    progressionText.text = "Atterris après la barrière !";
  }

  void configureLabelsForJumpInProgress() {
    progressionText.text = "Hop!";
  }

  bool isNewGateOnQueue() {
    return gate.isNewComer;
  }

  bool isSheepOnFloor() {
    return sheep.isOnFloor(floorY);
  }

  bool isSheepBeyondTheGate() {
    return sheep.isBeyond(gate.position.x);
  }

  @override
  void startGame() {
    successfulJumps = 0;
    hasSheepStartedJumping = false;
    sheepDidJumpOverGate = false;
    var params = settingsController.sheepParams;
    gameObjective = params["numberOfGates"];
    gateVelocity = params["gateVelocity"].value;
    print("gates : $gameObjective, velocity: $gateVelocity");
    counterManager.createMarks(gameObjective);
    progressionText.text = "";
    sheep.initialize();
    gate.reset(gateVelocity);
    super.startGame();
  }

  @override
  void resetGame() {
    super.resetGame();
    successfulJumps = 0;
    hasSheepStartedJumping = false;
    sheepDidJumpOverGate = false;
    var params = settingsController.sheepParams;
    gameObjective = params["numberOfGates"];
    gateVelocity = params["gateVelocity"].value;
    print("gates : $gameObjective, velocity: $gateVelocity");
    counterManager.createMarks(gameObjective);
    progressionText.text = "";

    sheep.initialize();
    gate.reset(gateVelocity);
    floor.show();
    cloudManager.start();
    sheep.tremble();
    if (paused) {
      resumeEngine();
    }
  }

  void setGameStateToWon(bool win) {
    state = win ? GameState.won : GameState.lost;
    feedback = win ? feedbackTitleWon : feedbackTitleLost;
    if (win) {
      sheep.hide();
      floor.hide();
      counterManager.counterText.text = "";
    }
    progressionText.text = ""; //feedback;
    endGame();
  }

  @override
  void endGame() {
    cloudManager.pause();
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

  @override
  void onDispose() {
    // TODO: implement onDispose
    super.onDispose();
  }
}
