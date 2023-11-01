import java.util.Arrays;
import java.util.Optional;

public class Path extends SimEntity {
  private ArrayList<Point> nodes;
  private ArrayList<Commuter> commuters;
  private int pathLength;
  private Queue<Commuter> spawnQueue;
  private boolean canSpawn;
  private int numCollisions;
  
  Path(Point[] nodes) {
    super("Unnamed", color(0, 0, 0));
    
    assert nodes.length >= 2;
    this.nodes = new ArrayList<Point>(Arrays.asList(nodes));
    this.spawnQueue = new ArrayDeque<Commuter>();
    this.pathLength = this.nodes.size();
    this.commuters = new ArrayList<Commuter>();
    this.canSpawn = true;
  }
  
  Path(Point[] nodes, color c, String name) {
    super(name, c);
    
    assert nodes.length >= 2;
    this.nodes = new ArrayList<Point>(Arrays.asList(nodes));
    this.spawnQueue = new ArrayDeque<Commuter>();
    this.pathLength = this.nodes.size();
    this.commuters = new ArrayList<Commuter>();
    this.canSpawn = true;
  }
  
  // draws path
  void draw(PApplet canvas) {
    color strokeColorOriginal = g.strokeColor;
    color fillColorOriginal = g.fillColor;
    
    canvas.stroke(this.c);
    
    for (int i = 0; i < nodes.size() - 1; i++) {
      canvas.line(nodes.get(i).getX(), nodes.get(i).getY(), nodes.get(i + 1).getX(), nodes.get(i + 1).getY());
      nodes.get(i).draw(canvas, this.c);
    }
    nodes.get(nodes.size() - 1).draw(canvas, this.c);
 
    canvas.stroke(strokeColorOriginal);
    canvas.fill(fillColorOriginal);
  }
  
  boolean addCommuter(Commuter commuter) {
    commuter.resetPosition(this.nodes.get(0).getX(), this.nodes.get(0).getY());
    if (canSpawn) {
      this.commuters.add(commuter);
      return true;
    }
    return false;
  }
  
  boolean removeCommuter(Commuter commuter) {
    return this.commuters.remove(commuter);
  }
  
  
  void updateCommuters() {
    int i = 0;
    while (i < commuters.size()) {
      commuters.get(i).updatePosition(nodes);
      
      if (commuters.get(i).hasReachedEnd()) {
        if (canSpawn) {
          commuters.get(i).resetPosition(nodes.get(0).getX(), nodes.get(0).getY());
        }
        else {
          spawnQueue.add(commuters.get(i));
          commuters.remove(commuters.get(i));
          continue;
        }
      }
      
      commuters.get(i).updateVelocity(commuters);
      i++;
    }
      
  }
   
  // get commuters currently on path
  ArrayList<Commuter> getCommuters() {
    return this.commuters;
  }
  
  boolean clicked(int xPos, int yPos) {
    for (int i = 0; i < nodes.size() - 1; i++) {
      float xDistance = nodes.get(i + 1).getX() - nodes.get(i).getX();
      float yDistance = nodes.get(i + 1).getY() - nodes.get(i).getY();
      float tFactor = (new PVector(xPos - nodes.get(i).getX(), yPos - nodes.get(i).getY()).mag()) / (new PVector(xDistance, yDistance).mag());
      if (tFactor > 1) {
        tFactor = 1;
      }
      
      float x = lerp(nodes.get(i).getX(), nodes.get(i + 1).getX(), tFactor);
      float y = lerp(nodes.get(i).getY(), nodes.get(i + 1).getY(), tFactor);
      if ((new Point(x, y)).onPoint(xPos, yPos, 10)) {
        return true;
      }
    }
    return false;
  }
  
  void updateSpawn() {
    this.canSpawn = true;
    int i = 0;
    while (canSpawn && i < commuters.size()) {
      Commuter commuter = commuters.get(i);
      if (nodes.get(0).onPoint(commuter.getCurrentPoint().getX(), commuter.getCurrentPoint().getY(), commuter.getRadius() + Commuter.MAX_COMMUTER_RADIUS)) {
        this.canSpawn = false;
      }
      i++;
    }
    
    if (!spawnQueue.isEmpty() && canSpawn) {
      Commuter commuter = spawnQueue.remove();
      commuter.resetPosition(nodes.get(0).getX(), nodes.get(0).getY());
      this.commuters.add(commuter);
    }
  }
  
  void updateCollisions() {
    for (int i = 0; i < commuters.size(); i++) {
      numCollisions += commuters.get(i).detectCollisions(commuters);
    }
  }
  
  // returns all points of intersection between this and other
  ArrayList<Point> intersect(Path other) {
    ArrayList<Point> result = new ArrayList<Point>();
    for (int i = 1; i < this.nodes.size(); i++) {
      float x1 = nodes.get(i - 1).getX();
      float y1 = nodes.get(i - 1).getY();
      float x2 = nodes.get(i).getX();
      float y2 = nodes.get(i).getY();
      for (int k = 1; k < other.nodes.size(); k++) {
        float x3 = other.nodes.get(k - 1).getX();
        float y3 = other.nodes.get(k - 1).getY();
        float x4 = other.nodes.get(k).getX();
        float y4 = other.nodes.get(k).getY();
        float uA = ((x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)) / ((y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1));
        float uB = ((x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3)) / ((y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1));
        // intersection occurs
        if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
          float intersectionPointX = x1 + (uA * (x2 - x1));
          float intersectionPointY = y1 + (uA * (y2 - y1));
          result.add(new Point(intersectionPointX, intersectionPointY));
        }
      }
    }
    return result;
  }
  
  void stopCommuters(Point stoppingPos, int radiusOfEffect) {
    for (int i = 0; i < commuters.size(); i++) {
      //System.out.println("in here");
      if (commuters.get(i).getCurrentPoint().onPoint(stoppingPos, radiusOfEffect)) {
        commuters.get(i).stop();
      }
    }
  }
  
  void stopCommuters() {
    for (int i = 0; i < commuters.size(); i++) {
      commuters.get(i).stop();
    }
  }
  
  void releaseCommuters() {
    for (int i = 0; i < commuters.size(); i++) {
      commuters.get(i).go();
    }
  }
  
  
   int getPathLength() { return this.pathLength; }
   
   int getNumCollisions() { return this.numCollisions; }
  //void enactTrafficSignal
  
  String toString() { return "Path: " + this.name; }
  
}
