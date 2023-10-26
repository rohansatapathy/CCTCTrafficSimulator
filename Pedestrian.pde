public class Pedestrian extends Commuter {
  Pedestrian(float velocity) {
    super(5, velocity);
  }
  
  String toString() { return "Pedestrian: " + this.name; }
}
