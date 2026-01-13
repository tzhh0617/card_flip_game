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
  late RectangleComponent _cardBorder;
  late TextComponent _characterText;
  late CircleComponent _questionMark;

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
    // Card shadow (slightly offset)
    final shadow = RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.black.withValues(alpha: 0.2),
      position: Vector2(3, 3),
    );
    shadow.priority = -1;
    add(shadow);

    // Card background with rounded corners effect
    _cardBackground = RectangleComponent(
      size: size,
      paint: Paint()..color = AppColors.cardBack,
    );
    _cardBackground.priority = 0;
    add(_cardBackground);

    // Card border for depth
    _cardBorder = RectangleComponent(
      size: size,
      paint: Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    _cardBorder.priority = 1;
    add(_cardBorder);

    // Question mark circle for face-down state
    _questionMark = CircleComponent(
      radius: size.x * 0.25,
      paint: Paint()..color = Colors.white.withValues(alpha: 0.3),
      anchor: Anchor.center,
      position: size / 2,
    );
    _questionMark.priority = 2;
    add(_questionMark);

    // Character text
    _characterText = TextComponent(
      text: '?',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: size.x * 0.3,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [
            Shadow(
              color: Colors.black26,
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
    );
    _characterText.anchor = Anchor.center;
    _characterText.position = size / 2;
    _characterText.priority = 3;
    add(_characterText);

    _addBreathingAnimation();
    _addFloatingAnimation();
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

  void _addFloatingAnimation() {
    // Subtle up-down floating
    add(
      MoveByEffect(
        Vector2(0, -3),
        EffectController(
          duration: 2.0,
          reverseDuration: 2.0,
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
    const duration = 0.15;

    // First half: scale X to 0 (card flipping away)
    add(
      ScaleEffect.to(
        Vector2(0.0, 1.0),
        EffectController(duration: duration, curve: Curves.easeIn),
      ),
    );

    // Add slight rotation for 3D effect
    add(
      RotateEffect.by(
        0.1 * (toFaceUp ? 1 : -1),
        EffectController(duration: duration, curve: Curves.easeIn),
      ),
    );

    await Future.delayed(Duration(milliseconds: (duration * 1000).toInt()));

    _updateCardAppearance(toFaceUp);

    // Second half: scale X back to 1 (card flipping to face)
    add(
      ScaleEffect.to(
        Vector2(1.0, 1.0),
        EffectController(duration: duration, curve: Curves.easeOut),
      ),
    );

    // Reset rotation
    add(
      RotateEffect.to(
        0,
        EffectController(duration: duration, curve: Curves.easeOut),
      ),
    );

    await Future.delayed(Duration(milliseconds: (duration * 1000).toInt()));
  }

  void _updateCardAppearance(bool faceUp) {
    if (faceUp) {
      _cardBackground.paint.color = cardColor;
      _characterText.text = cardData.characterName;
      _questionMark.paint.color = Colors.white.withValues(alpha: 0.15);
      
      // Update text style for face-up
      _characterText.textRenderer = TextPaint(
        style: TextStyle(
          fontSize: size.x * 0.2,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [
            Shadow(
              color: Colors.black38,
              offset: Offset(1, 1),
              blurRadius: 3,
            ),
          ],
        ),
      );
    } else {
      _cardBackground.paint.color = AppColors.cardBack;
      _characterText.text = '?';
      _questionMark.paint.color = Colors.white.withValues(alpha: 0.3);
      
      // Reset text style for face-down
      _characterText.textRenderer = TextPaint(
        style: TextStyle(
          fontSize: size.x * 0.3,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [
            Shadow(
              color: Colors.black26,
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      );
    }
  }

  void setMatched() {
    _state = CardState.matched;
    _playMatchEffect();
  }

  void _playMatchEffect() {
    game.audioManager.playMatch();

    // Pop scale effect
    add(
      ScaleEffect.by(
        Vector2.all(1.2),
        EffectController(
          duration: 0.12,
          reverseDuration: 0.12,
          curve: Curves.easeOut,
        ),
      ),
    );

    // Glow effect - change border color
    _cardBorder.paint.color = Colors.yellow;
    _cardBorder.paint.strokeWidth = 4;

    // Color flash
    add(
      ColorEffect(
        Colors.white,
        EffectController(duration: 0.25),
        opacityFrom: 0.0,
        opacityTo: 0.6,
      ),
    );

    // Spawn star burst
    game.spawnStarBurst(position + size / 2);

    // Fade border glow after delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (isMounted) {
        _cardBorder.paint.color = Colors.amber.withValues(alpha: 0.5);
        _cardBorder.paint.strokeWidth = 2;
      }
    });
  }

  void playMismatchEffect() {
    game.audioManager.playMismatch();

    // Red flash
    add(
      ColorEffect(
        Colors.red,
        EffectController(duration: 0.15, reverseDuration: 0.15),
        opacityFrom: 0.0,
        opacityTo: 0.3,
      ),
    );

    // Shake effect
    add(
      SequenceEffect([
        MoveByEffect(
          Vector2(-10, 0),
          EffectController(duration: 0.04),
        ),
        MoveByEffect(
          Vector2(20, 0),
          EffectController(duration: 0.08),
        ),
        MoveByEffect(
          Vector2(-20, 0),
          EffectController(duration: 0.08),
        ),
        MoveByEffect(
          Vector2(20, 0),
          EffectController(duration: 0.08),
        ),
        MoveByEffect(
          Vector2(-10, 0),
          EffectController(duration: 0.04),
        ),
      ]),
    );
  }

  void playEntranceAnimation(int index) {
    final delay = index * 0.08;
    scale = Vector2.zero();
    angle = -0.2;

    // Scale in with elastic bounce
    add(
      ScaleEffect.to(
        Vector2.all(1.0),
        EffectController(
          startDelay: delay,
          duration: 0.4,
          curve: Curves.elasticOut,
        ),
      ),
    );

    // Rotate to normal
    add(
      RotateEffect.to(
        0,
        EffectController(
          startDelay: delay,
          duration: 0.3,
          curve: Curves.easeOut,
        ),
      ),
    );
  }
}
