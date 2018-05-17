import java.util.*;
PImage lig;
ArrayList<Solid> solids;
boolean debug = false;
PGraphics buff;
class LightManager {

  Solid boundary;
  LightManager() {
    boundary = new Solid();

    solids = new ArrayList<Solid>();

    boundary.addPoint(0, 0);
    boundary.addPoint(0, height);
    boundary.addPoint(width, height);
    boundary.addPoint(width, 0);
    boundary.visible = false;
  }
  void addObject(Solid so) {
    solids.add(so);
  }
  void update(color c, float effectValue) {
    background(c);
    solids.clear();
    solids.add(boundary);
    fill(c, effectValue);
  }
  void setDebug(boolean tode) {
    debug = tode;
  }
}
class Solid {
  boolean visible = true;
  ArrayList<Float> x = new ArrayList<Float>();
  ArrayList<Float> y = new ArrayList<Float>();
  void addPoint(float xa, float ya) {
    x.add(xa);
    y.add(ya);
  }
  void display() {
    noStroke();
    fill(150, 230, 100);
    beginShape();


    for (int i=0;i<x.size();i++) {
      vertex(x.get(i), y.get(i));
    }
    endShape();
  }
}

class Light {


  void update(float posX, float posY, color c, float radius) {
   
    ArrayList <Inters>intersects = new ArrayList<Inters>();
    ArrayList<Segment> segs = new ArrayList<Segment>();
    ArrayList<Float> pointsX = new ArrayList<Float>();
    ArrayList<Float> pointsY = new ArrayList<Float>();
    for (Solid s:solids) {
      if (s.visible)s.display();
      for (int i=0;i<s.x.size()-1;i++) {
        pointsX.add(s.x.get(i));
        pointsY.add(s.y.get(i));
        segs.add(new Segment(s.x.get(i), s.y.get(i), s.x.get(i+1), s.y.get(i+1)));
      }
      pointsX.add(s.x.get(s.x.size()-1));
      pointsY.add(s.y.get(s.y.size()-1));
      segs.add(new Segment(s.x.get(0), s.y.get(0), s.x.get(s.x.size()-1), s.y.get(s.x.size()-1)));
    }
    // Get all angles
    ArrayList<Double> uniqueAngles = new ArrayList<Double>();

    for (int j=0;j<pointsX.size();j++) {
      double angle = Math.atan2(pointsY.get(j)-posY, pointsX.get(j)-posX);
      //uniquePoint.angle = angle;
      uniqueAngles.add(angle-0.00001);
      uniqueAngles.add(angle);
      uniqueAngles.add(angle+0.00001);
    }
    // RAYS IN ALL DIRECTIONS

    for (int k=0;k<uniqueAngles.size();k++) {
      double angle = uniqueAngles.get(k);

      // Calculate dx & dy from angle
      double dx = Math.cos(angle);
      double dy = Math.sin(angle);



      // Find CLOSEST intersection
      Inters closestIntersect = new Inters(posX+dx*9999, posY+dy*9999, 99999);
      for (Segment theseg: segs) {
        Inters intersect = getIntersection(posX, posY, posX+dx, posY+dy, theseg.sx, theseg.sy, theseg.sx1, theseg.sy1);
        if (intersect==null) {
        }
        else {
          if (intersect.L<closestIntersect.L) {
            closestIntersect=intersect;
          }
        }
      }
      // Add to list of intersects
      closestIntersect.ang = (double)angle;
      intersects.add(closestIntersect);
    }
  if(1/2==1){  Collections.sort(intersects, new Comparator<Inters>() {
      public int compare(Inters o1, Inters o2) {
        return Double.compare(o2.ang, o1.ang);
      }
    }
    );
  }
  else{
  intersects.sort(function(a,b) { return parseFloat(a.ang) - parseFloat(b.ang); } );
  }
     loadPixels();
buff = createGraphics(width,height);
    buff.beginShape();
    for (Inters inte: intersects) {
      buff.noStroke();
      buff.fill(c);
      buff.vertex((float)inte.x1, (float)inte.y1);
    }
    buff.endShape(CLOSE);
    
    buff.loadPixels();
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        int loc = x + y * width;
        
        if (buff.pixels[loc]==c) {
          float t = dist(posX,posY,x,y);
          float transp = (radius/t*5)*2+radius/30;
      
       pixels[x + y * width]=blendColor(pixels[loc], color(red(c)+transp/t,green(c)+transp/t,blue(c)+transp/t,transp),BLEND);
    
        }
      }
    }
    buff.updatePixels(); 
     updatePixels();
    if (debug) {
      for (Inters inte: intersects) {
        stroke(0, 20);
        line(posX, posY, (float)inte.x1, (float)inte.y1);
      }
    }
   
  }
}
float blendColors(float alphaBelow, float alphaAbove) 
{ 
  return alphaBelow + (1.0 - alphaBelow) * alphaAbove;
} 
Inters getIntersection(double r_px, double r_py, double r_px1, double r_py1, double s_px, double s_py, double s_px1, double s_py1) {
  double r_dx = r_px1-r_px;
  double r_dy = r_py1-r_py;
  double s_dx = s_px1-s_px;
  double s_dy = s_py1-s_py; 

  double T2 = (r_dx*(s_py-r_py) + r_dy*(r_px-s_px))/(s_dx*r_dy - s_dy*r_dx);
  double T1 = (s_px+s_dx*T2-r_px)/r_dx;

  if (T1<0||T2<0 || T2>1) return null;

  return new Inters(r_px+r_dx*T1, r_py+r_dy*T1, T1);
}
class Inters {
  double x1, y1, L, ang;
  Inters(double a, double b, double c) {
    x1=a;
    y1=b;
    L=c;
  }
}
class Segment {
  double sx, sy, sx1, sy1;
  Segment(double sxs, double sys, double sx1s, double sy1s) {
    sx = sxs;
    sy = sys;
    sx1 = sx1s;
    sy1 = sy1s;
  }
}

LightManager light;
Light lights, lights2, lights3;

void setup() { 
  size(800,600);
  if(1/2==0)frame.setResizable(true); 
  light = new LightManager();
  lights = new Light();
  lights2= new Light();
  lights3=new Light();
  
  
}
float lx=30, ly=30, lx1=130, ly1=130, lx2=260, ly2=260;
float px, py;
void draw() {
  imageMode(CENTER);
  light.update(color(4),100);
  light.setDebug(false);
Solid shape = new Solid();
  shape.addPoint(100+px, 150+py);
  shape.addPoint(300+px, 150+py);
  shape.addPoint(300+px, 180+py);
  shape.addPoint(100+px, 180+py);
  Solid shape3 = new Solid();
  Solid shape2 = new Solid();
  shape3.addPoint(240, 60);
  shape3.addPoint(360, 40);
  shape3.addPoint(370, 70);
  shape3.addPoint(170, 70);

  shape2.addPoint(440, 340);
  shape2.addPoint(420, 280);
  shape2.addPoint(370, 340);

  light.addObject(shape3);
  light.addObject(shape2);
  light.addObject(shape);
  
  lights.update(lx,ly,color(255,0,0),500);
  lights2.update(lx1,ly1,color(30,30,240),500);
  lights3.update(lx2,ly2,color(50,250,240),500);
text(frameRate,30,30);
}
void mouseDragged(){
  if(dist(mouseX,mouseY,lx,ly)<30){lx=mouseX;ly=mouseY;}
  if(dist(mouseX,mouseY,lx1,ly1)<30){lx1=mouseX;ly1=mouseY;}
  if(dist(mouseX,mouseY,lx2,ly2)<30){lx2=mouseX;ly2=mouseY;}
}
void keyPressed(){
if(key=='a'){
px++;
}
if(key=='d'){
px--;
}
}

