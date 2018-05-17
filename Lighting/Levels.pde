final int NUM_LEVELS = 8;
int whichLevel = 0;
float floorthicc = 20;

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

private void addTriangle(float x1, float y1, float x2, float y2, float x3, float y3) {
  Solid newTriangle = new Solid(); //<>//
  newTriangle.addPoint(x1,y1); //<>//
  newTriangle.addPoint(x2,y2);
  newTriangle.addPoint(x3,y3);
  solids.add(newTriangle);
}

private void addEnd(float x, float y) {
  finish = new Finish(x, y);
  finish.add();
}

private void addDot(float x, float y) {
  addBlock(x, y, x+4, y+4);
}

public void clearLevel() {
  move = false;
  solids.clear();
  balls.clear();
  lights.clear();
  lightManager.removeLights();
}

public void loadLevel(int l) {
  float wallthicc = 5 * width;
  
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
    
    case 7:
      move = true;
    case 2:
      addBlock(0, height-floorthicc, width, height);
      addBlock(xgrid, 14*ygrid, 5.5*xgrid, 15*ygrid);
      addBlock(14.5*xgrid, 11.5*ygrid, 19*xgrid, 12.5*ygrid);
      addBlock(0.25*xgrid, 6.5*ygrid, 4.75*xgrid, 7.5*ygrid);
      addBlock(8*xgrid, 1*ygrid, 12*xgrid, 2*ygrid);
      addLight(8*xgrid, .5*ygrid);
      addLight(12*xgrid, .5*ygrid);
      addEnd(1.5*xgrid, 2.5*ygrid);
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
      
    case 4:
      addLight(10*xgrid, 10*ygrid); 
      addLight(10*xgrid, 10*ygrid); 
      addLight(10*xgrid, 10*ygrid); 
      move = true;
    case 0:
      addBlock(0, 2.5*ygrid, 17.5*xgrid, 3*ygrid);
      addBlock(3.5*xgrid, 4.5*ygrid, width, 5*ygrid);
      addBlock(0, 6.5*ygrid, 15.5*xgrid, 7*ygrid);
      addBlock(5.5*xgrid, 8.5*ygrid, width, 9*ygrid);
      addBlock(0, 10.5*ygrid, 13.5*xgrid, 11*ygrid);
      addBlock(7.5*xgrid, 12.5*ygrid, width, 13*ygrid);
      addBlock(0, 14.5*ygrid, 13.5*xgrid, 15*ygrid);
      
      addEnd(17*xgrid, 18*ygrid);
      spawn(.3, EPS, 2.5*ygrid-EPS);
      break;
      
    case 5:
      addBlock(0, height-floorthicc/2, 3*xgrid, height);
      addBlock(5*xgrid, height-floorthicc/2, 7*xgrid, height);
      addBlock(9*xgrid, height-floorthicc/2, 11*xgrid, height);
      addBlock(13*xgrid, height-floorthicc/2, 15*xgrid, height);
      addBlock(17*xgrid, height-floorthicc/2, width, height);
      
      // Random dots for lighting effects
      for (int i = 0; i < NUM_DOTS; i++) {
        double rx = Math.random() * width;  
        double ry = Math.random() * 11.5*ygrid;  
        addDot((float) rx, (float) ry);
      }
      addLight(10*xgrid, 2*ygrid); 
      addLight(2*xgrid, 2*ygrid); 
      move = true;
      
      addEnd(1.5*xgrid, height-xgrid);
      spawn(.65, 19*xgrid, height-ygrid);
      break;
      
    case 6:
      float bh = 15*ygrid;
      addTriangle(0, bh, 1*xgrid, bh-ygrid, 2*xgrid, bh);
      addTriangle(5*xgrid, bh, 6*xgrid, bh-ygrid, 7*xgrid, bh);
      addTriangle(9*xgrid, bh, 10*xgrid, bh-ygrid, 11*xgrid, bh);
      addTriangle(13*xgrid, bh, 14*xgrid, bh-ygrid, 15*xgrid, bh);
      addTriangle(18*xgrid, bh, 19*xgrid, bh-ygrid, width, bh);      
      
      // Random dots for lighting effects
      for (int i = 0; i < 2.25 * NUM_DOTS; i++) {
        double rx = Math.random() * width;  
        double ry = height - (Math.random() * (height-bh));  
        addDot((float) rx, (float) ry);
      }      
      
      addLight(10*xgrid, 18*ygrid);
      move = true;
      
      addEnd(xgrid, 7.5*ygrid);
      spawn(.75, 19*xgrid, 12*ygrid);
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
