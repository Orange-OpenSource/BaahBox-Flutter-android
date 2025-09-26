import 'dart:ui' as ui;

class Player {
  double x;
  double y;
  double angle;
  final ui.Image? miniMapImage;
  final ui.Image? image;

  Player({required this.x,
    required this.y,
    required this.angle,
    required this.miniMapImage,
    required this.image});
}