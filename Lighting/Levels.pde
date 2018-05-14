final int NUM_LEVELS = 4;
int whichLevel = 0;
float floorthicc = 20;
float endx, endy;

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
  balls.add(new Ball(x, y, color(119,255,119,240), FIN_RAD, true));
  endx = x;
  endy = y;
}

public void clearLevel() {
  move = false;
  endx = INFINITY;
  endy = INFINITY;
  solids.clear();
  balls.clear();
  lights.clear();
  lightManager.removeLights();
}

public void loadLevel(int l) {
  float wallthicc = 2*width;
  
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
      addBlock(0, height-floorthicc, width, height);
      addBlock(5.5*xgrid, 2*ygrid, 7*xgrid, 14.5*ygrid);
      addBlock(12*xgrid, 2*ygrid, 13.5*xgrid, 18.5*ygrid);
      addLight(9.5*xgrid, 2*ygrid);
      addEnd(16*xgrid, 17.5*ygrid);
      spawn(.5, 20, height-floorthicc);
      break;
    
    case 2:
      addBlock(0, height-floorthicc, width, height);
      addBlock(xgrid, 14*ygrid, 5.5*xgrid, 15*ygrid);
      addBlock(14.5*xgrid, 11.5*ygrid, 19*xgrid, 12.5*ygrid);
      addBlock(0.25*xgrid, 6.5*ygrid, 4.75*xgrid, 7.5*ygrid);
      addBlock(8*xgrid, 1*ygrid, 12*xgrid, 2*ygrid);
      addLight(8*xgrid, .5*ygrid);
      addLight(12*xgrid, .5*ygrid);
      addEnd(15, 15);
      spawn(.5, 20, height-floorthicc);
      break;
      
    case 3:
      addBlock(0, 3*ygrid, 9.25*xgrid, 3.5*ygrid);
      addBlock(10.75*xgrid, 3*ygrid, width, 3.5*ygrid);
      addBlock(0, 17.5*ygrid, 9.75*xgrid, 18*ygrid);
      addBlock(10.25*xgrid, 17.5*ygrid, width, 18*ygrid);
      addLight(1*xgrid, 11*ygrid);
      addLight(19*xgrid, 11*ygrid);
      addEnd(10*xgrid, 19*ygrid);
      spawn(.3, EPS, 2.5*ygrid-EPS);
      break;
      
    default:
      addEnd(15*xgrid, 5*ygrid);
      // Floors
      float gapHalfWidth = 300;
      addBlock(0, height - floorthicc, width / 2 - gapHalfWidth, height + 100);
      addBlock(width / 2 + gapHalfWidth + 100, height - floorthicc, width, height + 100);   
      
      // Platforms
      addBlock(50, 130, 300, 180);
      addBlock(610, 540, 790, 620);

      Solid shape2 = new Solid();
      shape2.addPoint(470, 340);
      shape2.addPoint(420, 280);
      shape2.addPoint(370, 340);
      solids.add(shape2);
      
      spawn(.65, 20, height - floorthicc);
      break;
  }
}
