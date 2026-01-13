import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../../models/card_data.dart';
import '../../utils/constants.dart';
import '../card_flip_game.dart';

class CardComponent extends PositionComponent
    with TapCallbacks, HasGameReference<CardFlipGame> {
  final CardData cardData;
  final Color cardColor;

  CardState _state = CardState.faceDown;
  bool _isAnimating = false;

  late RectangleComponent _cardBackground;
  late TextComponent _characterText;

  CardComponent({
    required this.cardData,
    required this.cardColor,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  CardState get state => _state;
  bool get isAnimating => _isAnimating;

  @override
  Future<void> onLoad() async {
    _cardBackground = RectangleComponent(
      size: size,
      paint: Paint()..color = AppColors.cardBack,
    );
    _cardBackground.priority = 0;
    add(_cardBackground);

    _characterText = TextComponent(
      text: '?',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
    _characterText.anchor = Anchor.center;
    _characterText.position = size / 2;
    _characterText.priority = 1;
    add(_characterText);

    _addBreathingAnimation();
  }

  void _addBreathingAnimation() {
    add(
      ScaleEffect.by(
        Vector2.all(1.02),
        EffectController(
          duration: 1.5,
          reverseDuration: 1.5,
          infinite: true,
          curve: Curves.easeInOut,
        ),
      ),
    );
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (_state == CardState.faceDown && !_isAnimating) {
      game.onCardTapped(this);
    }
  }

  Future<void> flip() async {
    if (_isAnimating || _state != CardState.faceDown) return;

    _isAnimating = true;
    _state = CardState.flipping;
    game.audioManager.playFlip();

    await _animateFlip(true);

    _state = CardState.faceUp;
    _isAnimating = false;
  }

  Future<void> flipBack() async {
    if (_isAnimating || _state != CardState.faceUp) return;

    _isAnimating = true;
    _state = CardState.flipping;

    await _animateFlip(false);

    _state = CardState.faceDown;
    _isAnimating = false;
  }

  Future<void> _animateFlip(bool toFaceUp) async {
    const duration = 0.2;

    add(
      ScaleEffect.to(
        Vector2(0.0, 1.0),
        EffectController(duration: duration, curve: Curves.easeIn),
      ),
    );

    await Future.delayed(Duration(milliseconds: (duration * 1000).toInt()));

    _updateCardAppearance(toFaceUp);

    add(
      ScaleEffect.to(
        Vector2(1.0, 1.0),
        EffectController(duration: duration, curve: Curves.easeOut),
      ),
    );

    await Future.delayed(Duration(milliseconds: (duration * 1000).toInt()));
  }

  void _updateCardAppearance(bool faceUp) {
    if (faceUp) {
      _cardBackground.paint.color = cardColor;
      _characterText.text = cardData.characterName;
    } else {
      _cardBackground.paint.color = AppColors.cardBack;
      _characterText.text = '?';
    }
  }

  void setMatched() {
    _state = CardState.matched;
    _playMatchEffect();
  }

  void _playMatchEffect() {
    game.audioManager.playMatch();

    add(
      ScaleEffect.by(
        Vector2.all(1.15),
        EffectController(
          duration: 0.15,
          reverseDuration: 0.15,
          curve: Curves.easeOut,
        ),
      ),
    );

    add(
      ColorEffect(
        Colors.white,
        EffectController(duration: 0.3),
        opacityFrom: 0.0,
        opacityTo: 0.5,
      ),
    );

    game.spawnStarBurst(position + size / 2);
  }

  void playMismatchEffect() {
    game.audioManager.playMismatch();

    add(
      SequenceEffect([
        MoveByEffect(
          Vector2(-8, 0),
          EffectController(duration: 0.05),
        ),
        MoveByEffect(
          Vector2(16, 0),
          EffectController(duration: 0.1),
        ),
        MoveByEffect(
          Vector2(-16, 0),
          EffectController(duration: 0.1),
        ),
        MoveByEffect(
          Vector2(8, 0),
          EffectController(duration: 0.05),
        ),
      ]),
    );
  }

  void playEntranceAnimation(int index) {
    final delay = index * 0.1;
    scale = Vector2.zero();

    add(
      ScaleEffect.to(
        Vector2.all(1.0),
        EffectController(
          startDelay: delay,
          duration: 0.3,
          curve: Curves.elasticOut,
        ),
      ),
    );
  }
}
