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

  var gameObjective = 2;
  var successfullJumps = 0;
  var hasSheepStartedJumping = false;
  var nbDisplayedGates = 0;
  var sheepDidJumpOverGate = false;
  var strengthValue = 0;

  var panInput = 0;
  var input = 0;
  double floorY = 0;
  var instructionTitle = 'Saute les barrières';
  var instructionSubtitle = 'en contractant ton muscle';
  var feedbackTitleWon = 'tu as sauté toutes les barrières';
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
        position: Vector2(size.x/10,size.y/10),
        anchor: Anchor.bottomLeft,
        priority: 1,
      ),
    ]);
  }
  @override
  Future<void> onLoad() async {
    title = instructionTitle;
    subTitle = instructionSubtitle;
    floorY = (size.y * 0.7);
    await loadAssetsInCache();
    loadComponents();
    loadInfoComponents();
    progressionText.text = feedback;
    super.onLoad();
  }
// ===================
  // MARK: - Game loop
  // ===================

  @override
  void update(double dt) {
    super.update(dt);
    if (state == GameState.running) {
      refreshInput();
      if (isNewGateOnQueue()) {
        if (!isSheepOnFloor() && !sheepDidJumpOverGate) {
          setGameStateToWon(false);
          feedback = "aie !  tu n'as sauté que ${successfullJumps} barrière(s)";
          displayFeedBack();//.ended(Score(won: false, total: successfullJumps))
        } else if (successfullJumps == gameObjective) {
          setGameStateToWon(true); //.ended(Score(won: true, total: successfullJumps))
        }
        feedback = "";
        displayFeedBack();
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
        feedback = "bravo tu as sauté ${successfullJumps} barrière(s) sur ${gameObjective}";
        displayFeedBack();
        sheepDidJumpOverGate = true;
        //configureScoreLabel(with: successfullJumps);
      }
      hasSheepStartedJumping = false;
      // startWalkingSheepAnimation()
      //configureLabelsForWalking()
    } else {
      hasSheepStartedJumping = true;
      //stopWalkingSheepAnimation()
      // sheep.texture = sheepJumpTexture
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
    if (paused) {
      resumeEngine();
    }
  }

  void setGameStateToWon(bool win) {
    state = win ? GameState.won : GameState.lost;
    feedback = win ? feedbackTitleWon : feedbackTitleLost;
    if (win) {sheep.hide();}
    displayFeedBack();
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
