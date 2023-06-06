import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'balloonSprite.dart';
import 'package:flutter/material.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:get/get.dart';
import 'package:baahbox/constants/colors.dart';

class BalloonGame extends FlameGame {
  final Controller c = Get.find();
  Color backgroundColor() =>  BBColors.theme1Colors['balloon'] as Color;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await Flame.images.loadAll(<String>[
      'ballon_00@2x.png',
     'ballon_01@2x.png',
      'ballon_02@2x.png',
      'ballon_03@2x.png',
      'ballon_04@2x.png',
    ]);
    var _balloon = BalloonSprite();
    await add(_balloon);
    _balloon.position = size / 2;
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}