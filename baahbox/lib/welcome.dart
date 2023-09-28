import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:baahbox/routes/routes.dart';
import 'package:baahbox/constants/enums.dart';
import 'dart:ui';
import 'package:baahbox/services/ble/getx_ble.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainColor = BBColor.pinky.color;
    final Controller c = Get.put(Controller());
    final GetxBle bleController = Get.put(GetxBle());

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
              color: mainColor, fontWeight: FontWeight.bold, fontSize: 25),
          centerTitle: true,
          title: Text("Baah !"),
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
              children: <Widget>[
            GameRow(BBGameList.star, BBRoute.star.path),
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
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(game.baseColor.color),),
        child: Container(
            alignment: Alignment.centerLeft,
            height: 110,
            width: 400,
            child: Row(
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
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.end,
                      textScaleFactor: 2.0,
                    ),
                    SizedBox(height: 10),
                    Image(
                      alignment: Alignment.bottomRight,
                      image: AssetImage('assets/images/Dashboard/capteur.png'),
                      height: 25,
                      width: 25,
                    )
                  ])
            ])),
        onPressed: () => Get.toNamed(gamePath));
  }
}
