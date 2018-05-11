LightManager light;
ArrayList<Light> lights;
ArrayList<Ball> balls;
boolean move = true;
Movable shape = new Movable();

void draw() {

  light.beginLight(color(50));
  //Movable shape = new Movable();
  Solid shape3 = new Solid();
  Solid shape2 = new Solid();
 Solid shape4 = new Solid();
    //shape.addPoint(100, 150);
  //shape.addPoint(300, 150);
  //shape.addPoint(300, 180);
  //shape.addPoint(100, 180);
  
  shape3.addPoint(240, 60);
  shape3.addPoint(360, 40);
  shape3.addPoint(370, 70);
  shape3.addPoint(170, 70);

  shape2.addPoint(440, 340);
  shape2.addPoint(420, 280);
  shape2.addPoint(370, 340);
  
shape4.addPoint(510, 520);
shape4.addPoint(540, 520);
shape4.addPoint(540, 540);
shape4.addPoint(560, 540);
shape4.addPoint(560, 560);
shape4.addPoint(510, 560);
  light.addObject(shape3);
  light.addObject(shape2);
  light.addObject(shape);
  light.addObject(shape4);
  shape.move();
  for(int i=0;i<balls.size();i++){
    balls.get(i).move();
    balls.get(i).display();
    lights.get(i).move(balls.get(i).x,balls.get(i).y);
    //lights.get(i).setAngle(balls.get(i).rot,balls.get(i).rot+balls.get(i).angdif);
  }
  
   light.castLight();

 
text(frameRate,30,30);
}
void mousePressed(){
  balls.add(new Ball(mouseX,mouseY));
  //Light l = new Light(mouseX,mouseY,color(random(0,255),random(0,255),random(0,255)),random(300,1000),255);
  Light l = new Light(mouseX,mouseY,color(255,255,255),100,255);
  //brightness range 0 - 255
lights.add(l);
light.addLight(l);
}
void keyPressed(){
  if(key==' ')move=!move;
  else if (key == 'd') {
    
  }
else light.removeLights();
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
    }
    //Check vertical edges
    if (y > height || y < 0) {
      yspeed *= - 1;
    }
  }
  
  // Draw the ball
  void display() {
    stroke(0);
    fill(0,50);
    ellipse(x,y,r*2,r*2);
  }
}
