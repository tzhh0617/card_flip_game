import 'package:flutter/material.dart';
import '../data/storage_service.dart';
import '../models/theme_model.dart';
import '../utils/constants.dart';
import 'level_select_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            Expanded(child: _buildThemeGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      child: Column(
        children: [
          Text(
            AppStrings.appTitle,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '选择你喜欢的动画',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: GameThemes.all.length,
      itemBuilder: (context, index) {
        return _buildThemeCard(GameThemes.all[index], index);
      },
    );
  }

  Widget _buildThemeCard(GameTheme theme, int index) {
    final startLevel = theme.startLevelIndex;
    final completedLevels = _getCompletedLevels(startLevel, theme.levelCount);
    final totalStars = _getTotalStars(startLevel, theme.levelCount);
    final isUnlocked = _storage?.isLevelUnlocked(startLevel) ?? (index == 0);

    return GestureDetector(
      onTap: () {
        if (isUnlocked) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LevelSelectScreen(theme: theme),
            ),
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isUnlocked ? theme.color : Colors.grey[300],
          borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
          boxShadow: [
            BoxShadow(
              color: (isUnlocked ? theme.color : Colors.grey).withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getThemeEmoji(index),
                    style: const TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    theme.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$completedLevels/${theme.levelCount} 关',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '$totalStars/${theme.levelCount * 3}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (!isUnlocked)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
                ),
                child: const Center(
                  child: Icon(
                    Icons.lock,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getThemeEmoji(int index) {
    const emojis = ['🐕', '🐷', '🐶', '🦁', '🚂', '🐻', '🤖', '🎀', '🐑', '🦖'];
    return emojis[index % emojis.length];
  }

  int _getCompletedLevels(int startLevel, int count) {
    if (_storage == null) return 0;
    int completed = 0;
    for (int i = 0; i < count; i++) {
      if (_storage!.getStars(startLevel + i) > 0) {
        completed++;
      }
    }
    return completed;
  }

  int _getTotalStars(int startLevel, int count) {
    if (_storage == null) return 0;
    int total = 0;
    for (int i = 0; i < count; i++) {
      total += _storage!.getStars(startLevel + i);
    }
    return total;
  }
}
