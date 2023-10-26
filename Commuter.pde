public class Commuter extends SimEntity {
  private final int radius;
  private boolean collided;
  
  private float currentV;
  protected float currentDir;
  
  protected Point currentPoint;
  private Point targetPoint;
  private Point seekForwardPoint;
  private Point seekBackwardPoint;
  
  private int currentCurvePoint;
  private final int NUM_DIVISIONS = 50;
  private int divisionCounter;
  
  
  Commuter(int radius, float currentV) {
    super("Unnamed", color(0, 255, 0));
    this.radius = radius;
    this.currentV = currentV;
    
    this.currentCurvePoint = 0;
    this.currentPoint = new Point(0, 0);
    this.targetPoint = new Point(0, 0);
    this.seekForwardPoint = new Point(0, 0);
    this.seekBackwardPoint = new Point(0, 0);
    this.currentDir = 0;
    this.collided = true; // initial collision during spawn does not count
    this.divisionCounter = 0;

  }
  
  Commuter(int radius, float currentV, String name, color c) {
    super(name, c);
    this.radius = radius;
    this.currentV = currentV;
    
    this.currentCurvePoint = 0;
    this.currentPoint = new Point(0, 0);
    this.targetPoint = new Point(0, 0);
    this.seekForwardPoint = new Point(0, 0);
    this.seekBackwardPoint = new Point(0, 0);
    this.currentDir = 0;
    this.collided = true; // initial collision during spawn does not count
    this.divisionCounter = 0;
  }
  
  void setPos(float xPos, float yPos) {
    this.currentPoint.setX(xPos);
    this.currentPoint.setY(yPos);
    this.targetPoint.setX(xPos);
    this.targetPoint.setY(yPos);
    this.seekForwardPoint.setX(xPos);
    this.seekForwardPoint.setY(yPos);
    this.seekBackwardPoint.setX(xPos);
    this.seekBackwardPoint.setY(yPos);
  }
  
  // TODO: add a commuter "seek forward" and "seek backward" mechanism with new commuters parameter
  void update(ArrayList<Point> pathNodes, ArrayList<Commuter> commuters) {
    if (targetPoint.onPoint(currentPoint.getX(), currentPoint.getY(), radius)) {
      divisionCounter++;
      if (divisionCounter == NUM_DIVISIONS) {
        divisionCounter = 0;
        currentCurvePoint++;
        if (currentCurvePoint >= pathNodes.size() - 3) {
          // commuter has reached end of path, reset to beginning
          currentCurvePoint = 0;
          this.currentPoint.setX(pathNodes.get(0).getX());
          this.currentPoint.setY(pathNodes.get(0).getY());
        }
      }
      
      // get new target x and y
      float t = (divisionCounter % NUM_DIVISIONS) / (float)NUM_DIVISIONS;
      float x = curvePoint(pathNodes.get(currentCurvePoint).getX(), pathNodes.get(currentCurvePoint + 1).getX(), pathNodes.get(currentCurvePoint + 2).getX(), pathNodes.get(currentCurvePoint + 3).getX(), t);
      float y = curvePoint(pathNodes.get(currentCurvePoint).getY(), pathNodes.get(currentCurvePoint + 1).getY(), pathNodes.get(currentCurvePoint + 2).getY(), pathNodes.get(currentCurvePoint + 3).getY(), t);
      targetPoint.setX(x);
      targetPoint.setY(y);
      // adjust velocity here
    }
    
    this.currentDir = atan2(-(targetPoint.getY() - currentPoint.getY()), targetPoint.getX() - currentPoint.getX());
    this.currentPoint.setX(this.currentPoint.getX() + currentV * cos(currentDir));
    this.currentPoint.setY(this.currentPoint.getY() + currentV * sin((-1) * currentDir));
    //seekForward(pathNodes);
    //seekBackward(pathNodes);
    
  }
  
  void seekForward(ArrayList<Point> pathNodes) {
    int seekForwardDivisionCounter = divisionCounter + 5;
    int seekForwardCurvePoint = currentCurvePoint;
    if (seekForwardDivisionCounter >= NUM_DIVISIONS) {
      seekForwardDivisionCounter = seekForwardDivisionCounter % NUM_DIVISIONS;
      seekForwardCurvePoint++;
      if (currentCurvePoint >= pathNodes.size() - 3) {
        this.seekForwardPoint.setX(pathNodes.get(pathNodes.size() - 2).getX());
        this.seekForwardPoint.setY(pathNodes.get(pathNodes.size() - 2).getY());
        return;
      }
    }
    
    float t = (seekForwardDivisionCounter % NUM_DIVISIONS) / (float)NUM_DIVISIONS;
    float x = curvePoint(pathNodes.get(seekForwardCurvePoint).getX(), pathNodes.get(seekForwardCurvePoint + 1).getX(), pathNodes.get(seekForwardCurvePoint + 2).getX(), pathNodes.get(seekForwardCurvePoint + 3).getX(), t);
    float y = curvePoint(pathNodes.get(seekForwardCurvePoint).getY(), pathNodes.get(seekForwardCurvePoint + 1).getY(), pathNodes.get(seekForwardCurvePoint + 2).getY(), pathNodes.get(seekForwardCurvePoint + 3).getY(), t);
    seekForwardPoint.setX(x);
    seekForwardPoint.setY(y);
  }
  
 
  void seekBackward(ArrayList<Point> pathNodes) {
    int seekBackwardDivisionCounter = divisionCounter - 5;
    if (seekBackwardDivisionCounter <= 0) {
      seekBackwardDivisionCounter = NUM_DIVISIONS + seekBackwardDivisionCounter;
      currentCurvePoint--;
      if (currentCurvePoint <= 0) {
        this.seekBackwardPoint.setX(pathNodes.get(0).getX());
        this.seekBackwardPoint.setY(pathNodes.get(0).getY());
        return;
      }
    }
    
    float t = (seekBackwardDivisionCounter % NUM_DIVISIONS) / (float)NUM_DIVISIONS;
    float x = curvePoint(pathNodes.get(currentCurvePoint).getX(), pathNodes.get(currentCurvePoint + 1).getX(), pathNodes.get(currentCurvePoint + 2).getX(), pathNodes.get(currentCurvePoint + 3).getX(), t);
    float y = curvePoint(pathNodes.get(currentCurvePoint).getY(), pathNodes.get(currentCurvePoint + 1).getY(), pathNodes.get(currentCurvePoint + 2).getY(), pathNodes.get(currentCurvePoint + 3).getY(), t);
    seekBackwardPoint.setX(x);
    seekBackwardPoint.setY(y);
  }
  
  void adjustVelocity(ArrayList<Commuter> commuters) {
    
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
  
  
  boolean clicked(int mouseXPos, int mouseYPos) { 
    return (currentPoint.onPoint(mouseXPos, mouseYPos, radius));
  }
  
  boolean detectCollision(Commuter other) {
     return currentPoint.onPoint(other.currentPoint.getX(), other.currentPoint.getY(), this.radius);
  }
  
  boolean isCollided() {
    return collided;
  }
  
  void setVelocity() {}
  
  void setCollided(boolean value) {
    this.collided = value;
  }
  
  String toString() { return "Commuter: " + this.name; }
}
