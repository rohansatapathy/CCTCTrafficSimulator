public class Commuter extends SimEntity {
  private int radius;
  private boolean deaccelerated;
  private boolean collided;
  
  private float currentV;
  private float originalV;
  private float accelerationConstant = 0.05;
  protected float currentDir;
  
  protected Point currentPoint;
  private Point targetPoint;
  private Point seekForwardPoint;
  
  private int targetIndex;
  private SeekConfig seekConfig;
  private boolean stopped;
  private boolean hasReachedEnd;
  
  public static final int MAX_COMMUTER_RADIUS = 20;
  
  Commuter(int radius, float velocity, SeekConfig seekConfig) {
    super("Unnamed", color(0, 255, 0));
    this.radius = radius;
    this.currentV = this.originalV = velocity;
    
    this.targetIndex = 0;
    this.currentPoint = new Point(0, 0);
    this.targetPoint = new Point(0, 0);
    this.seekForwardPoint = new Point(0, 0);
    this.currentDir = 0;
    this.seekConfig = seekConfig;
    this.stopped = false;
    this.hasReachedEnd = false;
    this.deaccelerated = false;
    this.collided = true; // initial collision during spawn does not count
  }
  
  Commuter(int radius, float velocity, SeekConfig seekConfig, String name, color c) {
    super(name, c);
    this.radius = radius;
    this.currentV = this.originalV = velocity;
    
    this.targetIndex = 0;
    this.currentPoint = new Point(0, 0);
    this.targetPoint = new Point(0, 0);
    this.seekForwardPoint = new Point(0, 0);
    this.currentDir = 0;
    this.seekConfig = seekConfig;
    this.stopped = false;
    this.hasReachedEnd = false;
    this.deaccelerated = false;
    this.collided = true; // initial collision during spawn does not count
  }
  
  void resetPosition(float xPos, float yPos) {
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
    if (targetPoint.onPoint(currentPoint, 5)) {
      targetIndex++;
      if (targetIndex >= pathNodes.size()) {
        hasReachedEnd = true;
        return;
      }
      this.targetPoint.setX(pathNodes.get(targetIndex).getX());
      this.targetPoint.setY(pathNodes.get(targetIndex).getY());
    }
    
    this.currentDir = atan2(-(targetPoint.getY() - currentPoint.getY()), targetPoint.getX() - currentPoint.getX());
    this.currentPoint.setX(this.currentPoint.getX() + currentV * cos(currentDir));
    this.currentPoint.setY(this.currentPoint.getY() + currentV * sin((-1) * currentDir));
    //this.deaccelerated = false;
  }
  
  void updateVelocity(ArrayList<Commuter> others) {
    if (seekForward(others) || this.stopped) {
      this.deaccelerate();
    }
    else {
      //System.out.println("cruise");
      this.cruise();
    }
  }
  
  boolean seekForward(ArrayList<Commuter> others) {
    for (int i = 0; i < others.size(); i++) {
      if (this != others.get(i)) {
        seekForwardPoint.setX(currentPoint.getX() + seekConfig.getSeekDistance(others.get(i)) * cos(currentDir));
        seekForwardPoint.setY(currentPoint.getY() + seekConfig.getSeekDistance(others.get(i)) * sin((-1) * currentDir));
        if (seekForwardPoint.onPoint(others.get(i).currentPoint, seekConfig.getSeekRadius(others.get(i)))) {
          return true;
        }
      }
    }
    return false;
  }
  
  int detectCollisions(ArrayList<Commuter> others) {
    int i = 0;
    int collisionCount = 0;
    boolean neverCollided = true;
    while (neverCollided && i < others.size()) {
      if (this != others.get(i) && !(this instanceof Pedestrian && others.get(i) instanceof Pedestrian) && detectCollision(others.get(i))) {
        neverCollided = false;
        if (!(this.collided && others.get(i).collided)) {
          this.collided = true;
          others.get(i).collided = true;
          collisionCount++;
        }
      }
      i++;
    }
    
    if (neverCollided) {
      collided = false;
    }
    else {
      collided = true;
    }
    
    return collisionCount;
  } //<>//
  
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
    this.currentV += accelerationConstant; 
  }
  
  void deaccelerate() {
    if (this.currentV - accelerationConstant > 0) {
      this.currentV -= accelerationConstant;
    }
    else {
      this.currentV /= 2;
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
  
  boolean detectCollision(Commuter other) { return currentPoint.onPoint(other.currentPoint, this.radius + other.getRadius()); }
  
  boolean hasReachedEnd() { return this.hasReachedEnd; }
  
  void stop() { this.stopped = true; }
  
  void go() { this.stopped = false; }
  
  String toString() { return "Commuter: " + this.name; }
  
  Point getCurrentPoint() { return this.currentPoint; }
  
  int getRadius() { return this.radius; }
}
