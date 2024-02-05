import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../constants/enums.dart';
import 'BBGame.dart';

class OverlayBuilder {
  OverlayBuilder._();

  static Widget preGame(BuildContext context, BBGame game) {
    return PreGameOverlay(game: game);
  }
  static Widget instructions(BuildContext context, BBGame game) {
    return InstructionsOverlay(game: game);
  }
  static Widget feedback(BuildContext context, BBGame game) {
    return FeedbackOverlay(game: game);
  }

  static Widget postGame(BuildContext context, BBGame game) {
    assert(game.state == GameState.won || game.state == GameState.lost);
    final message = game.state == GameState.won ? 'Bravo !' : 'Perdu !';
    return PostGameOverlay(message: message, game: game);
  }
}

class PreGameOverlay extends StatelessWidget {

  final BBGame game;

  const PreGameOverlay({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          _startButton(context, game),
          const SizedBox(height: 35),
        ],
      ),
    );
  }

  Widget _startButton(BuildContext context, BBGame game) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
         // shape: const StadiumBorder(),
          side: const BorderSide(width: 1, color: Colors.white),
        ),
      child: const Text(' Jouer ', style: TextStyle(fontSize: 25, color: Colors.white) ),
      onPressed: () => game.startGame(),
    );
  }
}

class InstructionsOverlay extends StatelessWidget {
  final BBGame game;

  const InstructionsOverlay({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            game.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            game.subTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 90),
        ],
      ),
    );
  }
}
class FeedbackOverlay extends StatelessWidget {
  final BBGame game;

  const FeedbackOverlay({
    super.key,
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
            game.feedback,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
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
              color: Colors.white,
              fontSize: 40,
            ),
          ),
          const SizedBox(height: 35),
          _resetButton(context, game),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _resetButton(BuildContext context, BBGame game) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
          color: Colors.white,
        ),
      ),
      child: const Text(" Rejouer ", style: const TextStyle(
        color: Colors.white,
        fontSize: 25,
      )),
      onPressed: () => game.resetGame(),
    );
  }
}

