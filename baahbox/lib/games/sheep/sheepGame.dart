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
import 'package:baahbox/games/sheep/components/happySheepComponent.dart';

class SheepGame extends BBGame with TapCallbacks, HasCollisionDetection {
  final Controller appController = Get.find();

  late final SheepComponent sheep;
  late final GateComponent gate;
  late final FloorComponent floor;
  late final BimComponent collision;
  late final HappySheepComponent happySheep;
  late final TextComponent progressionText;

  int gameObjective = 2;
  int successfullJumps = 0;
  int nbDisplayedGates = 0;
  bool hasSheepStartedJumping = false;
  bool sheepDidJumpOverGate = false;
  int strengthValue = 0;

  int panInput = 0;
  int input = 0;
  double floorY = 0;
  var instructionTitle = 'Saute les barrières';
  var instructionSubtitle = 'en contractant ton muscle';
  var feedbackTitleWon = 'Bravo! \ntu as sauté toutes les barrières';
  var feedbackTitleLost = "tu n'as pas sauté toutes les barrières";

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
    ]);
  }

  void loadComponents() async {
    await add(gate = GateComponent());
    await add(sheep = SheepComponent(position: Vector2(size.x / 2, floorY)));
    await add(floor = FloorComponent(position: Vector2(size.x / 2, floorY), size: Vector2(size.x, 5.0)));
    await add(happySheep = HappySheepComponent(position: Vector2(0, 0), size: Vector2(size.x/2, size.y/2)));
  }

  void loadInfoComponents() {
    addAll([
      progressionText = TextComponent(
        position: Vector2(10,floorY+50),
        anchor: Anchor.topLeft,
        priority: 1,

      ),
    ]);
  }


  bool get isRunning => state == GameState.running;
  bool get isGameOver => (state == GameState.won || state == GameState.lost);
  bool get isWon => state == GameState.won;
  bool get isLost => state == GameState.lost;
  bool get isReady => state == GameState.ready;

  @override
  Future<void> onLoad() async {
    title = instructionTitle;
    subTitle = instructionSubtitle;
    floorY = (size.y * 0.7);
    await loadAssetsInCache();
    loadComponents();
    loadInfoComponents();
    progressionText.text = "";
    super.onLoad();
  }
// ===================
  // MARK: - Game loop
  // ===================

  @override
  void update(double dt) {
    super.update(dt);
    if (isRunning) {
      refreshInput();
      if (isNewGateOnQueue()) {
        if (!isSheepOnFloor() && !sheepDidJumpOverGate) {
          setGameStateToWon(false);
          feedback = "il faut atterrir entre chaque barrière!";
          progressionText.text = feedback;
        } else if (successfullJumps == gameObjective) {
          setGameStateToWon(true);
        }
        //progressionText.text = "tu dois sauter ${gameObjective} barrière(s)";
        sheepDidJumpOverGate = false;
      } else {
        checkSheepAndGatePositions();
      }
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

  void checkSheepAndGatePositions() {
    if (isSheepOnFloor()) {
      if ((isSheepBeyondTheGate()) &&
          hasSheepStartedJumping &&
          !sheepDidJumpOverGate) {
        successfullJumps += 1;
        feedback = "tu as sauté ${successfullJumps} barrière(s) sur ${gameObjective}";
        progressionText.text = feedback;
        sheepDidJumpOverGate = true;
      }
      hasSheepStartedJumping = false;
      // startWalkingSheepAnimation()
      //configureLabelsForWalking()
    } else {
      hasSheepStartedJumping = true;
      if (isSheepBeyondTheGate()) {
        // configureLabelsToGoDown()
      } else {
        //  configureLabelsForJumpInProgress()
      }
    }
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
  void resetGame() {
    super.resetGame();
    successfullJumps = 0;
    hasSheepStartedJumping = false;
    sheepDidJumpOverGate = false;
    sheep.initialize();
    gate.resetPosition();
    floor.setAlpha(255);
    progressionText.text ="";
    if (paused) {
      resumeEngine();
    }
  }

  void setGameStateToWon(bool win) {
    state = win ? GameState.won : GameState.lost;
    feedback = win ? feedbackTitleWon : feedbackTitleLost;
    if (win) {
      sheep.hide();
      floor.setAlpha(0);
      progressionText.text = "";//feedback;
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
      var yPos = info.eventPosition.global.y;
      var nextY = min(yPos, floorY);
      sheep.moveTo(nextY);
    }
  }

  // ===================
  // MARK: - Parameters
  // ===================

  // @objc func loadParameters() {
  //   threshold = ParameterDataManager.sharedInstance.threshold
  //   gameObjective = ParameterDataManager.sharedInstance.numberOfFences
  //
  //   switch ParameterDataManager.sharedInstance.fenceVelocity {
  //   case .slow:
  //   speedRate = 1
  //   case .average:
  //   speedRate = 2
  //   default:
  //   speedRate = 3
  //   }
  //   // needed ??
  //   if !isGameOnGoing {
  //   configureScoreLabel(with: 0)
  //   }
  //   }
}
