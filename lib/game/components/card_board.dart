import 'dart:math';
import 'package:flame/components.dart';
import '../../models/card_data.dart';
import '../../models/level_model.dart';
import '../../models/theme_model.dart';
import '../../utils/constants.dart';
import '../card_flip_game.dart';
import 'card_component.dart';

class CardBoard extends PositionComponent with HasGameReference<CardFlipGame> {
  final LevelConfig levelConfig;
  final List<CardComponent> cards = [];
  final Random _random = Random();

  CardBoard({required this.levelConfig});

  @override
  Future<void> onLoad() async {
    await _createCards();
    _layoutCards();
    _playEntranceAnimation();
  }

  Future<void> _createCards() async {
    final theme = GameThemes.getById(levelConfig.themeId);
    final cardDataList = _generateCardData(theme);

    cardDataList.shuffle(_random);

    for (int i = 0; i < cardDataList.length; i++) {
      final cardData = cardDataList[i];
      final colorIndex = cardData.pairId % AppColors.cardColors.length;

      final card = CardComponent(
        cardData: cardData,
        cardColor: AppColors.cardColors[colorIndex],
        position: Vector2.zero(),
        size: Vector2(80, 100),
      );

      cards.add(card);
      add(card);
    }
  }

  List<CardData> _generateCardData(GameTheme theme) {
    final cardDataList = <CardData>[];
    int cardId = 0;

    for (int i = 0; i < levelConfig.pairs; i++) {
      final charIndex = levelConfig.characterIndices[i];
      final charName = theme.characters[charIndex];

      for (int j = 0; j < 2; j++) {
        cardDataList.add(CardData(
          id: cardId++,
          characterName: charName,
          characterIndex: charIndex,
          pairId: i,
        ));
      }
    }

    return cardDataList;
  }

  void _layoutCards() {
    final totalCards = cards.length;
    final columns = _getColumns(totalCards);
    final rows = (totalCards / columns).ceil();

    final screenWidth = game.size.x;
    final screenHeight = game.size.y;

    final availableWidth = screenWidth - 40;
    final availableHeight = screenHeight - 200;

    final cardWidth = (availableWidth - (columns - 1) * AppSizes.cardSpacing) / columns;
    final cardHeight = (availableHeight - (rows - 1) * AppSizes.cardSpacing) / rows;
    final cardSize = min(cardWidth, cardHeight);
    final finalCardSize = min(cardSize, 120.0);

    final totalWidth = columns * finalCardSize + (columns - 1) * AppSizes.cardSpacing;
    final totalHeight = rows * finalCardSize + (rows - 1) * AppSizes.cardSpacing;

    final startX = (screenWidth - totalWidth) / 2;
    final startY = (screenHeight - totalHeight) / 2 + 40;

    for (int i = 0; i < cards.length; i++) {
      final col = i % columns;
      final row = i ~/ columns;

      cards[i].position = Vector2(
        startX + col * (finalCardSize + AppSizes.cardSpacing),
        startY + row * (finalCardSize + AppSizes.cardSpacing),
      );
      cards[i].size = Vector2.all(finalCardSize);
    }
  }

  int _getColumns(int totalCards) {
    if (totalCards <= 4) return 2;
    if (totalCards <= 6) return 3;
    if (totalCards <= 9) return 3;
    if (totalCards <= 12) return 4;
    return 4;
  }

  void _playEntranceAnimation() {
    for (int i = 0; i < cards.length; i++) {
      cards[i].playEntranceAnimation(i);
    }
  }

  bool get allMatched => cards.every((card) => card.state == CardState.matched);
}
