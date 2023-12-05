class Pedestrian extends Commuter {
  Pedestrian(float velocity, int radius) {
    super(radius, velocity, new SeekConfig(radius / 2, radius, radius * 4, radius * 3, radius * 4, radius * 3, 0));
  }
  
  Pedestrian(int radius, float velocity, String name, color c) {
    super(radius, velocity, new SeekConfig(radius / 2, radius, radius * 4, radius * 3, radius * 4, radius * 3, 0), name, c);
  }
  
  String toString() { return "Pedestrian: " + this.name; }
}
