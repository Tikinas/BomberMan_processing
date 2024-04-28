//function to stock the game sprites in arrays
PImage[][] loadSpritesTable( String pathImage, int numberSpriteHorizontal, int numberSpriteVertical , int spriteSizeWidth , int spriteSizeHeight ) {
  PImage[][] spriteArray = new PImage[numberSpriteVertical][numberSpriteHorizontal];
  PImage imageSprite = loadImage(pathImage);
  PImage spriteTemp;
  for ( int indexX = 0; indexX < spriteArray[0].length; indexX++ ) {
    for ( int indexY = 0; indexY < spriteArray.length; indexY++ ) {
      spriteTemp = imageSprite.get( indexX * spriteSizeWidth, indexY * spriteSizeHeight, spriteSizeWidth, spriteSizeHeight);
      spriteArray[indexY][indexX] = spriteTemp ;
    }
  }
  return spriteArray ; 
}
//font of the game 
PFont arcadeClassic;
//we initialize all the needed sprite to use it in the draw function in each class
PImage[][] wallEdge ;
PImage[][] normalWall ;
PImage[][] enemyType_STAND;
PImage[][] enemyType_EVOLVED;
PImage[][] descWall;
PImage[][] bombAnimation ;
PImage[][] bomberManSprites;
PImage[][] bonusAnimation;
PImage[][] grassCarte;
PImage[][] exitDoor;
PImage[][] bombFireAnimation;
PImage[][] wallDestruction;
PImage[] bomberAnimation_RIGHT;
PImage[] bomberAnimation_DOWN;
PImage[] bomberAnimation_LEFT;
PImage[] bomberAnimation_UP;
PImage playerHUD;
PImage clockTiming;
PImage buttonDisplay;
PImage backGround;
PImage gameOver;
int[] bomberMovingPattern_LEFT_RIGHT = {0,1,2,1};
int[] bomberMovingPattern_UP_DOWN = {2,1,0,1};
int[] bombPattern_Before = {0,1,2,1,0,1,2,1,0};
int[] bombPattern_After = {0,1,2,3,4,3,2,1,0};
int[] enemyPattern_STAND = {0,1,2,3,2,1};
int[] enemyPattern_EVOLVED = {0,1,2,3,4,5,4,3,2,1};
