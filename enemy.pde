enum TypeEnemy {
  ENEMY_STAND, ENEMY_EVOLVED;
}
class Enemy {
  float spawnTime;
  TypeEnemy enemyType;
  int healthPoint;
  int cellX;
  int cellY;
  Board board;
  float animationTime;
  int animationIndex;
  PVector position;
  float direction;
  PVector size;
  float lastTimeMoved;
  int speedEnemy;
  boolean wasHit;
  boolean immune;
  float immuneTime;
  int enemyScore;
  boolean canDropBonus;
  Enemy() {
  }
  Enemy(int _cellX, int _cellY, Board _board, TypeEnemy _enemyType) {
    cellX = _cellX;
    cellY = _cellY;
    board = _board;
    enemyType = _enemyType;
    position = board.getCellCenter(cellX, cellY);
    if ( enemyType == TypeEnemy.ENEMY_STAND ) {
      healthPoint = 1;
      enemyScore = 100;
    } else if ( enemyType == TypeEnemy.ENEMY_EVOLVED ) {
      healthPoint = 2;
      enemyScore = 300;
    }
    animationTime = millis();
    animationIndex = 0;
    direction = 0;
    size = new PVector(board.cellSize, 1.4375*board.cellSize);
    lastTimeMoved = millis();
    speedEnemy = int(board.cellSize/12);
    wasHit = false;
    immune = true;
    immuneTime = 1250;
    spawnTime = millis();
    canDropBonus = true;
  }
  boolean dead() {
    return healthPoint<=0;
  }
  void drawIt() {
    imageMode(CENTER);
    if (!wasHit) {
      if (enemyType == TypeEnemy.ENEMY_STAND) {
        if ( direction == 0) {
          if (millis() - animationTime >= 1000/32) {
            animationIndex = incrementIndex(animationIndex, 6);
            animationTime = millis();
          }
          image(enemyType_STAND[1][4+enemyPattern_STAND[animationIndex]], position.x, position.y-size.y/3.5, int(size.x), int(size.y));
        } else if ( direction == PI/2) {
          if (millis() - animationTime >= 1000/32) {
            animationIndex = incrementIndex(animationIndex, 6);
            animationTime = millis();
          }
          image(enemyType_STAND[0][enemyPattern_STAND[animationIndex]], position.x, position.y-size.y/3.5, int(size.x), int(size.y));
        } else if ( direction == PI) {
          if (millis() - animationTime >= 1000/32) {
            animationIndex = incrementIndex(animationIndex, 6);
            animationTime = millis();
          }
          image(enemyType_STAND[1][enemyPattern_STAND[animationIndex]], position.x, position.y-size.y/3.5, int(size.x), int(size.y));
        } else {
          if (millis() - animationTime >= 1000/32) {
            animationIndex = incrementIndex(animationIndex, 6);
            animationTime = millis();
          }
          image(enemyType_STAND[0][4+enemyPattern_STAND[animationIndex]], position.x, position.y-size.y/3.5, int(size.x), int(size.y));
        }
      } else if (enemyType == TypeEnemy.ENEMY_EVOLVED) {
        if (millis() - animationTime >=1000/10) {
          animationTime = millis();
          animationIndex = incrementIndex(animationIndex, 10);
        }
        image(enemyType_EVOLVED[0][enemyPattern_EVOLVED[animationIndex]], position.x, position.y-size.y/3.5, int(size.x), int(size.y));
      }
    } else {
      if (enemyType == TypeEnemy.ENEMY_STAND) {
        if (animationIndex == 5) {
          wasHit = false;
          healthPoint -=1;
        } else {
          if ( direction == 0) {
            if (millis() - animationTime >= 1000/32) {
              animationIndex = incrementIndex(animationIndex, 6);
              animationTime = millis();
            }
            if (animationIndex%2 == 0) {
              tint(0);
              image(enemyType_STAND[1][4+enemyPattern_STAND[animationIndex]], position.x, position.y-size.y/3.5, int(size.x), int(size.y));
              noTint();
            } else {
              image(enemyType_STAND[1][4+enemyPattern_STAND[animationIndex]], position.x, position.y-size.y/3.5, int(size.x), int(size.y));
            }
          } else if ( direction == PI/2) {
            if (millis() - animationTime >= 1000/32) {
              animationIndex = incrementIndex(animationIndex, 6);
              animationTime = millis();
            }
            if (animationIndex%2 == 0) {
              tint(0);
              image(enemyType_STAND[0][enemyPattern_STAND[animationIndex]], position.x, position.y-size.y/3.5, int(size.x), int(size.y));
              noTint();
            } else {
              image(enemyType_STAND[0][enemyPattern_STAND[animationIndex]], position.x, position.y-size.y/3.5, int(size.x), int(size.y));
            }
          } else if ( direction == PI) {
            if (millis() - animationTime >= 1000/32) {
              animationIndex = incrementIndex(animationIndex, 6);
              animationTime = millis();
            }
            if (animationIndex%2 == 0) {
              tint(0);
              image(enemyType_STAND[1][enemyPattern_STAND[animationIndex]], position.x, position.y-size.y/3.5, int(size.x), int(size.y));
              noTint();
            } else {
              image(enemyType_STAND[1][enemyPattern_STAND[animationIndex]], position.x, position.y-size.y/3.5, int(size.x), int(size.y));
            }
          } else {
            if (millis() - animationTime >= 1000/32) {
              animationIndex = incrementIndex(animationIndex, 6);
              animationTime = millis();
            }
            if (animationIndex%2 == 0) {
              tint(0);
              image(enemyType_STAND[0][4+enemyPattern_STAND[animationIndex]], position.x, position.y-size.y/3.5, int(size.x), int(size.y));
              noTint();
            } else {
              image(enemyType_STAND[0][4+enemyPattern_STAND[animationIndex]], position.x, position.y-size.y/3.5, int(size.x), int(size.y));
            }
          }
        }
      } else if (enemyType == TypeEnemy.ENEMY_EVOLVED) {
        if (animationIndex == 9) {
          wasHit = false;
          healthPoint -=1;
        } else {
          if (millis() - animationTime >=1000/10) {
            animationTime = millis();
            animationIndex = incrementIndex(animationIndex, 10);
          }
          if (animationIndex%2 == 0) {
            tint(0);
            image(enemyType_EVOLVED[0][enemyPattern_EVOLVED[animationIndex]], position.x, position.y-size.y/3.5, int(size.x), int(size.y));
            noTint();
          } else {
            image(enemyType_EVOLVED[0][enemyPattern_EVOLVED[animationIndex]], position.x, position.y-size.y/3.5, int(size.x), int(size.y));
          }
        }
      }
    }
  }
  boolean checkCorners( PVector newPosition) {
    PVector centerCellTopRight = board.getCellCenter(cellX+1, cellY-1);
    PVector centerCellTopLeft = board.getCellCenter(cellX-1, cellY-1);
    PVector centerCellBottomRight = board.getCellCenter(cellX+1, cellY+1);
    PVector centerCellBottomLeft = board.getCellCenter(cellX-1, cellY+1);
    int distanceTopRight = int(dist(centerCellTopRight.x, centerCellTopRight.y, newPosition.x, newPosition.y));
    int distanceTopLeft = int(dist(centerCellTopLeft.x, centerCellTopLeft.y, newPosition.x, newPosition.y));
    int distanceBottomRight = int(dist(centerCellBottomRight.x, centerCellBottomRight.y, newPosition.x, newPosition.y));
    int distanceBottomLeft = int(dist(centerCellBottomLeft.x, centerCellBottomLeft.y, newPosition.x, newPosition.y)) ;
    if ( ( (distanceTopLeft == distanceTopRight) && (distanceBottomLeft == distanceBottomRight) ) ||
      ( (distanceTopLeft == distanceBottomLeft) && ( distanceTopRight == distanceBottomRight) )  ) {
      return true;
    }
    return false;
  }
  void move() {
    if (!wasHit) {
      if (millis() - lastTimeMoved >= 40) {
        lastTimeMoved = millis();
        PVector newPosition = new PVector(position.x + speedEnemy*cos(direction), position.y + speedEnemy*sin(direction));
        float newDirection = atan2(newPosition.y - position.y, newPosition.x - position.x);
        int nextCellX = cellX + int(cos(newDirection));
        int nextCellY = cellY + int(sin(newDirection));
        PVector nextCellCenter = board.getCellCenter(nextCellX, nextCellY);
        TypeCell nextCell = board.cells[nextCellY][nextCellX];
        boolean nextCellNotBomb= (board.tableDestructionAttributs[nextCellY][nextCellX][3] == 0) ||(
          (dist(position.x, position.y, nextCellCenter.x, nextCellCenter.y)>board.cellSize ) && (board.tableDestructionAttributs[nextCellY][nextCellX][3] == 1)) ;
        boolean nextCellNotEnemy = (board.tableDestructionAttributs[nextCellY][nextCellX][4] == 0) ||(
          (dist(position.x, position.y, nextCellCenter.x, nextCellCenter.y)>board.cellSize ) && (board.tableDestructionAttributs[nextCellY][nextCellX][4] == 1)) ;
        if (checkCorners(newPosition)) {
          if ((nextCell == TypeCell.EXIT_DOOR && board.exitDoorAvailable) ||(nextCell == TypeCell.EMPTY && nextCellNotBomb && nextCellNotEnemy ) ||(
            (nextCell != TypeCell.EMPTY && dist(position.x, position.y, nextCellCenter.x, nextCellCenter.y)>board.cellSize) && nextCellNotBomb && nextCellNotEnemy)) {
            position = newPosition;
            direction = newDirection;
            PVector currentCenter;
            float[][] arrayDistance = new float[board.cells.length][board.cells[0].length];
            for (int indexY = 0; indexY<board.cells.length; indexY++) {
              for (int indexX = 0; indexX<board.cells[0].length; indexX++) {
                currentCenter = board.getCellCenter(indexX, indexY);
                arrayDistance[indexY][indexX] = dist(currentCenter.x, currentCenter.y, newPosition.x, newPosition.y);
              }
            }
            PVector minIndexCell = minIndexArray(arrayDistance);
            cellX = int(minIndexCell.y) ;
            cellY = int(minIndexCell.x) ;
          } else {
            direction = (direction+PI/2)%(2*PI);
          }
        } else {
          direction = (direction+PI/2)%(2*PI);
        }
      }
    }
  }
  void update() {
    if (immune) {
      if (millis() - spawnTime >= immuneTime) {
        immune = false;
      }
    }
  }
}
Enemy[] removeEnemy(Enemy[] initialEnemyArray, int indexToRemove) {
  Enemy[] newEnemyArray = new Enemy[initialEnemyArray.length-1];
  boolean status =false;
  for ( int index = 0; index< newEnemyArray.length; index++) {
    if ( index == indexToRemove) {
      status = true;
    }
    if (!status) {
      newEnemyArray[index] = initialEnemyArray[index];
    } else {
      newEnemyArray[index] = initialEnemyArray[index+1];
    }
  }
  return newEnemyArray;
}
Enemy[] appendEnemy(Enemy[] initialEnemyArray, Enemy enemy) {
  Enemy[] newEnemyArray = new Enemy[initialEnemyArray.length+1];
  System.arraycopy(initialEnemyArray, 0, newEnemyArray, 0, initialEnemyArray.length);
  newEnemyArray[initialEnemyArray.length] = enemy;
  return newEnemyArray;
}
