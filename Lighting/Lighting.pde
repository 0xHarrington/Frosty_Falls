import java.util.*;
ArrayList<Solid> solids;
ArrayList<Light> lightsa;
boolean debug = false;
PGraphics buff;
ArrayList<Segment> segs;
ArrayList<PVector> allPoints;
PImage imgMap;
Solid boundary;
int floorthicc = 20;
Player player;

void setup() { 
  balls= new ArrayList<Ball>();
  //size(800,600,P3D);
  fullScreen(P3D);
  //if(1/2==0)frame.setResizable(true); 
  lights = new ArrayList<Light>();
  lightManager = new LightManager();
  
  
  Solid floor = new Solid();
  floor.addPoint(0, height - floorthicc);
  floor.addPoint(width, height - floorthicc);
  floor.addPoint(width, height + floorthicc);
  floor.addPoint(0, height + floorthicc);
  
  float wallthicc = height / 2;
  Solid lwall = new Solid();
  lwall.addPoint(-wallthicc, 0);
  lwall.addPoint(0, 0);
  lwall.addPoint(0, height);
  lwall.addPoint(-wallthicc, height);
  
  Solid rwall = new Solid();
  rwall.addPoint(width, 0);
  rwall.addPoint(width + wallthicc, 0);
  rwall.addPoint(width + wallthicc, height);
  rwall.addPoint(width, height);
  
  Solid shape = new Solid();
  shape.addPoint(100, 150);
  shape.addPoint(300, 150);
  shape.addPoint(300, 180);
  shape.addPoint(100, 180);
  player = new Player();
  Solid shape2 = new Solid();
  Solid shape4 = new Solid();
  
  player.addPoint(10, height - height/10);
  player.addPoint(10, height - height/10 + 20);
  player.addPoint(30, height - height/10 + 20);
  player.addPoint(30, height - height/10);

  shape2.addPoint(440, 340);
  shape2.addPoint(420, 280);
  shape2.addPoint(370, 340);
  
  shape4.addPoint(610, 600);
  shape4.addPoint(790, 600);
  shape4.addPoint(790, 620);
  shape4.addPoint(610, 620);
  
  solids.add(shape);
  solids.add(shape2);
  solids.add(player);
  solids.add(shape4);
  solids.add(floor);
  solids.add(lwall);
  solids.add(rwall);

  // add image boundary for intersections
  boundary = new Solid();
  boundary.visible = false;
  boundary.addPoint(0, 0);
  boundary.addPoint(width, 0);
  boundary.addPoint(width, height);
  boundary.addPoint(0, height);
  solids.add(boundary);
}

class LightManager {
  color c;
  Solid boundary;
  LightManager() {
    imgMap = loadImage("http://i.imgur.com/DADrPTA.png");
    segs = new ArrayList<Segment>();
    allPoints = new ArrayList<PVector>();
    lightsa = new ArrayList<Light>();

    solids = new ArrayList<Solid>();
  }
  void addLight(Light li) { lightsa.add(li);}
  void removeLights() { lightsa.clear();}
  void beginLight(color c) {
    this.c = c;
    background(c);
  }

  void castLight() {
    blendMode(ADD);
    allPoints.clear();
    segs.clear();
    

    // populate segments
    for (Solid s:solids) {
      if (s.visible) s.display();
      for  (Vertex v: s.polygon) {
        allPoints.add(v);
        segs.add(new Segment(v.x, v.y, v.next.x, v.next.y, s));
      }
      s.lit = false;
    }
    for (Light light : lightsa) light.cast();
  }
}


class Solid {
  boolean visible = true;
  Polygon polygon = new Polygon();
  boolean lit;
  
  void addPoint(float xa, float ya) {polygon.addPoint(xa,ya);}
  void addPoint(PVector p) {polygon.addPoint(p.x,p.y);}
  
  void display() {
    noStroke();
    if (lit) fill(255,255,255);
    else fill(150, 230, 100);
    beginShape();
    for (Vertex v: polygon) vertex(v.x,v.y);
    endShape();
  }
  void move() {;}
}

class Player extends Solid {
  PVector velocity = new PVector(0,0);  
  boolean standing = false;
 
  void move() {
    if (this.lit && this.velocity.x != 0) lightScale += 0.25;
    else if (this.standing) lightScale = lightScale >= 2 + EPS ? lightScale - .5 : 1.5;
    
    if (velocity.x < 0) velocity.x = - walkingSpeed * lightScale;
    else if (velocity.x > 0) velocity.x = walkingSpeed * lightScale;
    velocity.add(gravity);
    for (Vertex v : player.polygon) v.add(velocity);
    
    // Collision Code
    player.standing = false;
    for (Solid other : solids) {
      if (other == boundary || other == player) continue;
      PVector impulse = player.polygon.detectCollision(other.polygon);
      if (impulse.magSq() <= EPS) continue;
      for (Vertex v : player.polygon) v.add(impulse);
      if (impulse.normalize().dot(new PVector(0,-1)) == 1)
        player.standing = true;
    }
    if (player.standing) player.velocity.y = 0.0;
    
    // no clipping for you
    float minX = 0, maxX = width;
    float minY = 0, maxY = height - height / 40;
    for (Vertex v : this.polygon) {
      minX = (v.x < minX) ? v.x : minX;
      maxX = (v.x > maxX) ? v.x : maxX;
      minY = (v.y < minY) ? v.y : minY;
      maxY = (v.y > maxY) ? v.y : maxY;
    }
    for (Vertex v : this.polygon) {
      if (minX < 0) v.x -= minX;
      else if (maxX > width) v.x -= maxX - width;
      if (minY < 0) v.y -= minY;
      else if (maxY > height - height / 40) v.y -= maxY - height + height/40;
    }
  }
}

class Oscillator extends Solid {
  PVector direction;
  int stepsFromStart, maxSteps, stepDir;
  
  Oscillator(PVector direction, int steps) {
    maxSteps = steps;
    this.direction = PVector.mult(direction, -1);
    stepsFromStart = 0;
    stepDir = -1;
  }
  void addPoint(PVector p) {
    polygon.addPoint(p.x, p.y);
    
  }
  void move() {
    if (stepsFromStart == 0 || stepsFromStart == maxSteps) {
      this.direction.mult(-1);
      stepDir *= -1;
    }
    for (Vertex v: this.polygon) v.add(direction);
    stepsFromStart += stepDir;
  }
}

// Represent segment as point and vector (magnitude matters)
class Segment {
  PVector pos, dir;
  Solid parent;
  Segment(double sxs, double sys, double sx1s, double sy1s, Solid s) {
    pos = new PVector((float)sxs, (float)sys);
    dir = new PVector((float)sx1s, (float)sy1s).sub(pos);
    parent = s;
  }
}
