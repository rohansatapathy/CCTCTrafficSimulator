public class Commuter extends SimEntity {
  private int radius;
  
  private float currentV;
  private float originalV;
  private float minimalV;
  private float accelerationConstant = 0.05;
  protected float currentDir;
  protected Point currentPoint;
  private Point targetPoint;
  protected Point seekForwardPoint;
  
  private int targetIndex;
  private SeekConfig seekConfig;
  private boolean stopped;
  private boolean hasReachedEnd;
  private int totalDelay;
  
  public static final int MAX_COMMUTER_RADIUS = 20;
  
  private boolean pathCommuterSighted;
  private boolean intersectionCommuterSighted;
  private float minVelocityPath;
  private float minVelocityIntersection;
  
  private boolean pathCollided;
  private boolean intersectionCollided;
  private boolean pathNeverCollided;
  private boolean intersectionNeverCollided;
  
  Commuter(int radius, float velocity, SeekConfig seekConfig) {
    super("Unnamed", color(0, 255, 0));
    this.radius = radius;
    this.currentV = this.originalV = velocity;
    this.minVelocityIntersection = 0;
    this.minimalV = 0;
    this.minVelocityPath = 0;
    
    this.targetIndex = 0;
    this.currentPoint = new Point(0, 0);
    this.targetPoint = new Point(0, 0);
    this.seekForwardPoint = new Point(0, 0);
    this.currentDir = 0;
    this.seekConfig = seekConfig;
    this.stopped = false;
    this.hasReachedEnd = false;
    this.totalDelay = 0;
    
    this.pathCommuterSighted = this.intersectionCommuterSighted = false;
    this.pathCollided = this.intersectionCollided = false;
  }
  
  Commuter(int radius, float velocity, SeekConfig seekConfig, String name, color c) {
    super(name, c);
    this.radius = radius;
    this.currentV = this.originalV = velocity;
    this.minVelocityIntersection = 0;
    this.minimalV = 0;
    this.minVelocityPath = 0;
    
    this.targetIndex = 0;
    this.currentPoint = new Point(0, 0);
    this.targetPoint = new Point(0, 0);
    this.seekForwardPoint = new Point(0, 0);
    this.currentDir = 0;
    this.seekConfig = seekConfig;
    this.stopped = false;
    this.hasReachedEnd = false;
    this.totalDelay = 0;
    
    this.pathCommuterSighted = this.intersectionCommuterSighted = false;
    this.pathCollided = this.intersectionCollided = false;
  }
  
  void resetPosition(float xPos, float yPos) {
    reset();
    this.currentPoint.setX(xPos);
    this.currentPoint.setY(yPos);
    this.targetPoint.setX(xPos);
    this.targetPoint.setY(yPos);
    this.seekForwardPoint.setX(xPos);
    this.seekForwardPoint.setY(yPos);
    this.targetIndex = 0;
    this.hasReachedEnd = false;
  }
  
  void updatePosition(ArrayList<Point> pathNodes) {
    float distToBeTraveled = currentV;
    float distFromCurrentToTarget = sqrt(pow(targetPoint.getX() - currentPoint.getX(), 2) + pow(targetPoint.getY() - currentPoint.getY(), 2));
    while (distToBeTraveled > distFromCurrentToTarget) {
      currentPoint.setX(targetPoint.getX());
      currentPoint.setY(targetPoint.getY());
      targetIndex++;
      if (targetIndex >= pathNodes.size()) {
        hasReachedEnd = true;
        return;
      }
      targetPoint.setX(pathNodes.get(targetIndex).getX());
      targetPoint.setY(pathNodes.get(targetIndex).getY());
      distToBeTraveled -= distFromCurrentToTarget;
      distFromCurrentToTarget = sqrt(pow(targetPoint.getX() - currentPoint.getX(), 2) + pow(targetPoint.getY() - currentPoint.getY(), 2));
    }
    this.currentDir = atan2(-(targetPoint.getY() - currentPoint.getY()), targetPoint.getX() - currentPoint.getX());
    this.currentPoint.setX(this.currentPoint.getX() + currentV * cos(currentDir));
    this.currentPoint.setY(this.currentPoint.getY() + currentV * sin((-1) * currentDir)); //<>//
  }
  
  void reset() {
    this.pathCommuterSighted = this.intersectionCommuterSighted = false;
    this.stopped = false;
    if (this.pathNeverCollided) {
      this.pathCollided = false;
    }
    if (this.intersectionNeverCollided) {
      this.intersectionCollided = false;
    }
    this.pathNeverCollided = this.intersectionNeverCollided = true;
  }
  
  void updateVelocity() {
    if (this.stopped || intersectionCommuterSighted) {
      minimalV = minVelocityIntersection;
      deaccelerate();
      System.out.println("currentV: " + this.currentV);
    }
    else if (pathCommuterSighted) {
      minimalV = minVelocityPath;
      deaccelerate();
    }
    else {
      cruise();
    }
    
    if (currentV < originalV) {
      totalDelay++;
    }
  }
  
  int seekCommuters(ArrayList<Commuter> others) {
    for (int i = 0; i < others.size(); i++) {
      if (this != others.get(i)) {
        seekForwardPoint.setX(currentPoint.getX() + seekConfig.getSeekDistance(others.get(i)) * cos(currentDir));
        seekForwardPoint.setY(currentPoint.getY() + seekConfig.getSeekDistance(others.get(i)) * sin((-1) * currentDir));
        if (seekForwardPoint.onPoint(others.get(i).currentPoint, seekConfig.getSeekRadius(others.get(i)))) {
          return i;
        }
      }
    }
    return -1;
  }
  
  void seekCommutersPath(ArrayList<Commuter> others) {
    int commuterIndex = this.seekCommuters(others);
    if (commuterIndex >= 0) {
      pathCommuterSighted = true;
      minVelocityPath = others.get(commuterIndex).currentV;
    }
  }
  
  void seekCommutersIntersection(ArrayList<Commuter> others) {
    int commuterIndex = this.seekCommuters(others);
    if (commuterIndex >= 0 && !others.get(commuterIndex).intersectionCommuterSighted) {
      intersectionCommuterSighted = true;
      minVelocityIntersection = 0; //<>//
    }
  }
  
  boolean seekTrafficSignal(TrafficSignal signal) {
    seekForwardPoint.setX(currentPoint.getX() + 10 * cos(currentDir));
    seekForwardPoint.setY(currentPoint.getY() + 10 * sin((-1) * currentDir));
    return seekForwardPoint.onPoint(signal.getPosition(), 10);
  }
  
  int detectCollisionsPath(ArrayList<Commuter> others) {
    int i = 0;
    int collisionCount = 0;
    while (pathNeverCollided && i < others.size()) {
      if (this != others.get(i) && !(this instanceof Pedestrian && others.get(i) instanceof Pedestrian) && detectCollision(others.get(i))) {
        this.pathNeverCollided = others.get(i).pathNeverCollided = false;
        if (!(this.pathCollided && others.get(i).pathCollided)) {
          this.pathCollided = others.get(i).pathCollided = true;
          collisionCount++;
        }
      }
      i++;
    }
    return collisionCount;
  }
  
  int detectCollisionsIntersection(ArrayList<Commuter> others) {
    int i = 0;
    int collisionCount = 0;
    while (intersectionNeverCollided && i < others.size()) {
      if (this != others.get(i) && !(this instanceof Pedestrian && others.get(i) instanceof Pedestrian) && detectCollision(others.get(i))) {
        this.intersectionNeverCollided = others.get(i).intersectionNeverCollided = false;
        if (!(this.intersectionCollided && others.get(i).intersectionCollided)) {
          this.intersectionCollided = others.get(i).intersectionCollided = true;
          collisionCount++;
        }
      }
      i++;
    }
    return collisionCount;
  }
  
  void draw(PApplet canvas) {
    color strokeColorOriginal = g.strokeColor;
    color fillColorOriginal = g.fillColor;
    
    canvas.stroke(this.c);
    canvas.fill(this.c);
    canvas.circle(this.currentPoint.getX(), this.currentPoint.getY(), this.radius);
    canvas.stroke(strokeColorOriginal);
    canvas.fill(fillColorOriginal);
  }
  
  void accelerate() {
    this.currentV += 0.01; 
  }
  
  void deaccelerate() {
    if (this.currentV > this.minimalV) {
      if (this.currentV - accelerationConstant > 0) {
        this.currentV -= accelerationConstant;
      }
      else {
        this.currentV /= 2;
      }
    }
  }
  
  void cruise() {
    if (this.currentV < this.originalV) {
      accelerate();
    }
    else if (this.currentV > this.originalV) {
      deaccelerate();
    }
    else {
      return;
    }
    
  }
  
  boolean clicked(int mouseXPos, int mouseYPos) { return (currentPoint.onPoint(mouseXPos, mouseYPos, radius)); }
  
  boolean detectCollision(Commuter other) { return currentPoint.onPoint(other.currentPoint, this.radius); }
  
  boolean hasReachedEnd() { return this.hasReachedEnd; }
  
  void stop() { this.stopped = true; }
  
  String toString() { return "Commuter: " + this.name; }
  
  Point getCurrentPoint() { return this.currentPoint; }
  
  float getCurrentV() { return this.currentV; }
  
  int getRadius() { return this.radius; }
  
  int getTotalDelay() { return this.totalDelay; }
}
