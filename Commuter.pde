public class Commuter extends SimulationEntity {
  private final Path pathOfTravel;
  private final int radius;
  
  private float currentXPos;
  private float currentYPos;
  private float currentV;
  private float currentDir;
  
  private Point targetCoord;
  private int currentCurvePoint;
  private final int NUM_DIVISIONS = 50;
  private int divisionCounter = 0;
 
  
  Commuter(Path pathOfTravel, int radius, float currentV) {
    super("Unnamed", color(0, 255, 0));
    this.pathOfTravel = pathOfTravel;
    this.radius = radius;
    this.currentV = currentV;
    
    this.currentXPos = pathOfTravel.getPathNode(0).getX();
    this.currentYPos = pathOfTravel.getPathNode(0).getY();
    this.currentCurvePoint = 0;
    
    this.divisionCounter = (this.divisionCounter + 1) % NUM_DIVISIONS;
    float t = (divisionCounter % NUM_DIVISIONS) / (float)NUM_DIVISIONS;
    this.targetCoord = pathOfTravel.getCurvePoint(currentCurvePoint, t);
    
    this.currentDir = atan2(-(targetCoord.getY() - currentYPos), targetCoord.getX() - currentXPos);
    
    
  }
  
  void update() {
    this.currentXPos = this.currentXPos + currentV * cos(currentDir);
    this.currentYPos = this.currentYPos + currentV * sin((-1) * currentDir);
    
    if (this.targetCoord.onPoint(currentXPos, currentYPos, radius)) {
      divisionCounter++;
      if (divisionCounter == NUM_DIVISIONS) {
        divisionCounter = 0;
        currentCurvePoint++;
        if (currentCurvePoint == pathOfTravel.getPathLength() - 1) {
          // commuter has reached end of path
          currentCurvePoint = 0;
          // reset to beginning
          this.currentXPos = pathOfTravel.getPathNode(0).getX();
          this.currentYPos = pathOfTravel.getPathNode(0).getY();
        }
      }
      
      // get new target coord
      float t = (divisionCounter % NUM_DIVISIONS) / (float)NUM_DIVISIONS;
      this.targetCoord = pathOfTravel.getCurvePoint(currentCurvePoint, t);
    }
    
    this.currentDir = atan2(-(targetCoord.getY() - currentYPos), targetCoord.getX() - currentXPos);
  }
  
  void draw(PApplet canvas) {
    color strokeColorOriginal = g.strokeColor;
    color fillColorOriginal = g.fillColor;
    
    canvas.stroke(this.c);
    canvas.fill(this.c);
    canvas.circle(this.currentXPos, this.currentYPos, this.radius);
    
    canvas.stroke(strokeColorOriginal);
    canvas.fill(fillColorOriginal);
  }
  
  
  boolean clicked(int mouseXPos, int mouseYPos) { 
    Point commuterPos = new Point(currentXPos, currentYPos);
    return (commuterPos.onPoint(mouseXPos, mouseYPos, radius));
  }
  
  Path getPathOfTravel() { return this.pathOfTravel; }
  
  String toString() { return "Commuter: " + this.name; }
}
