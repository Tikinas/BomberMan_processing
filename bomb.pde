class Bomb {
  float placementTime ;
  float timeToExplode;
  int cellX, cellY;
  int explosionRadius;
  PVector position;
  float animationTime;
  int animationIndex;
  int[][] infectedCellPositions_UP;
  int[][] infectedCellPositions_DOWN;
  int[][] infectedCellPositions_LEFT;
  int[][] infectedCellPositions_RIGHT;
  boolean checkExplosion;
  float explosionTime;
  boolean explosionEffect;
  boolean exploded;
  Board board;
  Bomb(){
  }
  Bomb(int _cellX, int _cellY, int _explosionRadius, Board _board) {
    cellX = _cellX ;
    cellY = _cellY ;
    explosionRadius = _explosionRadius;
    timeToExplode = 2000 ;
    animationTime = millis();
    animationIndex = 0;
    placementTime = millis();
    infectedCellPositions_UP = new int[0][2];
    infectedCellPositions_DOWN = new int[0][2];
    infectedCellPositions_LEFT = new int[0][2];
    infectedCellPositions_RIGHT = new int[0][2];
    board = _board;
    position = board.getCellCenter(cellX, cellY);
    checkExplosion = false;
    explosionTime = millis();
    cellFireDetector();
    exploded = false;
    explosionEffect = false;
  }
  void drawIt() {
    imageMode(CENTER);
    if (millis() - placementTime < timeToExplode) {
      if (millis() - animationTime >= timeToExplode/9) {
        animationTime = millis();
        animationIndex = incrementIndex(animationIndex, 8);
      }
      image(bombAnimation[0][bombPattern_Before[animationIndex]], position.x, position.y, 48, 48);
    } else {
      if (!checkExplosion) {
        explosionTime = millis();
        checkExplosion = true;
        animationTime = millis();
        explosionEffect = true;
      }
      if (millis() - explosionTime <=500) {
        if (millis() - animationTime >= 500/9 ) {
          animationTime = millis();
          animationIndex = incrementIndex(animationIndex, 9);
        }
        drawFire(infectedCellPositions_UP, -PI/2);
        drawFire(infectedCellPositions_DOWN, PI/2);
        drawFire(infectedCellPositions_LEFT, PI);
        drawFire(infectedCellPositions_RIGHT, 0);
        image(bombFireAnimation[2][bombPattern_After[animationIndex]], position.x, position.y, board.cellSize, board.cellSize);
      }else{
        exploded = true;
        explosionEffect = false;
      }
    }
  }
  void cellFireDetector() {
    boolean limitUP = false;
    boolean limitDOWN = false;
    boolean limitLEFT = false;
    boolean limitRIGHT = false;
    int currentCellX;
    int currentCellY;
    /*for (int indexY = 0; indexY < board.cells.length; indexY ++) {
      for (int indexX = 0; indexX < board.cells[0].length; indexX ++) {
        print("X:",indexX,"Y:",indexY,":",board.cells[indexY][indexX]);
      }
      println("");
    }*/
    for ( int indexUP = 1; indexUP< explosionRadius + 1; indexUP ++) {
      if (!limitUP) {
        //println("index :", indexUP);
        currentCellX = cellX;
        currentCellY = cellY - indexUP;
        //println("X:",currentCellX,"Y:",currentCellY,":",board.cells[currentCellY][currentCellX]);
        if (board.cells[currentCellY][currentCellX] == TypeCell.WALL ||
          board.cells[currentCellY][currentCellX] == TypeCell.DESTRUCTIBLE_WALL || board.cells[currentCellY][currentCellX] == TypeCell.EXIT_DOOR ) {
          infectedCellPositions_UP = appendInteger2(infectedCellPositions_UP, currentCellX, currentCellY);
          limitUP = true;
        } else {
          infectedCellPositions_UP = appendInteger2(infectedCellPositions_UP, currentCellX, currentCellY);
        }
      }
    }
    for ( int indexDOWN = 1; indexDOWN< explosionRadius+1; indexDOWN ++) {
      if (!limitDOWN) {
        currentCellX = cellX;
        currentCellY = cellY + indexDOWN;
        if (board.cells[currentCellY][currentCellX] == TypeCell.WALL ||
          board.cells[currentCellY][currentCellX] == TypeCell.DESTRUCTIBLE_WALL ||board.cells[currentCellY][currentCellX] == TypeCell.EXIT_DOOR ) {
          infectedCellPositions_DOWN = appendInteger2(infectedCellPositions_DOWN, currentCellX, currentCellY);
          limitDOWN = true;
        } else {
          infectedCellPositions_DOWN = appendInteger2(infectedCellPositions_DOWN, currentCellX, currentCellY);
        }
      }
    }
    for ( int indexLEFT = 1; indexLEFT< explosionRadius+1; indexLEFT ++) {
      if (!limitLEFT) {
        currentCellX = cellX-indexLEFT;
        currentCellY = cellY;
        if (board.cells[currentCellY][currentCellX] == TypeCell.WALL ||
          board.cells[currentCellY][currentCellX] == TypeCell.DESTRUCTIBLE_WALL||board.cells[currentCellY][currentCellX] == TypeCell.EXIT_DOOR ) {
          infectedCellPositions_LEFT = appendInteger2(infectedCellPositions_LEFT, currentCellX, currentCellY);
          limitLEFT = true;
        } else {
          infectedCellPositions_LEFT = appendInteger2(infectedCellPositions_LEFT, currentCellX, currentCellY);
        }
      }
    }
    for ( int indexRIGHT = 1; indexRIGHT< explosionRadius+1; indexRIGHT ++) {
      if (!limitRIGHT) {
        currentCellX = cellX + indexRIGHT;
        currentCellY = cellY;
        if (board.cells[currentCellY][currentCellX] == TypeCell.WALL ||
          board.cells[currentCellY][currentCellX] == TypeCell.DESTRUCTIBLE_WALL ||board.cells[currentCellY][currentCellX] == TypeCell.EXIT_DOOR) {
          infectedCellPositions_RIGHT = appendInteger2(infectedCellPositions_RIGHT, currentCellX, currentCellY);
          limitRIGHT = true;
        } else {
          infectedCellPositions_RIGHT = appendInteger2(infectedCellPositions_RIGHT, currentCellX, currentCellY);
        }
      }
    }
  }
  void update() {
  }
  void drawFire(int[][] arrayCellInfected, float directionFire) {
    int startingIndexLine;
    int startingIndexCol;
    PVector currentCellInfectedPosition;

    if (directionFire == 0) {
      startingIndexLine = 1 ;
      startingIndexCol = 5 ;
    } else if (directionFire == PI/2) {

      startingIndexLine = 1 ;
      startingIndexCol = 0 ;
    } else if (directionFire == PI) {

      startingIndexLine = 0 ;
      startingIndexCol = 0 ;
    } else {
      startingIndexLine = 0 ;
      startingIndexCol = 5 ;
    }
    for ( int index = 0; index < arrayCellInfected.length; index ++) {
      //println("for direction", directionFire, "length :", arrayCellInfected.length);
      if ( index == arrayCellInfected.length - 1 && (board.cells[arrayCellInfected[index][1]][arrayCellInfected[index][0]] != TypeCell.WALL &&
      board.cells[arrayCellInfected[index][1]][arrayCellInfected[index][0]] != TypeCell.DESTRUCTIBLE_WALL &&
      board.cells[arrayCellInfected[index][1]][arrayCellInfected[index][0]] != TypeCell.EXIT_DOOR) ) {
        currentCellInfectedPosition = board.getCellCenter(arrayCellInfected[index][0], arrayCellInfected[index][1]);
        image(bombFireAnimation[startingIndexLine][startingIndexCol+bombPattern_After[animationIndex]], currentCellInfectedPosition.x, currentCellInfectedPosition.y, board.cellSize, board.cellSize);
      } else if(index< arrayCellInfected.length - 1){

        currentCellInfectedPosition = board.getCellCenter(arrayCellInfected[index][0], arrayCellInfected[index][1]);
        translate(currentCellInfectedPosition.x, currentCellInfectedPosition.y);
        rotate(directionFire - PI/2);
        image(bombFireAnimation[3][bombPattern_After[animationIndex]], 0, 0, board.cellSize, board.cellSize);
        resetMatrix();
      }
    }
  }
}
Bomb[] appendBomb(Bomb[] initialBombArray, Bomb bomb){
  Bomb[] newBombArray = new Bomb[initialBombArray.length+1];
  System.arraycopy(initialBombArray,0,newBombArray,0,initialBombArray.length);
  newBombArray[initialBombArray.length] = bomb;
  return newBombArray; 
}
Bomb[] removeBomb(Bomb[] initialBombArray, int indexToRemove){
  Bomb[] newBombArray = new Bomb[initialBombArray.length-1];
  boolean status =false;
  for ( int index = 0; index< newBombArray.length; index++) {
    if ( index == indexToRemove) {
      status = true;
    }
    if (!status) {
      newBombArray[index] = initialBombArray[index];
    } else {
      newBombArray[index] = initialBombArray[index+1];
    }
  }
  return newBombArray;
}
