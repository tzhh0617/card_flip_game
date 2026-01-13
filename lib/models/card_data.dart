class CardData {
  final int id;
  final String characterName;
  final int characterIndex;
  final int pairId;

  CardData({
    required this.id,
    required this.characterName,
    required this.characterIndex,
    required this.pairId,
  });

  bool matches(CardData other) => pairId == other.pairId && id != other.id;
}

enum CardState {
  faceDown,
  flipping,
  faceUp,
  matched,
}
