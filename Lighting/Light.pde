LightManager lightManager;
ArrayList<Light> lights;
ArrayList<Ball> balls;

class LightManager {
  color c;
  Solid boundary;
  LightManager() {
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
    lig = lightImg.get();
    lig.resize(0, (int)radius);
  }
  
  void setRadius(float radius) {
    this.radius=radius;
    lig = lightImg.get();
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
    lig = lightImg.get();
    lig.resize(0, (int)radius);
    this.posX=posX;
    this.posY=posY;
    this.pos = new PVector(posX, posY);
    this.c=c;
    this.radius=radius;
  }
  
  void cast() {
    if (!dead && !complete) {
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

class Ball {
  float rotSpeed = random(-5,5), rot=random(0,360);
  float angdif = random(200,320);
  float r;   // radius
  float x,y; // location
  float xspeed,yspeed; // speed
  color col;
  boolean isFinish;
  
  // Constructor
  Ball(float x1, float y1, color c, float rad, boolean isFinish) {
    this.isFinish = isFinish;
    r = rad;
    col = c;
    x = x1;
    y = y1;
    xspeed = random( - 5,5);
    yspeed = random( - 5,5);
   }
  
  void move() {
   if(move) x += xspeed; // Increment x
    if(move)y += yspeed; // Increment y
     rot+=rotSpeed;
    // Check horizontal edges
    if (x > width || x < 0) {
      xspeed *= - 1;
      x += xspeed;
    }
    //Check vertical edges
    if (y > height - floorthicc || y < 0) {
      yspeed *= - 1;
      y  += yspeed;
    }
  }
  
  // Draw the ball
  void display() {
    stroke(0);
    fill(col);
    ellipse(x,y,r*2,r*2);
  }
}
