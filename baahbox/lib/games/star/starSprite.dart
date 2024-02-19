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

import 'package:baahbox/games/star/starGame.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:get/get.dart';

class StarSprite extends SpriteComponent with HasGameRef<StarGame> {
  final Controller appController = Get.find();
  StarSprite() : super(size: Vector2.all(16.0), anchor: Anchor.center);

  final starSprite = Sprite(Flame.images.fromCache('Jeux/Star/jeu_etoile_01@2x.png'));
  final shiningStarSprite =
      Sprite(Flame.images.fromCache('Jeux/Star/jeu_etoile_02@2x.png'));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    initialize();
    // TODO: calculer automatiquement la taille de l'étoile en
    //  fonction de celle de l'écran.
  }

  void initialize() {
    this.sprite = starSprite;
    size = starSprite.srcSize / 5;
    position = Vector2(gameRef.size.x / 2, gameRef.size.y/2-size.y/4);
    size = starSprite.srcSize / 5;
  }

  setTo(Sprite newSprite) {
    if (this.sprite != newSprite) {
      this.sprite = newSprite;
      final newSize = newSprite.srcSize;
      this.size = newSize / 5;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.input >= 750) {
      setTo(shiningStarSprite);
    } else {
      setTo(starSprite);
    }
  }
}
