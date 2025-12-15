#Project Overview

Pixel Adventure is a 2D platformer game built with Flutter and Flame engine. This debug system provides comprehensive tools for developing, testing, and optimizing game mechanics, particularly focusing on collision detection and physics simulation.

#Debug System Features

#Automatic Debug Detection

The debug system activates automatically when running in development mode (kDebugMode = true). No configuration needed - it just works out of the box.

Visual Collision Debugging

Solid blocks appear as semi-transparent red rectangles
Platforms (passable from below) appear as semi-transparent green rectangles
Player hitbox shows as a blue outline
Text labels indicate block types ("Solid" or "Platform")
Console Logging

#Real-time logging provides insights into:

Player position and velocity
Collision block creation and properties
Input system status (joystick/keyboard)
Physics calculations
Performance metrics
Physics Debugging

#Monitor and adjust:

Gravity force application
Jump mechanics
Velocity clamping
Collision response
Terminal velocity limits
Implementation Details

#File Structure

text
lib/
├── components/
│   ├── collision_block.dart  # Enhanced with debug rendering
│   ├── player.dart          # Player physics and debug
│   ├── utils.dart           # Collision detection utilities
│   └── level.dart           # Level loading with debug info
├── pixel_adventure.dart     # Main game class
└── main.dart               # App entry point
Core Debug Components

1. CollisionBlock Debug Rendering

dart
class CollisionBlock extends PositionComponent {
  // Debug visualization automatically activates in development
  debugMode = kDebugMode; // Set automatically
  
  @override
  void render(Canvas canvas) {
    if (debugMode) {
      // Draw colored rectangles based on block type
      final color = isPlatform ? Colors.green : Colors.red;
      final paint = Paint()..color = color.withOpacity(0.5);
      canvas.drawRect(size.toRect(), paint);
    }
  }
}
2. Player Physics Debugging

dart
class Player extends SpriteAnimationGroupComponent<PlayerState> {
  @override
  void update(double dt) {
    if (kDebugMode) {
      // Log physics state each frame
      print('Player - Position: (${position.x}, ${position.y})');
      print('Player - Velocity: (${velocity.x}, ${velocity.y})');
      print('Player - On Ground: $isOnGround');
    }
  }
}
3. Input System Debugging

dart
void updateJoystick() {
  if (kDebugMode) {
    print('Joystick - Direction: ${joystick.direction}');
    print('Joystick - Delta: ${joystick.delta}');
    print('Player Movement: $horizontalMovement');
  }
}
Getting Started

Prerequisites

Flutter SDK (latest stable)
Flame game engine
Visual Studio Code or Android Studio
Installation

Clone the repository
Run flutter pub get
Launch in debug mode: flutter run
Debug Mode Activation

The debug system activates automatically when:

Running with flutter run (debug mode)
Building with --debug flag
Running in IDE with debug configuration
To manually control debug mode:

dart
// In your game initialization
@override
FutureOr<void> onLoad() async {
  // Force debug mode (optional)
  debugMode = true;
  
  // Or conditionally enable
  debugMode = kDebugMode || showDebugOverlay;
}
Usage Examples

Monitoring Collision Issues

When collision problems occur, the debug system provides:

Visual representation of collision boxes
Console logs showing overlap detection
Real-time position tracking
Collision response feedback
Physics Tuning

Use debug output to tune:

Gravity strength (_gravity value)
Jump force (_jumpForce value)
Movement speed (moveSpeed value)
Terminal velocity limits
Performance Optimization

Debug mode includes performance tracking:

Frame rate monitoring
Collision check counts
Memory usage indicators
Render call optimization suggestions
Troubleshooting Common Issues

Problem: Infinite Collision Loops

Symptoms: Player oscillates between two positions
Debug Output: Shows repeated collision detection at same coordinates
Solution: System automatically adds epsilon (±1.0px) to prevent oscillation

Problem: Physics Instability

Symptoms: Jerky movement or unexpected behavior
Debug Output: Velocity and position logs show irregularities
Solution: Adjust acceleration/deceleration values in _updatePlayerMovement()

Problem: Input Lag

Symptoms: Delayed response to joystick/keyboard
Debug Output: Shows input detection timing
Solution: Optimize update() method order and reduce computation in input handlers

Best Practices

1. Use Debug Mode During Development

Always run with debug mode enabled during development to catch issues early.

2. Check Console Regularly

Monitor console output for warnings, errors, and performance metrics.

3. Use Visual Debugging

Enable visual collision boxes to verify level design and collision detection.

4. Performance Testing

Regularly test in both debug and release modes to ensure performance remains optimal.

Production Considerations

Automatic Disable in Release

Debug features automatically disable in release builds:

No debug rendering
No console logging
No performance overhead
All debug code eliminated by tree shaking
Zero Production Impact

The debug system is designed to have:

No runtime cost in production
No additional dependencies
No conditional checks affecting performance
No increase in bundle size
Extending the Debug System

Adding Custom Debug Features

dart
// Example: Add custom debug visualization
void _renderCustomDebug(Canvas canvas) {
  if (kDebugMode && showCustomDebug) {
    // Your custom debug rendering here
  }
}
Creating Debug Categories

dart
enum DebugCategory {
  physics,
  collisions,
  input,
  rendering,
  performance
}

bool isDebugCategoryEnabled(DebugCategory category) {
  // Implement category-based debug control
  return debugEnabledCategories.contains(category);
}
Contributing

When contributing to the debug system:

Ensure debug code is wrapped in kDebugMode checks
Maintain zero overhead in release builds
Add clear console output with context
Include visual indicators where appropriate
Document new debug features
License

This debug system is part of the Pixel Adventure project. See main project for licensing details.
