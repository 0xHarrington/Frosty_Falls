import java.util.*;
import java.text.DecimalFormat;
ArrayList<Solid> solids;
ArrayList<Light> lightsa;
boolean debug = false;
ArrayList<Segment> segs;
ArrayList<PVector> allPoints;
Solid boundary;

PImage lightImg;
PImage playerImg;
Player player;
Finish finish;

final float INFINITY = 999999;
final float EPS = .0001;
final float LIGHT_SPEED = 2.5;
final float FIN_RAD = 30, LIGHT_RAD = 5;
final int NUM_DOTS = 45;
final DecimalFormat df = new DecimalFormat("0.00");

double savedTime = 0;
double ELAPSED_TIME = 0;

/* CONTROL FLOW */
void setup() { 
  balls = new ArrayList<Ball>();
  fullScreen(P3D); 
  //size(500,500);
  
  lights = new ArrayList<Light>();
  lightManager = new LightManager();
  
  lightImg = loadImage("http://i.imgur.com/DADrPTA.png");

  savedTime = millis();

  /* Load Level Design */
  clearLevel();
  loadLevel(whichLevel);
}

void draw() {
  lightManager.beginLight(color(50));
  
  for (int i = 0; i < player.polygon.getVertexCount(); i++) { 
    PVector v = player.polygon.getVertex(i);
    //System.out.println(v);
    if (v.y > height) die();
  }
  
  if (dead) {
    fill(109);
    rect(0,0,width,height);
    textSize(20);
    textAlign(CENTER);
    fill(50);
    text("Bye bye Frosty", width / 2 , height / 2);
    text("Press 'r' to respawn", width / 2, height / 2 + 20);
  }
  else if (finished) {
    clearLevel();
    background(75,181,67);
    textSize(30);
    textAlign(CENTER);
    fill(50);
    text("Thank you for playing!",width / 2, height/2 - 20);
    text("Final Time: " + df.format(ELAPSED_TIME), width / 2, height/2 + 15);     
    textSize(15);
    text("Press ESCAPE to quit", width / 2, height / 2 + 50);
    text("Press ENTER to restart", width / 2, height / 2 + 65);
  }
  else if (complete) {
    fill(75,181,67);
    rect(0,0,width, height);
    textSize(25);
    textAlign(CENTER);
    fill(50);
    text("Level Complete",width / 2, height/2);
    text("Press ENTER to continue",width / 2, height/2 + 30);

    textSize(20);
    text("Time Passed: " + df.format(ELAPSED_TIME), width / 7.5, height / 10);
  }
  
  else {
    // Update every solids' position
    for (Solid solid : solids) solid.move();
    
    for (int i = 0; i < balls.size(); i++) {
      Ball bi = balls.get(i);
      bi.display();
      bi.move();
      lights.get(i).move(bi.x, bi.y);       
    }
    
    /* Timer updating */
    ELAPSED_TIME += (millis() - savedTime) / 100000;
      
    // Update lights
    lightManager.castLight();
  }
  
  //textSize(10);
  //text("" + ELAPSED_TIME, 18*width/20, height / 10);
  
}

void mousePressed() {
  addLight(mouseX,mouseY);
}

void keyPressed(){
  if (key == '\n') {
    if (complete) {
      if (whichLevel >= NUM_LEVELS) {finished = true; complete=false;}
      else {
        complete = false;
        clearLevel();
        loadLevel(++whichLevel);
      }
      savedTime = millis();
    }
    else if (finished) {
      finished = false;
      complete = false;
      whichLevel = 0;
      ELAPSED_TIME = 0;
      clearLevel();
      loadLevel(whichLevel);
    }
  }
  
  if (key == 'm') move = !move;
  if (key == 'c') lightManager.removeLights();
  if (key == 'r' && (!complete || !finished)) {
    clearLevel();
    loadLevel(whichLevel); 
  }
  
  player.keyPressed();
}

void keyReleased() {
  player.keyReleased();
}
