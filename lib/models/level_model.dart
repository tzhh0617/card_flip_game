class LevelConfig {
  final int levelIndex;
  final String themeId;
  final int pairs;
  final List<int> characterIndices;

  const LevelConfig({
    required this.levelIndex,
    required this.themeId,
    required this.pairs,
    required this.characterIndices,
  });

  int get totalCards => pairs * 2;

  int get levelInTheme => levelIndex % 10 + 1;
}

class LevelGenerator {
  static List<LevelConfig> generateAllLevels() {
    final levels = <LevelConfig>[];
    final themeIds = [
      'paw_patrol',
      'peppa_pig',
      'bluey',
      'super_wings',
      'thomas',
      'boonie_bears',
      'robocar_poli',
      'my_little_pony',
      'pleasant_goat',
      'meng_ji',
    ];

    for (int t = 0; t < themeIds.length; t++) {
      for (int l = 0; l < 10; l++) {
        final levelIndex = t * 10 + l;
        final pairs = _getPairsForLevel(l);
        final characterIndices = _getCharacterIndices(pairs, l);

        levels.add(LevelConfig(
          levelIndex: levelIndex,
          themeId: themeIds[t],
          pairs: pairs,
          characterIndices: characterIndices,
        ));
      }
    }

    return levels;
  }

  static int _getPairsForLevel(int levelInTheme) {
    if (levelInTheme < 2) return 2;
    if (levelInTheme < 4) return 3;
    if (levelInTheme < 6) return 4;
    if (levelInTheme < 8) return 5;
    return 6;
  }

  static List<int> _getCharacterIndices(int pairs, int levelInTheme) {
    final indices = <int>[];
    final offset = (levelInTheme ~/ 2) % 4;
    for (int i = 0; i < pairs; i++) {
      indices.add((offset + i) % 8);
    }
    return indices;
  }

  static final List<LevelConfig> allLevels = generateAllLevels();

  static LevelConfig getLevel(int index) {
    if (index < 0 || index >= allLevels.length) {
      return allLevels.first;
    }
    return allLevels[index];
  }

  static int get totalLevels => 100;
}
