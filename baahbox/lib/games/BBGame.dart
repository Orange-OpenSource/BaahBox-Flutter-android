/*
 * Baah Box
 * Copyright (c) 2024. Orange SA
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 */

import 'dart:io';

import 'package:get/get.dart';
import 'package:flame/game.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:flame/palette.dart';
import 'dart:ui';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:baahbox/services/settings/settingsController.dart';

class BBGame extends FlameGame with PanDetector {
  final Controller appController = Get.find();

  GameState state = GameState.initializing;
  final double reactivity = 0.2; //todo enum (hardnesscoeff in ios)
  String title = "titre";
  String subTitle = "sous titre";
  String feedback = "encore un effort !";

  bool get isRunning => state == GameState.running;
  bool get isGameOver => (state == GameState.won || state == GameState.lost);
  bool get isWon => state == GameState.won;
  bool get isLost => state == GameState.lost;
  bool get isReady => state == GameState.ready;

  //Flame.device.fullScreen();
  Future<void> onLoad() async {
    await super.onLoad();
    initializeGame();
  }

  void initializeGame() {
    overlays.clear();
    overlays.add('Instructions');
    overlays.add('PreGame');
    state = GameState.ready;
  }

  void startGame() {
    overlays.clear();
    appController.setActivationStateTo(true);
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
    const duration = Duration(milliseconds: 300);
    overlays.clear();
    overlays.add('Instructions');
    sleep(duration);
    startGame();
  }
}
