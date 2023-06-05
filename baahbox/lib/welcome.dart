import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'controllers/appController.dart';
import 'package:baahbox/games/sheepGame.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.orangeAccent),
          centerTitle: true,
          title: Text("Baah !"),
        ),
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // SizedBox(height: 50,),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFF70576E))),
                  child: Container(
                      height: 100,
                      width: 300,
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(image: AssetImage('assets/images/Dashboard/menu_etoile@2x.png')),
                        Text(
                          'Fais briller l\'étoile !',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.end,
                          textScaleFactor: 1.0,
                        )
                      ])),
                  onPressed: () => Get.to(() => SheepGame())),

              ElevatedButton(
                  child: Text('Balloon'),
                  onPressed: () => Get.to(() => WelcomePage())),

              ElevatedButton(
                  child: Text('Sheep'),
                  onPressed: () => Get.to(() => WelcomePage())),

              ElevatedButton(
                  child: Text('SpaceGame'),
                  onPressed: () => Get.to(() => WelcomePage())),

              ElevatedButton(
                  child: Text('Toad'),
                  onPressed: () => Get.to(() => WelcomePage())),
            ],
            //wrap
          ),
        ));
  }
}
