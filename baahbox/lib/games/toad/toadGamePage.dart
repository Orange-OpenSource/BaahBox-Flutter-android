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

import 'package:auto_size_text/auto_size_text.dart';
import 'package:baahbox/constants/enums.dart';
import 'toadGame.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flame/game.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:baahbox/games/overlayBuilder.dart';

class ToadGamePage extends StatelessWidget {
  final Controller appController = Get.find();
  final game = ToadGame();
  final mainColor = BBGameList.toad.baseColor.color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: mainColor,
          titleTextStyle: TextStyle(
              color: mainColor, fontWeight: FontWeight.bold, fontSize: 20),
          centerTitle: true,
          title: AutoSizeText("Slurp !", maxLines: 1),
          actions: [
            Container(
                width: 25,
                child: Obx(() => Image.asset(appController.currentSensor.asset,
                    color: mainColor))),
            IconButton(
                icon: Image.asset(
                    'assets/images/Dashboard/settings_icon.png',
                    width: 25, height: 25, color: mainColor),
                onPressed: () => Get.toNamed('/toadSettings')),
          ],
        ),
        body: Stack(children: [
          GameWidget(
            game: game,
            overlayBuilderMap: const {
              'PreGame': OverlayBuilder.preGame,
              'Instructions': OverlayBuilder.instructions,
              'FeedBack': OverlayBuilder.feedback,
              'PostGame': OverlayBuilder.postGame,
            },
            loadingBuilder: (_) => const Center(
              child: Text('Loading'),
            ),
          )
        ]),
    );
  }
}
