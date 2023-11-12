import java.util.Optional;
import java.util.*;

public class Sim {
  private PApplet canvas;
  private ArrayList<Path> paths;
  private ArrayList<Point> points;
  private ArrayList<Intersection> intersections;
  //private final float PIXELS_PER_FEET = (70 / 50);
  //private final int FRAME_RATE;
  
  // for data!
  private int totalCollisions;
  private int totalPersonDelay;
  
  
  Sim(PApplet canvas) {
    this.canvas = canvas;
    this.paths = new ArrayList<Path>();
    this.points = new ArrayList<Point>();
    this.intersections = new ArrayList<Intersection>();
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
    paths.add(new Path(nodes, c, name));
  }
  
  void addPath(Path path) {
    paths.add(path);
  }
 
  void removePath(Path target) {
    paths.remove(target);
    int i = 0;
    while (i < intersections.size()) {
      if (intersections.get(i).getPathA() == target) {
        intersections.remove(intersections.get(i));
      }
      else if (intersections.get(i).getPathB() == target) {
        intersections.remove(intersections.get(i));
      }
      else {
        i++;
      }
    }
  }
  
  void addIntersection(Intersection intersection) {
    intersections.add(intersection);
  }
  
  boolean addIntersection(Point click, Path pathA, Path pathB) {
    ArrayList<Point> intersectionPoints = pathA.intersect(pathB);
    for (int i = 0; i < intersectionPoints.size(); i++) {
      if (click.onPoint(intersectionPoints.get(i), 15)) {
        intersections.add(new Intersection(intersectionPoints.get(i), pathA, pathB));
        return true;
      }
    }
    return false;
  }
  
  void removeIntersection(Intersection target) {
    intersections.remove(target);
    
  }
  
  boolean addTrafficSignal(Intersection intersection, Path path) {
    for (int i = 0; i < intersections.size(); i++) {
      if (intersections.get(i) == intersection) {
        return intersections.get(i).addTrafficSignal(path, 2);
      }
    }
    return false;
  }
  
  
  void addCommuter(Commuter commuter, Path path) {
    for (int i = 0; i < paths.size(); i++) {
      if (paths.get(i) == path) {
        paths.get(i).addCommuter(commuter);
        return;
      }
    }
    for (int i = 0; i < intersections.size(); i++) {
      if (path == intersections.get(i).getPathA()) {
        intersections.get(i).getPathA().addCommuter(commuter);
        return;
      }
      if (path == intersections.get(i).getPathB()) {
        intersections.get(i).getPathB().addCommuter(commuter);
        return;
        
      }
    }
  }
  
  void removeCommuter(Commuter commuter) {
    for (int i = 0; i < paths.size(); i++) {
      if (paths.get(i).removeCommuter(commuter)) {
        return;
      }
    }
    
    for (int i = 0; i < intersections.size(); i++) {
      if (intersections.get(i).getPathA().getCommuters().remove(commuter) || intersections.get(i).getPathB().getCommuters().remove(commuter)) {
        return;
      }
    }
  }
  
  void update() {
    int sumCollisions = 0;
    //int sumDelay = 0;
    
    for (int i = 0; i < intersections.size(); i++) {
      intersections.get(i).enactSignal();
      intersections.get(i).seekCommuters();
      intersections.get(i).updateCollisions();
      sumCollisions += intersections.get(i).getNumCollisions();
    }
    
    for (int i = 0; i < paths.size(); i++) {
      paths.get(i).updateSpawn();
      paths.get(i).seekCommuters();
      paths.get(i).updateVelocities();
      paths.get(i).updateCollisions();
      sumCollisions += paths.get(i).getNumCollisions();
    }
    
    for (int i = 0; i < paths.size(); i++) {
      paths.get(i).updateCommuters();
    }
    
    //for (int i = 0; i < allCommuters.size(); i++) {
    //  sumDelay += allCommuters.get(i).getTotalDelay();
    //}
    
    //this.totalPersonDelay = sumDelay;
    this.totalCollisions = sumCollisions;
  }
  
  int getTotalPersonDelay() {
    return this.totalPersonDelay; 
  }
  
  
  int getCollisionCount() { // TODO: consider an overall get data function ????
    return this.totalCollisions;
  }
  
  void draw() {
    for (int i = 0; i < paths.size(); i++) { // draw paths
      paths.get(i).draw(this.canvas);
    }
    
    for (int i = 0; i < intersections.size(); i++) { // draw intersections
      intersections.get(i).draw(this.canvas);
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
    for (int i = 0; i < intersections.size(); i++) {
      ArrayList<TrafficSignal> signals = intersections.get(i).getSignals();
      for (int k = 0; k < signals.size(); k++) {
        if (signals.get(k).clicked(mouseXPos, mouseYPos)) {
          return Optional.of(signals.get(k));
        }
      }
      if (intersections.get(i).clicked(mouseXPos, mouseYPos)) {
        return Optional.of(intersections.get(i));
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
    else if (target instanceof Intersection) {
      this.removeIntersection((Intersection)target);
    }
  }
  
}
