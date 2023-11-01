public class Pedestrian extends Commuter {
  Pedestrian(float velocity) {
    super(5, velocity, new SeekConfig(7, 7, 7, 7, 15, 15));
  }
  
  Pedestrian(float velocity, String name, color c) {
    super(7, velocity, new SeekConfig(7, 7, 7, 7, 15, 15), name, c);
  }
  
  String toString() { return "Pedestrian: " + this.name; }
}
