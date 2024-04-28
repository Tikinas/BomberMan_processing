enum TypeBonus{
  EXTEND_RADIUS,EXTEND_BOMBS_LIMIT;
}
class Bonus{
  TypeBonus bonusEffect;
  int cellX;
  int cellY;
  PVector position;
  int animationIndex;
  int size;
  Bonus(){
  }
  Bonus( int _cellX, int _cellY,int _size, TypeBonus _bonusEffect){
    cellX = _cellX;
    cellY = _cellY;
    position = new PVector(0,0);
    bonusEffect = _bonusEffect;
    animationIndex = 0;
    size = _size;
  }
  void drawIt(){
    animationIndex = incrementIndex(animationIndex,2);
    imageMode(CENTER);
    if(bonusEffect == TypeBonus.EXTEND_RADIUS){
    image(bonusAnimation[0][2+animationIndex],position.x,position.y,size,size);
    }else{
      image(bonusAnimation[0][animationIndex],position.x,position.y,size,size);
    }
  }
}
Bonus[] appendBonus(Bonus[] initialBonusArray, Bonus bonus){
  Bonus[] newBonusArray = new Bonus[initialBonusArray.length+1];
  System.arraycopy(initialBonusArray,0,newBonusArray,0,initialBonusArray.length);
  newBonusArray[initialBonusArray.length] = bonus;
  return newBonusArray; 
}
Bonus[] removeBonus(Bonus[] initialBonusArray, int indexToRemove){
  Bonus[] newBonusArray = new Bonus[initialBonusArray.length-1];
  boolean status =false;
  for ( int index = 0; index< newBonusArray.length; index++) {
    if ( index == indexToRemove) {
      status = true;
    }
    if (!status) {
      newBonusArray[index] = initialBonusArray[index];
    } else {
      newBonusArray[index] = initialBonusArray[index+1];
    }
  }
  return newBonusArray;
}
