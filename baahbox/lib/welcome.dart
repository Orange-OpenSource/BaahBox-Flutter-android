import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:baahbox/routes/routes.dart';
import 'package:baahbox/constants/colors.dart';
import 'dart:ui';


class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final  mainColor = BBColors.theme1Colors['main'] as Color;
    final Controller c = Get.put(Controller());
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
              color: mainColor,
              fontWeight: FontWeight.bold,
              fontSize: 25),
          centerTitle: true,
          title: Text("Baah !"),
          actions: [
            Container(
                width: 25,
                child:
               Image.asset('assets/images/Dashboard/demo@2x.png', color: mainColor)
            ),
            SizedBox(width: 15,),

            IconButton(icon: Image.asset('assets/images/Dashboard/settings_icon@2x.png', color: mainColor),
                onPressed: () => Get.toNamed('/settings')
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GameRow('assets/images/Dashboard/menu_etoile@2x.png',
                    BBColors.theme1Colors['star'] as Color, 'Star', 1, BBRoutes.star),
                GameRow('assets/images/Dashboard/menu_ballon@2x.png',
                    BBColors.theme1Colors['balloon'] as Color, 'Balloon', 1, BBRoutes.balloon),
                GameRow('assets/images/Dashboard/menu_mouton@2x.png',
                    BBColors.theme1Colors['sheep'] as Color, 'Sheep', 1, BBRoutes.sheep),
                GameRow('assets/images/Dashboard/menu_espace@2x.png',
                    BBColors.theme1Colors['spaceShip'] as Color, 'SpaceShip', 2, BBRoutes.spaceShip),
                GameRow('assets/images/Dashboard/menu_gobe@2x.png', BBColors.theme1Colors['toad'] as Color,
                    'Toad', 2, BBRoutes.toad),
              ]
              //wrap
              ),
        ));
  }
}

class GameRow extends StatelessWidget {

  GameRow(this.gameAsset, this.gameColor, this.title, this.numberOfSensors, this.gameSceneName);
  final String gameSceneName;
  final String gameAsset;
  final Color gameColor;
  String title;
  int numberOfSensors;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(gameColor)),
        child: Container(
            alignment: Alignment.centerLeft,
            height: 100,
            width: 400,
            child: Row(//mainAxisAlignment: MainAxisAlignment.start,
                children: [
              Image(
                  alignment: Alignment.centerLeft,
                  image: AssetImage(gameAsset)),
              Spacer(),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
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
        onPressed: () => Get.toNamed(gameSceneName));
  }
}
