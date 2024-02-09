import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:baahbox/games/sheep/components/markComponent.dart';
import 'package:baahbox/games/sheep/sheepGame.dart';
import 'package:flame/text.dart';

class CounterManager extends Component with HasGameRef<SheepGame> {
  final markArray = [];
  var gateNumber = 1;
  final gapSize = 5;
  late final TextComponent counterText;

  @override
  Future<void> onLoad() async {
    showCount();
    createMarks(gateNumber);
  }

  void showCount() async {
    await gameRef.addAll([
      counterText = TextComponent(
          position: Vector2(0, game.size.y - 50),
          anchor: Anchor.bottomLeft,
          priority: 1,
          size: Vector2(50, 20)),
    ]);
  }

  void createMarks(int nbGates) {
    gateNumber = nbGates;
    counterText.text = "Barrières: ";
    const gapSize = 2;
    for (var i = 0; i < gateNumber; i++) {
      var xpos = (10 + gapSize) * i;
      _createMarkAt(xpos + 10, game.size.y - 10);
    }
  }

  void _createMarkAt(double x, double y) {
    final mark = MarkComponent(position: Vector2(x, y));
    markArray.add(mark);
    gameRef.add(mark);
  }

  void looseOneMark() {
    if (markArray.length > 0) {
      markArray.last.disappear();
      markArray.removeLast();
    } else {
      counterText.text = "";
    }
  }
}
