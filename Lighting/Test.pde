LightManager lightManager;
ArrayList<Light> lights;
ArrayList<Ball> balls;
boolean move = false;

PVector gravity = new PVector(0, 0.25);
int maxV = 4;
float walkingSpeed = 3;
float lightScale = 1.5;

void draw() {
  lightManager.beginLight(color(50));
  
  for (Solid solid : solids) solid.move();
  
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
  if (key == ' ' && player.standing) player.velocity.y = -10;
  if (key == 'c') lightManager.removeLights();
  switch(keyCode) {
      case LEFT:
        player.velocity.x = -walkingSpeed;
        break;
      case RIGHT:
        player.velocity.x = walkingSpeed;
        break;
      default:
        ;
    }
}
void keyReleased() {
  switch(keyCode) {
      case LEFT:
        if (player.velocity.x < 0) player.velocity.x = 0;
        break;
      case RIGHT:
        if (player.velocity.x > 0) player.velocity.x = 0;
        break;
      default:
        ;
    }
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
