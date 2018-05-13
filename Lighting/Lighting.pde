import java.util.*;
ArrayList<Solid> solids;
ArrayList<Light> lightsa;
boolean debug = false;
ArrayList<Segment> segs;
ArrayList<PVector> allPoints;
PImage imgMap;
Solid boundary;
float floorthicc;
Player player;
final float INFINITY = 999999;
final float EPS = .0001;


void setup() { 
  balls= new ArrayList<Ball>();
  fullScreen(P3D); 
  //size(2000,1000);
  
  lights = new ArrayList<Light>();
  lightManager = new LightManager();
  
  floorthicc = height / 40;
  
  spawn();
  
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
  
  Solid ceiling = new Solid();
  ceiling.addPoint(0,0);
  ceiling.addPoint(0,-floorthicc);
  ceiling.addPoint(width,-floorthicc);
  ceiling.addPoint(width,0);
  
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
  
  solids.add(shape);
  solids.add(shape2);
  solids.add(shape4);
  solids.add(floor1);
  solids.add(floor2);
  solids.add(lwall);
  solids.add(rwall);
  solids.add(ceiling);

  // add image boundary for intersections
  //boundary = new Solid();
  //boundary.visible = false;
  //boundary.addPoint(0, 0);
  //boundary.addPoint(width, 0);
  //boundary.addPoint(width, height);
  //boundary.addPoint(0, height);
  //solids.add(boundary);
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
      if (!s.opaque) continue;
      for  (Vertex v: s.polygon) {
        allPoints.add(v);
        segs.add(new Segment(v.x, v.y, v.next.x, v.next.y, s));
      }
      s.lit = false;
    }
    for (Light light : lightsa) light.cast();
  }
}
