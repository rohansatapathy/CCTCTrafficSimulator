import java.util.Arrays;

public class Path extends SimEntity {
  private ArrayList<Point> nodes;
  private ArrayList<Commuter> commuters;
  private int pathLength;
  
  Path(Point[] nodes) {
    super("Unnamed", color(0, 0, 0));
    
    assert nodes.length >= 2;
    this.nodes = new ArrayList<Point>(Arrays.asList(nodes));
    this.nodes.add(0, nodes[0]);
    this.nodes.add(nodes[nodes.length - 1]);
    this.pathLength = this.nodes.size() - 2;
    this.commuters = new ArrayList<Commuter>();
  }
  
  Path(Point[] nodes, color c, String name) {
    super(name, c);
    
    assert nodes.length >= 2;
    this.nodes = new ArrayList<Point>(Arrays.asList(nodes));
    this.nodes.add(0, nodes[0]);
    this.nodes.add(nodes[nodes.length - 1]);
    this.pathLength = this.nodes.size() - 2;
    this.commuters = new ArrayList<Commuter>();
  }
  
  // draws path
  void draw(PApplet canvas) {
    color strokeColorOriginal = g.strokeColor;
    color fillColorOriginal = g.fillColor;
    
    canvas.stroke(this.c);
    
    canvas.beginShape();
    for (int i = 0; i < nodes.size(); i++) {
      canvas.curveVertex(nodes.get(i).getX(), nodes.get(i).getY());
      nodes.get(i).draw(canvas, this.c);
      canvas.noFill();
      
    }
    canvas.endShape();
 
    canvas.stroke(strokeColorOriginal);
    canvas.fill(fillColorOriginal);
  }
  
  void addCommuter(Commuter commuter) {
    commuter.setPos(this.nodes.get(0).getX(), this.nodes.get(0).getY());
    this.commuters.add(commuter);
    
  }
  
  boolean removeCommuter(Commuter commuter) {
    return this.commuters.remove(commuter);
  }
  
  void updateCommuters() {
    for (int i = 0; i < commuters.size(); i++) {
      commuters.get(i).update(nodes, commuters);
    }
  }
   
  // get commuters currently on path
  ArrayList<Commuter> getCommuters() {
    return this.commuters;
  }
  
  
  int getPathLength() { return this.pathLength; }
  
  Point getPathNode(int index) {
    assert(index >= 0 && index < this.pathLength);
    return this.nodes.get(index + 1);
  }
  
  /*
  assuming relative linearity, we can approximate the corresponding point of comparison on the curve as
  the point D units along the curve, where the ratio of D to the length of the curve equals the ratio
  f the distance of the mouseClick point to the first effective node to the distance between the 2 effective nodes
  */
  boolean clicked(int xPos, int yPos) {
    for (int i = 0; i < nodes.size() - 3; i++) {
      float xDistance = nodes.get(i + 2).getX() - nodes.get(i + 1).getX();
      float yDistance = nodes.get(i + 2).getY() - nodes.get(i + 1).getY();
      float tFactor = (new PVector(xPos - nodes.get(i + 1).getX(), yPos - nodes.get(i + 1).getY()).mag()) / (new PVector(xDistance, yDistance).mag());
      if (tFactor > 1) {
        tFactor = 1;
      }
      
      float x = curvePoint(nodes.get(i).getX(), nodes.get(i + 1).getX(), nodes.get(i + 2).getX(), nodes.get(i + 3).getX(), tFactor);
      float y = curvePoint(nodes.get(i).getY(), nodes.get(i + 1).getY(), nodes.get(i + 2).getY(), nodes.get(i + 3).getY(), tFactor);
      
      if ((new Point(x, y)).onPoint(xPos, yPos, 15)) {
        return true;
      }
    }
    return false;
  }
  
  String toString() { return "Path: " + this.name; }
  
}
