class Vertex extends PVector{
  Vertex next;
  Vertex(float x, float y) {
    super(x,y);
  }
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
}
