import 'package:flutter/material.dart';
import '../data/storage_service.dart';
import '../models/theme_model.dart';
import '../utils/constants.dart';
import 'game_screen.dart';

class LevelSelectScreen extends StatefulWidget {
  final GameTheme theme;

  const LevelSelectScreen({super.key, required this.theme});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  StorageService? _storage;

  @override
  void initState() {
    super.initState();
    _initStorage();
  }

  Future<void> _initStorage() async {
    _storage = await StorageService.getInstance();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildLevelGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, size: 28),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.theme.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: widget.theme.color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '选择关卡',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: widget.theme.levelCount,
      itemBuilder: (context, index) {
        return _buildLevelButton(index);
      },
    );
  }

  Widget _buildLevelButton(int levelInTheme) {
    final levelIndex = widget.theme.startLevelIndex + levelInTheme;
    final isUnlocked = _storage?.isLevelUnlocked(levelIndex) ?? (levelIndex == 0);
    final stars = _storage?.getStars(levelIndex) ?? 0;

    return GestureDetector(
      onTap: () {
        if (isUnlocked) {
          _navigateToGame(levelIndex);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isUnlocked ? widget.theme.color : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: widget.theme.color.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isUnlocked)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${levelInTheme + 1}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      return Icon(
                        i < stars ? Icons.star : Icons.star_border,
                        size: 12,
                        color: Colors.amber,
                      );
                    }),
                  ),
                ],
              )
            else
              const Icon(
                Icons.lock,
                color: Colors.white,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }

  void _navigateToGame(int levelIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          levelIndex: levelIndex,
          onComplete: (stars) {
            setState(() {});
          },
        ),
      ),
    ).then((_) {
      _initStorage();
    });
  }
}
