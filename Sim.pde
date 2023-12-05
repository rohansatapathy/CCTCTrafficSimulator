import java.util.Optional;
import java.util.*;

class Sim {
  private PApplet canvas;
  private ArrayList<Path> paths;
  private ArrayList<Point> points;
  private ArrayList<Intersection> intersections;
  private ArrayList<TrafficSignal> signals;
  private ArrayList<TrafficSensor> sensors;
  private final int FRAME_RATE;
  
  private int totalCollisions;
  private float totalPersonDelay;
  
  Sim(PApplet canvas, int FRAME_RATE) {
    this.canvas = canvas;
    this.paths = new ArrayList<Path>();
    this.points = new ArrayList<Point>();
    this.intersections = new ArrayList<Intersection>();
    this.signals = new ArrayList<TrafficSignal>();
    this.sensors = new ArrayList<TrafficSensor>();
    this.totalCollisions = 0;
    this.FRAME_RATE = FRAME_RATE;
  }
  
  Point addPoint(int xCoord, int yCoord) {
    return addPoint(xCoord, yCoord, "Unnamed", color(0, 0, 0));
  }
  
  Point addPoint(int xCoord, int yCoord, String name, color c) {
    Point point = new Point(xCoord, yCoord, name, c);
    points.add(point);
    return point;
  }
  
  void removePoint(Point target) {
    points.remove(target);
  }
  
  Path addPath(Point[] nodes) {
    return addPath(nodes, color(0, 0, 0), "Unnamed");
  }
  
  Path addPath(Point[] nodes, color c, String name) {
    Path path = new Path(nodes, c, name);
    paths.add(path);
    return path;
  }
 
  void removePath(Path target) {
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
    paths.remove(target);
  }
  
  Optional<Intersection> addIntersection(Path pathA, Path pathB) {
    ArrayList<Point> intersectionPoints = pathA.intersect(pathB);
    for (int i = 0; i < intersectionPoints.size(); i++) {
      Intersection intersection = new Intersection(intersectionPoints.get(i), pathA, pathB);
      boolean identicalIntersection = false;
      int k = 0;
      while (k < intersections.size() && !identicalIntersection) {
        if (intersection.equals(intersections.get(k))) {
          identicalIntersection = true;
        }
        k++;
      }
      
      if (!identicalIntersection) {
        intersections.add(intersection);
        return Optional.of(intersection);
      }
    }
    return Optional.empty();
  }
  
  void removeIntersection(Intersection target) {
    intersections.remove(target);
  }
  
  Optional<TrafficSignal> addTrafficSignal(Intersection intersection, Path path) {
    Optional<TrafficSignal> signal = intersection.addTrafficSignal(path, 0, 10);
    if (signal.isPresent()) {
      signals.add(signal.get());
    }
    return signal;
  }
  
  void removeTrafficSignal(TrafficSignal target) {
    signals.remove(target);
    for (int i = 0; i < intersections.size(); i++) {
      intersections.get(i).removeSignal(target);
    }
  }
  
  TrafficSensor addTrafficSensor(Path path, float xPosition, float yPosition, ArrayList<TrafficSignal> signalsToControl) {
    TrafficSensor sensor = new TrafficSensor(1, xPosition, yPosition, signalsToControl);
    sensors.add(sensor);
    path.addSensor(sensor);
    return sensor;
  }

  
  void removeTrafficSensor(TrafficSensor target) {
    sensors.remove(target);
    for (int i = 0; i < paths.size(); i++) {
      paths.get(i).removeSensor(target);
    }
  }
  
  ArrayList<Pedestrian> addPedestrian(int num, Path path) {
    ArrayList<Pedestrian> result = new ArrayList<Pedestrian>();
    for (int i = 0; i < paths.size(); i++) {
      if (paths.get(i) == path) {
        for (int k = 0; k < num; k++) {
          Pedestrian pedestrian = new Pedestrian(5, random(0.1, 0.12), "Student", color(242, 133, 0));
          paths.get(i).addCommuter(pedestrian);
          result.add(pedestrian);
        }
      }
    }
    return result;
  }
  
  
  ArrayList<Bus> addBus(int num, Path path) {
    ArrayList<Bus> result = new ArrayList<Bus>();
    for (int i = 0; i < paths.size(); i++) {
      if (paths.get(i) == path) {
        for (int k = 0; k < num; k++) {
          Bus bus = new Bus(20, 15, random(0.3, 0.4), "MBus", color(62, 142, 222));
          paths.get(i).addCommuter(bus);
          result.add(bus);
        }
      }
    }
    return result;
  }
  
  
  ArrayList<Car> addCar(int num, Path path) {
    ArrayList<Car> result = new ArrayList<Car>();
    for (int i = 0; i < paths.size(); i++) {
      if (paths.get(i) == path) {
        for (int k = 0; k < num; k++) {
          Car car = new Car(12, 9, random(0.3, 0.4), "Driver", color(251, 236, 93));
          paths.get(i).addCommuter(car);
          result.add(car);
        }
      }
    }
    return result;
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
    float sumDelay = 0;
    
    for (int i = 0; i < intersections.size(); i++) {
      intersections.get(i).enactSignal(FRAME_RATE);
      intersections.get(i).seekCommuters();
      intersections.get(i).updateCollisions();
      sumCollisions += intersections.get(i).getNumCollisions();
    }
    
    for (int i = 0; i < paths.size(); i++) {
      paths.get(i).updateSpawn();
      paths.get(i).seekCommuters();
      paths.get(i).updateVelocities();
      paths.get(i).updateCollisions();
      paths.get(i).updateSensors();
      sumCollisions += paths.get(i).getNumCollisions();
    }
    
    for (int i = 0; i < paths.size(); i++) {
      paths.get(i).updateCommuters();
      sumDelay += paths.get(i).getTotalDelay();
      
    }
    
    this.totalPersonDelay = sumDelay;
    this.totalCollisions = sumCollisions;
  }
  
  float getTotalPersonDelay() {
    return (this.totalPersonDelay / (float)FRAME_RATE); 
  }
  
  
  int getCollisionCount() {
    return this.totalCollisions;
  }
  
  void draw() {
    ArrayList<SimEntity> simEntities = new ArrayList<SimEntity>();
    simEntities.addAll(paths);
    simEntities.addAll(intersections);
    simEntities.addAll(points);
    simEntities.addAll(sensors);
    for (int i = 0; i < simEntities.size(); i++) {
      simEntities.get(i).draw(this.canvas);
    }
    
    ArrayList<Commuter> commuters = new ArrayList<Commuter>();
    for (int i = 0; i < paths.size(); i++) {
      commuters.addAll(paths.get(i).getCommuters());
    }
    
    for (int i = 0; i < commuters.size(); i++) {
      commuters.get(i).draw(this.canvas);
    }
  }
  
  Optional<SimEntity> getClick(int mouseXPos, int mouseYPos) {
    ArrayList<Commuter> commuters = new ArrayList<Commuter>();
    for (int i = 0; i < paths.size(); i++) {
      commuters.addAll(paths.get(i).getCommuters());
    }
    
    for (int i = 0; i < commuters.size(); i++) {
      if (commuters.get(i).clicked(mouseXPos, mouseYPos)) {
        return Optional.of(commuters.get(i));
      }
    }
    
    ArrayList<SimEntity> simEntities = new ArrayList<SimEntity>();
    simEntities.addAll(points);
    simEntities.addAll(signals);
    simEntities.addAll(intersections);
    simEntities.addAll(sensors);
    simEntities.addAll(paths);
    for (int i = 0; i < simEntities.size(); i++) {
      if (simEntities.get(i).clicked(mouseXPos, mouseYPos)) {
        return Optional.of(simEntities.get(i));
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
    else if (target instanceof TrafficSignal) {
      this.removeTrafficSignal((TrafficSignal)target);
    }
    else if (target instanceof TrafficSensor) {
      this.removeTrafficSensor((TrafficSensor)target);
    }
  }
  
}
