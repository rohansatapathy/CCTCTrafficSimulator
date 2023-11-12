

class TrafficSignal extends SimEntity {
  private Point position;
  private int state; // 3 states: 0:  no signal, 1: stop, 2: go
  private int radiusOfEffect;
  private float direction;
  
  TrafficSignal(float xPosition, float yPosition, float direction, int initialState, int radiusOfEffect) {
    super("Unnamed", color(55, 55, 55));
    this.position = new Point(xPosition, yPosition);
    this.radiusOfEffect = radiusOfEffect;
    this.state = initialState;
    this.direction = direction;
  }
  
  void draw(PApplet canvas) {
    color strokeColorOriginal = g.strokeColor;
    color fillColorOriginal = g.fillColor;
    color lightColor;
    
    if (this.state == 0) {
      lightColor = color(255, 255, 255);
    }
    else if (this.state == 1) {
      lightColor = color(255, 87, 87);
    }
    else {
      lightColor = color(80, 200, 120);
    }
    
    canvas.stroke(lightColor);
    canvas.fill(lightColor);
    rectMode(CENTER);
    
    pushMatrix();
    translate(this.position.getX(), this.position.getY());
    rotate(this.direction);
    canvas.rect(0, 0, 25, 5);
    popMatrix();
    
    rectMode(CORNER);
    canvas.stroke(strokeColorOriginal);
    canvas.fill(fillColorOriginal);
  }
  
  boolean clicked(int mouseXPos, int mouseYPos) {
    if (position.onPoint(mouseXPos, mouseYPos, 15)) {
      this.state = (this.state + 1) % 3;
      return true;
    }
    return false;
  }
  
  int getRadiusOfEffect() { return this.radiusOfEffect; }
  
  Point getPosition() { return this.position; }
  
  int getState() { return this.state; }
  
  String toString() { return "TrafficSignal: " + this.name; }
  
}
