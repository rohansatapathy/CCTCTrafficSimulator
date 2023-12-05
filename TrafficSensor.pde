class TrafficSensor extends SimEntity {
  int stateToActivate;
  ArrayList<TrafficSignal> signalsToControl;
  Point position;
  
  TrafficSensor(int stateToActivate, float xPosition, float yPosition, ArrayList<TrafficSignal> signalsToControl) {
    super("Unnamed", color(130, 130, 130));
    this.stateToActivate = stateToActivate;
    this.position = new Point(xPosition, yPosition);
    this.signalsToControl = signalsToControl;
    
  }
  
  void enactSensor(ArrayList<Commuter> commuters) {
    for (int i = 0; i < commuters.size(); i++) {
      if (position.onPoint(commuters.get(i).getCurrentPoint(), 15) && commuters.get(i) instanceof Bus) {
        activateSignals();
        return;
      }
    }
  }
  
  void activateSignals() {
    for (int i = 0; i < signalsToControl.size(); i++) {
      signalsToControl.get(i).setState(stateToActivate);
    }
  }
  
  void draw(PApplet canvas) {
    color strokeColorOriginal = g.strokeColor;
    color fillColorOriginal = g.fillColor;
   
    canvas.stroke(this.c);
    canvas.fill(this.c);
    canvas.circle(position.getX(), position.getY(), 15);
    
    canvas.stroke(strokeColorOriginal);
    canvas.fill(fillColorOriginal);
  }
  
  boolean clicked(int mouseXPos, int mouseYPos) {
    return position.onPoint(mouseXPos, mouseYPos, 15);
  }
  
  String toString() { return "TrafficSensor: " + this.name; }
  
}
