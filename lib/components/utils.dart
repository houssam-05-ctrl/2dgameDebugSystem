bool checkCollision(player, block) {
  final playerX = player.position.x;
  final playerY = player.position.y;
  final playerHeight = player.position.y;
  final playerWidth = player.position.x;

  final blockX = block.position.x;
  final blockY = block.position.y;
  final blockHeight = block.position.y;
  final blockWidth = block.position.x;

  final fixedX = player.scale.x < 0 ? playerX - playerWidth : playerX;

  return (playerY < blockY + blockHeight &&
      playerY + playerHeight > blockY &&
      fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX);
}
