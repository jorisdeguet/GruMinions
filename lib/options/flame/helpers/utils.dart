bool checkCollision(character, block) {
  final hitBox = character.hitBox;
  final playerX = character.position.x + hitBox.offsetX;
  final playerY = character.position.y + hitBox.offsetY;
  final playerWidth = hitBox.width;
  final playerHeight = hitBox.height;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final fixedX = character.scale.x < 0 ? playerX - (hitBox.offsetX * 2) - playerWidth : playerX;
  final fixedY = block.isPlatform ? playerY + playerHeight : playerY;

  return (fixedY < blockY + blockHeight &&
          playerY + playerHeight > blockY &&
          fixedX < blockX + blockWidth &&
          fixedX + playerWidth > blockX);
}