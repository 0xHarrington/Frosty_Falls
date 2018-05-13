LightManager lightManager;
ArrayList<Light> lights;
ArrayList<Ball> balls;
boolean move = false;
PVector gravity = new PVector(0, 0.66);
boolean dead = false;

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

void draw() {
  lightManager.beginLight(color(50));
  
  for (Vertex v : player.polygon) if (v.y > height) dead = true;
  if (dead) text("Bye bye Frosty", width / 2, height / 2);
  else for (Solid solid : solids) solid.move();
  
  
  for (int i = 0; i < balls.size(); i++) {
    balls.get(i).display();
    balls.get(i).move();
    lights.get(i).move(balls.get(i).x,balls.get(i).y);
    //lights.get(i).setAngle(balls.get(i).rot,balls.get(i).rot+balls.get(i).angdif);
  }
  lightManager.castLight();
  text(frameRate,30,30);
}

void mousePressed(){
  balls.add(new Ball(mouseX,mouseY));
  
  //Light l = new Light(mouseX,mouseY,color(random(0,255),random(0,255),random(0,255)),random(300,1000),255);
  Light l = new Light(mouseX,mouseY,color(255,255,255),100,255);
  
  //brightness range 0 - 255
  lights.add(l);
  lightManager.addLight(l);
}

void keyPressed(){
  if (key == 'm') move = !move;
  if (key == 'c') lightManager.removeLights();
  if (key == 'r') {spawn(); System.out.println("restarting");}
  player.keyPressed();
}
void keyReleased() {
  player.keyReleased();
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
