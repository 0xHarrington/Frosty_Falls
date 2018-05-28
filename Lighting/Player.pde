void die() {
  state = DEAD;
}

void spawn(float h, float x, float y) {
  solids.remove(player);
  player = new Player(h, x, y);
  solids.add(player);
  state = PLAYING;
}

class Player extends Solid {
  float minx = width, maxx = 0, miny = height, maxy = 0;  
  PVector velocity = new PVector(0,0);  
  boolean standing = false;
  float walkingSpeed = 3.0;
  float leaningSpeed = 1.0;
  float maxLeaningSpeed = 5;
  float slidingSpeed = 10.0;
  float direction = 0;
  float rotation = 0;
  float maxSpeed = 30;
  float prevDir = 0;
  float cutoff = 2.0;
  float size, fullSize;
  PVector origin;
  ArrayList<PVector> offsets = new ArrayList<PVector>();
  boolean prevLit = false;
  
  Player(float h, float x, float y) {
    float w = h / 3;
    PShape hitbox = createShape();
    hitbox.beginShape();
    hitbox.vertex(x - w / 2, y);
    hitbox.vertex(x - w / 2, y - h);
    hitbox.vertex(x + w / 2, y - h);
    hitbox.vertex(x + w / 2, y);
    hitbox.endShape();
    this.polygon = hitbox;
    this.isEnd = false;
    origin = new PVector(x,y);
    fullSize = h;
    this.size = fullSize;
    
    for (int i = 0; i < hitbox.getVertexCount(); i++) {
      offsets.add(PVector.sub(hitbox.getVertex(i), origin));
    }
  }
  
  void keyPressed() {
    if (key == ' ') {
      if (standing)
        jump();
    }
    else if (keyCode == LEFT) 
      direction = -1.0;
    else if (keyCode == RIGHT) 
      direction = 1.0;
  }
  
  void keyReleased() {
    if (keyCode == LEFT) {
      if(direction < 0) 
        direction = 0;
    }
    else if (keyCode == RIGHT) {
      if (direction > 0) 
        direction = 0;
    }
    
    if (lit && Math.abs(velocity.x) < cutoff) 
      velocity.x = 0.0;
  }
  
  void jump() {
    velocity.y = -18;
  }
  
  
 
  void move() {
    
    for (int i = 0; i < polygon.getVertexCount(); i++) { 
    if (polygon.getVertex(i).y > height) 
      die();
    }
    if (lit) 
      size -= .5;
    else if (size < fullSize) 
      size += 1;
    
    if (size < 5) {
      die();
      return;
    }
    
    
    //polygon.clear();
    polygon = createShape();
    polygon.beginShape();
    for (PVector offset : offsets) { 
      PVector v = PVector.add(PVector.mult(offset,size/fullSize), origin);
      polygon.vertex(v.x, v.y);
    }
    polygon.endShape();
    
    
    if (standing) {
      if (lit) {
        if (prevLit)   
          velocity.x += leaningSpeed * direction; 
        else           
          velocity.x = slidingSpeed * direction;
      }
      else velocity.x = walkingSpeed * direction;
    }
    else {
      if (velocity.x * direction < 0) 
        velocity.x += leaningSpeed * direction;
      else if (Math.abs(velocity.x) < maxLeaningSpeed) 
          velocity.x += leaningSpeed * direction;
    }
    
    // cap speed
    velocity.x = (Math.abs(velocity.x) > maxSpeed) ? maxSpeed * direction : velocity.x;
    
    prevLit = lit;
    velocity.add(gravity);
    ArrayList<PVector> span = new ArrayList<PVector>();
    for (int i = 0; i < player.polygon.getVertexCount(); i++) {
      PVector v = player.polygon.getVertex(i);
      span.add(PVector.add(v, PVector.mult(velocity, EPS)));
      span.add(PVector.add(v, velocity));
    }
    
    PVector toApply = velocity;
    
    polygon.translate(toApply.x, toApply.y);
    origin.add(toApply);
    
    // Collision Code
    standing = false;
    for (Solid other : solids) {
      if (other == player) 
        continue;
        
      PVector impulse = detectCollision(convexHull(span), other.polygon, velocity);
      if (impulse.magSq() <= EPS) 
        continue;
      if (other.isEnd) {
        
        ELAPSED_TIME += (millis() - savedTime) / 100000;
        state = WIN;
        return;
      }
      polygon.translate(impulse.x, impulse.y);
      origin.add(impulse);
      
      if (impulse.normalize().dot(new PVector(0,-1)) > 0)
        standing = true;
        
      PVector parallel = new PVector(impulse.y, -impulse.x);
      velocity = parallel.mult(velocity.dot(parallel));
    }
    
  }
void display() {
    float radius = fullSize / 6;
    rotation += direction;
    
    if (lit) myColor = myLitColor;
    else myColor = myUnlitColor;
    stroke(255);
    fill(255);
    
    int sides = 10;
    pushMatrix();
    blendMode(REPLACE);
    translate(origin.x, origin.y);
    scale(size/fullSize);
    // snowman head
    translate(0,- 5 * radius);
    pushMatrix();
    rotate(-rotation);
    polygon(0, 0, radius, sides);
    popMatrix();
    
    // face
    fill(0);
    polygon(radius / 3,-radius / 2, radius/5, sides);
    polygon(-radius / 3,-radius / 2, radius/5, sides);
    
    
    polygon(0,7 * radius / 12, radius/8, sides);
    polygon(-radius / 4,radius / 2, radius/8, sides);
    polygon(radius / 4,radius / 2, radius/8, sides);
    polygon(-radius / 2,4 * radius / 12, radius/8, sides);
    polygon(radius / 2,4 * radius / 12, radius/8, sides);
    fill(237, 145, 33);
    polygon(0,0, radius/4, 3);
    fill(255);
    
    
    // torso
    translate(0, 2 * radius);
    pushMatrix();
    rotate(rotation);
    polygon(0, 0, radius, sides);
    popMatrix();
    
    // buttons
    fill(0);
    polygon(0,0, radius/5, sides);
    polygon(0,radius  / 2, radius/5, sides);
    polygon(0,-radius / 2, radius/5, sides);
    
    fill(255);
    
    // booty
    translate(0, 2 * radius);
    pushMatrix();
    rotate(-rotation);
    polygon(0, 0, radius, sides);
    popMatrix();
    
    
    popMatrix();
    noStroke();
    blendMode(ADD);
    }
}
void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
