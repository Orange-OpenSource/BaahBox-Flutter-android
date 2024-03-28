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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:baahbox/routes/routes.dart';
import 'package:baahbox/constants/enums.dart';

class WelcomePage extends StatelessWidget with WidgetsBindingObserver {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainColor = BBColor.pinky.color;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
              color: mainColor, fontWeight: FontWeight.bold, fontSize: 25),
          centerTitle: true,
          title: Text("Baah !"),
          leading: null,
          automaticallyImplyLeading: false,
          actions: [
            Container(
                width: 25,
                child: Image.asset('assets/images/Dashboard/demo@2x.png',
                    color: mainColor)),
            SizedBox(
              width: 15,
            ),
            IconButton(
                icon: Image.asset(
                    'assets/images/Dashboard/settings_icon@2x.png',
                    color: mainColor),
                onPressed: () => Get.toNamed('/settings')),
          ],
        ),
        backgroundColor: Colors.white,
        body: Container(
          child: ListView(
              padding: const EdgeInsets.all(0),
              children: <Widget>[GameRow(BBGameList.star, BBRoute.star.path),
        GameRow(BBGameList.balloon, BBRoute.balloon.path),
        GameRow(BBGameList.sheep, BBRoute.sheep.path),
        GameRow(BBGameList.starship, BBRoute.spaceShip.path),
        GameRow(BBGameList.toad, BBRoute.toad.path),
          ] //wrap
          ),
        ));
  }
}

class GameRow extends StatelessWidget {
  GameRow(this.game, this.gamePath);
  final String gamePath;
  final BBGameList game;

  @override
  Widget build(BuildContext context) {
    return
        ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(game.baseColor.color),
        shape:MaterialStateProperty.all(ContinuousRectangleBorder())),
        child: Container(
            alignment: Alignment.centerLeft,
            height: (Get.height/5)-10,
            width: Get.width,
            padding: const EdgeInsets.all(0),

            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Image(
                  alignment: Alignment.centerLeft,
                  image: AssetImage(game.mainAsset)),
                  Spacer(),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      game.title,
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                      textAlign: TextAlign.end,

                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                      alignment: Alignment.bottomRight,
                      image: AssetImage('assets/images/Dashboard/capteur.png'),
                      height: 25,
                      width: 25,
                    )]),
                  ]),


            ])),
        onPressed: () => Get.toNamed(gamePath));
  }
}
