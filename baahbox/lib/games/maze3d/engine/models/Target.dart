import 'dart:ui' as ui;

class Target {
  double x;
  double y;
  double angle;
  final ui.Image? image;
  Target({required this.x, required this.y, required this.angle, required this.image});
}