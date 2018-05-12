import java.util.*;
ArrayList<Solid> solids;
ArrayList<Light> lightsa;
boolean debug = false;
PGraphics buff;
ArrayList<Segment> segs;
ArrayList<PVector> allPoints;
PImage imgMap;
Solid boundary;
void setup() { 
  balls= new ArrayList<Ball>();
  size(800,600,P3D);
  //if(1/2==0)frame.setResizable(true); 
  lights = new ArrayList<Light>();
  light = new LightManager();
  
  
  //Solid shape = new Oscillator(new PVector(1,1),200);
  Solid shape = new Solid();
  shape.addPoint(100, 150);
  shape.addPoint(300, 150);
  shape.addPoint(300, 180);
  shape.addPoint(100, 180);
  Solid shape3 = new Player();
  Solid shape2 = new Solid();
  Solid shape4 = new Solid();
  
  shape3.addPoint(240, 60);
  shape3.addPoint(360, 40);
  shape3.addPoint(370, 70);
  shape3.addPoint(170, 70);

  shape2.addPoint(440, 340);
  shape2.addPoint(420, 280);
  shape2.addPoint(370, 340);
  
  shape4.addPoint(510, 520);
  shape4.addPoint(540, 520);
  shape4.addPoint(540, 540);
  shape4.addPoint(560, 540);
  shape4.addPoint(560, 560);
  shape4.addPoint(510, 560);
  light.addObject(shape);
  light.addObject(shape2);
  light.addObject(shape3);
  light.addObject(shape4);

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
  void addObject(Solid so) { solids.add(so);}
  void beginLight(color c) {
    this.c = c;
    //solids.clear();
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
  void move() {
    if (keyPressed) {
      PVector velocity;
      switch(keyCode) {
        case UP:
          velocity = new PVector(0, -1);
          break;
        case DOWN:
          velocity = new PVector(0, 1);
          break;
        case LEFT:
          velocity = new PVector(-1, 0);
          break;
        case RIGHT:
          velocity = new PVector(1, 0);
          break;
        default:
          velocity = new PVector(0, 0);
      }
      for (Vertex v : polygon) v.add(velocity);
    }
    for (Solid other : solids) {
      if (other == boundary || other == this) continue;
      PVector impulse = polygon.detectCollision(other.polygon);
      if (impulse.magSq() <= EPS) continue;
      System.out.println(impulse);
      for (Vertex v : polygon) v.add(impulse);
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

Intersection getIntersection(Ray ray, Segment segment) {
  // distance along segment
  double T2 = (ray.dir.x * (segment.pos.y - ray.pos.y) + ray.dir.y * (ray.pos.x - segment.pos.x)) /
              (segment.dir.x * ray.dir.y - segment.dir.y * ray.dir.x);
  // distance along ray
  double T1 = (segment.pos.x + segment.dir.x * T2 - ray.pos.x) / ray.dir.x;

  if (T1 < 0 || T2 < 0 || T2 > 1) return null;

  return new Intersection(ray.pos.x + ray.dir.x * T1, ray.pos.y + ray.dir.y * T1, T1, segment);
}
class Intersection extends PVector {
  float L, ang;
  Segment segment;
  Intersection(double x, double y, double L, Segment seg) {
    super((float) x, (float) y);
    this.segment = seg;
    this.L = (float) L;
  }
  Intersection(PVector p, float L) {
    super(p.x, p.y);
    this.L = L;
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
