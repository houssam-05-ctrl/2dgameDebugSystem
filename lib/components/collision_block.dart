import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

//we define les blocs de collisions importe depuis notre tiled
class CollisionBlock extends PositionComponent {
  /// si c est une platforme il peut traverser dessus ( pas une collision )
  bool isPlatform;

  /// choix de couleur
  final Color _debugPlatformColor = Colors.green.withOpacity(0.5);
  final Color _debugSolidColor = Colors.red.withOpacity(0.5);

  /// Crée un nouveau bloc de collision.
  ///
  /// [position]: position du bloc in our world
  /// [size]: dimen du bloc
  CollisionBlock({
    super.position,
    super.size,
    this.isPlatform = false,
  }) {
    // active le mode debug si on est en mode développement
    debugMode = kDebugMode;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // dessine le rectangle de collision en mode debug
    if (debugMode) {
      final paint = Paint()
        ..color = isPlatform ? _debugPlatformColor : _debugSolidColor
        ..style = PaintingStyle.fill
        ..strokeWidth = 2.0;

      // dessine le rectangle rempli
      canvas.drawRect(size.toRect(), paint);

      // Dessine le contour
      final borderPaint = Paint()
        ..color = isPlatform ? Colors.green : Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawRect(size.toRect(), borderPaint);

      // ajoute un texte pour identifier le type
      if (size.x > 30 && size.y > 30) {
        // seul si c grand
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
