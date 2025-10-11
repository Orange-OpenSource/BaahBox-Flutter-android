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

import 'dart:math';

import 'package:baahbox/services/settings/settingsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:baahbox/routes/routes.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/controllers/appController.dart';

class WelcomePage extends StatefulWidget with WidgetsBindingObserver {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final mainColor = BBColor.pinky.color;
    double h = (Get.height / 5) - 10;
    double w = Get.width;
    final Controller appController = Get.find();

    return Scaffold(
        appBar: AppBar(
          title: Text("Baah !"),
          // leading: null,
          automaticallyImplyLeading: false,
          actions: [
            Container(
                width: 25,
                child: Obx(() => Image.asset(appController.currentSensor.asset,
                    color: mainColor))),
            IconButton(
                icon: Image.asset('assets/images/Dashboard/settings_icon.png',
                    width: 25, height: 25, color: mainColor),
                onPressed: () => Get.toNamed('/settings')),
          ],
        ),
        body: SafeArea(child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return GameList(availableHeight: constraints.maxHeight);
        })));
  }
}

class GameList extends StatelessWidget {
  final double availableHeight;

  const GameList({super.key, required this.availableHeight});
  @override
  Widget build(BuildContext context) {
    final double height =
        availableHeight / 6; //MediaQuery.of(context).size.height/6;
    return Container(
      child: ListView(padding: const EdgeInsets.all(0), children: <Widget>[
        GameRow(BBGameList.star, BBRoute.star.path, height),
        GameRow(BBGameList.balloon, BBRoute.balloon.path, height),
        GameRow(BBGameList.sheep, BBRoute.sheep.path, height),
        GameRow(BBGameList.starship, BBRoute.spaceShip.path, height),
        GameRow(BBGameList.toad, BBRoute.toad.path, height),
        GameRow(BBGameList.maze, BBRoute.maze.path, height),
        GameRow(BBGameList.maze3d, BBRoute.maze3d.path, height),
      ] //wrap
          ),
    );
  }
}

class GameRow extends StatelessWidget {
  GameRow(this.game, this.gamePath, this.height);
  final String gamePath;
  final BBGameList game;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(game.baseColor.color),
            shape: MaterialStateProperty.all(ContinuousRectangleBorder())),
        child: Container(
            alignment: Alignment.centerLeft,
            height: max(60, height), //(Get.height/5)-10,
            width: double.infinity,
            padding: const EdgeInsets.all(0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                      alignment: Alignment.center,
                      image: AssetImage(game.mainAsset),
                      height: 60),
                  Spacer(),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(game.title,
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0),
                            textAlign: TextAlign.end,
                            maxLines: 2),
                        SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: game.compatibleSensorsList
                                .where((sensor) =>
                                    !(sensor == Sensor.analogJoystick &&
                                        game.compatibleSensorsList
                                            .contains(Sensor.digitalJoystick)))
                                .map((Sensor sensor) {
                              return Padding(
                                  padding: const EdgeInsets.only(left:5.0),
                              child:Image(
                                  alignment: Alignment.bottomRight,
                                  image: AssetImage(sensor.asset),
                                  height: 25,
                                  width: 25,
                                  color: Colors.white));
                            }).toList()),
                      ]),
                ])),
        onPressed: () => Get.toNamed(gamePath));
  }
}
