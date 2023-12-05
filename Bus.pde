class Bus extends Commuter {
  private float busLength;
  private float busWidth;
  
  Bus(float busLength, float busWidth, float velocity) {
    super(busLength / 3, velocity, new SeekConfig(busLength / 2, busLength / 2, busLength, busLength / 2, busLength / 2, busLength, busLength / 2));
    this.busLength = busLength;
    this.busWidth = busWidth;
  }
  
  Bus(float busLength, float busWidth, float velocity, String name, color c) {
    super(busLength / 3, velocity, new SeekConfig(busLength / 2, busLength / 2, busLength, busLength / 2, busLength / 2, busLength, busLength / 2), name, c);
    this.busLength = busLength;
    this.busWidth = busWidth;
  }
  
  void draw(PApplet canvas) {
    color strokeColorOriginal = g.strokeColor;
    color fillColorOriginal = g.fillColor;
    
    
    canvas.stroke(this.c);
    canvas.fill(this.c);
    rectMode(CENTER);
    
    pushMatrix();
    translate(this.currentPoint.getX(), this.currentPoint.getY());
    rotate((-1) * this.currentDir);
    canvas.rect(0, 0, busLength, busWidth);
    popMatrix();
    
    rectMode(CORNER);
    
    
    canvas.stroke(strokeColorOriginal);
    canvas.fill(fillColorOriginal);
  }
  
  String toString() { return "Bus: " + this.name; }
  
  float getTotalDelay() { return super.getTotalDelay() * 25; }
  
 
}
