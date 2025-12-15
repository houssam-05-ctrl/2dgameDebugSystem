# Pixel Adventure - Platformer Game

A 2D platformer game built with Flutter and Flame engine, featuring a comprehensive debug system for collision detection and physics development.

## Features

- **Complete 2D Platformer Mechanics**: Running, jumping, collision detection
- **Visual Debug System**: See collision boxes in development mode
- **Tiled Level Support**: Build levels with Tiled map editor
- **Mobile Controls**: On-screen joystick for mobile devices
- **Camera System**: Smooth camera following with boundaries

## Debug System

The game includes an advanced debug system that activates automatically in development mode:

### Visual Debugging

- **Red boxes**: Solid collision blocks (walls, floors)
- **Green boxes**: Platform blocks (passable from below)
- **Blue outline**: Player collision boundary
- **Console logging**: Real-time position, velocity, and collision data

### How to Use Debug Mode

1. Run the app in debug mode: `flutter run`
2. Collision boxes will appear automatically
3. Check console for physics data
4. No configuration needed - works out of the box

## Project Structure

lib/
├── main.dart # App entry point
├── pixel_adventure.dart # Main game class
└── components/
├── player.dart # Player controller and physics
├── collision_block.dart # Collision system with debug
├── level.dart # Level loader (Tiled maps)
└── utils.dart # Collision detection utilities

----------------------- Getting started -----------------------

---

### Prerequisites

- Flutter SDK (latest stable)
- Android Studio / VS Code
- Tiled Map Editor (optional, for level design)

### Installation

````bash
# Clone the repository
git clone https://github.com/houssam-05-ctrl/pixel_adventure

# Navigate to project
cd pixel_adventure

# Install dependencies/tiles
flutter pub get

# Run in debug mode
flutter run

dont forget to check the versions of flutter youre using, dear enthoustiast

--------------
