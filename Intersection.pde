import java.util.Optional;

class Intersection extends SimEntity {
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
  
  Optional<TrafficSignal> addTrafficSignal(Path path, int initialState, float onTime) {
    if (path == pathA) {
      Optional<Pose> pose = pathA.getPoseDistanceFrom(centerPoint.getX(), centerPoint.getY(), -20);
      if (pose.isPresent()) {
        TrafficSignal signal = new TrafficSignal(pose.get().getPosition().getX(), pose.get().getPosition().getY(), pose.get().getHeading(), initialState, 15, onTime);
        pathALight = Optional.of(signal);
        return pathALight;
      }
    }
    else if (path == pathB) {
      Optional<Pose> pose = pathB.getPoseDistanceFrom(centerPoint.getX(), centerPoint.getY(), -20);
      if (pose.isPresent()) {
        TrafficSignal signal = new TrafficSignal(pose.get().getPosition().getX(), pose.get().getPosition().getY(), pose.get().getHeading(), initialState, 15, onTime);
        pathBLight = Optional.of(signal);
        return pathBLight;
      }
    }
    return Optional.empty();
  }
  
  boolean equals(Intersection other) {
    return ((this.pathA == other.pathA && this.pathB == other.pathB && this.centerPoint.getX() == other.centerPoint.getX() && this.centerPoint.getY() == other.centerPoint.getY()) || 
            (this.pathA == other.pathB && this.pathB == other.pathA && this.centerPoint.getX() == other.centerPoint.getX() && this.centerPoint.getY() == other.centerPoint.getY()));
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
      if (inIntersection(pathACommuters.get(i))) {
        pathACommuters.get(i).seekCommutersIntersection(pathBCommuters, pathA);
      }
    }
    for (int i = 0; i < pathBCommuters.size(); i++) {
      if (inIntersection(pathBCommuters.get(i))) {
        pathBCommuters.get(i).seekCommutersIntersection(pathACommuters, pathB);
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
  
  void enactSignal(int FRAME_RATE) {
    if (pathALight.isPresent()) {
      pathALight.get().update(FRAME_RATE);
      pathA.enactSignal(pathALight.get());
    }
    if (pathBLight.isPresent()) {
      pathBLight.get().update(FRAME_RATE);
      pathB.enactSignal(pathBLight.get());
    }
  }
  
  boolean clicked(int mouseXPos, int mouseYPos) {
    return centerPoint.onPoint(mouseXPos, mouseYPos, 20);
  }
  
  boolean inIntersection(Commuter commuter) {
    return centerPoint.onPoint(commuter.getCurrentPoint(), 100);
  }
  
  void removeSignal(TrafficSignal signal) {
    if (pathALight.isPresent() && pathALight.get() == signal) {
      pathALight = Optional.empty();
    }
    if (pathBLight.isPresent() && pathBLight.get() == signal) {
      pathBLight = Optional.empty();
    }
  }
  
  int getNumCollisions() { return this.numCollisions; }
}
