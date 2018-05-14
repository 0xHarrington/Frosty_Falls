private void addBlock(float tlx, float tly, float brx, float bry) {
  Solid newBlock = new Solid();
  newBlock.addPoint(tlx, tly);
  newBlock.addPoint(brx, tly);
  newBlock.addPoint(brx, bry);
  newBlock.addPoint(tlx, bry);
  solids.add(newBlock);
}

public void addLight(float x, float y) {
  balls.add(new Ball(x, y));
  Light l = new Light(x, y, color(255,255,255), 100, 255);
  lights.add(l);
  lightManager.addLight(l);  
}

public void loadLevel(int l) {
  float wallthicc = width;
  
  /* FIXED THINGS */
  // Walls
  addBlock(-wallthicc, 0, 0, height);
  addBlock(width, 0, width + wallthicc, height);
  // Ceiling
  addBlock(0, -floorthicc, width, 0);

  /* VARIABLE STUFF */
  float xgrid = width / 20;
  float ygrid = height / 20;
  switch (l) {
    case 1: 
      addBlock(0, height-(.5*ygrid), width, height);
      addBlock(5.5*xgrid, 2*ygrid, 7*xgrid, 14.5*ygrid);
      addBlock(12*xgrid, 2*ygrid, 13.5*xgrid, 16*ygrid);
      addLight(9.5*xgrid, 2*ygrid);
      break;
    
    
    
    
    default:
      // Floors
      float gapHalfWidth = 300;
      Solid floor1 = new Solid();
      floor1.addPoint(0, height - floorthicc);
      floor1.addPoint(width / 2 - gapHalfWidth, height - floorthicc);
      floor1.addPoint(width / 2 - gapHalfWidth, height + 100);
      floor1.addPoint(0, height + 100);
      
      Solid floor2 = new Solid();
      floor2.addPoint(width / 2 + gapHalfWidth + 100, height - floorthicc);
      floor2.addPoint(width, height - floorthicc);
      floor2.addPoint(width, height + 100);
      floor2.addPoint(width / 2 + gapHalfWidth + 100, height + 100);
      
      // Platforms
      Solid shape = new Solid();
      shape.addPoint(100, 150);
      shape.addPoint(300, 150);
      shape.addPoint(300, 180);
      shape.addPoint(100, 180);
      
      Solid shape2 = new Solid();
      Solid shape4 = new Solid();
      
      shape2.addPoint(440, 340);
      shape2.addPoint(420, 280);
      shape2.addPoint(370, 340);
      
      shape4.addPoint(610, 600);
      shape4.addPoint(790, 600);
      shape4.addPoint(790, 620);
      shape4.addPoint(610, 620);
      
      // Add them
      solids.add(shape);
      solids.add(shape2);
      solids.add(shape4);
      solids.add(floor1);
      solids.add(floor2);
      break;
  }
}
