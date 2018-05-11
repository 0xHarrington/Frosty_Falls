import java.util.*;
ArrayList<Solid> solids;
ArrayList<Light> lightsa;
boolean debug = false;
PGraphics buff;
ArrayList<Segment> segs;
ArrayList<Float> pointsX;
ArrayList<Float> pointsY;
PImage imgMap;
void setup() { 
  balls= new ArrayList<Ball>();
  size(800,600,P3D);
  if(1/2==0)frame.setResizable(true); 
  lights = new ArrayList<Light>();
  light = new LightManager();
  shape.addPoint(100, 150);
  shape.addPoint(300, 150);
  shape.addPoint(300, 180);
  shape.addPoint(100, 180);
}
class LightManager {
  color c;
  Solid boundary;
  LightManager() {
    imgMap = loadImage("http://i.imgur.com/DADrPTA.png");
    segs = new ArrayList<Segment>();
    pointsX = new ArrayList<Float>();
    pointsY = new ArrayList<Float>();
    lightsa = new ArrayList<Light>();

    solids = new ArrayList<Solid>();
  }
  void addLight(Light li) {
    lightsa.add(li);
  }
  void removeLights() {
    lightsa.clear();
  }
  void addObject(Solid so) {
    solids.add(so);
  }
  void beginLight(color c) {
    this.c = c;
    solids.clear();
    background(c);
  }

  void castLight() {
    blendMode(ADD);
    pointsX.clear();
    pointsY.clear();
    segs.clear();
    boundary = new Solid();
    boundary.addPoint(0, 0);
    boundary.addPoint(-width, height*2);
    boundary.addPoint(width*2, height*2);
    boundary.addPoint(width*2, -height);
    boundary.visible = false;
    solids.add(boundary);

    // populate segments
    for (Solid s:solids) {
      if (s.visible)s.display();
      for  (Vertex v: s.polygon) {
        pointsX.add(v.point.x);
        pointsY.add(v.point.y);
        segs.add(new Segment(v.point.x, v.point.y, v.next.point.x, v.next.point.y));
      }
    }
    for (Light light : lightsa) light.cast();
  }
  void setDebug(boolean tode) {
    debug = tode;
  }
}
class Vertex {
  PVector point;
  Vertex next;
  Vertex(float x, float y) {
    this.point = new PVector(x,y);
  }
}
class Polygon implements Iterable<Vertex> {
  Vertex head, tail;
  
  public void addPoint(float x, float y) {
    Vertex v = new Vertex(x,y);
    if (this.head == null) {
      this.head = v;
      this.tail = v;
    }
    v.next = head;
    tail.next = v;
    tail = v;
  }
  public Iterator<Vertex> iterator() {
    return new VertexIterator();
  }
  private class VertexIterator implements Iterator<Vertex> {
    private Vertex current;
    private boolean started;
    public VertexIterator() {
      this.current = Polygon.this.head;
      started = false;
    }
    public boolean hasNext() {
      return !(started  && current == Polygon.this.head);
    }
    public Vertex next() {
      if (!this.hasNext()) throw new NoSuchElementException();
      Vertex toReturn = current;
      current = current.next;
      started = true;
      return toReturn;
    }
  }
}
class Solid {
  boolean visible = true;
  ArrayList<Float> x = new ArrayList<Float>();
  ArrayList<Float> y = new ArrayList<Float>();
  Polygon polygon = new Polygon();
  void addPoint(float xa, float ya) {
    x.add(xa);
    y.add(ya);
    polygon.addPoint(xa,ya);
  }
  void display() {
    noStroke();
    fill(150, 230, 100);
    beginShape();


    for (int i=0;i<x.size();i++) {
      vertex(x.get(i), y.get(i));
    }
    endShape();
  }
}

class Movable extends Solid {
  boolean visible = false;
  PVector velDir;
  int speed = 1;
  void move() {
    for (int i=0;i<x.size();i++) {
      if (x.get(i) < 100) speed = 1;
      if (x.get(i) > 500) speed = -1;
    }
    for (int i=0;i<x.size();i++) {
      x.set(i,x.get(i) + speed);
    }
    for (Vertex v: this.polygon) {
      v.point.x += speed;
    }
  }
}

//class Player extends Solid {
// void move() {
//   if(move) x += xspeed; // Increment x
//    if(move)y += yspeed; // Increment y
//     rot+=rotSpeed
//    // Check horizontal edges
//    if (x > width || x < 0) {
//      xspeed *= - 1;
//    }
//    //Check vertical edges
//    if (y > height || y < 0) {
//      yspeed *= - 1;
//    }
// }
//}

class Light {
  float posX, posY, radius;
  PImage lig;
  color c;
  float brightness = 100;
  float ang1 = 360;
  float ang2 = 360;
  boolean dead = false;
  void kill() {
    dead = true;
  }
  Light(float posX, float posY, color c, float radius, float brightness) {
    this.brightness = brightness;
    this.posX=posX;
    this.posY=posY;
    this.c=c;

    this.radius=radius;
    lig = imgMap.get();
    lig.resize(0, (int)radius);
  }
  void setRadius(float radius) {
    this.radius=radius;
    lig = imgMap.get();
    lig.resize((int)radius, (int)radius);
  }
  void setAngle(float ang1, float ang2) {
    this.ang1 = ang1;
    this.ang2 = ang2;
  }
  void move(float posX, float posY) {
    this.posX=posX;
    this.posY=posY;
  }

  void update(float posX, float posY, color c, float radius, float brightness) {
    this.brightness=brightness;
    lig = imgMap.get();
    lig.resize(0, (int)radius);
    this.posX=posX;
    this.posY=posY;
    this.c=c;
    this.radius=radius;
  }
  void cast() {

    if (!dead) {
      ArrayList <Inters>intersects = new ArrayList<Inters>();


      ArrayList<Double> uniqueAngles = new ArrayList<Double>();
      Solid block = new Solid();
      block.visible = false;
      double angle1 = radians(ang1);
      double angle2 = radians(ang2);
      float dx0 = (float)(Math.cos(angle1)*1000);
      float dy0 = (float)(Math.sin(angle1)*1000);
      float dx1 = (float)(Math.cos(angle2)*1000);
      float dy1 = (float)(Math.sin(angle2)*1000);
      float dx2 = (float)(Math.cos(radians((ang1+ang2)/2))*2);
      float dy2 = (float)(Math.sin(radians((ang1+ang2)/2))*2);
      block.addPoint(posX+dx2, posY+dy2);
      block.addPoint(posX+ dx0, posY + dy0);
      block.addPoint(posX+ dx2*2, posY + dy2*2);
      block.addPoint(posX+ dx1, posY + dy1);
 for (int i=0;i<block.x.size()-1;i++) {
        pointsX.add(block.x.get(i));
        pointsY.add(block.y.get(i));
        segs.add(new Segment(block.x.get(i), block.y.get(i), block.x.get(i+1), block.y.get(i+1)));
      }
      pointsX.add(block.x.get(block.x.size()-1));
      pointsY.add(block.y.get(block.y.size()-1));
      segs.add(new Segment(block.x.get(0), block.y.get(0), block.x.get(block.x.size()-1), block.y.get(block.x.size()-1)));
      for (int j=0;j<pointsX.size();j++) {

        double angle = Math.atan2(pointsY.get(j)-posY, pointsX.get(j)-posX);
        //uniquePoint.angle = angle;
        uniqueAngles.add(angle-0.00001);
        uniqueAngles.add(angle);
        uniqueAngles.add(angle+0.00001);
      }
      // RAYS IN ALL DIRECTIONS
      for (int k=0;k<uniqueAngles.size();k++) {
        double angle = uniqueAngles.get(k);
        // if(angle>ang2)angle = ang2;
        //if(angle<ang1)angle = ang1;
        // Calculate dx & dy from angle
        double dx = Math.cos(angle);
        double dy = Math.sin(angle);



        // Find CLOSEST intersection
        Inters closestIntersect = new Inters(posX+dx*9999, posY+dy*9999, 99999);
        for (Segment theseg: segs) {
          Inters intersect = getIntersection(posX, posY, posX+dx, posY+dy, theseg.sx, theseg.sy, theseg.sx1, theseg.sy1);
          if (intersect==null) {
          }
          else {
            if (intersect.L<closestIntersect.L) {
              closestIntersect=intersect;
            }
          }
        }
        // Add to list of intersects
        closestIntersect.ang = (double)angle;
        intersects.add(closestIntersect);
      }
      Collections.sort(intersects, new Comparator<Inters>() {
        public int compare(Inters o1, Inters o2) {
          return Double.compare(o2.ang, o1.ang);
        }
      }
      );

      tint(red(c), green(c), blue(c), brightness);

      pushMatrix();
      beginShape();
      texture(lig);
      for (Inters inte: intersects) {
        vertex((float)inte.x1, (float)inte.y1, (float)inte.x1+(radius/2)-posX, (float)inte.y1+(radius/2)-posY);
      }

      endShape();
      popMatrix();
      if (debug) {
        for (Inters inte: intersects) {
          stroke(255);
          line(posX, posY, (float)inte.x1, (float)inte.y1);
        }
      }
      for(int i=0;i<4;i++){
      pointsX.remove(pointsX.size()-1);
       pointsY.remove(pointsY.size()-1);
       segs.remove(segs.size()-1);
      }
    }
  }
}
Inters getIntersection(double r_px, double r_py, double r_px1, double r_py1, double s_px, double s_py, double s_px1, double s_py1) {
  double r_dx = r_px1-r_px;
  double r_dy = r_py1-r_py;
  double s_dx = s_px1-s_px;
  double s_dy = s_py1-s_py; 

  double T2 = (r_dx*(s_py-r_py) + r_dy*(r_px-s_px))/(s_dx*r_dy - s_dy*r_dx);
  double T1 = (s_px+s_dx*T2-r_px)/r_dx;

  if (T1<0||T2<0 || T2>1) return null;

  return new Inters(r_px+r_dx*T1, r_py+r_dy*T1, T1);
}
class Inters {
  double x1, y1, L, ang;
  Inters(double a, double b, double c) {
    x1=a;
    y1=b;
    L=c;
  }
}
class Segment {
  double sx, sy, sx1, sy1;
  Segment(double sxs, double sys, double sx1s, double sy1s) {
    sx = sxs;
    sy = sys;
    sx1 = sx1s;
    sy1 = sy1s;
  }
}
