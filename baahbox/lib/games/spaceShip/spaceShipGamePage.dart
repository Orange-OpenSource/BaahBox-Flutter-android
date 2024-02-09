import 'package:baahbox/constants/enums.dart';
import 'spaceShipGame.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flame/game.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:baahbox/games/overlayBuilder.dart';

class SpaceShipGamePage extends StatelessWidget {
  final Controller appController = Get.find();
  final game = SpaceShipGame();
  final mainColor = BBGameList.starship.baseColor.color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: mainColor,
          titleTextStyle: TextStyle(
              color: mainColor, fontWeight: FontWeight.bold, fontSize: 25),
          centerTitle: true,
          title: Text("La bataille de l'espace"),
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
        floatingActionButton: FloatingActionButton(
            onPressed: () => Get.back(),
            tooltip: 'Go back',
            child: const Icon(Icons.arrow_back)
        )
    );
  }
}
