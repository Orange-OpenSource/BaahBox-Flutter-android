import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../constants/enums.dart';
import 'BBGame.dart';

class OverlayBuilder {
  OverlayBuilder._();

  static Widget preGame(BuildContext context, BBGame game) {
    return const PreGameOverlay();
  }

  static Widget postGame(BuildContext context, BBGame game) {
    assert(game.state == GameState.won || game.state == GameState.lost);
    final message = 'Game Over';
    return PostGameOverlay(message: message, game: game);
  }
}

class PreGameOverlay extends StatelessWidget {
  const PreGameOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
            "Jouer",
            style: TextStyle(color:
            Colors.white,
              fontSize: 24,)
        )
    );
  }
}

class PostGameOverlay extends StatelessWidget {

  final String message;
  final BBGame game;

  const PostGameOverlay({
    super.key,
    required this.message,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Text(
            message,
            style: const TextStyle(
              color: Colors.black38,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 24),
          _resetButton(context, game),
        ],
      ),
    );
  }

  Widget _resetButton(BuildContext context, BBGame game) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
          color: Colors.blue,
        ),
      ),
      onPressed: () => game.resetGame(),
      icon: const Icon(Icons.restart_alt_outlined),
      label: const Text('Replay'),
    );
  }
}

