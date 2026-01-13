import 'package:flame/components.dart';
import '../card_flip_game.dart';
import '../components/card_component.dart';
import '../../models/card_data.dart';
import '../../utils/constants.dart';

enum GameState {
  loading,
  ready,
  oneCardOpen,
  twoCardsOpen,
  locked,
  completed,
}

class GameManager extends Component with HasGameReference<CardFlipGame> {
  GameState _state = GameState.loading;
  CardComponent? _firstCard;
  CardComponent? _secondCard;
  int _flipCount = 0;
  int _matchedPairs = 0;
  int _comboCount = 0;
  int _totalPairs = 0;

  GameState get state => _state;
  int get flipCount => _flipCount;
  int get matchedPairs => _matchedPairs;
  int get totalPairs => _totalPairs;

  void initialize(int totalPairs) {
    _totalPairs = totalPairs;
    _flipCount = 0;
    _matchedPairs = 0;
    _comboCount = 0;
    _state = GameState.ready;
  }

  bool canTapCard() {
    return _state == GameState.ready || _state == GameState.oneCardOpen;
  }

  Future<void> onCardTapped(CardComponent card) async {
    if (!canTapCard()) return;
    if (card.state != CardState.faceDown) return;

    _flipCount++;

    if (_state == GameState.ready) {
      _firstCard = card;
      await card.flip();
      _state = GameState.oneCardOpen;
    } else if (_state == GameState.oneCardOpen) {
      _secondCard = card;
      _state = GameState.locked;
      await card.flip();
      await _checkMatch();
    }
  }

  Future<void> _checkMatch() async {
    if (_firstCard == null || _secondCard == null) return;

    await Future.delayed(const Duration(milliseconds: 300));

    if (_firstCard!.cardData.matches(_secondCard!.cardData)) {
      _onMatch();
    } else {
      await _onMismatch();
    }
  }

  void _onMatch() {
    _firstCard!.setMatched();
    _secondCard!.setMatched();
    _matchedPairs++;
    _comboCount++;

    if (_comboCount >= 2) {
      final comboIndex = (_comboCount - 2).clamp(0, AppStrings.comboTexts.length - 1);
      game.showComboText(AppStrings.comboTexts[comboIndex]);
      game.audioManager.playCombo();
    }

    if (_comboCount >= 3) {
      game.spawnHeartRain();
    }

    _firstCard = null;
    _secondCard = null;

    if (_matchedPairs >= _totalPairs) {
      _state = GameState.completed;
      game.onGameCompleted();
    } else {
      _state = GameState.ready;
    }
  }

  Future<void> _onMismatch() async {
    _comboCount = 0;

    _firstCard!.playMismatchEffect();
    _secondCard!.playMismatchEffect();

    await Future.delayed(const Duration(milliseconds: 600));

    await Future.wait([
      _firstCard!.flipBack(),
      _secondCard!.flipBack(),
    ]);

    _firstCard = null;
    _secondCard = null;
    _state = GameState.ready;
  }

  void reset() {
    _state = GameState.loading;
    _firstCard = null;
    _secondCard = null;
    _flipCount = 0;
    _matchedPairs = 0;
    _comboCount = 0;
  }

  int calculateStars() {
    final perfectFlips = _totalPairs * 2;
    final goodFlips = _totalPairs * 3;

    if (_flipCount <= perfectFlips) return 3;
    if (_flipCount <= goodFlips) return 2;
    return 1;
  }
}
