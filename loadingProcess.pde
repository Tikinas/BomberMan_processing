int[][] readArray2dIntFromFile(String filePathName) {
  // Charger les lignes du fichier dans un tableau de chaînes
  String[] lines = loadStrings(filePathName);

  // Vérifier si le fichier est vide
  if (lines == null || lines.length == 0) {
    return null;
  }

  // Déterminer la taille de la matrice en fonction de la première ligne
  int numRows = lines.length;
  String[] firstRowElements = split(lines[0], ',');
  int numCols = firstRowElements.length;

  // Créer la matrice pour stocker les entiers
  int[][] result = new int[numRows][numCols];

  // Remplir la matrice avec les entiers à partir des lignes du fichier
  for (int indexX = 0; indexX < numRows; indexX++) {
    String[] elements = split(lines[indexX], ',');
    for (int indexY = 0; indexY < numCols; indexY++) {
      result[indexX][indexY] = int(elements[indexY]);
    }
  }

  return result;
}
float[][][] readArray3dFloatFromFile(String filePathName) {
  // Charger les lignes du fichier dans un tableau de chaînes
  String[] lines = loadStrings(filePathName);

  // Vérifier si le fichier est vide
  if (lines == null || lines.length == 0) {
    return null;
  }

  // Déterminer la taille de la matrice en fonction de la première ligne
  int numLayers = lines.length;
  String[] firstRowElements = split(lines[0], '/');
  int numRows = firstRowElements.length;
  String[] firstLayerElements = split(firstRowElements[0], ',');
  int numCols = firstLayerElements.length;

  // Créer la matrice pour stocker les nombres à virgule flottante
  float[][][] result = new float[numLayers][numRows][numCols];

  // Remplir la matrice avec les nombres à virgule flottante à partir des lignes du fichier
  for (int indexX = 0; indexX < numLayers; indexX++) {
    String[] layers = split(lines[indexX], '/');
    for (int indexY = 0; indexY < numRows; indexY++) {
      String[] elements = split(layers[indexY], ',');
      for (int indexZ = 0; indexZ < numCols; indexZ++) {
        result[indexX][indexY][indexZ] = float(elements[indexZ]);
      }
    }
  }
  for (int indexY = 0; indexY < result.length; indexY++) {
      for (int indexX = 0; indexX < result[0].length; indexX++) {
        //result[indexY][indexX][0] = 0;//index animation for the destruciton (we will use int() to give it as an index for the PImage 2d array)
        result[indexY][indexX][1] = millis();//animation time for the destuction
        //result[indexY][indexX][2] = 0;//0 if not destructed 1 if not (works like a boolean)
        //result[indexY][indexX][3] = 0;//if the current cell is occupide by a bomb
      }
    }

  return result;
}
boolean readBooleanFromFile(String filePathName) {
  // Charger les lignes du fichier dans un tableau de chaînes
  String[] lines = loadStrings(filePathName);

  // Vérifier si le fichier est vide
  if (lines == null || lines.length == 0) {
    return false;  // Valeur par défaut en cas de fichier vide
  }

  // Lire la première ligne du fichier et convertir en booléen
  return boolean(lines[0]);
}

float readFloatFromFile(String filePathName) {
  // Charger les lignes du fichier dans un tableau de chaînes
  String[] lines = loadStrings(filePathName);

  // Vérifier si le fichier est vide
  if (lines == null || lines.length == 0) {
    return 0.0;  // Valeur par défaut en cas de fichier vide
  }

  // Lire la première ligne du fichier et convertir en float
  return float(lines[0]);
}

int readIntFromFile(String filePathName) {
  // Charger les lignes du fichier dans un tableau de chaînes
  String[] lines = loadStrings(filePathName);

  // Vérifier si le fichier est vide
  if (lines == null || lines.length == 0) {
    return 0;  // Valeur par défaut en cas de fichier vide
  }

  // Lire la première ligne du fichier et convertir en int
  return int(lines[0]);
}

PVector readPVectorFromFile(String filePathName) {
  // Charger les lignes du fichier dans un tableau de chaînes
  String[] lines = loadStrings(filePathName);

  // Vérifier si le fichier est vide
  if (lines == null || lines.length < 2) {
    return new PVector(0, 0);  // Valeur par défaut en cas de fichier vide
  }

  // Lire les deux premières lignes du fichier et convertir en PVector
  float x = float(lines[0]);
  float y = float(lines[1]);
  return new PVector(x, y);
}
TypeCell[][] readArrayCellFromFile(String filePathName) {
  // Charger les lignes du fichier dans un tableau de chaînes
  String[] lines = loadStrings(filePathName);

  // Vérifier si le fichier est vide
  if (lines == null || lines.length == 0) {
    return null;
  }

  // Déterminer la taille de la matrice en fonction de la première ligne
  int numRows = lines.length;
  String[] firstRowElements = split(lines[0], '|');
  int numCols = firstRowElements.length;

  // Créer la matrice pour stocker les types de cellules
  TypeCell[][] result = new TypeCell[numRows][numCols];

  // Remplir la matrice avec les types de cellules à partir des lignes du fichier
  for (int cellY = 0; cellY < numRows; cellY++) {
    String[] cells = split(lines[cellY], '|');
    for (int cellX = 0; cellX < numCols; cellX++) {
      String currentCell = cells[cellX].trim();
      switch (currentCell) {
        case "EMPTY":
          result[cellY][cellX] = TypeCell.EMPTY;
          break;
        case "WALL":
          result[cellY][cellX] = TypeCell.WALL;
          break;
        case "DESTRUCTIBLE_WALL":
          result[cellY][cellX] = TypeCell.DESTRUCTIBLE_WALL;
          break;
        case "EXIT_DOOR":
          result[cellY][cellX] = TypeCell.EXIT_DOOR;
          break;
        // Ajoutez d'autres cas selon les besoins
        default:
          // Cas par défaut, peut être EMPTY ou une autre valeur par défaut
          result[cellY][cellX] = TypeCell.EMPTY;
      }
    }
  }

  return result;
}
TypeBonus readTypeBonusFromFile(String filePathName) {
  // Charger les lignes du fichier dans un tableau de chaînes
  String[] lines = loadStrings(filePathName);

  // Vérifier si le fichier est vide
 
  // Lire la première ligne du fichier et convertir en TypeBonus
  switch (lines[0]) {
    case "EXTEND_RADIUS":
      return TypeBonus.EXTEND_RADIUS;
    case "EXTEND_BOMBS_LIMIT":
      return TypeBonus.EXTEND_BOMBS_LIMIT;
    // Ajoutez d'autres cas selon les besoins
    default:
      return null;  // Valeur par défaut en cas de correspondance non trouvée
  }
}
Bonus readBonusFromFile(String filePathName) {
  // Créer un nouvel objet Bonus en utilisant le constructeur par défaut
  Bonus bonus = new Bonus();

  // Modifier les attributs en lisant depuis les fichiers
  bonus.bonusEffect = readTypeBonusFromFile(filePathName + "/bonusEffect.txt");
  bonus.cellX = readIntFromFile(filePathName + "/cellX.txt");
  bonus.cellY = readIntFromFile(filePathName + "/cellY.txt");
  bonus.position = readPVectorFromFile(filePathName + "/position.txt");
  bonus.animationIndex = readIntFromFile(filePathName + "/animationIndex.txt");
  bonus.size = readIntFromFile(filePathName + "/size.txt");

  // Retourner l'objet Bonus modifié
  return bonus;
}
Bonus[] readBonusArrayFromFile(String filePathName) {
  int length = readIntFromFile(filePathName+"/length.txt");
  Bonus[] bonusArray = new Bonus[length];

  // Lire les données depuis chaque fichier et mettre à jour le tableau d'objets Enemy
  for (int indexBonus = 0; indexBonus < bonusArray.length; indexBonus++) {
    bonusArray[indexBonus] = readBonusFromFile(filePathName+"/Bonus"+str(indexBonus));
  }

  // Retourner le tableau d'objets Enemy mis à jour
  return bonusArray;
}
TypeEnemy readTypeEnemyFromFile(String filePathName) {
  // Charger les lignes du fichier dans un tableau de chaînes
  String[] lines = loadStrings(filePathName);

  // Vérifier si le fichier est vide
  

  // Lire la première ligne du fichier et convertir en TypeEnemy
  switch (lines[0]) {
    case "ENEMY_STAND":
      return TypeEnemy.ENEMY_STAND;
    case "ENEMY_EVOLVED":
      return TypeEnemy.ENEMY_EVOLVED;
    // Ajoutez d'autres cas selon les besoins
    default:
      return null;  // Valeur par défaut en cas de correspondance non trouvée
  }
}
Board readBoardFromFile(String filePathName) {
  // Créer un nouveau Board avec le constructeur par défaut
  Board board = new Board();

  // Mettre à jour les attributs en lisant les données depuis les fichiers
  board.cells = readArrayCellFromFile(filePathName + "/cells.txt");
  board.drawPosition = readPVectorFromFile(filePathName + "/drawPosition.txt");
  board.drawSize = readPVectorFromFile(filePathName + "/drawSize.txt");
  board.nbCellsX = readIntFromFile(filePathName + "/nbCellsX.txt");
  board.nbCellsY = readIntFromFile(filePathName + "/nbCellsY.txt");
  board.cellSize = readIntFromFile(filePathName + "/cellSize.txt");
  board.animationTime_DESTRUCTIBLE_WALL = millis();
  board.animationTime_EXIT_DOOR = millis();
  board.animationIndex_DESTRUCTIBLE_WALL = readIntFromFile(filePathName + "/animationIndex_DESTRUCTIBLE_WALL.txt");
  board.animationIndex_EXIT_DOOR = readIntFromFile(filePathName + "/animationIndex_EXIT_DOOR.txt");
  board.exitDoorAvailable = readBooleanFromFile(filePathName + "/exitDoorAvailable.txt");
  board.tableDestructionAttributs = readArray3dFloatFromFile(filePathName + "/tableDestructionAttributs.txt");
  board.bonusArray = readBonusArrayFromFile(filePathName + "/bonusArray");

  // Retourner le Board mis à jour
  return board;
}
Bomb readBombFromFile(String filePathName) {
  // Créer un nouvel objet Bomb avec le constructeur par défaut
  Bomb bomb = new Bomb();

  // Mettre à jour les attributs en lisant les données depuis les fichiers
  bomb.placementTime = millis();
  bomb.timeToExplode = readFloatFromFile(filePathName + "/timeToExplode.txt");
  bomb.placementTime = -bomb.timeToExplode - 1;
  bomb.cellX = readIntFromFile(filePathName + "/cellX.txt");
  bomb.cellY = readIntFromFile(filePathName + "/cellY.txt");
  bomb.explosionRadius = readIntFromFile(filePathName + "/explosionRadius.txt");
  bomb.position = readPVectorFromFile(filePathName + "/position.txt");
  bomb.animationTime = millis();
  bomb.animationIndex = readIntFromFile(filePathName + "/animationIndex.txt");
  bomb.infectedCellPositions_UP = readArray2dIntFromFile(filePathName + "/infectedCellPositions_UP.txt");
  bomb.infectedCellPositions_DOWN = readArray2dIntFromFile(filePathName + "/infectedCellPositions_DOWN.txt");
  bomb.infectedCellPositions_LEFT = readArray2dIntFromFile(filePathName + "/infectedCellPositions_LEFT.txt");
  bomb.infectedCellPositions_RIGHT = readArray2dIntFromFile(filePathName + "/infectedCellPositions_RIGHT.txt");
  bomb.checkExplosion = readBooleanFromFile(filePathName + "/checkExplosion.txt");
  bomb.explosionTime = millis();;
  bomb.explosionEffect = readBooleanFromFile(filePathName + "/explosionEffect.txt");
  bomb.exploded = readBooleanFromFile(filePathName + "/exploded.txt");
  bomb.board = readBoardFromFile(filePathName + "/board");

  // Retourner l'objet Bomb mis à jour
  return bomb;
}
Bomb[] readBombArrayFromFile(String filePathName) {
  int length = readIntFromFile(filePathName+"/length.txt");
  Bomb[] bombArray = new Bomb[length];

  // Lire les données depuis chaque fichier et mettre à jour le tableau d'objets Enemy
  for (int indexBomb = 0; indexBomb < bombArray.length; indexBomb++) {
    bombArray[indexBomb] = readBombFromFile(filePathName+"/Bomb"+str(indexBomb));
  }

  // Retourner le tableau d'objets Enemy mis à jour
  return bombArray;
}
Enemy readEnemyFromFile(String filePathName) {
  // Créer un nouvel objet Enemy avec le constructeur par défaut
  Enemy enemy = new Enemy();

  // Mettre à jour les attributs en lisant les données depuis les fichiers
  enemy.spawnTime = millis();
  enemy.enemyType = readTypeEnemyFromFile(filePathName + "/enemyType.txt");
  enemy.healthPoint = readIntFromFile(filePathName + "/healthPoint.txt");
  enemy.cellX = readIntFromFile(filePathName + "/cellX.txt");
  enemy.cellY = readIntFromFile(filePathName + "/cellY.txt");
  enemy.board = readBoardFromFile(filePathName + "/board");
  enemy.animationTime =millis();
  enemy.animationIndex = readIntFromFile(filePathName + "/animationIndex.txt");
  enemy.position = readPVectorFromFile(filePathName + "/position.txt");
  enemy.direction = readFloatFromFile(filePathName + "/direction.txt");
  enemy.size = readPVectorFromFile(filePathName + "/size.txt");
  enemy.lastTimeMoved = millis();
  enemy.speedEnemy = readIntFromFile(filePathName + "/speedEnemy.txt");
  enemy.wasHit = readBooleanFromFile(filePathName + "/wasHit.txt");
  enemy.immune = readBooleanFromFile(filePathName + "/immune.txt");
  enemy.immuneTime = millis();
  enemy.enemyScore = readIntFromFile(filePathName + "/enemyScore.txt");
  enemy.canDropBonus = readBooleanFromFile(filePathName + "/canDropBonus.txt");

  // Retourner l'objet Enemy mis à jour
  return enemy;
}
Enemy[] readEnemyArrayFromFile(String filePathName) {
  int length = readIntFromFile(filePathName+"/length.txt");
  Enemy[] enemyArray = new Enemy[length];

  // Lire les données depuis chaque fichier et mettre à jour le tableau d'objets Enemy
  for (int indexEnemy = 0; indexEnemy < enemyArray.length; indexEnemy++) {
    enemyArray[indexEnemy] = readEnemyFromFile(filePathName+"/Enemy"+str(indexEnemy));
  }

  // Retourner le tableau d'objets Enemy mis à jour
  return enemyArray;
}
Hero readHeroFromFile(String filePathName) {
  // Créer un nouvel objet Hero avec le constructeur par défaut
  Hero hero = new Hero();

  // Mettre à jour les attributs en lisant les données depuis les fichiers
  hero.healthPoint = readIntFromFile(filePathName + "/healthPoint.txt");
  hero.position = readPVectorFromFile(filePathName + "/position.txt");
  hero.board = readBoardFromFile(filePathName + "/board");
  hero.cellX = readIntFromFile(filePathName + "/cellX.txt");
  hero.cellY = readIntFromFile(filePathName + "/cellY.txt");
  hero.size = readPVectorFromFile(filePathName + "/size.txt");
  hero.wasHit = readBooleanFromFile(filePathName + "/wasHit.txt");
  hero.damaged = readBooleanFromFile(filePathName + "/damaged.txt");
  hero.isMoving = false;
  hero.animationTime = millis();
  hero.animationIndex = readIntFromFile(filePathName + "/animationIndex.txt");
  hero.heroDirection = readFloatFromFile(filePathName + "/heroDirection.txt");
  hero.bombArray = readBombArrayFromFile(filePathName + "/bombArray");
  hero.bombLimit = readIntFromFile(filePathName + "/bombLimit.txt");
  hero.heroBombRadius = readIntFromFile(filePathName + "/heroBombRadius.txt");
  hero.lastTimePlacedBomb = millis();
  hero.animationIndexDeath = readIntFromFile(filePathName + "/animationIndexDeath.txt");
  hero.restartPosition = readBooleanFromFile(filePathName + "/restartPosition.txt");
  hero.timeLeft = readIntFromFile(filePathName + "/timeLeft.txt");
  hero.immune = readBooleanFromFile(filePathName+"/immune.txt");
  hero.immuneDeltaTime = readIntFromFile(filePathName+"/immuneDeltaTime.txt");
  hero.immuneAnimationIndex = 0;

  // Retourner l'objet Hero mis à jour
  return hero;
}
Game readGameFromFile(String filePathName) {
  // Créer un nouvel objet Game avec le constructeur par défaut
  Game game = new Game();

  // Mettre à jour les attributs en lisant les données depuis les fichiers
  game.board = readBoardFromFile(filePathName + "/board");
  game.hero = readHeroFromFile(filePathName + "/hero");
  game.enemyArray = readEnemyArrayFromFile(filePathName + "/enemyArray");
  game.restartPositionCellX = readIntFromFile(filePathName + "/restartPositionCellX.txt");
  game.restartPositionCellY = readIntFromFile(filePathName + "/restartPositionCellY.txt");
  game.lastTimeSpawned =-readFloatFromFile(filePathName + "/lastTimeSpawned.txt") -1;
  game.winDoorCellX = readIntFromFile(filePathName + "/winDoorCellX.txt");
  game.winDoorCellY = readIntFromFile(filePathName + "/winDoorCellY.txt");
  game.gameWon = readBooleanFromFile(filePathName + "/gameWon.txt");
  game.gameLost = readBooleanFromFile(filePathName + "/gameLost.txt");
  game.gameScore = readIntFromFile(filePathName + "/gameScore.txt");
  game.bonusArray = readBonusArrayFromFile(filePathName + "/bonusArray");
  game.deltaTimeLife = readIntFromFile(filePathName +"/deltaTimeLife.txt");
  game.gameElapsedTime = millis();

  // Retourner l'objet Game mis à jour
  return game;
}
