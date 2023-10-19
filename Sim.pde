import java.util.Optional;
import java.util.*;

public class Sim {
  private PApplet canvas;
  private Map<Path, ArrayList<Commuter>> pathCommuterMap;
  private ArrayList<Point> points;
  
  Sim(PApplet canvas) {
    this.canvas = canvas;
    this.pathCommuterMap = new HashMap<Path, ArrayList<Commuter>>();
    this.points = new ArrayList<Point>();
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
    System.out.println("Num: " + pathCommuterMap.size());
    Path path = new Path(nodes, c, name);
    pathCommuterMap.put(path, new ArrayList<Commuter>());
    //paths.add(path);
  }
  
  void addPath(Path path) {
    pathCommuterMap.putIfAbsent(path, new ArrayList<Commuter>());
    //paths.add(path);
  }
  
  void removePath(Path target) {
    pathCommuterMap.remove(target);
    //paths.remove(target);
  }
  
  void addCommuter(Commuter commuter) {
    assert(pathCommuterMap.get(commuter.getPathOfTravel()) != null);
    pathCommuterMap.get(commuter.getPathOfTravel()).add(commuter);
  }
  
  void removeCommuter(Commuter commuter) {
    ArrayList<Commuter> commutersOnPath = pathCommuterMap.get(commuter.getPathOfTravel());
    commutersOnPath.remove(commuter);
  }
  
  void update() {
    Collection<ArrayList<Commuter>> commuters = pathCommuterMap.values();
    Iterator<ArrayList<Commuter>> iterator = commuters.iterator();
    
    while (iterator.hasNext()) {
      ArrayList<Commuter> elem = iterator.next();
      for (int i = 0; i < elem.size(); i++) {
        elem.get(i).update();
      }
    }
  }
  
  void draw() {
    Set<Path> paths = pathCommuterMap.keySet();
    Iterator<Path> pathIterator = paths.iterator();
    
    while (pathIterator.hasNext()) {
      Path path = pathIterator.next();
      path.draw(this.canvas);
      ArrayList<Commuter> commuters = pathCommuterMap.get(path);
      if (commuters != null) {
        for (int i = 0; i < commuters.size(); i++) {
          commuters.get(i).draw(this.canvas);
        }
      }
    }
    
    for (int i = 0; i < points.size(); i++) {
      points.get(i).draw(this.canvas);
    }
    
  }
  
  Optional<SimulationEntity> getClick(int mouseXPos, int mouseYPos) {
    System.out.println("in Sim get click");
    for (int i = 0; i < points.size(); i++) {
      if (points.get(i).clicked(mouseXPos, mouseYPos)) {
        return Optional.of(points.get(i));
      }
    }
    
    Collection<ArrayList<Commuter>> commuters = pathCommuterMap.values();
    Iterator<ArrayList<Commuter>> commuterIterator = commuters.iterator();
    while (commuterIterator.hasNext()) {
      ArrayList<Commuter> elem = commuterIterator.next();
      for (int i = 0; i < elem.size(); i++) {
        if (elem.get(i).clicked(mouseXPos, mouseYPos)) {
          return Optional.of(elem.get(i));
        }
      }
    }
    
    Set<Path> paths = pathCommuterMap.keySet();
    Iterator<Path> pathIterator = paths.iterator();
    System.out.println("Path size: " + paths.size());
    while (pathIterator.hasNext()) {
      Path path = pathIterator.next();
      if (path.clicked(mouseXPos, mouseYPos)) {
        return Optional.of(path);
      }
    }
    
    return Optional.empty();
  }
  
  void removeEntity(SimulationEntity target) {
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
