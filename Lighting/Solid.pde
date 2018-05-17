boolean move = false;
PVector gravity = new PVector(0, 0.66);
boolean dead = false;
boolean complete = false;
boolean finished = false;





class Solid {
  boolean visible = true;
  boolean opaque =  true;
  PShape polygon;
  boolean lit, isEnd;
  boolean isplayer = false;
  color myColor, myLitColor, myUnlitColor;
  
  Solid() {
    myLitColor = color(69,179,224);
    myUnlitColor = color(0,176,255);
  }
  
  Solid(PShape polygon) {
    this.polygon = polygon;
    myLitColor = color(69,179,224);
    myUnlitColor = color(0,176,255);
    isEnd = false;
  }
  
  Solid(PShape polygon, boolean isEnd) {
    this.polygon = polygon;
    myLitColor = color(69,179,224);
    myUnlitColor = color(0,176,255);
    this.isEnd = isEnd;
  }
  
  void addPoint(float xa, float ya) {
    if (polygon == null) {
      polygon = createShape();
      polygon.beginShape();
      polygon.vertex(xa,ya);
      polygon.endShape();
      return;
    }
    ArrayList<PVector> oldPoints = new ArrayList<PVector>();
    for(int i = 0; i < polygon.getVertexCount(); i++) {
      oldPoints.add(polygon.getVertex(i));
    }
    polygon = createShape();
    polygon.beginShape();
    for (PVector v : oldPoints)
      polygon.vertex(v.x,v.y);
    polygon.vertex(xa,ya);
    polygon.endShape();
  }
  void addPoint(PVector p) {addPoint(p.x,p.y);}
  
  void display() {
    if (lit) myColor = myLitColor;
    else myColor = myUnlitColor;
    noStroke();
    fill(myColor);
    
    shape(polygon);
  }
  
  void update() {
    move();
  }
  void move() {}
}


class Oscillator extends Solid {
  PVector direction, origin;
  int stepsFromStart, maxSteps, stepDir;
  ArrayList<PVector> offsets;
  
  Oscillator(PShape shape, PVector direction, int steps) {
    maxSteps = steps;
    this.origin = shape.getVertex(0);
    this.direction = PVector.mult(direction, -1);
    offsets = new ArrayList<PVector>();
    for (int i = 0; i < shape.getVertexCount(); i++) {
      offsets.add(PVector.sub(shape.getVertex(i), origin));
    }
    stepsFromStart = 0;
    stepDir = -1;
    this.polygon = shape;
  }
  void update() {
    move();
  }
  void move() {
    if (stepsFromStart == 0 || stepsFromStart == maxSteps) {
      this.direction.mult(-1);
      stepDir *= -1;
    }
    
    origin.add(direction);
    polygon = createShape();
    polygon.beginShape();
    for (PVector offset : offsets) { 
      PVector v = PVector.add(offset, origin);
      polygon.vertex(v.x, v.y);
    }
    polygon.endShape();
    polygon.setFill(color(69,179,224));
    stepsFromStart += stepDir;
  }
}
