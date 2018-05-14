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
  Polygon polygon = new Polygon();
  boolean lit;
  boolean isplayer = false;
  color myColor, myLitColor, myUnlitColor;
  
  Solid() {
    myLitColor = color(69,179,224);
    myUnlitColor = color(0,176,255);
  }
  
  void addPoint(float xa, float ya) {polygon.addPoint(xa,ya);}
  void addPoint(PVector p) {polygon.addPoint(p.x,p.y);}
  
  void display() {
    if (lit) myColor = myLitColor;
    else myColor = myUnlitColor;
    noStroke();
    fill(myColor);
    
    beginShape();
    if (isplayer) texture(playerImg);
    for (Vertex v: polygon) vertex(v.x,v.y);
    endShape();
  }
  
  void move() {}
}

class Player extends Solid {
  float minx = width, maxx = 0, miny = height, maxy = 0;  
  PVector velocity = new PVector(0,0);  
  boolean standing = false;
  float walkingSpeed = 10.0;
  float leaningSpeed = 1.0;
  float maxLeaningSpeed = 5;
  float slidingSpeed = 10.0;
  float direction = 0;
  float maxSpeed = 30;
  float prevDir = 0;
  float cutoff = 2.0;
  float size = 100;
  PVector origin;
  ArrayList<PVector> offsets = new ArrayList<PVector>();
  boolean prevLit = false;
  
  Player(PVector o) {
    super();
    super.isplayer = true;
    origin = o;
    super.myLitColor = color(143,242,216);
    super.myUnlitColor = color(255,255,255);
  }
  
  void keyPressed() {
    if (key == ' ') {if (standing) jump();}
    else if (keyCode == LEFT) direction = -1.0;
    else if (keyCode == RIGHT) direction = 1.0;
  }
  
  void keyReleased() {
    if (keyCode == LEFT) {if(direction < 0) direction = 0;}
    else if (keyCode == RIGHT) {if (direction > 0) direction = 0;}
    
    if (lit && Math.abs(velocity.x) < cutoff) velocity.x = 0.0;
  }
  
  void jump() {velocity.y = -20;}
  
  
  void addPoint(float x, float y) {
    addPoint(new PVector(x,y));
  }
  
  void addPoint(PVector p) {
    offsets.add(PVector.sub(p,origin));
    super.addPoint(p);
  }
  
  boolean checkFinish() {
    float r = 3 * FIN_RAD / 4;
    return (minx <= endx + r && maxx >= endx - r && 
            miny <= endy + r && maxy >= endy - r);
  }
 
  void move() {
    if (lit) size -= .5;
    else if (size < 100) size += 1;
    
    if (size < 5) {die();return;}
    
    if (checkFinish()) complete = true;
    
    polygon.clear();
    for (PVector offset : offsets) polygon.addPoint(PVector.add(PVector.mult(offset,size), origin));
    
    if (standing) {
      if (lit) {if (prevLit) velocity.x += leaningSpeed * direction; else velocity.x = slidingSpeed * direction;}
      else velocity.x = walkingSpeed * direction;
    }
    else {
      if (velocity.x * direction < 0) velocity.x += leaningSpeed * direction;
      else if (Math.abs(velocity.x) < maxLeaningSpeed) velocity.x += leaningSpeed * direction;
    }
    
    velocity.x = (Math.abs(velocity.x) > maxSpeed) ? maxSpeed * direction : velocity.x;
    
    prevLit = lit;
    velocity.add(gravity);
    ArrayList<PVector> span = new ArrayList<PVector>();
    for (Vertex v : player.polygon) {
      span.add(PVector.add(v,PVector.mult(velocity, EPS))); 
      v.add(velocity); 
      span.add(v);
    }
    origin.add(velocity);
    
    // Collision Code
    player.standing = false;
    for (Solid other : solids) {
      if (other == player) continue;
      PVector impulse = convexHull(span).detectCollision(other.polygon, velocity);
      if (impulse.magSq() <= EPS) continue;
      for (Vertex v : player.polygon) v.add(impulse);
      origin.add(impulse);
      if (impulse.normalize().dot(new PVector(0,-1)) > 0)
        standing = true;
      PVector parallel = new PVector(impulse.y, -impulse.x);
      velocity = parallel.mult(velocity.dot(parallel));
    }
    for (Vertex v : polygon) {
      minx = min(v.x, minx);
      maxx = max(v.x, maxx);
      miny = min(v.y, miny);
      maxy = max(v.y, maxy);
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
