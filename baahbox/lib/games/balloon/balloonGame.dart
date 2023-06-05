import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';
import 'balloonSprite.dart';
import 'package:flutter/material.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:get/get.dart';

class BalloonGame extends FlameGame {

  final Controller c = Get.find();
  @override
  Color backgroundColor() => const Color(0xFFE26F3B);
  Future<void> onLoad() async {
    super.onLoad();
    await Flame.images.loadAll(<String>[
      'ballon_00@2x.png',
     'ballon_01@2x.png',
      'ballon_02@2x.png',
      'ballon_03@2x.png',
      'ballon_04@2x.png',
    ]);

    // final gonfle = SpriteComponent.fromImage(
    //   Flame.images.fromCache('ballon_03@2x.png'),
    //   position: Vector2(10, 100), // Set your position here
    //   size: Vector2(100, 100), // Set your size here (by default it is 0),
    // );

    //await add(gonfle);
    var _balloon = BalloonSprite();
    await add(_balloon);
    _balloon.position = size / 2;
   // camera.followComponent(_balloon,
    //    worldBounds: Rect.fromLTRB(0, 0, 300, 300));
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}