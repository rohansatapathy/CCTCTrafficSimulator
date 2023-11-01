import java.util.Optional;
import java.util.*;

public class Sim {
  private PApplet canvas;
  private ArrayList<Path> paths;
  private ArrayList<Point> points;
  private ArrayList<Intersection> intersections;
  private final float PIXELS_PER_FEET = (70 / 50);
  
  // for data!
  private int totalCollisions;
  
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
    System.out.println("Num: " + paths.size());
    paths.add(new Path(nodes, c, name));
  }
  
  void addPath(Path path) {
    paths.add(path);
  }
  
  void removePath(Path target) {
    paths.remove(target);
  }
  
  boolean addIntersection(Point click, Path pathA, Path pathB) {
    //System.out.println("here");
    ArrayList<Point> intersectionPoints = pathA.intersect(pathB);
    for (int i = 0; i < intersectionPoints.size(); i++) {
      //System.out.println("in for loop"); 
      if (click.onPoint(intersectionPoints.get(i), 15)) {
        //System.out.println("new intersection");
        intersections.add(new Intersection(intersectionPoints.get(i), pathA, pathB)); //<>//
        paths.remove(pathA);
        paths.remove(pathB);
        return true;
      }
    }
    return false;
  }
  
  void removeIntersection(Intersection target) {
    paths.add(target.getPathA());
    paths.add(target.getPathB());
    intersections.remove(target);
  }
  
  
  boolean addCommuter(Commuter commuter, Path path) {
    for (int i = 0; i < paths.size(); i++) {
      if (paths.get(i) == path) {
        return paths.get(i).addCommuter(commuter);
      }
    }
    for (int i = 0; i < intersections.size(); i++) {
      if (path == intersections.get(i).getPathA()) {
        System.out.println("here1");
        return intersections.get(i).getPathA().addCommuter(commuter);
      }
      if (path == intersections.get(i).getPathB()) {
        System.out.println("here2");
        return intersections.get(i).getPathB().addCommuter(commuter);
        
      }
    }
    return false;
  }
  
  void removeCommuter(Commuter commuter) {
    for (int i = 0; i < paths.size(); i++) {
      if (paths.get(i).removeCommuter(commuter)) {
        return;
      }
    }
  }
  
  void update() {
    int sumCollisions = 0;
    for (int i = 0; i < intersections.size(); i++) {
      intersections.get(i).enactSignal();
    }
    
    for (int i = 0; i < paths.size(); i++) {
      paths.get(i).updateSpawn();
      paths.get(i).updateCommuters();
      paths.get(i).updateCollisions();
      
      sumCollisions += paths.get(i).getNumCollisions();
    }
    
    for (int i = 0; i < intersections.size(); i++) {
      //intersections.get(i).updateCommuters(); // TODO: implement this function correctly
      intersections.get(i).updatePaths();
      intersections.get(i).updateCollisions();
      sumCollisions += intersections.get(i).getNumCollisions();
    }
    
    this.totalCollisions = sumCollisions;
    
    
   //for (int i = 0; i < intersections.size(); i++) {
   //  intersections.get(i).enactSignal();
   //}
    //updateCollisions();
    //enactObstacleAvoidance();
  }
  
  int getCollisionCount() { // TODO: consider an overall get data function ????
    return this.totalCollisions;
  }
  
  void draw() {
    for (int i = 0; i < paths.size(); i++) { // draw paths
      paths.get(i).draw(this.canvas);
    }
    
    for (int i = 0; i < intersections.size(); i++) {
      intersections.get(i).getPathA().draw(this.canvas);
      intersections.get(i).getPathB().draw(this.canvas);
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
    
    for (int i = 0; i < intersections.size(); i++) {
      ArrayList<Commuter> commutersA = intersections.get(i).getPathA().getCommuters();
      ArrayList<Commuter> commutersB = intersections.get(i).getPathB().getCommuters();
      for (int k = 0; k < commutersA.size(); k++) {
        commutersA.get(k).draw(this.canvas);
      }
      for (int k = 0; k < commutersB.size(); k++) {
        commutersB.get(k).draw(this.canvas);
      }
    }
    
    
  }
  
  Optional<SimEntity> getClick(int mouseXPos, int mouseYPos) {
    for (int i = 0; i < points.size(); i++) {
      if (points.get(i).clicked(mouseXPos, mouseYPos)) {
        return Optional.of(points.get(i));
      }
    }
    // TODO: add clicking for path A and B's commuters
    for (int i = 0; i < intersections.size(); i++) {
     
      if (intersections.get(i).clicked(mouseXPos, mouseYPos)) {
        return Optional.of(intersections.get(i));
      }
      if (intersections.get(i).getPathA().clicked(mouseXPos, mouseYPos)) {
        return Optional.of(intersections.get(i).getPathA());
      }
      if (intersections.get(i).getPathB().clicked(mouseXPos, mouseYPos)) {
        return Optional.of(intersections.get(i).getPathB());
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
