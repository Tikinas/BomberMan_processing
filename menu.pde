class Button {
  String textDisplay;
  PVector topLeft;
  PVector size;
  boolean isTriggered;
  Button(String _textDisplay, PVector _topLeft, PVector _size) {
    textDisplay =_textDisplay;
    topLeft = _topLeft;
    size =_size;
    isTriggered = false;
  }
  void updateIsTriggered() {
    if (mouseX >=topLeft.x && mouseY>=topLeft.y && mouseX <=(topLeft.x+size.x) && mouseY<=(topLeft.y+size.y) ) {
      isTriggered = true;
    }
  }
  void drawIt() {
    imageMode(CORNER);
    image(buttonDisplay, topLeft.x, topLeft.y, int(size.x), int(size.y));
    textMode(CORNER);
    textAlign(CENTER);
    textFont(arcadeClassic);
    textSize(30);
    text(textDisplay, (2*topLeft.x+size.x)/2+5, (2*topLeft.y+size.y)/2+5);
  }
}

class Menu {
  boolean mainMenu;
  boolean pauseMenu;
  boolean gameInProcess;
  Button[] mainMenuButtons;
  Button[] pauseMenuButtons;
  boolean gameOverStatus;
  float lastTimePlayerLost;
  Menu() {
    mainMenu = true;
    pauseMenu = false;
    gameInProcess = false;
    mainMenuButtons = new Button[9];
    pauseMenuButtons = new Button[5];
    mainMenuButtons[0]= new Button("New Game", new PVector(279, 422), new PVector(200, 50));
    mainMenuButtons[1]=new Button("Load Game", new PVector(279, 522), new PVector(200, 50));
    mainMenuButtons[2]=new Button("Quit", new PVector(279, 622), new PVector(200, 50));
    mainMenuButtons[3]=new Button("Best Scores", new PVector(30, 190), new PVector(300, 70));
    mainMenuButtons[4]=new Button("", new PVector(70, 260), new PVector(200, 50));
    mainMenuButtons[5]=new Button("", new PVector(70, 310), new PVector(200, 50));
    mainMenuButtons[6]=new Button("", new PVector(70, 360), new PVector(200, 50));
    mainMenuButtons[7]=new Button("", new PVector(70, 410), new PVector(200, 50));
    mainMenuButtons[8]=new Button("", new PVector(70, 460), new PVector(200, 50));
    pauseMenuButtons[0]= new Button("Resume", new PVector(56, 42), new PVector(200, 50));
    pauseMenuButtons[1]= new Button("Restart", new PVector(56, 105), new PVector(200, 50));
    pauseMenuButtons[2]= new Button("LoadGame", new PVector(540, 42), new PVector(200, 50));
    pauseMenuButtons[3]= new Button("To Menu", new PVector(540, 105), new PVector(200, 50));
    pauseMenuButtons[4] = new Button("Save Game", new PVector(300, 105), new PVector(200, 50));
    gameOverStatus = false;
  }

  void drawIt() {
    if (mainMenu) {
      imageMode(CORNERS);
      image(backGround, 0, 0, 800, 800);
      mainMenuButtons[4]=new Button(bestScores[0], new PVector(70, 260), new PVector(200, 50));
      mainMenuButtons[5]=new Button(bestScores[1], new PVector(70, 310), new PVector(200, 50));
      mainMenuButtons[6]=new Button(bestScores[2], new PVector(70, 360), new PVector(200, 50));
      mainMenuButtons[7]=new Button(bestScores[3], new PVector(70, 410), new PVector(200, 50));
      mainMenuButtons[8]=new Button(bestScores[4], new PVector(70, 460), new PVector(200, 50));
      for ( int indexButton = 0; indexButton<mainMenuButtons.length; indexButton++) {
        mainMenuButtons[indexButton].drawIt();
      }
    } else if (pauseMenu) {
      fill(0);
      rectMode(CORNERS);
      rect(0, 0, 800, 164);
      fill(255);
      for ( int indexButton = 0; indexButton<pauseMenuButtons.length; indexButton++) {
        pauseMenuButtons[indexButton].drawIt();
      }
    } else if (gameInProcess) {
      globalGame.update();
      globalGame.drawIt();
      globalGame.handleKey();
      handleKey();
      updateWinCondition();
    } else if (gameOverStatus) {
      imageMode(CENTER);
      tint(255, 165, 0);
      image(gameOver, width/2, height/2, 800, 800);
      noTint();
      if (millis() - lastTimePlayerLost>=5000) {
        String[] newScores = writeOnfile("Scores/scores.txt", str(globalGame.gameScore));
        saveStrings("Scores/scores.txt", newScores);
        bestScores = bestScoresSort();
        gameOverStatus = false;
        mainMenu = true;
      }
    }
  }

  void update() {
    if (mainMenu) {
      if (mainMenuButtons[0].isTriggered) {
        generateRandomLevel();
        globalGame = new Game("levels/levelRandom.txt");
        mainMenuButtons[0].isTriggered = false;
        mainMenu = false;
        gameInProcess = true;
      } else if (mainMenuButtons[1].isTriggered) {
        selectFolder("Navigate to the savedGame folder with your mouse else the program will crash, dont mess with the files!", "loadGameFromSelection" );
        mainMenuButtons[1].isTriggered = false;
      } else if (mainMenuButtons[2].isTriggered) {
        exit();
      }
    } else if (pauseMenu) {
      if (pauseMenuButtons[0].isTriggered) {
        pauseMenu = false;
        gameInProcess = true;
        pauseMenuButtons[0].isTriggered = false;
      } else if (pauseMenuButtons[1].isTriggered) {
        generateRandomLevel();
        globalGame = new Game("levels/levelRandom.txt");
        pauseMenu = false;
        gameInProcess = true;
        pauseMenuButtons[1].isTriggered = false;
      } else if (pauseMenuButtons[2].isTriggered) {
        selectFolder("Navigate to the savedGame folder with your mouse else the program will crash, dont mess with the files!", "loadGameFromSelection");
        pauseMenuButtons[2].isTriggered = false;
      } else if (pauseMenuButtons[3].isTriggered) {
        globalGame = new Game();
        mainMenu = true;
        pauseMenu = false;
        pauseMenuButtons[3].isTriggered = false;
      } else if (pauseMenuButtons[4].isTriggered) {
        String saveDateTime = getCurrentDateTime();
        println("savedGames/"+saveDateTime);
        writeGameToFile(globalGame, "savedGames/"+saveDateTime);
        pauseMenuButtons[4].isTriggered = false;
      }
    }
  }

  void updateWinCondition( ) {
    if ( globalGame != null) {
      if (!globalGame.gameLost) {
        if (globalGame.hero.cellX == globalGame.winDoorCellX && globalGame.hero.cellY == globalGame.winDoorCellY && globalGame.enemyArray.length == 0) {
          int currentHealthPoint = globalGame.hero.healthPoint;
          int currentBombRadius = globalGame.hero.heroBombRadius;
          int currentBombLimit = globalGame.hero.bombLimit;
          int currentGameScore = globalGame.gameScore;
          generateRandomLevel();
          globalGame = new Game("levels/levelRandom.txt");
          globalGame.hero.healthPoint = currentHealthPoint;
          globalGame.hero.heroBombRadius = currentBombRadius;
          globalGame.hero.bombLimit = currentBombLimit;
          globalGame.gameScore = currentGameScore;
        }
      } else {
        gameInProcess = false;
        lastTimePlayerLost = millis();
        gameOverStatus = true;
      }
    }
  }

  void handleMouse() {
    if (mainMenu) {
      for ( int indexButton = 0; indexButton<mainMenuButtons.length; indexButton++) {
        mainMenuButtons[indexButton].updateIsTriggered();
      }
    } else if (pauseMenu) {
      for ( int indexButton = 0; indexButton<pauseMenuButtons.length; indexButton++) {
        pauseMenuButtons[indexButton].updateIsTriggered();
      }
    }
  }
  void handleKey() {
    if (gameInProcess) {
      if (keysTrigered[5]) {
        gameInProcess = false;
        pauseMenu = true;
      }
    }
  }
  void drawBestScores() {
  }
}
void loadGameFromSelection(File savedDataSelected) {
  if (savedDataSelected != null) {
    globalGame = readGameFromFile(savedDataSelected.getAbsolutePath());
    if (globalMenu.mainMenu) {
      globalMenu.mainMenu = false;
      globalMenu.gameInProcess = true;
    } else if (globalMenu.pauseMenu) {
      globalMenu.pauseMenu = false;
      globalMenu.gameInProcess = true;
    }
  }
}
String[] bestScoresSort() {
  String[] scoresStringArray = loadStrings("Scores/scores.txt");
  int[] scoresIntArray = new int[scoresStringArray.length];
  for ( int index = 0; index< scoresStringArray.length; index++) {
    scoresIntArray[index] = int(scoresStringArray[index]);
  }
  int startIndexSort = scoresIntArray.length;
  boolean swaped = false;
  for ( int indexTime = 0; indexTime < startIndexSort; indexTime++) {
    for ( int indexSort = 0; indexSort < scoresIntArray.length - 1; indexSort++) {
      if ( scoresIntArray[indexSort] < scoresIntArray[indexSort + 1]) {
        swaped = true;
        int tempSwapVariable = scoresIntArray[indexSort];
        scoresIntArray[indexSort] = scoresIntArray[indexSort + 1 ];
        scoresIntArray[indexSort + 1] = tempSwapVariable;
      }
    }
    if (swaped) {
      swaped = false;
      startIndexSort --;
    }
  }
  String[] resultScores = new String[5];
  for ( int index = 0; index < 5; index ++) {
    if (index > scoresIntArray.length - 1 ) {
      resultScores[index] = str(0);
    } else {
      resultScores[index] = str(scoresIntArray[index]);
    }
  }
  return resultScores;
}
