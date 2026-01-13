import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../card_flip_game.dart';

class StarBurstEffect extends PositionComponent with HasGameReference<CardFlipGame> {
  final int starCount;
  final Random _random = Random();

  StarBurstEffect({
    required Vector2 position,
    this.starCount = 8,
  }) : super(position: position);

  @override
  Future<void> onLoad() async {
    for (int i = 0; i < starCount; i++) {
      final star = _createStar(i);
      add(star);
    }
  }

  PositionComponent _createStar(int index) {
    final angle = (2 * pi / starCount) * index;
    final distance = 50.0 + _random.nextDouble() * 30;
    final starSize = 10.0 + _random.nextDouble() * 6;

    final star = StarComponent(
      points: 5,
      innerRadius: starSize * 0.4,
      outerRadius: starSize,
      paint: Paint()..color = _getStarColor(index),
      anchor: Anchor.center,
    );

    star.add(
      MoveByEffect(
        Vector2(cos(angle) * distance, sin(angle) * distance),
        EffectController(
          duration: 0.5,
          curve: Curves.easeOut,
        ),
      ),
    );

    star.add(
      RotateEffect.by(
        pi * 2,
        EffectController(duration: 0.5),
      ),
    );

    star.add(
      ScaleEffect.to(
        Vector2.zero(),
        EffectController(
          startDelay: 0.3,
          duration: 0.2,
        ),
      ),
    );

    star.add(
      RemoveEffect(delay: 0.6),
    );

    return star;
  }

  Color _getStarColor(int index) {
    final colors = [
      Colors.yellow,
      Colors.orange,
      Colors.pink,
      Colors.cyan,
      Colors.lightGreen,
      Colors.purple,
      Colors.amber,
      Colors.red,
    ];
    return colors[index % colors.length];
  }

  @override
  void onMount() {
    super.onMount();
    Future.delayed(const Duration(milliseconds: 700), () {
      removeFromParent();
    });
  }
}

/// Custom 5-point star component
class StarComponent extends PositionComponent {
  final int points;
  final double innerRadius;
  final double outerRadius;
  final Paint paint;

  StarComponent({
    this.points = 5,
    required this.innerRadius,
    required this.outerRadius,
    required this.paint,
    super.anchor,
  }) : super(size: Vector2.all(outerRadius * 2));

  @override
  void render(Canvas canvas) {
    final path = _createStarPath();
    canvas.drawPath(path, paint);
  }

  Path _createStarPath() {
    final path = Path();
    final centerX = outerRadius;
    final centerY = outerRadius;
    final angleStep = pi / points;

    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = i * angleStep - pi / 2;
      final x = centerX + radius * cos(angle);
      final y = centerY + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }
}

class HeartRainEffect extends PositionComponent with HasGameReference<CardFlipGame> {
  final int heartCount;
  final Random _random = Random();

  HeartRainEffect({this.heartCount = 20});

  @override
  Future<void> onLoad() async {
    for (int i = 0; i < heartCount; i++) {
      Future.delayed(Duration(milliseconds: i * 50), () {
        if (isMounted) {
          add(_createHeart());
        }
      });
    }
  }

  PositionComponent _createHeart() {
    final screenWidth = game.size.x;
    final startX = _random.nextDouble() * screenWidth;
    final heartSize = 12.0 + _random.nextDouble() * 12;

    final heart = HeartComponent(
      size: heartSize,
      color: _getHeartColor(),
      position: Vector2(startX, -20),
      anchor: Anchor.center,
    );

    final duration = 2.0 + _random.nextDouble() * 1.0;
    final endY = game.size.y + 50;

    heart.add(
      MoveToEffect(
        Vector2(startX + (_random.nextDouble() - 0.5) * 100, endY),
        EffectController(
          duration: duration,
          curve: Curves.easeIn,
        ),
      ),
    );

    heart.add(
      RotateEffect.by(
        pi * 0.5 * (_random.nextBool() ? 1 : -1),
        EffectController(duration: duration),
      ),
    );

    // Scale pulsing
    heart.add(
      ScaleEffect.by(
        Vector2.all(1.2),
        EffectController(
          duration: 0.3,
          reverseDuration: 0.3,
          infinite: true,
        ),
      ),
    );

    heart.add(RemoveEffect(delay: duration));

    return heart;
  }

  Color _getHeartColor() {
    final colors = [
      Colors.pink,
      Colors.red,
      Colors.pinkAccent,
      Colors.redAccent,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  void onMount() {
    super.onMount();
    Future.delayed(const Duration(seconds: 3), () {
      removeFromParent();
    });
  }
}

/// Custom heart shape component
class HeartComponent extends PositionComponent {
  final double heartSize;
  final Color color;

  HeartComponent({
    required double size,
    required this.color,
    super.position,
    super.anchor,
  }) : heartSize = size, super(size: Vector2.all(size));

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = color;
    final path = _createHeartPath();
    canvas.drawPath(path, paint);
  }

  Path _createHeartPath() {
    final path = Path();
    final width = heartSize;
    final height = heartSize;

    path.moveTo(width / 2, height * 0.35);

    // Left curve
    path.cubicTo(
      width * 0.15, height * 0.0,
      width * -0.1, height * 0.5,
      width / 2, height,
    );

    // Right curve
    path.moveTo(width / 2, height * 0.35);
    path.cubicTo(
      width * 0.85, height * 0.0,
      width * 1.1, height * 0.5,
      width / 2, height,
    );

    return path;
  }
}

class ComboTextEffect extends PositionComponent {
  final String text;
  late TextComponent _textComponent;

  ComboTextEffect({
    required Vector2 position,
    required this.text,
  }) : super(position: position);

  @override
  Future<void> onLoad() async {
    _textComponent = TextComponent(
      text: text,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
          shadows: [
            Shadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
      ),
      anchor: Anchor.center,
    );
    add(_textComponent);

    add(
      MoveByEffect(
        Vector2(0, -50),
        EffectController(
          duration: 0.8,
          curve: Curves.easeOut,
        ),
      ),
    );

    add(
      ScaleEffect.by(
        Vector2.all(1.3),
        EffectController(
          duration: 0.2,
          reverseDuration: 0.2,
        ),
      ),
    );

    add(
      OpacityEffect.fadeOut(
        EffectController(
          startDelay: 0.5,
          duration: 0.3,
        ),
      ),
    );

    add(RemoveEffect(delay: 1.0));
  }
}

class FireworkEffect extends PositionComponent with HasGameReference<CardFlipGame> {
  final Random _random = Random();
  final int particleCount;

  FireworkEffect({
    required Vector2 position,
    this.particleCount = 30,
  }) : super(position: position);

  @override
  Future<void> onLoad() async {
    for (int i = 0; i < particleCount; i++) {
      final particle = _createParticle();
      add(particle);
    }
  }

  PositionComponent _createParticle() {
    final angle = _random.nextDouble() * 2 * pi;
    final speed = 80.0 + _random.nextDouble() * 120;
    final size = 4.0 + _random.nextDouble() * 6;

    final colors = [
      Colors.red,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.cyan,
    ];

    final particle = CircleComponent(
      radius: size,
      paint: Paint()..color = colors[_random.nextInt(colors.length)],
      anchor: Anchor.center,
    );

    final duration = 0.8 + _random.nextDouble() * 0.4;

    particle.add(
      MoveByEffect(
        Vector2(cos(angle) * speed, sin(angle) * speed + 50),
        EffectController(
          duration: duration,
          curve: Curves.easeOut,
        ),
      ),
    );

    particle.add(
      ScaleEffect.to(
        Vector2.zero(),
        EffectController(
          startDelay: duration * 0.6,
          duration: duration * 0.4,
        ),
      ),
    );

    particle.add(RemoveEffect(delay: duration));

    return particle;
  }

  @override
  void onMount() {
    super.onMount();
    Future.delayed(const Duration(milliseconds: 1200), () {
      removeFromParent();
    });
  }
}

class BalloonEffect extends PositionComponent with HasGameReference<CardFlipGame> {
  final Color color;
  final double startX;
  final Random _random = Random();

  BalloonEffect({
    required this.color,
    required this.startX,
  });

  @override
  Future<void> onLoad() async {
    final screenHeight = game.size.y;
    position = Vector2(startX, screenHeight + 50);

    // Balloon body with gradient effect
    final balloon = CircleComponent(
      radius: 25,
      paint: Paint()..color = color,
      anchor: Anchor.center,
    );
    add(balloon);

    // Balloon highlight (shine effect)
    final highlight = CircleComponent(
      radius: 8,
      paint: Paint()..color = Colors.white.withValues(alpha: 0.4),
      anchor: Anchor.center,
      position: Vector2(-8, -8),
    );
    balloon.add(highlight);

    // Balloon knot
    final knot = CircleComponent(
      radius: 4,
      paint: Paint()..color = color.withValues(alpha: 0.8),
      anchor: Anchor.center,
      position: Vector2(0, 25),
    );
    add(knot);

    // Balloon string (curvy)
    final string = RectangleComponent(
      size: Vector2(2, 35),
      paint: Paint()..color = Colors.grey.shade600,
      anchor: Anchor.topCenter,
      position: Vector2(0, 29),
    );
    add(string);

    final duration = 3.5 + _random.nextDouble() * 2.0;
    final wobbleAmount = 40.0 + _random.nextDouble() * 30;

    // Main upward movement
    add(
      MoveToEffect(
        Vector2(startX, -100),
        EffectController(
          duration: duration,
          curve: Curves.easeOut,
        ),
      ),
    );

    // Side-to-side wobble
    add(
      MoveByEffect(
        Vector2(wobbleAmount, 0),
        EffectController(
          duration: 0.8,
          reverseDuration: 0.8,
          infinite: true,
          curve: Curves.easeInOut,
          startDelay: _random.nextDouble() * 0.5,
        ),
      ),
    );

    // Gentle rotation wobble
    add(
      RotateEffect.by(
        0.15,
        EffectController(
          duration: 0.6,
          reverseDuration: 0.6,
          infinite: true,
          curve: Curves.easeInOut,
        ),
      ),
    );

    add(RemoveEffect(delay: duration));
  }
}

class ConfettiEffect extends PositionComponent with HasGameReference<CardFlipGame> {
  final int count;
  final Random _random = Random();

  ConfettiEffect({this.count = 50});

  @override
  Future<void> onLoad() async {
    final screenWidth = game.size.x;

    for (int i = 0; i < count; i++) {
      Future.delayed(Duration(milliseconds: _random.nextInt(500)), () {
        if (isMounted) {
          add(_createConfetti(screenWidth));
        }
      });
    }
  }

  PositionComponent _createConfetti(double screenWidth) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
    ];

    final confetti = RectangleComponent(
      size: Vector2(8 + _random.nextDouble() * 8, 4 + _random.nextDouble() * 4),
      paint: Paint()..color = colors[_random.nextInt(colors.length)],
      position: Vector2(_random.nextDouble() * screenWidth, -20),
      anchor: Anchor.center,
    );

    final duration = 2.0 + _random.nextDouble() * 2.0;
    final endY = game.size.y + 50;

    confetti.add(
      MoveToEffect(
        Vector2(
          confetti.position.x + (_random.nextDouble() - 0.5) * 100,
          endY,
        ),
        EffectController(
          duration: duration,
          curve: Curves.easeIn,
        ),
      ),
    );

    confetti.add(
      RotateEffect.by(
        pi * 4 * (_random.nextBool() ? 1 : -1),
        EffectController(duration: duration),
      ),
    );

    confetti.add(RemoveEffect(delay: duration));

    return confetti;
  }

  @override
  void onMount() {
    super.onMount();
    Future.delayed(const Duration(seconds: 4), () {
      removeFromParent();
    });
  }
}

/// Trophy bounce animation effect for celebration
class TrophyBounceEffect extends PositionComponent with HasGameReference<CardFlipGame> {
  final int bounceCount;
  
  TrophyBounceEffect({
    required Vector2 position,
    this.bounceCount = 3,
  }) : super(position: position, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // Create trophy using shapes (🏆 emoji alternative)
    final cup = _createTrophyCup();
    add(cup);

    // Bounce animation
    for (int i = 0; i < bounceCount; i++) {
      final delay = i * 0.4;
      final bounceHeight = 30.0 * (1 - i * 0.2);
      
      add(
        SequenceEffect([
          MoveByEffect(
            Vector2(0, -bounceHeight),
            EffectController(
              startDelay: delay,
              duration: 0.15,
              curve: Curves.easeOut,
            ),
          ),
          MoveByEffect(
            Vector2(0, bounceHeight),
            EffectController(
              duration: 0.15,
              curve: Curves.easeIn,
            ),
          ),
        ]),
      );
    }

    // Scale pulse effect
    add(
      ScaleEffect.by(
        Vector2.all(1.2),
        EffectController(
          duration: 0.3,
          reverseDuration: 0.3,
          repeatCount: 2,
        ),
      ),
    );

    // Auto remove
    add(RemoveEffect(delay: 2.0));
  }

  PositionComponent _createTrophyCup() {
    final container = PositionComponent(anchor: Anchor.center);

    // Trophy cup body (golden rectangle with rounded look)
    final cupBody = RectangleComponent(
      size: Vector2(40, 35),
      paint: Paint()..color = Colors.amber,
      anchor: Anchor.bottomCenter,
      position: Vector2(0, 0),
    );
    container.add(cupBody);

    // Trophy base
    final base = RectangleComponent(
      size: Vector2(50, 8),
      paint: Paint()..color = Colors.amber.shade700,
      anchor: Anchor.topCenter,
      position: Vector2(0, 5),
    );
    container.add(base);

    // Trophy stem
    final stem = RectangleComponent(
      size: Vector2(12, 15),
      paint: Paint()..color = Colors.amber.shade600,
      anchor: Anchor.topCenter,
      position: Vector2(0, 0),
    );
    container.add(stem);

    // Left handle
    final leftHandle = CircleComponent(
      radius: 8,
      paint: Paint()
        ..color = Colors.amber
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
      anchor: Anchor.centerRight,
      position: Vector2(-20, -20),
    );
    container.add(leftHandle);

    // Right handle
    final rightHandle = CircleComponent(
      radius: 8,
      paint: Paint()
        ..color = Colors.amber
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
      anchor: Anchor.centerLeft,
      position: Vector2(20, -20),
    );
    container.add(rightHandle);

    return container;
  }
}

/// Falling star with rotation effect
class FallingStarEffect extends PositionComponent with HasGameReference<CardFlipGame> {
  final int starCount;
  final Random _random = Random();

  FallingStarEffect({this.starCount = 15});

  @override
  Future<void> onLoad() async {
    for (int i = 0; i < starCount; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (isMounted) {
          add(_createFallingStar());
        }
      });
    }
  }

  PositionComponent _createFallingStar() {
    final screenWidth = game.size.x;
    final startX = _random.nextDouble() * screenWidth;
    final starSize = 12.0 + _random.nextDouble() * 12;

    // Use proper 5-point star
    final star = StarComponent(
      points: 5,
      innerRadius: starSize * 0.4,
      outerRadius: starSize,
      paint: Paint()..color = _getStarColor(),
      anchor: Anchor.center,
    );
    star.position = Vector2(startX, -30);

    final duration = 2.0 + _random.nextDouble() * 1.5;
    final endY = game.size.y + 50;
    final wobbleX = (_random.nextDouble() - 0.5) * 150;

    // Fall down with wobble
    star.add(
      MoveToEffect(
        Vector2(startX + wobbleX, endY),
        EffectController(
          duration: duration,
          curve: Curves.easeIn,
        ),
      ),
    );

    // Continuous rotation while falling
    star.add(
      RotateEffect.by(
        pi * 4 * (_random.nextBool() ? 1 : -1),
        EffectController(duration: duration),
      ),
    );

    // Slight scale pulsing
    star.add(
      ScaleEffect.by(
        Vector2.all(1.2),
        EffectController(
          duration: 0.25,
          reverseDuration: 0.25,
          infinite: true,
        ),
      ),
    );

    star.add(RemoveEffect(delay: duration));

    return star;
  }

  Color _getStarColor() {
    final colors = [
      Colors.amber,
      Colors.yellow,
      Colors.orange,
      Colors.amber.shade300,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  void onMount() {
    super.onMount();
    Future.delayed(const Duration(seconds: 4), () {
      removeFromParent();
    });
  }
}
