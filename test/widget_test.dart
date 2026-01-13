// Basic test for Card Flip Game
// TODO: Add proper widget tests when the game is complete

import 'package:flutter_test/flutter_test.dart';
import 'package:card_flip_game/models/theme_model.dart';
import 'package:card_flip_game/models/level_model.dart';

void main() {
  group('GameThemes', () {
    test('should have 10 themes', () {
      expect(GameThemes.all.length, equals(10));
    });

    test('each theme should have 10 levels', () {
      for (final theme in GameThemes.all) {
        expect(theme.levelCount, equals(10));
      }
    });

    test('getById should return correct theme', () {
      final theme = GameThemes.getById('paw_patrol');
      expect(theme.name, equals('汪汪队立大功'));
    });
  });

  group('LevelGenerator', () {
    test('should generate 100 levels', () {
      expect(LevelGenerator.totalLevels, equals(100));
    });

    test('first level should have 2 pairs', () {
      final level = LevelGenerator.getLevel(0);
      expect(level.pairs, equals(2));
    });

    test('last level should have more pairs', () {
      final level = LevelGenerator.getLevel(99);
      expect(level.pairs, greaterThan(2));
    });
  });
}
