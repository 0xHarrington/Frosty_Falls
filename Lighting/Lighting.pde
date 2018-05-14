import java.util.*;
ArrayList<Solid> solids;
ArrayList<Light> lightsa;
boolean debug = false;
ArrayList<Segment> segs;
ArrayList<PVector> allPoints;
PImage imgMap;
Solid boundary;
Player player;
final float INFINITY = 999999;
final float EPS = .0001;

final int NUM_LEVELS = 1;
int whichLevel = 0;
float floorthicc = height / 40;


void setup() { 
  balls= new ArrayList<Ball>();
  fullScreen(P3D); 
  //size(2000,1000);
  
  lights = new ArrayList<Light>();
  lightManager = new LightManager();
  
  spawn();

  /* Load Level Design */
  loadLevel(whichLevel);

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
    //imgMap = loadImage("https://www.freeiconspng.com/uploads/snowman-png-1.jpg");
    imgMap = loadImage("http://i.imgur.com/DADrPTA.png");
    //imgMap = loadImage("olaf.png");
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
