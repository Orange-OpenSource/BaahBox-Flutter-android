// raycasting explanations (DDA algorithm) :
// https://wynnliam.github.io/raycaster/news/tutorial/2019/03/23/raycaster-part-01.html
// https://ismailassil.medium.com/ray-casting-c-8bfae2c2fc13

import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../constants/enums.dart';
import '../models/Player.dart';
import '../models/Target.dart';

class RayCastingPainter extends CustomPainter {
  List<List<int>> map;
  final Player player;
  final Target target;
  final ui.Image? wallTexture;
  final bool isReverse;

  double fov = pi / 3;

  RayCastingPainter(
      {required this.map,
      required this.player,
      required this.target,
      required this.wallTexture,
      required this.isReverse});

  void setFOV(double newFOV) {
    fov = newFOV;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final screenWidth = size.width;
    final screenHeight = size.height;

    //const fov = pi / 3; // 60 degrees field of view
    var halfFov = fov / 2;

    final numRays = screenWidth.toInt();
    final angleStep = fov / numRays;

    const maxDepth = 20.0;

    if (isReverse) {
      paint.color = Colors.white;
      canvas.drawRect(
        Rect.fromLTWH(
          0,
          0,
          screenWidth,
          screenHeight,
        ),
        paint,
      );
    }

    // Draw floor and ceiling with gradient effect
    for (int y = screenHeight ~/ 2; y < screenHeight; y++) {
      double depth = (screenHeight / (2.0 * y - screenHeight));
      double brightness = 1.0 - (depth / maxDepth);
      if (brightness < 0) brightness = 0;

      // Floor
      paint.color =
          Color.lerp(BBColor.lightGreen.color, Colors.black, 1 - brightness)!;
      canvas.drawLine(
        Offset(0, y.toDouble()),
        Offset(screenWidth, y.toDouble()),
        paint,
      );

      // Ceiling (mirror the y-coordinate)
      paint.color =
          Color.lerp(Colors.lightBlueAccent, Colors.black, 1 - brightness)!;
      canvas.drawLine(
        Offset(0, (screenHeight - y).toDouble()),
        Offset(screenWidth, (screenHeight - y).toDouble()),
        paint,
      );
    }
    List<double> depthBuffer = List.filled(numRays, double.infinity);

    for (int i = 0; i < numRays; i++) {
      double playerAngleView = isReverse ? player.angle + pi : player.angle;
      final rayAngle = (playerAngleView - halfFov) + (i * angleStep);

      double distanceToWall = 0.0;
      bool hitWall = false;
      bool isVerticalHit = false;

      final eyeX = cos(rayAngle);
      final eyeY = sin(rayAngle);

      double hitX = 0.0;
      double hitY = 0.0;

      while (!hitWall && distanceToWall < maxDepth) {
// Position sur la carte (en cases entières)
        int mapX = player.x.toInt();
        int mapY = player.y.toInt();

        // Longueur du rayon depuis la position actuelle jusqu'au prochain côté x ou y
        double sideDistX;
        double sideDistY;

        // Longueur du rayon d'un côté x ou y au côté suivant x ou y
        // On évite la division par zéro si le rayon est parfaitement parallèle aux axes
        final deltaDistX = (eyeX == 0) ? 1e30 : (1 / eyeX).abs();
        final deltaDistY = (eyeY == 0) ? 1e30 : (1 / eyeY).abs();

        // Direction dans laquelle avancer sur la grille (+1 ou -1)
        int stepX;
        int stepY;

        // Calcul des valeurs initiales de sideDist et step
        if (eyeX < 0) {
          stepX = -1;
          sideDistX = (player.x - mapX) * deltaDistX;
        } else {
          stepX = 1;
          sideDistX = (mapX + 1.0 - player.x) * deltaDistX;
        }

        if (eyeY < 0) {
          stepY = -1;
          sideDistY = (player.y - mapY) * deltaDistY;
        } else {
          stepY = 1;
          sideDistY = (mapY + 1.0 - player.y) * deltaDistY;
        }

        // Boucle DDA
        while (!hitWall && distanceToWall < maxDepth) {
          // On saute à la prochaine case de la grille, soit en direction x, soit en y
          if (sideDistX < sideDistY) {
            sideDistX += deltaDistX;
            mapX += stepX;
            isVerticalHit = true; // Le rayon a traversé une ligne verticale
          } else {
            sideDistY += deltaDistY;
            mapY += stepY;
            isVerticalHit = false; // Le rayon a traversé une ligne horizontale
          }

          // À l'intérieur de la boucle DDA, après avoir avancé,
          // on calcule la distance du rayon. C'est la distance euclidienne le long du rayon.
          if (isVerticalHit) {
            // La distance est calculée à partir de la position du joueur jusqu'au mur vertical
            distanceToWall = (mapX - player.x + (1 - stepX) / 2) / eyeX;
          } else {
            // La distance est calculée à partir de la position du joueur jusqu'au mur horizontal
            distanceToWall = (mapY - player.y + (1 - stepY) / 2) / eyeY;
          }

          // Vérifier si le rayon est sorti des limites
          if (mapX < 0 ||
              mapX >= map[0].length ||
              mapY < 0 ||
              mapY >= map.length) {
            hitWall = true; // Considéré comme un mur pour arrêter le rayon
            distanceToWall = maxDepth;
          } else if (map[mapY][mapX] == 1) {
            hitWall = true;
            // La distance est déjà calculée, isVerticalHit est déjà défini.
          }
        }

//      Calcule la différence d'angle entre la direction du joueur et le rayon actuel.
        final angleDifference = playerAngleView - rayAngle;

        // Corrige la distance pour annuler la distorsion fisheye.
        // On utilise le cosinus de la différence d'angle.
        final correctedDistance = distanceToWall * cos(angleDifference);

        final wallHeight = screenHeight / (correctedDistance + 0.0001);

        double brightness =
            (1 - (correctedDistance / maxDepth)).clamp(0.0, 1.0);

        // Further adjust shade based on hit orientation
        if (isVerticalHit) {
          brightness *= 0.5; // Darken vertical walls
        }

        final x = i * (screenWidth / numRays);

        // rendu des murs
        if (wallTexture != null && hitWall) {
          // Texture mapping
          double wallX;
          if (isVerticalHit) {
            wallX = hitY % 1;
          } else {
            wallX = hitX % 1;
          }
          int texX = (wallX * wallTexture!.width).toInt();
          texX = texX.clamp(0, wallTexture!.width - 1);

          Rect srcRect = Rect.fromLTWH(
            texX.toDouble(),
            0,
            1,
            wallTexture!.height.toDouble(),
          );

          Rect dstRect = Rect.fromLTWH(
            x,
            (screenHeight - wallHeight) / 2,
            (screenWidth / numRays) + 1,
            wallHeight,
          );

          paint.color = Colors.white;
          paint.colorFilter = ColorFilter.mode(
            Colors.black.withValues(alpha: 1 - brightness),
            BlendMode.multiply,
          );

          canvas.drawImageRect(wallTexture!, srcRect, dstRect, paint);

          paint.colorFilter = null; // Reset color filter
        } else {
          paint.color = Color.lerp(
              BBColor.sheepGray.color, Colors.black, 1 - brightness)!;

          canvas.drawLine(
            Offset(x, max(0, (screenHeight - wallHeight) / 2)),
            Offset(x, min(screenHeight, (screenHeight + wallHeight) / 2)),
            paint..strokeWidth = (screenWidth / numRays) + 1,
          );
        }
        // Save the distance to the wall for this ray
        depthBuffer[i] = correctedDistance;
      }
    }
    // Render target
    renderTarget(canvas, size, depthBuffer);
    // applyLighting(canvas, size);
  }

  void applyLighting(Canvas canvas, Size size) {
    final screenWidth = size.width;
    final screenHeight = size.height;

    // Create a radial gradient centered on the player's view direction
    Rect gradientRect = Rect.fromCircle(
      center: Offset(screenWidth / 2, screenHeight / 2),
      radius: screenHeight / 2,
    );

    Paint lightPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, 0),
        radius: 0.8,
        colors: [
          Colors.transparent,
          Colors.black.withValues(alpha: 0.8),
        ],
        stops: const [0.6, 1.0],
      ).createShader(gradientRect)
      ..blendMode = BlendMode.darken;

    // Draw the gradient overlay
    canvas.drawRect(
      Rect.fromLTWH(0, 0, screenWidth, screenHeight),
      lightPaint,
    );
  }

  void renderTarget(Canvas canvas, Size size, List<double> depthBuffer) {
    final screenWidth = size.width;
    final screenHeight = size.height;

    var halfFov = fov / 2;

    TargetData? targetData;

    double dx = target.x - player.x;
    double dy = target.y - player.y;
    double distance = sqrt(dx * dx + dy * dy);

    double playerAngleView = isReverse ? player.angle + pi : player.angle;
    double angleToTarget = atan2(dy, dx) - playerAngleView;

    // Normalize angle to -pi to pi
    if (angleToTarget < -pi) angleToTarget += 2 * pi;
    if (angleToTarget > pi) angleToTarget -= 2 * pi;

    // Check if target is within FOV
    if (angleToTarget > -halfFov && angleToTarget < halfFov) {
      // Check if target is visible (not blocked by walls)
      if (isTargetVisible(target, distance)) {
        targetData = TargetData(
          target: target,
          distance: distance,
          angleToTarget: angleToTarget,
        );
      }
    }

    // Now render target
    if (targetData != null) {
      Target target = targetData.target;

      double distance = targetData.distance;
      double angleToTarget = targetData.angleToTarget;

      // Project target onto screen
      double screenX = (angleToTarget + halfFov) / fov * screenWidth;

      // Scale target size based on distance
      double targetSize =
          (screenHeight / distance) * 0.5; // Adjust scaling factor as needed
      targetSize =
          targetSize.clamp(20, screenHeight / 2); // Clamp to reasonable size

      int targetScreenX = screenX.toInt();

      // Check if target is behind a wall at this screen position
      bool drawTarget = true;
      if (targetScreenX >= 0 && targetScreenX < depthBuffer.length) {
        if (depthBuffer[targetScreenX] < distance) {
          // Wall is closer than target, so skip rendering
          drawTarget = false;
        }
      }
      if (drawTarget) {
        // Save the canvas state before applying transformations
        canvas.save();

        // Translate canvas to the target's position
        canvas.translate(screenX, screenHeight / 2);

        canvas.rotate(target.angle);

        if (target.image != null) {
          // Draw target image
          Paint paint = Paint();
          Rect srcRect = Rect.fromLTWH(
            0,
            0,
            target.image!.width.toDouble(),
            target.image!.height.toDouble(),
          );
          Rect dstRect = Rect.fromCenter(
            center: const Offset(0, 0),
            width: targetSize / 2,
            height: targetSize,
          );
          canvas.drawImageRect(target.image!, srcRect, dstRect, paint);
        } else {
          // Draw target as a rectangle as a fallback
          Paint paint = Paint()..color = Colors.red;
          canvas.drawRect(
            Rect.fromCenter(
              center: const Offset(0, 0),
              width: targetSize / 2,
              height: targetSize,
            ),
            paint,
          );
        }

        // Restore canvas to previous state
        canvas.restore();
      }
    }
  }

  bool isTargetVisible(Target target, double distance) {
    // Perform ray casting from player to target
    double dx = target.x - player.x;
    double dy = target.y - player.y;
    double angleToTarget = atan2(dy, dx);

    double eyeX = cos(angleToTarget);
    double eyeY = sin(angleToTarget);

    double rayX = player.x;
    double rayY = player.y;
    double maxDistance = distance;

    double stepSize = 0.05; // Adjust step size as needed

    double distanceTraveled = 0.0;

    while (distanceTraveled < maxDistance) {
      rayX += eyeX * stepSize;
      rayY += eyeY * stepSize;

      distanceTraveled += stepSize;

      int mapX = rayX.toInt();
      int mapY = rayY.toInt();

      // Check if ray is out of bounds
      if (mapX < 0 || mapX >= map[0].length || mapY < 0 || mapY >= map.length) {
        return false;
      }

      if (map[mapY][mapX] == 1) {
        // Wall is blocking the target
        return false;
      }
    }

    return true;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class TargetData {
  Target target;
  double distance;
  double angleToTarget;

  TargetData(
      {required this.target,
      required this.distance,
      required this.angleToTarget});
}
