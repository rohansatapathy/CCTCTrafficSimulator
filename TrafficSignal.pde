class TrafficSignal extends SimEntity {
  private Point position;
  private int state; // 4 states: [0: nothing, autonomous behavior, 1: pathA goes, pathB stops, 2: pathB goes, pathA stops, 3: both paths stop, ]
  private int radiusOfEffect;
  
  TrafficSignal(float xPosition, float yPosition, int initialState, int radiusOfEffect) {
    super("Unnamed", color(55, 55, 55));
    this.position = new Point(xPosition, yPosition);
    this.radiusOfEffect = radiusOfEffect;
    this.state = initialState;
  }
  
  void draw(PApplet canvas) {
    color strokeColorOriginal = g.strokeColor;
    color fillColorOriginal = g.fillColor;
    color lightColor;
    
    canvas.stroke(this.c);
    canvas.fill(this.c);
    rectMode(CENTER);
    canvas.rect(this.position.getX(), this.position.getY(), 30, 30, 5, 5, 5, 5);
    
    if (this.state == 0) {
      lightColor = color(234, 60, 83);
    }
    else {
      lightColor = color(255, 95, 87);
    }
    
    canvas.stroke(lightColor);
    canvas.fill(lightColor);
    canvas.circle(this.position.getX(), this.position.getY(), 15);
    //canvas.fill(color(255, 0, 0));
    //canvas.circle(this.position.getX(), this.position.getY(), 5);
    rectMode(CORNER);
    
    canvas.stroke(strokeColorOriginal);
    canvas.fill(fillColorOriginal);
  }
  
  boolean clicked(int mouseXPos, int mouseYPos) {
    return position.onPoint(mouseXPos, mouseYPos, 15);
  }
  
  int getRadiusOfEffect() { return this.radiusOfEffect; }
  
  int getState() { return this.state; }
  
  String toString() { return "TrafficSignal: " + this.name; }
  
}
