import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/hand_tracking_cubit.dart';
import 'finger_tracking_game.dart';

/// The main entry point of the application.
class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hand Tracking Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (_) => HandTrackingCubit(),
        child: const GameView(),
      ),
    );
  }
}

/// The main game view that displays the game.
class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Game());
  }
}

/// The game widget that initializes the FingerTrackingGame.
/// It uses the HandTrackingCubit provided by the BlocProvider.
class Game extends StatelessWidget {
  const Game({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: FingerTrackingGame(
        handTrackingCubit: context.read<HandTrackingCubit>(),
      ),
    );
  }
}
