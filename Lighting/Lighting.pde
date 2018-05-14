import java.util.*;
ArrayList<Solid> solids;
ArrayList<Light> lightsa;
boolean debug = false;
ArrayList<Segment> segs;
ArrayList<PVector> allPoints;
Solid boundary;

PImage lightImg;
PImage playerImg;
Player player;

final float INFINITY = 999999;
final float EPS = .0001;

void setup() { 
  balls= new ArrayList<Ball>();
  fullScreen(P3D); 
  //size(2000,1000);
  
  lights = new ArrayList<Light>();
  lightManager = new LightManager();
  
  lightImg = loadImage("http://i.imgur.com/DADrPTA.png");
//  playerImg = loadImage("olaf.png");
  spawn();

  /* Load Level Design */
  loadLevel(whichLevel);
}

void draw() {
  lightManager.beginLight(color(50));
  
  for (Vertex v : player.polygon) if (v.y > height) dead = true;
  if (dead) {
    fill(109);
    rect(0,0,width,height);
    textSize(20);
    textAlign(CENTER);
    fill(50);
    text("Bye bye Frosty", width / 2 , height / 2);
    text("Press 'r' to respawn", width / 2, height / 2 + 20);
    noFill();
  }
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

void mousePressed() {
  addLight(mouseX,mouseY);
}

void keyPressed(){
  if (key == '\n' && complete) {
    if (whichLevel < NUM_LEVELS) {
      fill(75,181,67);
      rect(0,0,width, height);
      textSize(20);
      textAlign(CENTER);
      fill(50);
      text("Thank you for playing!",width / 2, height/2);
      text("Press ecsape to quit",width / 2, height/2 + 20);
    }
    else whichLevel++;
    
  }
  if (key == 'm') move = !move;
  if (key == 'c') lightManager.removeLights();
  if (key == 'r') {spawn(); System.out.println("restarting");}
  player.keyPressed();
}

void keyReleased() {
  player.keyReleased();
}
