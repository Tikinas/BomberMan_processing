 class Hero {
  int healthPoint;
  // position on screen
  PVector position;
  //board in iwch the hero is on
  Board board;
  // position on board
  int cellX, cellY;
  // display size
  PVector size;
  // if hero was hit by a bomb
  boolean wasHit;
  //by default it is false so when the hero is hit it gets the damaged and we prvent the hero to get more damge when the damage animation is on the screen cause of the mechanisim of the detection funcion
  boolean damaged;
  //if the hero is moving
  boolean isMoving;
  //last time of the last animatio displayed on the screen when the hero is moving
  float animationTime;
  //index of the current animation to display on the screen when the bomberman is moving
  int animationIndex;
  // direction of the hero
  float heroDirection ;
  //array of Bomb of the hero
  Bomb[] bombArray;
  //limit of bombs
  int bombLimit;
  int heroBombRadius;
  float lastTimePlacedBomb;
  int animationIndexDeath;
  boolean restartPosition;
  int timeLeft;
  boolean immune;
  //
  int immuneAnimationIndex;
  //
  int immuneDeltaTime;
  //
  float heroElapsedTime;
  Hero() {
  }
  Hero(int _cellX, int _cellY, Board _board) {
    wasHit = false;
    isMoving = false;
    cellX = _cellX;
    cellY = _cellY;
    board = _board;
    position = board.getCellCenter(cellX, cellY);
    animationIndex = 0;
    heroDirection = PI/2;
    size = new PVector(board.cellSize, 1.4375*board.cellSize);
    animationTime = millis();
    bombArray = new Bomb[0];
    bombLimit = 1;
    heroBombRadius = 1;
    lastTimePlacedBomb = millis();
    healthPoint = 5;
    damaged = false;
    animationIndexDeath = 0;
    restartPosition = false;
    timeLeft = 120;
    immune = true;
    immuneAnimationIndex = 0;
    immuneDeltaTime = 7;
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
  void move(Board board, PVector direction) {
    if (!wasHit) {
      float[][] arrayDistance = new float[board.cells.length][board.cells[0].length];
      PVector newPosition = new PVector(position.x+direction.x, position.y+direction.y);
      PVector currentCenter;
      for (int indexY = 0; indexY<board.cells.length; indexY++) {
        for (int indexX = 0; indexX<board.cells[0].length; indexX++) {
          currentCenter = board.getCellCenter(indexX, indexY);
          arrayDistance[indexY][indexX] = dist(currentCenter.x, currentCenter.y, newPosition.x, newPosition.y);
        }
      }

      //this function in processing calculate the argument of the vector by two given points
      float newHeroDirection = atan2(newPosition.y - position.y, newPosition.x - position.x);
      int nextCellX = cellX +int(cos(newHeroDirection));
      int nextCellY = cellY +int(sin(newHeroDirection));
      PVector currentCellCenter = board.getCellCenter(cellX, cellY);
      PVector nextCellCenter = board.getCellCenter(nextCellX, nextCellY);
      TypeCell nextCell = board.cells[nextCellY][nextCellX];
      boolean nextCellNotBomb= (board.tableDestructionAttributs[nextCellY][nextCellX][3] == 0) ||(
        (dist(position.x, position.y, nextCellCenter.x, nextCellCenter.y)>board.cellSize+2 ) && (board.tableDestructionAttributs[nextCellY][nextCellX][3] == 1)) ;
      if (checkCorners( newPosition)) {
        if (((nextCell == TypeCell.EXIT_DOOR && board.exitDoorAvailable) ||(nextCell == TypeCell.EMPTY ||
          (nextCell != TypeCell.EMPTY && dist(position.x, position.y, nextCellCenter.x, nextCellCenter.y)>board.cellSize+2 ))  ) && nextCellNotBomb) {
          position = newPosition;
          heroDirection = newHeroDirection;
          PVector minIndexCell = minIndexArray(arrayDistance);
          cellX = int(minIndexCell.y) ;
          cellY = int(minIndexCell.x) ;
          isMoving = true ;
        }
      }
    }
  }
  boolean heroDead() {
    return healthPoint<=0;
  }
  void update() {
    if (immune) {
      if (immuneDeltaTime == 0) {
        immune = false;
      } else if (millis() - heroElapsedTime>=1000) {
        heroElapsedTime = millis();
        immuneDeltaTime --;
      }
    }
  }

  void drawIt() {
    imageMode(CENTER);
    if (immune) {
      immuneAnimationIndex = incrementIndex(immuneAnimationIndex, 2);
      tint(255*immuneAnimationIndex);
    } else {
      noTint();
    }
    if (!wasHit) {
      if (heroDirection == PI/2) {
        if (!isMoving) {
          image(bomberManSprites[0][1], position.x, position.y-size.y/3.5, size.x, size.y);
        } else {
          if (millis() - animationTime>=150) {
            animationTime = millis();
            animationIndex = incrementIndex(animationIndex, 3);
          }
          image(bomberAnimation_DOWN[animationIndex], position.x, position.y-size.y/3.5, size.x, size.y);
        }
      } else if (heroDirection == PI) {
        if (!isMoving) {
          image(bomberManSprites[1][0], position.x, position.y-size.y/3.5, size.x, size.y);
        } else {
          if (millis() - animationTime>=150) {
            animationTime = millis();
            animationIndex = incrementIndex(animationIndex, 3);
          }
          image(bomberAnimation_LEFT[animationIndex], position.x, position.y-size.y/3.5, size.x, size.y);
        }
      } else if (heroDirection == -PI/2) {
        if (!isMoving) {
          image(bomberManSprites[0][4], position.x, position.y-size.y/3.5, size.x, size.y);
        } else {
          if (millis() - animationTime>=150) {
            animationTime = millis();
            animationIndex = incrementIndex(animationIndex, 3);
          }
          image(bomberAnimation_UP[animationIndex], position.x, position.y-size.y/3.5, size.x, size.y);
        }
      } else if (heroDirection == 0) {
        if (!isMoving) {
          image(bomberManSprites[1][3], position.x, position.y-size.y/3.5, size.x, size.y);
        } else {
          if (millis() - animationTime>=150) {
            animationTime = millis();
            animationIndex = incrementIndex(animationIndex, 3);
          }
          image(bomberAnimation_RIGHT[animationIndex], position.x, position.y-size.y/3.5, size.x, size.y);
        }
      }
    } else {
      if (millis() - animationTime >=1000/6) {
        animationTime = millis();
        animationIndexDeath = incrementIndex(animationIndexDeath, 7);
      }
      if (healthPoint == 1 && animationIndexDeath == 5){
        healthPoint -=1;    
      }
      if (animationIndexDeath == 6) {
        animationIndexDeath = 0;
        wasHit = false;
        healthPoint -=1;
        restartPosition = true;
        heroElapsedTime = millis();
        immuneDeltaTime = 7;
        immune = true;
      } else {
        image(bomberManSprites[2][animationIndexDeath], position.x, position.y - size.y/3.5, int(size.x), int(size.y));
      }
    }
    noTint();
  }
}
