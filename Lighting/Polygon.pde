class Vertex extends PVector{
  Vertex next;
  Vertex(float x, float y) {
    super(x,y);
  }
}

Intersection getIntersection(Ray ray, Segment segment) {
  // distance along segment
  double T2 = (ray.dir.x * (segment.pos.y - ray.pos.y) + ray.dir.y * (ray.pos.x - segment.pos.x)) /
              (segment.dir.x * ray.dir.y - segment.dir.y * ray.dir.x);
  // distance along ray
  double T1 = (segment.pos.x + segment.dir.x * T2 - ray.pos.x) / ray.dir.x;

  if (T1 < 0 || T2 < 0 || T2 > 1) return null;

  return new Intersection(ray.pos.x + ray.dir.x * T1, ray.pos.y + ray.dir.y * T1, T1, segment);
}

class Polygon implements Iterable<Vertex> {
  Vertex head, tail;
  
  public void addPoint(float x, float y) {
    Vertex v = new Vertex(x,y);
    if (this.head == null) {
      this.head = v;
      this.tail = v;
    }
    v.next = head;
    tail.next = v;
    tail = v;
  }
  public Iterator<Vertex> iterator() {
    return new VertexIterator();
  }
  private class VertexIterator implements Iterator<Vertex> {
    private Vertex current;
    private boolean started;
    public VertexIterator() {
      this.current = Polygon.this.head;
      started = false;
    }
    public boolean hasNext() {
      return !(current != null && started  && current == Polygon.this.head);
    }
    public Vertex next() {
      if (!this.hasNext()) throw new NoSuchElementException();
      Vertex toReturn = current;
      current = current.next;
      started = true;
      return toReturn;
    }
  }
  public PVector detectCollision(Polygon other) {
    ArrayList<Vertex> together = new ArrayList<Vertex>();
    for (Vertex v : this) together.add(v);
    for (Vertex v : other) together.add(v);
    float dt = INFINITY;
    PVector toGo = new PVector(0,0);
    for (Vertex v : together) {
      PVector edge = PVector.sub(v.next, v);
      PVector normal = new PVector(edge.y,-edge.x);
      float myMin = INFINITY, myMax = -INFINITY, theirMin = INFINITY, theirMax = -INFINITY;
      for (Vertex u : this) {
        float t = normal.dot(u);
        myMin = t < myMin ? t : myMin;
        myMax = t > myMax ? t : myMax;
      }
      for (Vertex u : other) {
        float t = normal.dot(u);
        theirMin = t < theirMin ? t : theirMin;
        theirMax = t > theirMax ? t : theirMax;
      }
      if (myMax < theirMin || theirMax < myMin)
        return new PVector(0,0);
      else {
        if (myMax - theirMin > 0 && myMax - theirMin < dt) {
          dt = myMax - theirMin;
          toGo = PVector.mult(normal, -1).normalize();
        }
        if (theirMax - myMin > 0 && theirMax - myMin < dt) {
          dt = theirMax - myMin;
          toGo = normal.copy().normalize();
        }
      }
    }
    return toGo.mult(dt);
  }
}
