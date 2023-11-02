public class Intersection extends SimEntity {
  private Point centerPoint;
  private Path pathA;
  private Path pathB;
  TrafficSignal signal;
  
  Intersection(Point centerPoint, Path pathA, Path pathB) {
    super("Unnamed", color(220, 208, 255));
    assert(pathA != pathB);
    this.centerPoint = centerPoint;
    this.pathA = pathA;
    this.pathB = pathB;
    this.signal = new TrafficSignal(centerPoint.getX() + 30, centerPoint.getY(), 0, 25);
  }
  
  void draw(PApplet canvas) {
    color strokeColorOriginal = g.strokeColor;
    color fillColorOriginal = g.fillColor;
    
    canvas.stroke(this.c);
    canvas.fill(this.c);
    canvas.circle(this.getXCenterPos(), this.getYCenterPos(), 7);
    this.signal.draw(canvas);
    
    canvas.stroke(strokeColorOriginal);
    canvas.fill(fillColorOriginal);
  }
  
  float getXCenterPos() { return this.centerPoint.getX(); }
  float getYCenterPos() { return this.centerPoint.getY(); }
  
  String toString() { return "Intersection: " + this.name; }
  
  Path getPathA() { return this.pathA; }
  Path getPathB() { return this.pathB; }
  
  void enactSignal() {
    if (signal.getState() == 1) {
      pathB.stopCommuters(centerPoint, signal.getRadiusOfEffect());
      pathA.releaseCommuters();
    }
    else if (signal.getState() == 2) {
      pathA.stopCommuters(centerPoint, signal.getRadiusOfEffect());
      pathB.releaseCommuters();
    }
    else if (signal.getState() == 3) {
      pathA.stopCommuters(centerPoint, signal.getRadiusOfEffect());
      pathB.stopCommuters(centerPoint, signal.getRadiusOfEffect());
    }
    
  }
  
  boolean clicked(int mouseXPos, int mouseYPos) {
    return centerPoint.onPoint(mouseXPos, mouseYPos, 20);
  }
}
