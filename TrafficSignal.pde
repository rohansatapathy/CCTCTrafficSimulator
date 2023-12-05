
class TrafficSignal extends SimEntity {
  private Point position;
  private int state; // 2 states: 0:  no signal, 1: stop
  private int radiusOfEffect;
  private float direction;
  private float onTime;
  private float currentTimer;
  
  TrafficSignal(float xPosition, float yPosition, float direction, int initialState, int radiusOfEffect, float onTime) {
    super("Unnamed", color(55, 55, 55));
    this.position = new Point(xPosition, yPosition);
    this.radiusOfEffect = radiusOfEffect;
    this.state = initialState;
    this.direction = direction;
    this.onTime = this.currentTimer = onTime;
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
    rotate(this.direction * (-1) + (PI / 2));
    canvas.rect(0, 0, 25, 5);
    popMatrix();
    
    rectMode(CORNER);
    canvas.stroke(strokeColorOriginal);
    canvas.fill(fillColorOriginal);
  }
  
  void update(int simFrameRate) {
    if (state == 1) {
      currentTimer -= (1.0 / simFrameRate);
    }
    else {
      currentTimer = onTime;
    }
    
    if (currentTimer <= 0) {
      state = 0;
    }
  }
  
  float getCurrentTimer() { return this.currentTimer; }
  
  boolean clicked(int mouseXPos, int mouseYPos) {
    if (position.onPoint(mouseXPos, mouseYPos, 15)) {
      this.state = (this.state + 1) % 2;
      return true;
    }
    return false;
  }
  
  int getRadiusOfEffect() { return this.radiusOfEffect; }
  
  Point getPosition() { return this.position; }
  
  int getState() { return this.state; }
  
  void setState(int newState) { 
    this.state = newState;
    currentTimer = onTime;
  }
  
  String toString() { return "TrafficSignal: " + this.name; }
  
}
