boolean move = false;
PVector gravity = new PVector(0, 0.66);
boolean dead = false;
boolean complete = false;
boolean finished = false;

void spawn(float w, float x, float y) {
  solids.remove(player);

  float h = 1.75 * w;
  player = new Player(new PVector(x, y));
  player.addPoint(x, y-h);
  player.addPoint(x+w, y-h);
  player.addPoint(x+w, y);
  player.addPoint(x, y);
  solids.add(player);
  dead = false;
}

void die() {
  dead = true;
}

class Solid {
  boolean visible = true;
  boolean opaque =  true;
  PShape polygon;
  boolean lit;
  boolean isplayer = false;
  color myColor, myLitColor, myUnlitColor;
  
  Solid() {
    myLitColor = color(69,179,224);
    myUnlitColor = color(0,176,255);
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
    
    beginShape();
    //if (isplayer) texture(playerImg);
    for (int i = 0; i < polygon.getVertexCount(); i++) {
      PVector v = polygon.getVertex(i);
      vertex(v.x,v.y);
    }
    endShape();
  }
  
  void move() {}
}

class Finish extends Solid {
  float x, y;
  
  Finish(float x, float y) {
    PShape s = createShape();
    float angle = TWO_PI / 20;
    float r = 40;
    s.beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * r;
      float sy = y + sin(a) * r;
      s.vertex(sx, sy);
    }
    s.endShape();
    
    super.polygon = s;
    super.opaque = false;
    super.myLitColor = color(127,231,6);
    super.myUnlitColor = color(72,167,1);
    this.x = x;
    this.y = y;
  }
  
  void add() {
    solids.add(this);
  }
}

//class Oscillator extends Solid {
//  PVector direction;
//  int stepsFromStart, maxSteps, stepDir;
  
//  Oscillator(PVector direction, int steps) {
//    maxSteps = steps;
//    this.direction = PVector.mult(direction, -1);
//    stepsFromStart = 0;
//    stepDir = -1;
//  }
//  void addPoint(PVector p) {
//    polygon.addPoint(p.x, p.y);
    
//  }
//  void move() {
//    if (stepsFromStart == 0 || stepsFromStart == maxSteps) {
//      this.direction.mult(-1);
//      stepDir *= -1;
//    }
//    for (Vertex v: this.polygon) v.add(direction);
//    stepsFromStart += stepDir;
//  }
//}
