import 'package:baahbox/dino_game.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:baahbox/model/sensorInput.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:get/get.dart';
import 'package:flame/game.dart';
import 'dart:ui';
import 'starSprite.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../../dino_game.dart';
import '../../helpers/navigation_keys.dart';



class StarGame extends StatefulWidget {
  const StarGame({Key? key}) : super(key: key);

  @override
  _StarGameState createState() => _StarGameState();

}


  class _StarGameState extends State<StarGame> {
  bool _duringCelebration = false;
  late DateTime _startOfPlay;
  final game = DinoGame();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          GameWidget(
            game: game,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: NavigationKeys(
              onDirectionChanged: game.onArrowKeyChanged,
            ),
          ),
        ]));
  }
}

// Widget build(context) {
//   final Controller c = Get.find();
//   return Obx(() =>
//       Scaffold(
//           body: Center(
//
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         foregroundColor: Colors.white,
//                         backgroundColor: Colors.grey, // foreground
//                       ),
//                       onPressed: () => Get.back(),
//                       child: const Text('Sheep ! Back to earth !'),
//                     ),
//                     Text(c.musclesInput.describe()),
//                   ]
//               )
//           )
//       ));
// }
//}
