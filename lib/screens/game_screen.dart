import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../data/storage_service.dart';
import '../game/card_flip_game.dart';
import '../models/level_model.dart';
import '../models/theme_model.dart';
import '../utils/constants.dart';

class GameScreen extends StatefulWidget {
  final int levelIndex;
  final Function(int stars) onComplete;

  const GameScreen({
    super.key,
    required this.levelIndex,
    required this.onComplete,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  CardFlipGame? _game;
  bool _showCelebration = false;
  int _stars = 0;
  int _flipCount = 0;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    _game = CardFlipGame(
      levelIndex: widget.levelIndex,
      onComplete: _onGameComplete,
      onBack: () => Navigator.pop(context),
    );
  }

  Future<void> _onGameComplete() async {
    final stars = _game!.stars;
    final flipCount = _game!.flipCount;

    final storage = await StorageService.getInstance();
    await storage.completeLevel(widget.levelIndex, stars);

    setState(() {
      _showCelebration = true;
      _stars = stars;
      _flipCount = flipCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final levelConfig = LevelGenerator.getLevel(widget.levelIndex);
    final theme = GameThemes.getById(levelConfig.themeId);

    return Scaffold(
      body: Stack(
        children: [
          if (_game != null)
            GameWidget(game: _game!),
          _buildTopBar(theme, levelConfig),
          if (_showCelebration)
            _buildCelebrationOverlay(theme, levelConfig),
        ],
      ),
    );
  }

  Widget _buildTopBar(GameTheme theme, LevelConfig levelConfig) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.9),
                padding: const EdgeInsets.all(12),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${theme.name} - 第 ${levelConfig.levelInTheme} 关',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCelebrationOverlay(GameTheme theme, LevelConfig levelConfig) {
    final encouragement = AppStrings.encouragements[
        widget.levelIndex % AppStrings.encouragements.length];

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (context, opacity, child) {
        return Container(
          color: Colors.black.withValues(alpha: 0.7 * opacity),
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 500),
              curve: Curves.elasticOut,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: theme.color.withValues(alpha: 0.4),
                      blurRadius: 25,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated title
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.bounceOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: const Text(
                            '🎉 恭喜过关！🎉',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Bouncing trophy
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, (1 - value) * -50),
                          child: Transform.scale(
                            scale: value,
                            child: const Text(
                              '🏆',
                              style: TextStyle(fontSize: 72),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Animated stars
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (i) {
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: Duration(milliseconds: 400 + i * 200),
                          curve: Curves.elasticOut,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Transform.rotate(
                                angle: (1 - value) * 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Icon(
                                    i < _stars ? Icons.star : Icons.star_border,
                                    size: 52,
                                    color: i < _stars ? Colors.amber : Colors.grey.shade300,
                                    shadows: i < _stars
                                        ? [
                                            Shadow(
                                              color: Colors.amber.withValues(alpha: 0.5),
                                              blurRadius: 10,
                                            ),
                                          ]
                                        : null,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '翻牌次数: $_flipCount',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Animated encouragement
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, (1 - value) * 20),
                            child: Text(
                              encouragement,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: theme.color,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _showCelebration = false;
                              _initGame();
                            });
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('再玩一次'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _goToNextLevel,
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('下一关'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.color,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _goToNextLevel() {
    final nextLevel = widget.levelIndex + 1;
    if (nextLevel >= LevelGenerator.totalLevels) {
      Navigator.pop(context);
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          levelIndex: nextLevel,
          onComplete: widget.onComplete,
        ),
      ),
    );
  }
}
