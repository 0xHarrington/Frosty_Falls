final int NUM_LEVELS = 1;
int whichLevel = 0;
float floorthicc = height / 40;
float endx, endy;
final float FIN_RAD = 25, LIGHT_RAD = 5;

private void addBlock(float tlx, float tly, float brx, float bry) {
  Solid newBlock = new Solid();
  newBlock.addPoint(tlx, tly);
  newBlock.addPoint(brx, tly);
  newBlock.addPoint(brx, bry);
  newBlock.addPoint(tlx, bry);
  solids.add(newBlock);
}

public void addLight(float x, float y) {
  balls.add(new Ball(x, y, 225, LIGHT_RAD, false));
  Light l = new Light(x, y, color(255,255,255), 100, 255);
  lights.add(l);
  lightManager.addLight(l);  
}

private void addEnd(float x, float y) {
  balls.add(new Ball(x, y, color(119,255,119,220), FIN_RAD, true));
  endx = x;
  endy = y;
}

public void clearLevel() {
  solids.clear();
  balls.clear();
  lightManager.removeLights();
}

public void loadLevel(int l) {
  float wallthicc = width;
  
  /* FIXED DESIGN */
  // Walls
  addBlock(-wallthicc, 0, 0, height);
  addBlock(width, 0, width + wallthicc, height);
  // Ceiling
  addBlock(0, -floorthicc, width, 0);

  /* VARIABLE DESIGN */
  float xgrid = width / 20;
  float ygrid = height / 20;
  switch (l) {
    case 1: 
      addBlock(0, height-(.5*ygrid), width, height);
      addBlock(5.5*xgrid, 2*ygrid, 7*xgrid, 14.5*ygrid);
      addBlock(12*xgrid, 2*ygrid, 13.5*xgrid, 18.5*ygrid);
      addLight(9.5*xgrid, 2*ygrid);
      addEnd(16*xgrid, 17.5*ygrid);
      break;
    
    
    
    
    default:
      addEnd(15*xgrid, 5*ygrid);
      // Floors
      float gapHalfWidth = 300;
      addBlock(0, height - floorthicc, width / 2 - gapHalfWidth, height + 100);
      addBlock(width / 2 + gapHalfWidth + 100, height - floorthicc, width, height + 100);   
      
      // Platforms
      addBlock(100, 150, 300, 180);
      addBlock(610, 540, 790, 620);
      Solid shape2 = new Solid();
      
      shape2.addPoint(440, 340);
      shape2.addPoint(420, 280);
      shape2.addPoint(370, 340);
      
      // Add them
      solids.add(shape2);
      break;
  }
}
