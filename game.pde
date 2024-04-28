class Game
{
  Board board;
  Hero hero;
  Enemy[] enemyArray;
  //level from the levels directory
  String levelName;
  int restartPositionCellX;
  int restartPositionCellY;
  float lastTimeSpawned;
  int winDoorCellX;
  int winDoorCellY;
  boolean gameWon;
  boolean gameLost;
  int gameScore;
  float gameElapsedTime;
  int deltaTimeLife;
  Bonus[] bonusArray;
  Game() {
    board = null;
    hero = null;
  }
  Game(String _levelName) {
    TypeCell[][] _arrayCells = levelBoardDetector(_levelName);
    int[][] heroMonstersPosition  = heroMonsterPositionDetector(_levelName);
    PVector _drawPosition = new PVector(48/3, 48/2*8);
    PVector _drawSize = new PVector(width, height);
    int _nbCellsY = _arrayCells.length;
    int _nbCellsX = _arrayCells[0].length;
    board = new Board( _drawPosition, _drawSize, _nbCellsY, _nbCellsX);
    board.cells = _arrayCells;
    enemyArray = new Enemy[0];
    bonusArray = new Bonus[0];
    for ( int index = 0; index < heroMonstersPosition.length; index++) {
      switch(heroMonstersPosition[index][2]) {
      case 0 :
        restartPositionCellX=heroMonstersPosition[index][0];
        restartPositionCellY=heroMonstersPosition[index][1];
        hero = new Hero(restartPositionCellX, restartPositionCellY, board);
        break;
      case 1 :
        Enemy currentEnemy1= new Enemy(heroMonstersPosition[index][0], heroMonstersPosition[index][1], board, TypeEnemy.ENEMY_STAND);
        enemyArray = appendEnemy(enemyArray, currentEnemy1);
        break;
      case 2 :
        Enemy currentEnemy2= new Enemy(heroMonstersPosition[index][0], heroMonstersPosition[index][1], board, TypeEnemy.ENEMY_EVOLVED);
        enemyArray = appendEnemy(enemyArray, currentEnemy2);
        break;
      }
    }
    lastTimeSpawned = millis();
    gameWon = false;
    gameLost = false;
    gameScore = 0;
    gameElapsedTime = millis();
    deltaTimeLife = hero.timeLeft;
  }
  void updateHeroTimeLife(){
    if(deltaTimeLife == 0){
      hero.wasHit = true;
      deltaTimeLife = hero.timeLeft;
    }
  }
  void updateDeltaTimeLife(){
    if (millis() - gameElapsedTime >=1000){
      deltaTimeLife --;
      gameElapsedTime = millis();
    }
  }
  void update() {
    updateDeltaTimeLife();
    updateHeroTimeLife();
    updateAfterSaveInCase();
    for ( int indexEnemy = 0; indexEnemy < enemyArray.length; indexEnemy ++) {
      enemyArray[indexEnemy].move();
    }
    updateHeroEnemies();
    if (hero.restartPosition) {
      hero.cellX = restartPositionCellX;
      hero.cellY = restartPositionCellY;
      hero.position = board.getCellCenter(restartPositionCellX, restartPositionCellY);
      hero.restartPosition = false;
    }
    hero.update();
    updateHeroBonuses();
    updateBombsStatus();
    detectAreaBomb();
    updateBombOnOffCell();
    updateEnemyOnCell();
    updateEnemiesStatus();
    updateLossCondition();
  }
  void drawIt() {
    board.drawIt();
    drawBonuses();
    drawPlayerHUD();
    for ( int indexBomb = 0; indexBomb < hero.bombArray.length; indexBomb ++) {
      hero.bombArray[indexBomb].drawIt();
    }
    for ( int indexEnemy = 0; indexEnemy < enemyArray.length; indexEnemy ++) {
      enemyArray[indexEnemy].drawIt();
    }
    hero.drawIt();
  }
  void updateHeroEnemies() {
    for ( int indexEnemy = 0; indexEnemy < enemyArray.length; indexEnemy++) {
      if (hero.cellX == enemyArray[indexEnemy].cellX && hero.cellY == enemyArray[indexEnemy].cellY) {
        if (!hero.immune) {
          hero.wasHit = true;
          deltaTimeLife = hero.timeLeft;
        }
      }
    }
  }
  void detectAreaBomb() {
    for ( int indexBomb = 0; indexBomb<hero.bombArray.length; indexBomb++) {
      if (hero.bombArray[indexBomb].explosionEffect) {
        detectLineCells(hero.bombArray[indexBomb].infectedCellPositions_UP);
        detectLineCells(hero.bombArray[indexBomb].infectedCellPositions_DOWN);
        detectLineCells(hero.bombArray[indexBomb].infectedCellPositions_LEFT);
        detectLineCells(hero.bombArray[indexBomb].infectedCellPositions_RIGHT);
        if (hero.cellX == hero.bombArray[indexBomb].cellX && hero.cellY == hero.bombArray[indexBomb].cellY) {
          if (!hero.immune) {
            hero.wasHit = true;
            deltaTimeLife = hero.timeLeft;
          }
        }

        for ( int indexEnemy = 0; indexEnemy<enemyArray.length; indexEnemy++) {
          if (enemyArray[indexEnemy].cellX == hero.bombArray[indexBomb].cellX && enemyArray[indexEnemy].cellY == hero.bombArray[indexBomb].cellY ) {
            enemyArray[indexEnemy].wasHit = true;
          }
        }
      }
    }
  }
  void detectLineCells(int[][] positionCellInfected) {
    for ( int index = 0; index < positionCellInfected.length; index++) {
      if ( hero.cellX == positionCellInfected[index][0] && hero.cellY == positionCellInfected[index][1] ) {
        if (!hero.immune) {
          hero.wasHit = true;
          deltaTimeLife = hero.timeLeft;
        }
      }
      for ( int indexEnemy = 0; indexEnemy< enemyArray.length; indexEnemy++) {
        if ( !enemyArray[indexEnemy].immune &&enemyArray[indexEnemy].cellX == positionCellInfected[index][0] && enemyArray[indexEnemy].cellY == positionCellInfected[index][1] ) {
          enemyArray[indexEnemy].wasHit = true;
          enemyArray[indexEnemy].animationIndex = 0;
        }
      }
      if ( board.cells[positionCellInfected[index][1]][positionCellInfected[index][0]] == TypeCell.DESTRUCTIBLE_WALL ) {
        board.tableDestructionAttributs[positionCellInfected[index][1]][positionCellInfected[index][0]][2] = 1;//set animation time
      } else if ( board.cells[positionCellInfected[index][1]][positionCellInfected[index][0]] == TypeCell.EXIT_DOOR && !board.exitDoorAvailable) {
        board.tableDestructionAttributs[positionCellInfected[index][1]][positionCellInfected[index][0]][2] = 1;
        winDoorCellX = positionCellInfected[index][0];
        winDoorCellY = positionCellInfected[index][1];
      } else if ( board.cells[positionCellInfected[index][1]][positionCellInfected[index][0]] == TypeCell.EXIT_DOOR && board.exitDoorAvailable) {
        detectSpawnEnemies( winDoorCellX, winDoorCellY);
      }
    }
  }
  void updateHeroBonuses() {
    for ( int indexBonus = 0; indexBonus<bonusArray.length; indexBonus++) {
      if (bonusArray[indexBonus].cellX == hero.cellX && bonusArray[indexBonus].cellY == hero.cellY) {
        if (bonusArray[indexBonus].bonusEffect == TypeBonus.EXTEND_BOMBS_LIMIT) {
          hero.bombLimit++;
        } else if (bonusArray[indexBonus].bonusEffect == TypeBonus.EXTEND_RADIUS) {
          hero.heroBombRadius++;
        }
        gameScore+=100;
        bonusArray = removeBonus(bonusArray, indexBonus);
      }
    }
    for ( int indexBonus = 0; indexBonus<board.bonusArray.length; indexBonus++) {
      if (board.bonusArray[indexBonus].cellX == hero.cellX && board.bonusArray[indexBonus].cellY == hero.cellY) {
        if (board.bonusArray[indexBonus].bonusEffect == TypeBonus.EXTEND_BOMBS_LIMIT) {
          hero.bombLimit++;
        } else if (board.bonusArray[indexBonus].bonusEffect == TypeBonus.EXTEND_RADIUS) {
          hero.heroBombRadius++;
        }
        gameScore+=100;
        board.bonusArray = removeBonus(board.bonusArray, indexBonus);
      }
    }
  }
  void drawBonuses() {
    for ( int indexBonus = 0; indexBonus<bonusArray.length; indexBonus++) {
      bonusArray[indexBonus].drawIt();
    }
    for ( int indexBonus = 0; indexBonus<board.bonusArray.length; indexBonus++) {
      board.bonusArray[indexBonus].drawIt();
    }
  }
  void updateLossCondition() {
    if (hero.healthPoint <=0) {
      gameLost = true;
    }
  }
  void detectSpawnEnemies(int cellX_EXIT, int cellY_EXIT) {
    if (millis() - lastTimeSpawned >=1000) {
      lastTimeSpawned = millis();
      if (enemyArray.length>0) {
        TypeEnemy[] possibleSpawnEnemy = { TypeEnemy.ENEMY_STAND, TypeEnemy.ENEMY_STAND, TypeEnemy.ENEMY_EVOLVED, TypeEnemy.ENEMY_STAND};
        Enemy currentEnemySpawn = new Enemy(cellX_EXIT, cellY_EXIT, board, possibleSpawnEnemy[int(random(0, 4))]);
        currentEnemySpawn.canDropBonus = false;
        enemyArray = appendEnemy(enemyArray, currentEnemySpawn);
      }
    }
  }
  void updateBombsStatus() {
    for (int indexBomb = 0; indexBomb < hero.bombArray.length; indexBomb++) {
      if (hero.bombArray[indexBomb].exploded) {
        hero.bombArray = removeBomb(hero.bombArray, indexBomb);
        break;
      }
    }
  }

  void updateEnemiesStatus() {
    for ( int indexEnemy = 0; indexEnemy< enemyArray.length; indexEnemy++) {
      enemyArray[indexEnemy].update();
      if (enemyArray[indexEnemy].dead()) {
        if (enemyArray[indexEnemy].canDropBonus) {
          boolean[] willDropBonus = { false, true, false, false, false, true, false, false, false, false, false};
          if (willDropBonus[int(random(0, 11))]) {
            TypeBonus[] possibleBonus = {TypeBonus.EXTEND_RADIUS, TypeBonus.EXTEND_BOMBS_LIMIT};
            Bonus currentBonus = new Bonus(enemyArray[indexEnemy].cellX, enemyArray[indexEnemy].cellY, board.cellSize, possibleBonus[int(random(0, 2))]);
            currentBonus.position = board.getCellCenter(enemyArray[indexEnemy].cellX, enemyArray[indexEnemy].cellY);
            bonusArray = appendBonus(bonusArray, currentBonus);
          }
        }
        gameScore += enemyArray[indexEnemy].enemyScore;
        enemyArray = removeEnemy(enemyArray, indexEnemy);
        break;
      }
    }
  }
  void updateBombOnOffCell() {
    for ( int indexY = 0; indexY<board.cells.length; indexY++) {
      for (int indexX = 0; indexX<board.cells[0].length; indexX++) {
        boolean changedToTrue = false;
        for ( int indexBomb = 0; indexBomb < hero.bombArray.length; indexBomb++) {
          if (hero.bombArray[indexBomb].cellX == indexX && hero.bombArray[indexBomb].cellY == indexY) {
            board.tableDestructionAttributs[indexY][indexX][3] = 1;
            changedToTrue = true;
          }
        }
        if (!changedToTrue) {
          board.tableDestructionAttributs[indexY][indexX][3] = 0;
        }
      }
    }
  }
  void updateEnemyOnCell(){
    for ( int indexY = 0; indexY<board.cells.length; indexY++) {
      for (int indexX = 0; indexX<board.cells[0].length; indexX++) {
        boolean changedToTrue = false;
        for ( int indexEnemy = 0; indexEnemy < enemyArray.length; indexEnemy++) {
          if (enemyArray[indexEnemy].cellX == indexX && enemyArray[indexEnemy].cellY == indexY) {
            board.tableDestructionAttributs[indexY][indexX][4] = 1;
            changedToTrue = true;
          }
        }
        if (!changedToTrue) {
          board.tableDestructionAttributs[indexY][indexX][4] = 0;
        }
      }
    }
  }
  void updateAfterSaveInCase() {
    for ( int indexEnemy = 0; indexEnemy < enemyArray.length; indexEnemy++) {
      enemyArray[indexEnemy].board = board;
    }
    hero.board = board;
  }
  void handleKey() {
    if (keysTrigered[0]) {
      hero.move(board, directionUP);
    }
    if (keysTrigered[1]) {
      hero.move(board, directionDOWN);
    }
    if (keysTrigered[2]) {
      hero.move(board, directionLEFT);
    }
    if (keysTrigered[3]) {

      hero.move(board, directionRIGHT);
    }
    if (keysTrigered[4]) {
      //delta time in case the key listener is so fast to put tow bombs in the same cells (int this cae delta time = 200)
      if (!hero.wasHit) {
        if ( millis() - hero.lastTimePlacedBomb >= 200) {
          hero.lastTimePlacedBomb = millis();
          if (hero.bombArray.length <hero.bombLimit) {
            if ( board.cells[hero.cellY][hero.cellX] != TypeCell.EXIT_DOOR && board.tableDestructionAttributs[hero.cellY][hero.cellX][3] == 0) {
              Bomb currentBomb = new Bomb(hero.cellX, hero.cellY, hero.heroBombRadius, board);
              hero.bombArray = appendBomb(hero.bombArray, currentBomb);
            }
          }
        }
      }
    }
    if (keysTrigered[0] == false && keysTrigered[1] == false && keysTrigered[2] == false && keysTrigered[3] == false ) {
      hero.isMoving = false;
      hero.animationIndex = 0;
    }
  }
  void drawPlayerHUD() {
    imageMode(CORNERS);
    image(playerHUD, 0, 0, width, board.drawPosition.y-board.cellSize/2);
    textFont(arcadeClassic);
    textSize(50);
    textMode(CENTER);
    textAlign(LEFT);
    text(deltaTimeLife, 361, 45);
    text(hero.healthPoint, 68, 100);
    textMode(CORNERS);
    text(gameScore, 156, 100);
    imageMode(CENTER);
    translate(400, 112);
    rotate(radians((360/hero.timeLeft)*(hero.timeLeft - deltaTimeLife)));
    image(clockTiming, 0, 0, 31, 56);
    resetMatrix();
  }
}
PVector directionUP ;
PVector directionDOWN ;
PVector directionLEFT ;
PVector directionRIGHT ;
// key for each index  : w, s, a, d, p, enter
boolean[] keysTrigered = {false, false, false, false, false, false};
