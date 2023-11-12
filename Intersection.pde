import java.util.Optional;

public class Intersection extends SimEntity {
  private Point centerPoint;
  private Path pathA;
  private Path pathB;
  Optional<TrafficSignal> pathALight;
  Optional<TrafficSignal> pathBLight;
  private int numCollisions;
  
  Intersection(Point centerPoint, Path pathA, Path pathB) {
    super("Unnamed", color(220, 208, 255));
    assert(pathA != pathB);
    this.centerPoint = centerPoint;
    this.pathA = pathA;
    this.pathB = pathB;
    pathALight = Optional.empty();
    pathBLight = Optional.empty();
    System.out.println(centerPoint);
  }
  
  void draw(PApplet canvas) {
    color strokeColorOriginal = g.strokeColor;
    color fillColorOriginal = g.fillColor;
    
    canvas.stroke(this.c);
    canvas.fill(this.c);
    canvas.circle(this.getXCenterPos(), this.getYCenterPos(), 7);
    if (pathALight.isPresent()) {
      pathALight.get().draw(canvas);
    }
    
    if (pathBLight.isPresent()) {
      pathBLight.get().draw(canvas);
    }
    
    canvas.stroke(strokeColorOriginal);
    canvas.fill(fillColorOriginal);
  }
  
  boolean addTrafficSignal(Path path, int initialState) {
    if (path == pathA) {
      Optional<Point> node = pathA.getPreviousPathNode(centerPoint.getX(), centerPoint.getY());
      if (node.isPresent()) {
        float direction = atan2(-(node.get().getY() - centerPoint.getY()), node.get().getX() - centerPoint.getX());
        float positionX = centerPoint.getX() + 20 * cos(direction);
        float positionY = centerPoint.getY() + 20 * sin((-1) * direction);
        pathALight = Optional.of(new TrafficSignal(positionX, positionY, direction, initialState, 15));
        return true;
      }
    }
    else if (path == pathB) {
      Optional<Point> node = pathB.getPreviousPathNode(centerPoint.getX(), centerPoint.getY());
      if (node.isPresent()) {
        float direction = atan2(-(node.get().getY() - centerPoint.getY()), node.get().getX() - centerPoint.getX());
        float positionX = centerPoint.getX() + 20 * cos(direction);
        float positionY = centerPoint.getY() + 20 * sin((-1) * direction);
        pathBLight = Optional.of(new TrafficSignal(positionX, positionY, direction, initialState, 15));
        return true;
      }
    }
    return false;
  }
  
  float getXCenterPos() { return this.centerPoint.getX(); }
  float getYCenterPos() { return this.centerPoint.getY(); }
  
  String toString() { return "Intersection: " + this.name; }
  
  Path getPathA() { return this.pathA; }
  Path getPathB() { return this.pathB; }
  
  void seekCommuters() {
    ArrayList<Commuter> pathACommuters = pathA.getCommuters();
    ArrayList<Commuter> pathBCommuters = pathB.getCommuters();
    for (int i = 0; i < pathACommuters.size(); i++) {
      if (inIntersection(pathACommuters.get(i))) { // TODO: consider letting seekCommutersIntersection handle this if?
        pathACommuters.get(i).seekCommutersIntersection(pathBCommuters);
      }
    }
    for (int i = 0; i < pathBCommuters.size(); i++) {
      if (inIntersection(pathBCommuters.get(i))) {
        pathBCommuters.get(i).seekCommutersIntersection(pathACommuters);
      }
    }
  }
  
  void updateCollisions() {
    ArrayList<Commuter> pathACommuters = pathA.getCommuters();
    ArrayList<Commuter> pathBCommuters = pathB.getCommuters();
    for (int i = 0; i < pathACommuters.size(); i++) {
      if (inIntersection(pathACommuters.get(i))) {
        numCollisions += pathACommuters.get(i).detectCollisionsIntersection(pathBCommuters);
      }
    }
    for (int i = 0; i < pathBCommuters.size(); i++) {
      if (inIntersection(pathBCommuters.get(i))) {
        numCollisions += pathBCommuters.get(i).detectCollisionsIntersection(pathACommuters);
      }
    }
  }
  
  void enactSignal() {
    if (pathALight.isPresent()) {
      pathA.enactSignal(pathALight.get());
    }
    if (pathBLight.isPresent()) {
      pathB.enactSignal(pathBLight.get());
    }
  }
  
  boolean clicked(int mouseXPos, int mouseYPos) {
    return centerPoint.onPoint(mouseXPos, mouseYPos, 20);
  }
  
  // TODO: remove this??
  boolean inIntersection(Commuter commuter) {
    return centerPoint.onPoint(commuter.getCurrentPoint(), 15);
  }
  
  ArrayList<TrafficSignal> getSignals() {
    ArrayList<TrafficSignal> signals = new ArrayList<TrafficSignal>();
    if (pathALight.isPresent()) {
      signals.add(pathALight.get());
    }
    if (pathBLight.isPresent()) {
      signals.add(pathBLight.get());
    }
    return signals;
  }
  
  int getNumCollisions() { return this.numCollisions; }
}
