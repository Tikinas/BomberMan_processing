TypeCell[][] levelBoardDetector(String levelPath) {
  String[] arrayStrings = loadStrings(levelPath);
  TypeCell[][] arrayCells = new TypeCell[arrayStrings.length][arrayStrings[0].length()];
  for ( int indexX = 0; indexX < arrayCells.length; indexX++ ) {
    String[] currentLineText = new String[arrayCells[0].length];
    currentLineText = arrayStrings[indexX].split("");
    for ( int indexY = 0; indexY < arrayCells[0].length; indexY++) {
      switch(currentLineText[indexY]) {
      case "v" :
        TypeCell cellEmpty1 = TypeCell.EMPTY;
        arrayCells[indexX][indexY] = cellEmpty1;
        break;
      case "x" :
        TypeCell cellWall = TypeCell.WALL;
        arrayCells[indexX][indexY] = cellWall;
        break;
      case "o" :
        TypeCell cellDescWall = TypeCell.DESTRUCTIBLE_WALL;
        arrayCells[indexX][indexY] = cellDescWall;
        break;
      case "S" :
        TypeCell cellExitDoor = TypeCell.EXIT_DOOR;
        arrayCells[indexX][indexY] = cellExitDoor;
        break;
      case "M" :
        TypeCell cellEmpty3 = TypeCell.EMPTY;
        arrayCells[indexX][indexY] = cellEmpty3;
        break;
      case "E" :
        TypeCell cellEmpty4 = TypeCell.EMPTY;
        arrayCells[indexX][indexY] = cellEmpty4;
        break;
      case "B" :
        TypeCell cellEmpty5 = TypeCell.EMPTY;
        arrayCells[indexX][indexY] = cellEmpty5;
        break;
      default :
      println(currentLineText[indexY]);
      println(indexY,indexX);
      break;
      }
    }
  }
  for ( int indexY = 0; indexY < arrayCells.length ; indexY++){
    for ( int indexX = 0; indexX < arrayCells[0].length ; indexX++){
      if (arrayCells[indexY][indexX] == null){
        println(indexY,indexX);
      }
    
    
  }
    
  }
  return arrayCells;
}
int[][] heroMonsterPositionDetector(String levelPath) {
  int[][] resultPosition = new int[0][0];
  String[] arrayStrings = loadStrings(levelPath);
  for ( int indexLine = 0; indexLine < arrayStrings.length; indexLine++) {
    String[] currentLineText = arrayStrings[indexLine].split("");
    for ( int indexCol = 0; indexCol < currentLineText.length; indexCol++) {
      switch(currentLineText[indexCol]) {
      //position of the bomber man, 0 stand for hero
        case "B":
        resultPosition = appendInteger3(resultPosition,indexCol,indexLine,0);
        break;
      //position of the monster stand, 1 stand for monster stand
      case "M":
      resultPosition = appendInteger3(resultPosition,indexCol,indexLine,1);
        break;
      //position fo the evolved monster, 2 stand for monster evolved 
      case "E":
      resultPosition = appendInteger3(resultPosition,indexCol,indexLine,2);
        break;
      }
    }
  }
  return resultPosition;
}
PVector minIndexArray(float[][] arrayFloat) {
  PVector minIndex = new PVector(0, 0);
  for (int indexX = 0; indexX < arrayFloat.length; indexX++) {
    for (int indexY = 0; indexY< arrayFloat[0].length; indexY++) {
      if (arrayFloat[indexX][indexY] <= arrayFloat[int(minIndex.x)][int(minIndex.y)]) {
        minIndex = new PVector(indexX, indexY);
      }
    }
  }
  return minIndex;
}
PImage[] extractImageArray(PImage[][] array2dImage, int lineExtract, int posExtract) {
  PImage[] extractedImage = new PImage[3];
  for ( int index = 0; index < 3; index ++) {
    extractedImage[index] = array2dImage[lineExtract][posExtract + index];
  }
  return extractedImage;
}
int incrementIndex(int currentIndex, int limit) {
  return (currentIndex+1)%limit;
}
int[][] appendInteger2(int[][] initialArray, int valX, int valY) {
  int[][] newArray = new int[initialArray.length+1][2];
  for ( int index = 0; index < initialArray.length; index++) {
    newArray[index][0] = initialArray[index][0];
    newArray[index][1] = initialArray[index][1];
  }
  newArray[newArray.length-1][0] = valX;
  newArray[newArray.length-1][1] = valY;
  return newArray;
}
int[][] appendInteger3(int[][] initialArray, int valX, int valY, int valZ) {
  int[][] newArray = new int[initialArray.length+1][3];
  for ( int index = 0; index < initialArray.length; index++) {
    newArray[index][0] = initialArray[index][0];
    newArray[index][1] = initialArray[index][1];
    newArray[index][2] = initialArray[index][2];
  }
  newArray[newArray.length-1][0] = valX;
  newArray[newArray.length-1][1] = valY;
  newArray[newArray.length-1][2] = valZ;
  return newArray;
}
String getCurrentDateTime() {
  // Obtenir les composants de la date
  int year = year();
  int month = month();
  int day = day();
  int hour = hour();
  int minute = minute();
  int second = second();
  String formattedDateTime = nf(year, 4) + "_" + nf(month, 2) + "_" + nf(day, 2) + " Time " +
                        
                             nf(hour, 2) + "_" + nf(minute, 2) + "_" + nf(second, 2);

  return formattedDateTime;
}
String[] writeOnfile(String fileNamePath,String textToWrite){
  String[] initialContent = loadStrings(fileNamePath);
  String[] newContent = new String[initialContent.length+1];
  for (int numLine = 0; numLine < initialContent.length;numLine++){
    newContent[numLine] = initialContent[numLine];
  }
  newContent[newContent.length - 1] = textToWrite;
  return newContent;
}
void generateRandomLevel() {
  int rows = 13; 
  int cols = 15; 
  String[] board = new String[rows];
  for (int i = 0; i < rows; i++) {
    StringBuilder row = new StringBuilder();
    for (int j = 0; j < cols; j++) {
      if (i == 0 || i == rows - 1 || j == 0 || j == cols - 1 || (i % 2 == 0 && j % 2 == 0) ) {
        row.append("x"); 
      } else if (i == 1 && j == 1) {
        row.append("B"); 
      } else if (random(1) < 0.42) {
        row.append("o"); 
      }else if(random(1)<0.1){
        row.append("x");          
      } else {
        row.append("v"); 
      }
    }
    board[i] = row.toString();
  }
  int exitRow = int(random(1, rows - 1));
  int exitCol = int(random(1, cols - 1));
  board[exitRow] = board[exitRow].substring(0, exitCol) + "S" + board[exitRow].substring(exitCol + 1);
  for (int i = 0; i < 3; i++) {
    int monsterRow, monsterCol;
    do {
      monsterRow = int(random(1, rows - 1));
      monsterCol = int(random(1, cols - 1));
    } while (board[monsterRow].charAt(monsterCol) != 'v'); // Répéter jusqu'à trouver une case vide
    board[monsterRow] = board[monsterRow].substring(0, monsterCol) + "M" + board[monsterRow].substring(monsterCol + 1);
  }  
  for (int i = 0; i < 2; i++) {
    int enemyRow, enemyCol;
    do {
      enemyRow = int(random(1, rows - 1));
      enemyCol = int(random(1, cols - 1));
    } while (board[enemyRow].charAt(enemyCol) != 'v'); // Répéter jusqu'à trouver une case vide
    board[enemyRow] = board[enemyRow].substring(0, enemyCol) + "E" + board[enemyRow].substring(enemyCol + 1);
  }
  for (int i = 0; i < 1; i++) { 
    int evolvedEnemyRow, evolvedEnemyCol;
    do {
      evolvedEnemyRow = int(random(1, rows - 1));
      evolvedEnemyCol = int(random(1, cols - 1));
    } while (board[evolvedEnemyRow].charAt(evolvedEnemyCol) != 'v'); // Répéter jusqu'à trouver une case vide
    board[evolvedEnemyRow] = board[evolvedEnemyRow].substring(0, evolvedEnemyCol) + "x" + board[evolvedEnemyRow].substring(evolvedEnemyCol + 1);
  }
  saveStrings("levels/levelRandom.txt", board);
}
