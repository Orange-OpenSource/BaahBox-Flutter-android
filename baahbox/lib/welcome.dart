import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:baahbox/games/testGame.dart';
import 'package:baahbox/settings.dart';
import 'package:baahbox/controllers/appController.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
              color: Color(0xFFF98885),
              fontWeight: FontWeight.bold,
              fontSize: 25),
          centerTitle: true,
          title: Text("Baah !"),
          actions: [
            Container(
                width: 25,
                child:
               Image.asset('assets/images/Dashboard/demo@2x.png', color: Color(0xFFF98885))
            ),
            SizedBox(width: 15,),

            IconButton(icon: Image.asset('assets/images/Dashboard/settings_icon@2x.png', color: Color(0xFFF98885)),
                onPressed: () => Get.to(() => SettingsPage())
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
                    0xFF70576E, 'Star', 1),
                GameRow('assets/images/Dashboard/menu_ballon@2x.png',
                    0xFFE26F3B, 'Balloon', 1),
                GameRow('assets/images/Dashboard/menu_mouton@2x.png',
                    0xFFF98885, 'Sheep', 1),
                GameRow('assets/images/Dashboard/menu_espace@2x.png',
                    0xFF085559, 'Starship', 2),
                GameRow('assets/images/Dashboard/menu_gobe@2x.png', 0xFF86A2A3,
                    'Toad', 2),
              ]
              //wrap
              ),
        ));
  }
}

class GameRow extends StatelessWidget {
  // const GameRow({Key? key}) : super(key: key);

  GameRow(this.gameAsset, this.gameColorCode, this.title, this.numberOfSensors);

  final String gameAsset;
  int gameColorCode;
  String title;
  int numberOfSensors;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(gameColorCode))),
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
        onPressed: () => Get.to(() => TestGame()));
  }
}
