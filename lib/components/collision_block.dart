import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Composant qui représente un bloc de collision invisible.
/// En mode debug, les collisions sont visibles avec des couleurs différentes.
class CollisionBlock extends PositionComponent {
  /// Si vrai, ce bloc est une plateforme que le joueur peut traverser par le bas.
  bool isPlatform;

  /// Couleur pour le mode debug
  final Color _debugPlatformColor = Colors.green.withOpacity(0.5);
  final Color _debugSolidColor = Colors.red.withOpacity(0.5);

  /// Crée un nouveau bloc de collision.
  ///
  /// [position]: Position du bloc dans le monde.
  /// [size]: Dimensions du bloc.
  /// [isPlatform]: Si le bloc est une plateforme traversable.
  CollisionBlock({
    super.position,
    super.size,
    this.isPlatform = false,
  }) {
    // Active le mode debug si on est en mode développement
    debugMode = kDebugMode;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Dessine le rectangle de collision en mode debug
    if (debugMode) {
      final paint = Paint()
        ..color = isPlatform ? _debugPlatformColor : _debugSolidColor
        ..style = PaintingStyle.fill
        ..strokeWidth = 2.0;

      // Dessine le rectangle rempli
      canvas.drawRect(size.toRect(), paint);

      // Dessine le contour
      final borderPaint = Paint()
        ..color = isPlatform ? Colors.green : Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawRect(size.toRect(), borderPaint);

      // Ajoute un texte pour identifier le type
      if (size.x > 30 && size.y > 30) {
        // Seulement si assez grand
        final textPainter = TextPainter(
          text: TextSpan(
            text: isPlatform ? 'Platform' : 'Solid',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        final textX = size.x / 2 - textPainter.width / 2;
        final textY = size.y / 2 - textPainter.height / 2;

        textPainter.paint(canvas, Offset(textX, textY));
      }
    }
  }

  @override
  void onMount() {
    super.onMount();
    if (kDebugMode) {
      print(
          'CollisionBlock ${isPlatform ? '(Platform)' : '(Solid)'} loaded at: '
          '(${position.x}, ${position.y}) size: (${size.x}, ${size.y})');
    }
  }
}
