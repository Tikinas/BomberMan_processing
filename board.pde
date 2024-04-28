 enum TypeCell
{
  EMPTY, WALL, DESTRUCTIBLE_WALL, EXIT_DOOR;
}
class Board
{
  TypeCell[][] cells;
  PVector drawPosition;
  PVector drawSize;
  int nbCellsX;
  int nbCellsY;
  int cellSize; // cells should be square
  float animationTime_DESTRUCTIBLE_WALL;
  float animationTime_EXIT_DOOR;
  int animationIndex_DESTRUCTIBLE_WALL;
  int animationIndex_EXIT_DOOR;
  boolean exitDoorAvailable;
  float[][][] tableDestructionAttributs;
  Bonus[] bonusArray;
  Board(){
  }
  Board(PVector _drawPosition, PVector _drawSize, int _nbCellsY, int _nbCellsX ) {
    drawPosition = _drawPosition;
    drawSize = _drawSize;
    nbCellsX = _nbCellsX;
    nbCellsY = _nbCellsY;
    cells = new TypeCell[nbCellsY][nbCellsX];
    cellSize = int(drawSize.x/17)+int(drawSize.x/17)%2;
    animationTime_DESTRUCTIBLE_WALL= millis();
    animationTime_EXIT_DOOR = millis();
    animationIndex_DESTRUCTIBLE_WALL = 0;
    animationIndex_EXIT_DOOR = 0;
    exitDoorAvailable = false;
    bonusArray = new Bonus[0];
    tableDestructionAttributs = new float[nbCellsY][nbCellsX][5];
    for (int indexY = 0; indexY < tableDestructionAttributs.length; indexY++) {
      for (int indexX = 0; indexX < tableDestructionAttributs[0].length; indexX++) {
        tableDestructionAttributs[indexY][indexX][0] = 0;//index animation for the destruciton (we will use int() to give it as an index for the PImage 2d array)
        tableDestructionAttributs[indexY][indexX][1] = 0;//animation time for the destuction
        tableDestructionAttributs[indexY][indexX][2] = 0;//0 if not destructed 1 if not (works like a boolean)
        tableDestructionAttributs[indexY][indexX][3] = 0;//if the current cell is occupide by a bomb
        tableDestructionAttributs[indexY][indexX][4] = 0;//if the cell is occupide by enemy
      }
    }
  }
  //this method returns the coordinates of the cell center of a cell where i and j are the index of the cell in the table of cells of the board
  PVector getCellCenter(int i, int j) {
    PVector cellCenter = new PVector((1 + i) * cellSize+drawPosition.x, (j) * cellSize+drawPosition.y);
    return cellCenter;
  }

  void drawIt() {
    imageMode(CENTER);
    PVector cellCenterTopLeft;
    PVector cellCenterTopRight;
    PVector cellCenterBottomLeft;
    PVector cellCenterBottomRight;
    PVector cellCenterTemp;
    PVector cellCenterRight;
    PVector cellCenterLeft;
    if (millis() - animationTime_DESTRUCTIBLE_WALL >=1000/8) {
      animationTime_DESTRUCTIBLE_WALL = millis();
      animationIndex_DESTRUCTIBLE_WALL = incrementIndex(animationIndex_DESTRUCTIBLE_WALL, 4);
    }

    if (exitDoorAvailable) {
      animationIndex_EXIT_DOOR = incrementIndex(animationIndex_EXIT_DOOR, 2);
    }
    //we iterate each cell in the table and then we get the cell center of the cell to display the images
    for ( int cellY = 0; cellY<cells.length; cellY++ ) {
      for ( int cellX = 0; cellX<cells[0].length; cellX++ ) {
        cellCenterTemp = getCellCenter( cellX, cellY );
        //PVector cellCenterTemp = new PVector(cellCenter.x + drawPosition.x, cellCenter.y + drawPosition.y);
        switch (cells[cellY][cellX]) {
        case EMPTY :
          if (cells[cellY - 1][cellX] == TypeCell.WALL && cellY != 0 ) {
            //one with the wall shadow
            image(grassCarte[0][0], cellCenterTemp.x, cellCenterTemp.y, cellSize, cellSize);
            break;
          } else if (cells[cellY - 1][cellX] == TypeCell.DESTRUCTIBLE_WALL && cellY != 0) {
            // the one with the detructible wall shadow
            image(grassCarte[0][2], cellCenterTemp.x, cellCenterTemp.y, cellSize, cellSize);
            break;
          } else {
            // the normal grass 2d block
            image(grassCarte[0][1], cellCenterTemp.x, cellCenterTemp.y, cellSize, cellSize);
            break;
          }
        case WALL :
          if (cellY == 0) {
            if (cellX == 0) {
              //the one of the edge on the top left
              cellCenterTopLeft = getCellCenter(cellX - 1, cellY);
              //cellCenterTopLeft = new PVector(cellCenterTopLeft.x+drawPosition.x, cellCenterTopLeft.y+drawPosition.y);
              image(wallEdge[0][0], cellCenterTopLeft.x, cellCenterTopLeft.y, cellSize, cellSize);
              image(wallEdge[0][1], cellCenterTemp.x, cellCenterTemp.y, cellSize, cellSize);
              break;
            } else if (cellX == cells[0].length - 1) {
              // the of the edge on the top right
              cellCenterTopRight = getCellCenter(cellX + 1, cellY);
              //cellCenterTopRight = new PVector(cellCenterTopRight.x+drawPosition.x, cellCenterTopRight.y+drawPosition.y);
              image(wallEdge[0][5], cellCenterTopRight.x, cellCenterTopRight.y, cellSize, cellSize);
              image(wallEdge[0][4], cellCenterTemp.x, cellCenterTemp.y, cellSize, cellSize);
              break;
            } else if (cellX <= int(cells[0].length/2)) {
              //the edge normal pointing to the right
              image(wallEdge[1][6], cellCenterTemp.x, cellCenterTemp.y, cellSize, cellSize);
              break;
            } else {
              //the normal edge pointing to the left
              image(wallEdge[0][6], cellCenterTemp.x, cellCenterTemp.y, cellSize, cellSize);
              break;
            }
          } else if (cellY == cells.length - 1) {
            if (cellX == 0) {
              //the one of the edge on the bottom left
              cellCenterBottomLeft = getCellCenter(cellX - 1, cellY);
              //cellCenterBottomLeft = new PVector(cellCenterBottomLeft.x+drawPosition.x, cellCenterBottomLeft.y+drawPosition.y);
              image(wallEdge[2][0], cellCenterBottomLeft.x, cellCenterBottomLeft.y, cellSize, cellSize);
              image(wallEdge[2][1], cellCenterTemp.x, cellCenterTemp.y, cellSize, cellSize);
              break;
            } else if (cellX == cells[0].length - 1) {
              // the one of the edge on the bottom right
              cellCenterBottomRight = getCellCenter(cellX + 1, cellY);
              //cellCenterBottomRight = new PVector(cellCenterBottomRight.x+drawPosition.x, cellCenterBottomRight.y+drawPosition.y);
              image(wallEdge[2][5], cellCenterBottomRight.x, cellCenterBottomRight.y, cellSize, cellSize);
              image(wallEdge[2][4], cellCenterTemp.x, cellCenterTemp.y, cellSize, cellSize);
              break;
            } else if (cellX <= int(cells[0].length/2)) {
              //the edge normal pointing to the right
              image(wallEdge[2][3], cellCenterTemp.x, cellCenterTemp.y, cellSize, cellSize);
              break;
            } else {
              //the normal edge pointing to the left
              image(wallEdge[2][2], cellCenterTemp.x, cellCenterTemp.y, cellSize, cellSize);
              break;
            }
          } else if (cellX == 0) {
            // the one on the left edge
            cellCenterLeft = getCellCenter(cellX - 1, cellY);
            //cellCenterLeft = new PVector(cellCenterLeft.x+drawPosition.x, cellCenterLeft.y+drawPosition.y);
            image(wallEdge[1][0], cellCenterLeft.x, cellCenterLeft.y, cellSize, cellSize);
            image(wallEdge[1][1], cellCenterTemp.x, cellCenterTemp.y, cellSize, cellSize);
            break;
          } else if ( cellX == cells[0].length - 1) {
            // the one on the right edge
            cellCenterRight = getCellCenter(cellX + 1, cellY);
            //cellCenterRight = new PVector(cellCenterRight.x+drawPosition.x, cellCenterRight.y+drawPosition.y);
            image(wallEdge[1][5], cellCenterRight.x, cellCenterRight.y, cellSize, cellSize);
            image(wallEdge[1][4], cellCenterTemp.x, cellCenterTemp.y, cellSize, cellSize);
            break;
          } else {
            //the normal non destructible wall
            image(normalWall[0][0], cellCenterTemp.x, cellCenterTemp.y, cellSize, cellSize);
            break;
          }
        case DESTRUCTIBLE_WALL:
          if (tableDestructionAttributs[cellY][cellX][2] == 0) {
            if (cells[cellY - 1][cellX] == TypeCell.WALL && cellY != 0 ) {
              // the one with the wall shadow with the right animation
              image(descWall[0][animationIndex_DESTRUCTIBLE_WALL+4], cellCenterTemp.x, cellCenterTemp.y, cellSize, cellSize);
              break;
            } else {
              // the normal destructible wall with the right animation
              image(descWall[0][animationIndex_DESTRUCTIBLE_WALL], cellCenterTemp.x, cellCenterTemp.y, cellSize, cellSize);
              break;
            }
          } else {
            if (tableDestructionAttributs[cellY][cellX][0] < 6) {
              image(wallDestruction[0][int(tableDestructionAttributs[cellY][cellX][0])], cellCenterTemp.x, cellCenterTemp.y, cellSize, cellSize);
            }
            if (millis() - tableDestructionAttributs[cellY][cellX][1]>=500/4 ) {
              tableDestructionAttributs[cellY][cellX][1] = millis();
              tableDestructionAttributs[cellY][cellX][0] ++;
            }
              if ( tableDestructionAttributs[cellY][cellX][0] == 5) {
                cells[cellY][cellX] = TypeCell.EMPTY;
                boolean[] willDropBonus = { false,false , false,false,false , false,
              false, false,false,false,false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false};
                if (willDropBonus[int(random(0, 26))]) {
                  TypeBonus[] possibleBonus = {TypeBonus.EXTEND_RADIUS,TypeBonus.EXTEND_BOMBS_LIMIT};
                  Bonus currentBonus = new Bonus(cellX, cellY, cellSize, possibleBonus[int(random(0,2))]);
                  currentBonus.position = getCellCenter(cellX, cellY);
                  bonusArray = appendBonus(bonusArray, currentBonus);
                }
              }
            
            break;
          }
        case EXIT_DOOR :
          if (exitDoorAvailable) {
            // display the right animation of the exist door ;
            image(exitDoor[0][animationIndex_EXIT_DOOR], cellCenterTemp.x, cellCenterTemp.y, cellSize, cellSize);
            break;
          } else {
            if (tableDestructionAttributs[cellY][cellX][2] == 0) {
              if (cells[cellY - 1][cellX] == TypeCell.WALL && cellY != 0 ) {
                // the one with the wall shadow with the right animation
                image(descWall[0][animationIndex_DESTRUCTIBLE_WALL+4], cellCenterTemp.x, cellCenterTemp.y, cellSize, cellSize);
                break;
              } else {
                // the normal destructible wall with the right animation
                image(descWall[0][animationIndex_DESTRUCTIBLE_WALL], cellCenterTemp.x, cellCenterTemp.y, cellSize, cellSize);
                break;
              }
            } else {
              if (tableDestructionAttributs[cellY][cellX][0] < 6) {
                image(wallDestruction[0][int(tableDestructionAttributs[cellY][cellX][0])], cellCenterTemp.x, cellCenterTemp.y, cellSize, cellSize);
              }
              if (millis() - tableDestructionAttributs[cellY][cellX][1]>=500/4 ) {
                tableDestructionAttributs[cellY][cellX][1] = millis();
                tableDestructionAttributs[cellY][cellX][0] ++;
                if ( tableDestructionAttributs[cellY][cellX][0] == 6) {
                  exitDoorAvailable = true;
                }
              }
              break;
            }
          }
        }
      }
    }
  }
}
