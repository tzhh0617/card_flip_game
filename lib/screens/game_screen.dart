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

    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: theme.color.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🎉 恭喜过关！🎉',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '🏆',
                style: TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 300 + i * 200),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Icon(
                          i < _stars ? Icons.star : Icons.star_border,
                          size: 48,
                          color: Colors.amber,
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
              Text(
                encouragement,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.color,
                ),
              ),
              const SizedBox(height: 24),
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
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _goToNextLevel,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('下一关'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.color,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
