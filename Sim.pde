import java.util.Optional;
import java.util.*;

public class Sim {
  private PApplet canvas;
  private ArrayList<Path> paths;
  private ArrayList<Point> points;
  private final float PIXELS_PER_FEET = (70 / 50);
  
  // for data!
  private int totalCollisions;
  
  Sim(PApplet canvas) {
    this.canvas = canvas;
    this.paths = new ArrayList<Path>();
    this.points = new ArrayList<Point>();
    totalCollisions = 0;
  }
  
  void addPoint(int xCoord, int yCoord) {
    addPoint(xCoord, yCoord, "Unnamed", color(0, 0, 0));
  }
  
  void addPoint(int xCoord, int yCoord, String name, color c) {
    Point point = new Point(xCoord, yCoord, name, c);
    points.add(point);
  }
  
  void removePoint(Point target) {
    points.remove(target);
  }
  
  void addPath(Point[] nodes) {
    addPath(nodes, color(0, 0, 0), "Unnamed");
  }
  
  void addPath(Point[] nodes, color c, String name) {
    System.out.println("Num: " + paths.size());
    paths.add(new Path(nodes, c, name));
  }
  
  void addPath(Path path) {
    paths.add(path);
  }
  
  void removePath(Path target) {
    paths.remove(target);
  }
  
  
  void addCommuter(Commuter commuter, Path path) {
    for (int i = 0; i < paths.size(); i++) {
      if (paths.get(i) == path) {
        paths.get(i).addCommuter(commuter);
      }
    }
  }
  
  void removeCommuter(Commuter commuter) {
    for (int i = 0; i < paths.size(); i++) {
      if (paths.get(i).removeCommuter(commuter)) {
        return;
      }
    }
  }
  
  void updateCollisions() {
    ArrayList<Commuter> allCommuters = new ArrayList<Commuter>();
    for (int i = 0; i < paths.size(); i++) {
      allCommuters.addAll(paths.get(i).getCommuters());
    }
    
    for (int i = 0; i < allCommuters.size(); i++) {
      int k = i + 1;
      boolean neverCollided = true;
      while (neverCollided && k < allCommuters.size()) {
        // non-pedestrian collision detected  
        if (!(allCommuters.get(i) instanceof Pedestrian && allCommuters.get(k) instanceof Pedestrian) && 
              allCommuters.get(i).detectCollision(allCommuters.get(k))) {
          neverCollided = false;
          if (!allCommuters.get(i).isCollided()) {
            this.totalCollisions++;
          }
        }
        k++;
      }
      
      if (neverCollided) {
        allCommuters.get(i).setCollided(false);
      }
      else {
        allCommuters.get(i).setCollided(true);
      }
    }
  }
  
  void obstacleAvoidance() {} // TODO: implement this
  
  void update() {
    for (int i = 0; i < paths.size(); i++) {
      paths.get(i).updateCommuters();
    }
    updateCollisions();
  }
  
  int getCollisionCount() { // TODO: consider an overall get data function ????
    return this.totalCollisions;
  }
  
  void draw() {
    for (int i = 0; i < paths.size(); i++) { // draw paths
      paths.get(i).draw(this.canvas);
    }
    
    for (int i = 0; i < points.size(); i++) { // draw points
      points.get(i).draw(this.canvas);
    }
    
    for (int i = 0; i < paths.size(); i++) { // draw commuters
      ArrayList<Commuter> commuters = paths.get(i).getCommuters();
      for (int k = 0; k < commuters.size(); k++) {
        commuters.get(k).draw(this.canvas);
      }
    }
    
  }
  
  Optional<SimEntity> getClick(int mouseXPos, int mouseYPos) {
    for (int i = 0; i < points.size(); i++) {
      if (points.get(i).clicked(mouseXPos, mouseYPos)) {
        return Optional.of(points.get(i));
      }
    }
    
    for (int i = 0; i < paths.size(); i++) {
      ArrayList<Commuter> commuters = paths.get(i).getCommuters();
      for (int k = 0; k < commuters.size(); k++) {
        if (commuters.get(k).clicked(mouseXPos, mouseYPos)) {
          return Optional.of(commuters.get(k));
        }
      }
      if (paths.get(i).clicked(mouseXPos, mouseYPos)) {
        return Optional.of(paths.get(i));
      }
    }
    
    return Optional.empty();
  }
  
  void removeEntity(SimEntity target) {
    if (target instanceof Path) {
      this.removePath((Path)target);
    }
    else if (target instanceof Point) {
      this.removePoint((Point)target);
    }
    else if (target instanceof Commuter) {
      this.removeCommuter((Commuter)target);
    }
  }
  
}
