import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'starSprite.dart';
import 'package:flutter/material.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:get/get.dart';
import 'package:baahbox/constants/colors.dart';

class StarGame extends FlameGame {
  final Controller c = Get.find();
  Color backgroundColor() =>  BBColors.theme1Colors['star'] as Color;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await Flame.images.loadAll(<String>[
      'jeu_etoile_01@2x.png',
      'jeu_etoile_02@2x.png',
    ]);
    var _star = StarSprite();
    await add(_star);
    _star.position = size / 2;
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}