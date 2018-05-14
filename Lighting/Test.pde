LightManager lightManager;
ArrayList<Light> lights;
ArrayList<Ball> balls;
boolean move = false;
PVector gravity = new PVector(0, 0.66);
boolean dead = false;
boolean complete = false;

void spawn() {
  solids.remove(player);
  player = new Player(new PVector(10, height - height/10 + 2));
  player.addPoint(10, height - height/10 + 2);
  player.addPoint(10, height - height/10);
  player.addPoint(11, height - height/10);
  player.addPoint(11, height - height/10 + 2);
  solids.add(player);
  dead = false;
}

void die() {
  dead = true;
  //solids.remove(player);
}
  
class Ball {
  float rotSpeed = random(-5,5), rot=random(0,360);
  float angdif = random(200,320);
  float r=5;   // radius
  float x,y; // location
  float xspeed,yspeed; // speed
  
  // Constructor
  Ball(float x1, float y1) {
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
    fill(0,50);
    ellipse(x,y,r*2,r*2);
  }
}
