void writeArray2dIntToFile(int[][] array2dInteger, String filePathName) {
  String[] result = new String[array2dInteger.length];
  for ( int indexX = 0; indexX <array2dInteger.length; indexX++) {
    String currentLine = "";
    for ( int indexY = 0; indexY< array2dInteger[0].length; indexY++) {
      if (indexY == array2dInteger[0].length - 1 ) {
        currentLine+=str(array2dInteger[indexX][indexY]);
      } else {
        currentLine+=str(array2dInteger[indexX][indexY])+",";
      }
    }
    result[indexX] = currentLine;
  }
  saveStrings(filePathName, result);
}
void writeArray3dFloatToFile(float[][][] array3dFloat, String filePathName) {
  String[] result = new String[array3dFloat.length];
  for ( int indexX = 0; indexX<array3dFloat.length; indexX++) {
    String currentLine = "";
    for ( int indexY = 0; indexY<array3dFloat[0].length; indexY++) {
      String currentLine_temp = "";
      for ( int indexZ = 0; indexZ<array3dFloat[0][0].length; indexZ++) {
        if ( indexZ == array3dFloat[0][0].length -1) {
          currentLine_temp +=  str(array3dFloat[indexX][indexY][indexZ]);
        } else {
          currentLine_temp +=  str(array3dFloat[indexX][indexY][indexZ]) + ",";
        }
      }
      if ( indexY ==array3dFloat[0].length - 1 ) {
        currentLine+=currentLine_temp;
      } else {
        currentLine+=currentLine_temp+"/";
      }
    }
    result[indexX] = currentLine;
  }
  saveStrings(filePathName, result);
}
void writeBooleanToFile(boolean Value, String filePathName) {
  String[] result = new String[1];
  result[0] = str(Value);
  saveStrings(filePathName, result);
}
void writeFloatToFile(float Value, String filePathName) {
  String[] result = new String[1];
  result[0] = str(Value);
  saveStrings(filePathName, result);
}
void writeIntToFile(int Value, String filePathName) {
  String[] result = new String[1];
  result[0] = str(Value);
  saveStrings(filePathName, result);
}
void writePVectorToFile(PVector Value, String filePathName) {
  String[] result = new String[2];
  result[0] = str(Value.x);
  result[1] = str(Value.y);
  saveStrings(filePathName, result);
}
void writeTypeBonusToFile(TypeBonus Value, String filePathName) {
  String[] result = new String[1];
  if (Value == TypeBonus.EXTEND_RADIUS) {
    result[0] = "EXTEND_RADIUS";
  } else if (Value == TypeBonus.EXTEND_BOMBS_LIMIT) {
    result[0] = "EXTEND_BOMBS_LIMIT";
  }
  saveStrings(filePathName, result);
}
void writeTypeEnemyToFile(TypeEnemy Value, String filePathName) {
  String[] result = new String[1];
  if (Value == TypeEnemy.ENEMY_STAND) {
    result[0] = "ENEMY_STAND";
  } else if (Value == TypeEnemy.ENEMY_EVOLVED) {
    result[0] = "ENEMY_EVOLVED";
  }
  saveStrings(filePathName, result);
}
void writeArrayCellToFile(TypeCell[][] cellArray, String filePathName) {
  String[] result = new String[cellArray.length];
  for ( int cellY = 0; cellY <cellArray.length; cellY++) {
    String currentLine ="";
    for ( int cellX = 0; cellX <cellArray[0].length; cellX++) {
      String currentCell="";
      if (cellArray[cellY][cellX] == TypeCell.EMPTY) {
        currentCell="EMPTY";
      } else if (cellArray[cellY][cellX] == TypeCell.WALL) {
        currentCell="WALL";
      } else if (cellArray[cellY][cellX] == TypeCell.DESTRUCTIBLE_WALL) {
        currentCell="DESTRUCTIBLE_WALL";
      } else if (cellArray[cellY][cellX] == TypeCell.EXIT_DOOR) {
        currentCell="EXIT_DOOR";
      }
      if (cellX == cellArray[0].length - 1) {
        currentLine += currentCell;
      } else {
        currentLine += currentCell + "|";
      }
    }
    result[cellY] = currentLine;
  }
  saveStrings(filePathName, result);
}
void writeBonusToFile(Bonus bonus, String filePathName) {
  writeTypeBonusToFile(bonus.bonusEffect, filePathName+"/bonusEffect.txt");
  writeIntToFile(bonus.cellX, filePathName+"/cellX.txt");
  writeIntToFile(bonus.cellY, filePathName+"/cellY.txt");
  writePVectorToFile(bonus.position, filePathName+"/position.txt");
  writeIntToFile(bonus.animationIndex, filePathName+"/animationIndex.txt");
  writeIntToFile(bonus.size, filePathName+"/size.txt");
}
void writeBonusArrayToFile(Bonus[] bonusArray, String filePathName) {
  for ( int indexBonus = 0; indexBonus<bonusArray.length; indexBonus++) {
    writeBonusToFile(bonusArray[indexBonus], filePathName+"/Bonus"+str(indexBonus));
  }
  writeIntToFile(bonusArray.length, filePathName+"/length.txt");
}
void writeBoardToFile(Board board, String filePathName) {
  writeArrayCellToFile(board.cells, filePathName + "/cells.txt");
  writePVectorToFile(board.drawPosition, filePathName + "/drawPosition.txt");
  writePVectorToFile(board.drawSize, filePathName + "/drawSize.txt");
  writeIntToFile(board.nbCellsX, filePathName + "/nbCellsX.txt");
  writeIntToFile(board.nbCellsY, filePathName + "/nbCellsY.txt");
  writeIntToFile(board.cellSize, filePathName + "/cellSize.txt");
  writeFloatToFile(board.animationTime_DESTRUCTIBLE_WALL, filePathName + "/animationTime_DESTRUCTIBLE_WALL.txt");
  writeFloatToFile(board.animationTime_EXIT_DOOR, filePathName + "/animationTime_EXIT_DOOR.txt");
  writeIntToFile(board.animationIndex_DESTRUCTIBLE_WALL, filePathName + "/animationIndex_DESTRUCTIBLE_WALL.txt");
  writeIntToFile(board.animationIndex_EXIT_DOOR, filePathName + "/animationIndex_EXIT_DOOR.txt");
  writeBooleanToFile(board.exitDoorAvailable, filePathName + "/exitDoorAvailable.txt");
  writeArray3dFloatToFile(board.tableDestructionAttributs, filePathName + "/tableDestructionAttributs.txt");
  writeBonusArrayToFile(board.bonusArray, filePathName + "/bonusArray");
}
void writeBombToFile(Bomb bomb, String filePathName) {
  writeFloatToFile(bomb.placementTime, filePathName + "/placementTime.txt");
  writeFloatToFile(bomb.timeToExplode, filePathName + "/timeToExplode.txt");
  writeIntToFile(bomb.cellX, filePathName + "/cellX.txt");
  writeIntToFile(bomb.cellY, filePathName + "/cellY.txt");
  writeIntToFile(bomb.explosionRadius, filePathName + "/explosionRadius.txt");
  writePVectorToFile(bomb.position, filePathName + "/position.txt");
  writeFloatToFile(bomb.animationTime, filePathName + "/animationTime.txt");
  writeIntToFile(bomb.animationIndex, filePathName + "/animationIndex.txt");
  writeArray2dIntToFile(bomb.infectedCellPositions_UP, filePathName + "/infectedCellPositions_UP.txt");
  writeArray2dIntToFile(bomb.infectedCellPositions_DOWN, filePathName + "/infectedCellPositions_DOWN.txt");
  writeArray2dIntToFile(bomb.infectedCellPositions_LEFT, filePathName + "/infectedCellPositions_LEFT.txt");
  writeArray2dIntToFile(bomb.infectedCellPositions_RIGHT, filePathName + "/infectedCellPositions_RIGHT.txt");
  writeBooleanToFile(bomb.checkExplosion, filePathName + "/checkExplosion.txt");
  writeFloatToFile(bomb.explosionTime, filePathName + "/explosionTime.txt");
  writeBooleanToFile(bomb.explosionEffect, filePathName + "/explosionEffect.txt");
  writeBooleanToFile(bomb.exploded, filePathName + "/exploded.txt");
  writeBoardToFile(bomb.board, filePathName + "/board");
}
void writeBombArrayToFile(Bomb[] bombArray, String filePathName) {
  for ( int indexBomb = 0; indexBomb<bombArray.length; indexBomb++) {
    writeBombToFile(bombArray[indexBomb], filePathName+"/Bomb"+str(indexBomb));
  }
  writeIntToFile(bombArray.length, filePathName+"/length.txt");
}
void writeEnemyToFile(Enemy enemy, String filePathName) {
  writeFloatToFile(enemy.spawnTime, filePathName + "/spawnTime.txt");
  writeTypeEnemyToFile(enemy.enemyType, filePathName + "/enemyType.txt");
  writeIntToFile(enemy.healthPoint, filePathName + "/healthPoint.txt");
  writeIntToFile(enemy.cellX, filePathName + "/cellX.txt");
  writeIntToFile(enemy.cellY, filePathName + "/cellY.txt");
  writeBoardToFile(enemy.board, filePathName + "/board");
  writeFloatToFile(enemy.animationTime, filePathName + "/animationTime.txt");
  writeIntToFile(enemy.animationIndex, filePathName + "/animationIndex.txt");
  writePVectorToFile(enemy.position, filePathName + "/position.txt");
  writeFloatToFile(enemy.direction, filePathName + "/direction.txt");
  writePVectorToFile(enemy.size, filePathName + "/size.txt");
  writeFloatToFile(enemy.lastTimeMoved, filePathName + "/lastTimeMoved.txt");
  writeIntToFile(enemy.speedEnemy, filePathName + "/speedEnemy.txt");
  writeBooleanToFile(enemy.wasHit, filePathName + "/wasHit.txt");
  writeBooleanToFile(enemy.immune, filePathName + "/immune.txt");
  writeFloatToFile(enemy.immuneTime, filePathName + "/immuneTime.txt");
  writeIntToFile(enemy.enemyScore, filePathName + "/enemyScore.txt");
  writeBooleanToFile(enemy.canDropBonus, filePathName + "/canDropBonus.txt");
}
void writeEnemyArrayToFile(Enemy[] enemyArray, String filePathName) {
  for (int indexEnemy = 0; indexEnemy < enemyArray.length; indexEnemy++) {
    writeEnemyToFile(enemyArray[indexEnemy], filePathName+"/Enemy"+str(indexEnemy));
  }
  writeIntToFile(enemyArray.length, filePathName+"/length.txt");
}
void writeHeroToFile(Hero hero, String filePathName) {
  writeIntToFile(hero.healthPoint, filePathName + "/healthPoint.txt");
  writePVectorToFile(hero.position, filePathName + "/position.txt");
  writeBoardToFile(hero.board, filePathName + "/board");
  writeIntToFile(hero.cellX, filePathName + "/cellX.txt");
  writeIntToFile(hero.cellY, filePathName + "/cellY.txt");
  writePVectorToFile(hero.size, filePathName + "/size.txt");
  writeBooleanToFile(hero.wasHit, filePathName + "/wasHit.txt");
  writeBooleanToFile(hero.damaged, filePathName + "/damaged.txt");
  writeBooleanToFile(hero.isMoving, filePathName + "/isMoving.txt");
  writeFloatToFile(hero.animationTime, filePathName + "/animationTime.txt");
  writeIntToFile(hero.animationIndex, filePathName + "/animationIndex.txt");
  writeFloatToFile(hero.heroDirection, filePathName + "/heroDirection.txt");
  writeBombArrayToFile(hero.bombArray, filePathName + "/bombArray");
  writeIntToFile(hero.bombLimit, filePathName + "/bombLimit.txt");
  writeIntToFile(hero.heroBombRadius, filePathName + "/heroBombRadius.txt");
  writeFloatToFile(hero.lastTimePlacedBomb, filePathName + "/lastTimePlacedBomb.txt");
  writeIntToFile(hero.animationIndexDeath, filePathName + "/animationIndexDeath.txt");
  writeBooleanToFile(hero.restartPosition, filePathName + "/restartPosition.txt");
  writeIntToFile(hero.timeLeft, filePathName + "/timeLeft.txt");
  writeBooleanToFile(hero.immune,filePathName +"/immune.txt");
  writeIntToFile(hero.immuneDeltaTime,filePathName +"/immuneDeltaTime.txt");
}
void writeGameToFile(Game game, String filePathName) {
  writeBoardToFile(game.board, filePathName + "/board");
  writeHeroToFile(game.hero, filePathName + "/hero");
  writeEnemyArrayToFile(game.enemyArray, filePathName + "/enemyArray");
  writeIntToFile(game.restartPositionCellX, filePathName + "/restartPositionCellX.txt");
  writeIntToFile(game.restartPositionCellY, filePathName + "/restartPositionCellY.txt");
  writeFloatToFile(game.lastTimeSpawned, filePathName + "/lastTimeSpawned.txt");
  writeIntToFile(game.winDoorCellX, filePathName + "/winDoorCellX.txt");
  writeIntToFile(game.winDoorCellY, filePathName + "/winDoorCellY.txt");
  writeBooleanToFile(game.gameWon, filePathName + "/gameWon.txt");
  writeBooleanToFile(game.gameLost, filePathName + "/gameLost.txt");
  writeIntToFile(game.gameScore, filePathName + "/gameScore.txt");
  writeBonusArrayToFile(game.bonusArray, filePathName + "/bonusArray");
  writeIntToFile(game.deltaTimeLife,filePathName +"/deltaTimeLife.txt");
}
