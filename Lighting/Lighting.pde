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


/* CONTROL FLOW */
void setup() { 
  balls = new ArrayList<Ball>();
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
  
  for (Vertex v : player.polygon) if (v.y > height) die();
  
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
  else if (finished) {
    clearLevel();
    background(75,181,67);
    textSize(30);
    textAlign(CENTER);
    fill(50);
    text("Thank you for playing!",width / 2, height/2 - 20);
    textSize(15);
    text("Press ESCAPE to quit",width / 2, height/2 + 10); 
  }
  else if (complete) {
    fill(75,181,67);
    rect(0,0,width, height);
    textSize(20);
    textAlign(CENTER);
    fill(50);
    text("Level Complete",width / 2, height/2);
    text("Press ENTER to continue",width / 2, height/2 + 20);
  }
  else for (Solid solid : solids) solid.move();
  
  int passedBall = 0;
  for (int i = 0; i < balls.size(); i++) {
    Ball bi = balls.get(i);
    bi.display();
    if (bi.isFinish) passedBall = 1;
    if (!bi.isFinish) { 
      bi.move();
      lights.get(i - passedBall).move(bi.x, bi.y);
    }
  }
  
  lightManager.castLight();
  
  text(frameRate,40,40);
  text(String.valueOf(complete), 40, 50);
}

void mousePressed() {
  addLight(mouseX,mouseY);
}

void keyPressed(){
  if (key == '\n' && complete) {
    if (whichLevel >= NUM_LEVELS) finished = true;
    else {
      complete = false;
      clearLevel();
      loadLevel(++whichLevel);
      spawn();
    }
  }
  
  if (key == 'm') move = !move;
  if (key == 'c') lightManager.removeLights();
  if (key == 'r') {spawn(); System.out.println("restarting");}
  player.keyPressed();
}

void keyReleased() {
  player.keyReleased();
}
