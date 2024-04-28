Menu globalMenu;
Game globalGame;
String[] bestScores;
void setup() {
  //We have to put P2D as a third argument for a better performence example : size(800,800,P2D)
  size(800, 800,P2D);
  globalMenu = new Menu();
  globalGame = new Game();
  bestScores = bestScoresSort();
  arcadeClassic = createFont("data/gameFont/arcadeclassic/ARCADECLASSIC.TTF",30);
  wallEdge = loadSpritesTable( "data/img/wallEdge.png", 7, 3, 16, 16);
  normalWall = loadSpritesTable( "data/img/normalWall.png", 1, 1, 16, 16);
  enemyType_STAND = loadSpritesTable( "data/img/enemyType1.png", 8, 2, 16, 24);
  enemyType_EVOLVED = loadSpritesTable( "data/img/enemyType2.png", 6, 1, 16, 16);
  descWall = loadSpritesTable( "data/img/descWall.png", 8, 1, 16, 16);
  bombAnimation = loadSpritesTable( "data/img/bombAnimation.png", 3, 1, 16, 16);
  bomberManSprites = loadSpritesTable( "data/img/bomberManSprites.png", 6, 3, 16, 24);
  bonusAnimation = loadSpritesTable( "data/img/bonusAnimation.png", 4, 1, 16, 16);
  grassCarte = loadSpritesTable("data/img/grassCarte.png", 3, 1, 16, 16);
  exitDoor = loadSpritesTable("data/img/exitDoor.png", 2, 1, 16, 16);
  bombFireAnimation = loadSpritesTable("data/img/fireBomb.png", 10, 4, 16, 16);
  wallDestruction = loadSpritesTable("data/img/destruction.png", 6, 1, 16, 16);
  playerHUD = loadImage("data/img/PlayerHUD.png");
  clockTiming = loadImage("data/img/clockTiming.png");
  buttonDisplay = loadImage("data/img/buttonDisplay.png");
  backGround = loadImage("data/img/menuBomberMan.png");
  gameOver  = loadImage("data/img/gameOver.png");
  bomberAnimation_DOWN = extractImageArray(bomberManSprites, 0, 0);
  bomberAnimation_UP = extractImageArray(bomberManSprites, 0, 3);
  bomberAnimation_LEFT = extractImageArray(bomberManSprites, 1, 0);
  bomberAnimation_RIGHT = extractImageArray(bomberManSprites, 1, 3);
  directionUP = new PVector(0, -4);
  directionDOWN = new PVector(0, 4);
  directionLEFT = new PVector(-4, 0);
  directionRIGHT = new PVector(4, 0);
}

void draw() {
  globalMenu.update();
  globalMenu.drawIt();
}
void keyPressed() {
  if (key == 'w' || keyCode == UP) {
    keysTrigered[0] = true;
  }
  if (key == 's'|| keyCode == DOWN) {
    keysTrigered[1] = true;
  }
  if (key == 'a'|| keyCode == LEFT) {
    keysTrigered[2] = true;
  }
  if (key == 'd'|| keyCode == RIGHT) {
    keysTrigered[3] = true;
  }
  if ( key == 'p' || key == 'b') {
    keysTrigered[4] = true;
  }
  if (key ==  ENTER){
    keysTrigered[5] = true;
  }
}
void keyReleased() {
  if (key == 'w'|| keyCode == UP) {
    keysTrigered[0] = false;
  }
  if (key == 's'|| keyCode == DOWN) {
    keysTrigered[1] = false;
  }
  if (key == 'a'|| keyCode == LEFT) {
    keysTrigered[2] = false;
  }
  if (key == 'd'|| keyCode == RIGHT) {
    keysTrigered[3] = false;
  }
  if (key == 'p'|| key == 'b') {
    keysTrigered[4] = false;
  }
  if (key == ENTER){
    keysTrigered[5] = false;
  }
}
void mousePressed() {
  println(mouseX,mouseY);
  globalMenu.handleMouse();
}
