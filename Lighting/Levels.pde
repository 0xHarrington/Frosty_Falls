final int NUM_LEVELS = 8;
int whichLevel = 1;
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

private void addTriangle(float x1, float y1, float x2, float y2, float x3, float y3) {
  Solid newTriangle = new Solid();
  newTriangle.addPoint(x1,y1);
  newTriangle.addPoint(x2,y2);
  newTriangle.addPoint(x3,y3);
  solids.add(newTriangle);
}

private void addEnd(float x, float y) {
  float radius = 40;
  int npoints = 24;
  //balls.add(new Ball(x, y, color(119,255,119,240), FIN_RAD, true));
  PShape end = createShape();
  float angle = TWO_PI / npoints;
  end.beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    end.vertex(sx, sy);
  }
  end.endShape(CLOSE);
  
  end.setFill(color(127,231,6));
  
  solids.add(new Solid(end, true));
  
  endx = x;
  endy = y;
}

private void addDot(float x, float y) {
  addBlock(x, y, x+4, y+4);
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
  PShape scene;
  /* VARIABLE DESIGN */
  float xgrid = width / 20;
  float ygrid = height / 20;
  switch (l) {
    case 1: 
      addLight(275, 5);
      addEnd(1000, 500);
      scene = loadShape("level1.svg");
      for (int i = 0; i < scene.getChildCount(); i++) {
        PShape shape = scene.getChild(i);
        solids.add(new Solid(shape));
      }
      spawn(125, 100, 500);
      break;
    
    case 5:
      move = true;
    case 2:
      scene = loadShape("level2.svg");
      for (int i = 0; i < scene.getChildCount(); i++) {
        PShape shape = scene.getChild(i);
        solids.add(new Solid(shape));
      }
      addLight(512, 18);
      addLight(768, 18);
      addEnd(125, 2.5);
      spawn(150, 20, 620);
      break;
      
    case 3:
      //addBlock(0, 108, 592, 126);
      //addBlock(688, 108, 1280, 126);
      //addBlock(0, 630, 624, 648);
      //addBlock(656, 630, 1280, 648);
      scene = loadShape("level3.svg");
      for (int i = 0; i < scene.getChildCount(); i++) {
        PShape shape = scene.getChild(i);
        solids.add(new Solid(shape));
      }
      addLight(64, 396);
      addLight(1216, 396);
      addEnd(640, 684);
      spawn(100, 30, 100);
      break;
      
    case 4:
      //addBlock(0, 2.5*ygrid, 17.25*xgrid, 3*ygrid);
      //addBlock(2.75*xgrid, 4.5*ygrid, width, 5*ygrid);
      //addBlock(0, 6.5*ygrid, 16*xgrid, 7*ygrid);
      //addBlock(4*xgrid, 8.5*ygrid, width, 9*ygrid);
      //addBlock(0, 10.5*ygrid, 14.75*xgrid, 11*ygrid);
      //addBlock(5.75*xgrid, 12.5*ygrid, width, 13*ygrid);
      //addBlock(0, 14.5*ygrid, 13.5*xgrid, 15*ygrid);
      
      scene = loadShape("level3.svg");
      for (int i = 0; i < scene.getChildCount(); i++) {
        PShape shape = scene.getChild(i);
        solids.add(new Solid(shape));
      }
      
      scene = loadShape("level4_oscillators.svg");
      for (int i = 0; i < scene.getChildCount(); i++) {
        PShape shape = scene.getChild(i);
        solids.add(new Oscillator(shape, new PVector((i % 2 == 0) ? -4 : 4,0), 100));
      }
      
      
      
      
      addLight(10*xgrid, 10*ygrid); 
      addLight(10*xgrid, 10*ygrid); 
      move = true;
      
      addEnd(640, 684);
      spawn(50, EPS, 2.5*ygrid-EPS);
      break;
      
    case 6:
      addBlock(0, height-floorthicc/2, 3*xgrid, height);
      addBlock(5*xgrid, height-floorthicc/2, 7*xgrid, height);
      addBlock(9*xgrid, height-floorthicc/2, 11*xgrid, height);
      addBlock(13*xgrid, height-floorthicc/2, 15*xgrid, height);
      addBlock(17*xgrid, height-floorthicc/2, width, height);
      
      // Random dots for lighting effects
      for (int i = 0; i < 20; i++) {
        double rx = Math.random() * width;  
        double ry = Math.random() * 11.5*ygrid;  
        addDot((float) rx, (float) ry);
      }
      addLight(10*xgrid, 2*ygrid); 
      addLight(2*xgrid, 2*ygrid); 
      move = true;
      
      addEnd(1.5*xgrid, height-xgrid);
      spawn(150, 19*xgrid, height-ygrid);
      break;
      
    case 7:
      float bh = 15*ygrid;
      addTriangle(0, bh, 0, bh-ygrid, 2*xgrid, bh);
      addTriangle(5*xgrid, bh, 6*xgrid, bh-ygrid, 7*xgrid, bh);
      addTriangle(9*xgrid, bh, 10*xgrid, bh-ygrid, 11*xgrid, bh);
      addTriangle(13*xgrid, bh, 14*xgrid, bh-ygrid, 15*xgrid, bh);
      addTriangle(18*xgrid, bh, width, bh-ygrid, width, bh);      
      
      // Random dots for lighting effects
      for (int i = 0; i < 20; i++) {
        double rx = Math.random() * width;  
        double ry = height - (Math.random() * (height-bh));  
        addDot((float) rx, (float) ry);
      }      
      
      addLight(10*xgrid, 10*ygrid);
      move = true;
      
      addEnd(xgrid, 7.5*ygrid);
      spawn(200, 19*xgrid, 12*ygrid);
      break;
      
    default:
      addEnd(15*xgrid, 5*ygrid);
      // Floors
      //float gapHalfWidth = 300;
      //addBlock(0, height - floorthicc, width / 2 - gapHalfWidth, height + 100);
      //addBlock(width / 2 + gapHalfWidth + 100, height - floorthicc, width, height + 100);   
      
      // Platforms
      //addBlock(50, 130, 300, 180);
      //addBlock(610, 540, 790, 620);
      
      scene = loadShape("level8.svg");
      for (int i = 0; i < scene.getChildCount(); i++) {
        PShape shape = scene.getChild(i);
        solids.add(new Solid(shape));
      }
      
      scene = loadShape("level8_oscillators.svg");
      for (int i = 0; i < scene.getChildCount(); i++) {
        PShape shape = scene.getChild(i);
        solids.add(new Oscillator(shape, new PVector((i % 2 == 0) ? -4 : 4,0), 100));
      }

      //Solid shape2 = new Solid();
      //shape2.addPoint(470, 340);
      //shape2.addPoint(420, 280);
      //shape2.addPoint(370, 340);
      //solids.add(shape2);
      
      spawn(150, 20, height - 500);
      break;
  }
}
