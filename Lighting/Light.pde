final float INFINITY = 999999;
final float EPS = .00001;

// Represent ray as point and direction
class Ray {
  PVector pos, dir;
  Ray(PVector pos, PVector dir) {
    this.pos = pos;
    this.dir = dir;
  }
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

class Light {
  PVector pos;
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
    this.pos = new PVector(posX, posY);
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
    this.pos = new PVector(posX, posY);
  }

  void update(float posX, float posY, color c, float radius, float brightness) {
    this.brightness=brightness;
    lig = imgMap.get();
    lig.resize(0, (int)radius);
    this.posX=posX;
    this.posY=posY;
    this.pos = new PVector(posX, posY);
    this.c=c;
    this.radius=radius;
  }
  void cast() {

    if (!dead) {
      ArrayList <Intersection>intersects = new ArrayList<Intersection>();
      ArrayList<Float> uniqueAngles = new ArrayList<Float>();
      
      for (PVector point : allPoints) {
        PVector light2point = PVector.sub(point, pos);
        float angle = light2point.heading();
        uniqueAngles.add(angle - EPS);
        uniqueAngles.add(angle); 
        uniqueAngles.add(angle + EPS);
      }
      
      // RAYS IN ALL DIRECTIONS
      for (float angle: uniqueAngles) {
        PVector dir = PVector.fromAngle(angle);
        PVector far = PVector.add(pos, PVector.mult(dir, INFINITY));
        Ray ray = new Ray(pos, dir);
        
        // Find CLOSEST intersection
        Intersection closestIntersect = new Intersection(far, INFINITY);
        for (Segment segment: segs) {
          Intersection intersect = getIntersection(ray, segment);
          if (intersect != null && intersect.L < closestIntersect.L)
              closestIntersect = intersect;
        }
        
        // Add to list of intersects
        closestIntersect.ang = angle;
        intersects.add(closestIntersect);
      }
      
      // draw polygon comprised of all intersections
      Collections.sort(intersects, new Comparator<Intersection>() {
        public int compare(Intersection o1, Intersection o2) {
          return Double.compare(o2.ang, o1.ang);
        }
      });
      tint(red(c), green(c), blue(c), brightness);
      beginShape();
      texture(lig);
      for (Intersection intersect: intersects) {
        if (intersect.segment != null) intersect.segment.parent.lit = true;
        PVector uv = PVector.sub(intersect, pos).add(radius/2,radius/2);
        vertex(intersect.x, intersect.y, uv.x, uv.y);
      }
      endShape();
      
      if (debug) {
        stroke(255);
        for (Intersection intersect: intersects)
          line(pos.x, pos.y, intersect.x, intersect.y);
      }
    }
  }
}
