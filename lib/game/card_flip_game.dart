import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../models/level_model.dart';
import '../models/theme_model.dart';
import 'components/card_board.dart';
import 'components/card_component.dart';
import 'effects/effects.dart';
import 'managers/audio_manager.dart';
import 'managers/game_manager.dart';

class CardFlipGame extends FlameGame {
  final int levelIndex;
  final VoidCallback onComplete;
  final VoidCallback onBack;

  late LevelConfig levelConfig;
  late GameTheme gameTheme;
  late GameManager gameManager;
  late AudioManager audioManager;
  CardBoard? cardBoard;

  final Random _random = Random();

  CardFlipGame({
    required this.levelIndex,
    required this.onComplete,
    required this.onBack,
  });

  @override
  Future<void> onLoad() async {
    levelConfig = LevelGenerator.getLevel(levelIndex);
    gameTheme = GameThemes.getById(levelConfig.themeId);

    audioManager = AudioManager.instance;
    gameManager = GameManager();
    add(gameManager);

    await _setupBackground();
    await _createCardBoard();

    gameManager.initialize(levelConfig.pairs);
  }

  Future<void> _setupBackground() async {
    final bg = RectangleComponent(
      size: size,
      paint: Paint()..color = gameTheme.color.withValues(alpha: 0.1),
    );
    add(bg);
  }

  Future<void> _createCardBoard() async {
    cardBoard = CardBoard(levelConfig: levelConfig);
    add(cardBoard!);
  }

  void onCardTapped(CardComponent card) {
    gameManager.onCardTapped(card);
  }

  void spawnStarBurst(Vector2 position) {
    add(StarBurstEffect(position: position));
  }

  void spawnHeartRain() {
    add(HeartRainEffect());
  }

  void showComboText(String text) {
    final position = Vector2(size.x / 2, size.y / 3);
    add(ComboTextEffect(position: position, text: text));
  }

  void onGameCompleted() {
    audioManager.playWin();
    _playCelebration();

    Future.delayed(const Duration(milliseconds: 2000), () {
      onComplete();
    });
  }

  void _playCelebration() {
    // Fireworks
    for (int i = 0; i < 5; i++) {
      Future.delayed(Duration(milliseconds: i * 300), () {
        if (isMounted) {
          final x = _random.nextDouble() * size.x;
          final y = _random.nextDouble() * size.y * 0.5 + 100;
          add(FireworkEffect(position: Vector2(x, y)));
        }
      });
    }

    // Confetti rain
    add(ConfettiEffect(count: 80));

    // Falling stars with rotation
    Future.delayed(const Duration(milliseconds: 300), () {
      if (isMounted) {
        add(FallingStarEffect(starCount: 12));
      }
    });

    // Trophy bounce in center
    Future.delayed(const Duration(milliseconds: 200), () {
      if (isMounted) {
        add(TrophyBounceEffect(position: Vector2(size.x / 2, size.y / 2 - 50)));
      }
    });

    // Balloons
    final balloonColors = [
      Colors.red,
      Colors.blue,
      Colors.yellow,
      Colors.green,
      Colors.pink,
      Colors.purple,
    ];

    for (int i = 0; i < 8; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (isMounted) {
          final x = (size.x / 9) * (i + 1);
          add(BalloonEffect(
            color: balloonColors[i % balloonColors.length],
            startX: x,
          ));
        }
      });
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      audioManager.playCheer();
    });
  }

  int get stars => gameManager.calculateStars();
  int get flipCount => gameManager.flipCount;
}
