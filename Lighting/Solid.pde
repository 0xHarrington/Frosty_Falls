class Solid {
  boolean visible = true;
  boolean opaque =  true;
  Polygon polygon = new Polygon();
  boolean lit;
  color myColor, myLitColor, myUnlitColor;
  
  
  Solid() {
    super();
    myLitColor = color(150, 230, 100);
    myUnlitColor = color(150, 230, 100);
  }
  
  void addPoint(float xa, float ya) {polygon.addPoint(xa,ya);}
  void addPoint(PVector p) {polygon.addPoint(p.x,p.y);}
  
  void display() {
    if (lit) myColor = myLitColor;
    else myColor = myUnlitColor;
    noStroke();
    fill(myColor);
    beginShape();
    for (Vertex v: polygon) vertex(v.x,v.y);
    endShape();
  }
  void move() {;}
}

class Player extends Solid {
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
    origin = o;
    myLitColor = color(143,242,216);
    myUnlitColor = color(255,255,255);
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
 
  void move() {
    
    if (lit) size -= .5;
    else if (size < 100) size += 1;
    
    if (size < 5) {die();return;}
    
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
    for (Vertex v : player.polygon) {span.add(PVector.add(v,PVector.mult(velocity, EPS))); v.add(velocity); span.add(v);}
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
