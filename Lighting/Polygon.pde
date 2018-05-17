final int CLOCKWISE = -1, COLLINEAR = 0, COUNTER_CLOCKWISE = 1;

// Represent ray as point and direction
class Ray {
  PVector pos, dir;
  Ray(PVector pos, PVector dir) {
    this.pos = pos;
    this.dir = dir;
  }
}

class Intersection extends PVector {
  float L, ang;
  Segment segment;
  Intersection(double x, double y, double L, Segment seg) {
    super((float) x, (float) y);
    this.segment = seg;
    this.L = (float) L;
  }
  Intersection(PVector p, float L) {
    super(p.x, p.y);
    this.L = L;
  }
}


/* BEGIN FROM ALGS4 (COS 226)*/
class Point2D extends PVector implements Comparable<Point2D> {
  Point2D(float x, float y) {
    super(x,y);
  }
  public int compareTo(Point2D that) {
    if (this.y < that.y) return -1;
    if (this.y > that.y) return +1;
    if (this.x < that.x) return -1;
    if (this.x > that.x) return +1;
    return 0;
  }
  public Comparator<Point2D> polarOrder() {
    return new PolarOrder();
  }
  private class PolarOrder implements Comparator<Point2D> {
    public int compare(Point2D q1, Point2D q2) {
        double dx1 = q1.x - x;
        double dy1 = q1.y - y;
        double dx2 = q2.x - x;
        double dy2 = q2.y - y;

        if      (dy1 >= 0 && dy2 < 0) return -1;    // q1 above; q2 below
        else if (dy2 >= 0 && dy1 < 0) return +1;    // q1 below; q2 above
        else if (dy1 == 0 && dy2 == 0) {            // 3-collinear and horizontal
            if      (dx1 >= 0 && dx2 < 0) return -1;
            else if (dx2 >= 0 && dx1 < 0) return +1;
            else                          return  0;
        }
        else return -ccw(Point2D.this, q1, q2);     // both above or below

        // Note: ccw() recomputes dx1, dy1, dx2, and dy2
    }
  }
  
}
public int ccw(Point2D a, Point2D b, Point2D c) {
    double area2 = (b.x-a.x)*(c.y-a.y) - (b.y-a.y)*(c.x-a.x);
    if      (area2 < 0) return CLOCKWISE;
    else if (area2 > 0) return COUNTER_CLOCKWISE;
    else                return  COLLINEAR;
  }

PShape convexHull(ArrayList<PVector> points) {
  Stack<Point2D> hull = new Stack<Point2D>();
  
  int n = points.size();
  Point2D[] a = new Point2D[n];
  for(int i = 0; i < n; i++) a[i] = new Point2D(points.get(i).x, points.get(i).y);
  Arrays.sort(a);
  Arrays.sort(a, 1, n, a[0].polarOrder());
  hull.push(a[0]);
  int k1;
  for (k1 = 1; k1 < n; k1++)
    if (!a[0].equals(a[k1])) break;
  if (k1 == n) {
    PShape poly = createShape();
    poly.beginShape();
    poly.vertex(a[0].x,a[0].y);
    poly.endShape();
    return poly;
  }
  
  // find index k2 of first point not collinear with a[0] and a[k1]
  int k2;
  for (k2 = k1+1; k2 < n; k2++)
    if (ccw(a[0], a[k1], a[k2]) != 0) break;
  hull.push(a[k2-1]);    // a[k2-1] is second extreme point

  // Graham scan; note that a[n-1] is extreme point different from a[0]
  for (int i = k2; i < n; i++) {
    Point2D top = hull.pop();
    while (ccw(hull.peek(), top, a[i]) <= 0) {
      top = hull.pop();
    }
    hull.push(top);
    hull.push(a[i]);
  }
  
  PShape poly = createShape();
  poly.beginShape();
  for (Point2D point : hull) poly.vertex(point.x,point.y);
  poly.endShape();
  return poly;
}
/* END FROM ALGS4 (COS 226)*/


// Represent segment as point and vector (magnitude matters)
class Segment {
  PVector pos, dir;
  Solid parent;
  Segment(double sxs, double sys, double sx1s, double sy1s, Solid s) {
    pos = new PVector((float)sxs, (float)sys);
    dir = new PVector((float)sx1s, (float)sy1s).sub(pos);
    parent = s;
  }
}

Intersection getIntersection(Ray ray, Segment segment) {
  
  double T1, T2;
  
  if (Math.abs(ray.dir.x) > Math.abs(ray.dir.y)) {
  // distance along segment
  T2 = (ray.dir.x * (segment.pos.y - ray.pos.y) + ray.dir.y * (ray.pos.x - segment.pos.x)) /
              (segment.dir.x * ray.dir.y - segment.dir.y * ray.dir.x);
  // distance along ray
  T1 = (segment.pos.x + segment.dir.x * T2 - ray.pos.x) / ray.dir.x;
  }
  else {
  // distance along segment
  T2 = (ray.dir.y * (segment.pos.x - ray.pos.x) + ray.dir.x * (ray.pos.y - segment.pos.y)) /
              (segment.dir.y * ray.dir.x - segment.dir.x * ray.dir.y);
  // distance along ray
  T1 = (segment.pos.y + segment.dir.y * T2 - ray.pos.y) / ray.dir.y;
  }
  if (T1 < -EPS || T2 < 0 || T2 > 1) return null;

  return new Intersection(ray.pos.x + ray.dir.x * T1, ray.pos.y + ray.dir.y * T1, T1, segment);
}


public PVector detectCollision(PShape poly, PShape other, PVector motion) {
  ArrayList<PVector> together = new ArrayList<PVector>();
  for (int i = 0; i < poly.getVertexCount(); i++) {
    PVector v = poly.getVertex(i);
    together.add(v);
  }
  for (int i = 0; i < other.getVertexCount(); i++) {
    PVector v = other.getVertex(i);
    together.add(v);
  }
  float dt = INFINITY;
  PVector toGo = new PVector(0,0);
  for (int i = 0; i < together.size(); i++) {
    PVector v = together.get(i);
    int ni;
    if (i < poly.getVertexCount()) {
      ni = i < poly.getVertexCount() - 1 ? i + 1 : 0;
    }
    else {
      ni = i < together.size() - 1 ? i + 1 : poly.getVertexCount();
    }
    
    PVector next = together.get(ni);
    
    
    PVector edge = PVector.sub(next, v);
    PVector normal = new PVector(edge.y,-edge.x).normalize();
    float myMin = INFINITY, myMax = -INFINITY, theirMin = INFINITY, theirMax = -INFINITY;
    for (int j = 0; j < poly.getVertexCount(); j++) {
      PVector u = poly.getVertex(j);
      float t = normal.dot(u);
      myMin = t < myMin ? t : myMin;
      myMax = t > myMax ? t : myMax;
    }
    for (int j = 0; j < other.getVertexCount(); j++) {
      PVector u = other.getVertex(j);
      float t = normal.dot(u);
      theirMin = t < theirMin ? t : theirMin;
      theirMax = t > theirMax ? t : theirMax;
    }
    if (myMax < theirMin || theirMax < myMin)
      return new PVector(0,0);
    else {
      //if (normal.dot(motion) > 0) continue;
      float mag = normal.mag();
      myMin /= mag;
      myMax /= mag;
      theirMin /= mag;
      theirMax /= mag;
      normal.div(mag);
      if (myMax - theirMin > -EPS && myMax - theirMin < dt) {
        if (normal.dot(motion) < 0) continue;
        dt = myMax - theirMin;
        toGo = PVector.mult(normal, -1);
      }
      if (theirMax - myMin > -EPS && theirMax - myMin < dt) {
        if (normal.dot(motion) > 0) continue;
        dt = theirMax - myMin;
        toGo = normal.copy();
      }
    }
  }
  return toGo.mult(dt + EPS);
}
