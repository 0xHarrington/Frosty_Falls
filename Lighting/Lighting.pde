import java.util.*;
import java.text.DecimalFormat;
ArrayList<Solid> solids;
ArrayList<Light> lightsa;
boolean debug = false;

PImage lightImg;
PImage playerImg;
Player player;

final float INFINITY = 999999;
final float EPS = .0001;
final float LIGHT_SPEED = 2.5;
final float FIN_RAD = 30, LIGHT_RAD = 5;
final int NUM_DOTS = 45;

final int PLAYING = 0, DEAD = 1, WIN = 2, END = 3;


int state;
final DecimalFormat df = new DecimalFormat("0.00");
double savedTime = 0;
double ELAPSED_TIME = 0;

/* CONTROL FLOW */
void setup() { 
  balls = new ArrayList<Ball>();
  //fullScreen(P3D); 
  size(1280,720,P2D);
  
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
  
  switch(state) {
    case PLAYING:
      for(Solid solid : solids)
        solid.move();
      break;
    case DEAD:
      deathScreen();
      break;
    case WIN:
      winScreen();
      break;
    case END:
      endScreen();
      break;
    default:
      endScreen(); 
  }
  
  
  // This "passedBall" solution total workaround, still breaks occasionally
  for (int i = 0; i < balls.size(); i++) {
    Ball bi = balls.get(i);
    bi.display();
    //if (bi.isFinish) passedBall = 1;
    bi.move();
    lights.get(i).move(bi.x, bi.y);
  }
  
  lightManager.castLight();
  
  //text(frameRate,40,40);
}

void deathScreen() {
  fill(109);
  rect(0,0,width,height);
  textSize(20);
  textAlign(CENTER);
  fill(50);
  text("Bye bye Frosty", width / 2 , height / 2);
  text("Press 'r' to respawn", width / 2, height / 2 + 20);
}

void endScreen() {
  clearLevel();
  background(75,181,67);
  textSize(30);
  textAlign(CENTER);
  fill(50);
  text("Thank you for playing!",width / 2, height/2 - 20);
  textSize(15);
  text("Press ESCAPE to quit",width / 2, height/2 + 10); 
}

void winScreen() {
  fill(75,181,67);
  rect(0,0,width, height);
  textSize(20);
  textAlign(CENTER);
  fill(50);
  text("Level Complete",width / 2, height/2);
  text("Press ENTER to continue",width / 2, height/2 + 20);
  text("Time: " + df.format(ELAPSED_TIME), 100,100);
}

void mousePressed() {
  addLight(mouseX,mouseY);
}

void keyPressed(){
  if (key == '\n' && state == WIN) {
    if (whichLevel >= NUM_LEVELS) 
      state = END;
    else {
      state = PLAYING;
      clearLevel();
      loadLevel(++whichLevel);
    }
    savedTime = millis();
  }
  
  if (key == 'm') move = !move;
  if (key == 'c') lightManager.removeLights();
  if (key == 'r' && (state != WIN || state != END)) {
    clearLevel();
    loadLevel(whichLevel); 
  }
  
  player.keyPressed();
}

void keyReleased() {
  player.keyReleased();
}
