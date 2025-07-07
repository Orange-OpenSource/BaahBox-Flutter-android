// credit : Jobehi (Youssef El Behi)
// licence : MIT Licence
// url :https://github.com/jobehi/Flutter_ray_casting

import 'dart:math';

import 'package:flutter/material.dart';

import '../models/Player.dart';
import '../models/Target.dart';

class MinimapPainter extends CustomPainter {
  final List<List<int>> map;
  final Player player;
  final Target target;

  MinimapPainter({
    required this.map,
    required this.player,
    required this.target,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final mapHeight = map.length;
    final mapWidth = map[0].length;

    // Determine the scale factor to fit the map into the minimap size
    final scaleX = size.width / mapWidth;
    final scaleY = size.height / mapHeight;
    final scale = min(scaleX, scaleY);

    // Draw maze walls
    paint.color = Colors.grey;
    for (int y = 0; y < mapHeight; y++) {
      for (int x = 0; x < mapWidth; x++) {
        if (map[y][x] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(
              x * scale,
              y * scale,
              scale,
              scale,
            ),
            paint,
          );
        }
      }
    }

    // Draw player

    if (player.miniMapImage != null) {
      var imageScale =  min(scaleX/player.miniMapImage!.width,
          scaleY/player.miniMapImage!.height);

      var scaledWidth = player.miniMapImage!.width * imageScale;
      var scaledHeight = player.miniMapImage!.height * imageScale;
      // Draw target image
      Paint paint = Paint();
      Rect srcRect = Rect.fromLTWH(
        0,
        0,
        player.miniMapImage!.width.toDouble(),
        player.miniMapImage!.height.toDouble(),
      );
      Rect dstRect = Rect.fromLTWH(
        0,
        0,
        scaledWidth,
        scaledHeight,
      );
      canvas.save();

      canvas.translate(player.x * scale, player.y * scale);
      canvas.rotate(player.angle - pi/2);
      canvas.translate(-scaledWidth/2, -scaledHeight/2);
      canvas.drawImageRect(player.miniMapImage!, srcRect, dstRect, paint);
      canvas.restore();
    } else {

      // Draw player's viewing direction
      final double dirLength = scale;
      final playerDirX = cos(player.angle) * dirLength;
      final playerDirY = sin(player.angle) * dirLength;
      paint.color = Colors.blue;
      canvas.drawCircle(
        Offset(player.x * scale, player.y * scale),
        scale / 4, // Adjust size of the player dot
        paint,
      );


      paint.strokeWidth = 2;
      canvas.drawLine(
        Offset(player.x * scale, player.y * scale),
        Offset(
          (player.x * scale) + playerDirX,
          (player.y * scale) + playerDirY,
        ),
        paint,
      );
    }
    if (target.image != null) {
      var imageScale =  min(scaleX/target.image!.width,
          scaleY/target.image!.height);
      // Draw target image
      Paint paint = Paint();
      Rect srcRect = Rect.fromLTWH(
        0,
        0,
        target.image!.width.toDouble(),
        target.image!.height.toDouble(),
      );
      Rect dstRect = Rect.fromCenter(
        center: Offset(target.x * scale, target.y * scale),
        width: target.image!.width * imageScale,
        height: target.image!.height * imageScale,
      );
      canvas.drawImageRect(target.image!, srcRect, dstRect, paint);
    } else {
      // Draw target
      paint.color = Colors.red;

      canvas.drawCircle(
        Offset(target.x * scale, target.y * scale),
        scale / 4, // Adjust size of the enemy dot
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
