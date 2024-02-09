import 'package:flame/components.dart';
import 'package:baahbox/games/spaceShip/components/lifeComponent.dart';
import 'package:baahbox/games/spaceShip/spaceShipGame.dart';

class LifeManager extends Component with HasGameRef<SpaceShipGame> {
  final lifeNumber = 5;
  final lifeArray = [];
  final gapSize = 5;

  @override
  Future<void> onLoad() async {
    createLifes();
  }

  void createLifes() {
    const gapSize = 6;
    for (var i = 0; i < lifeNumber; i++) {
       var xpos = (25 + gapSize) * i;
      _createLifeAt(xpos + 10, game.size.y - 10);
    }
  }

  void _createLifeAt(double x, double y) {
    final life = LifeComponent(position: Vector2(x, y));
    lifeArray.add(life);
    game.add(life);
  }

  void looseOneLife() {
    if (lifeArray.length > 0) {
      lifeArray.last.disappear();
      lifeArray.removeLast();
    } else {
      game.endGame();
    }
  }
}
