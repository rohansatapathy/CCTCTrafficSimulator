public class Bus extends Commuter {
  private int busLength;
  private int busWidth;
  
  Bus(int busLength, int busWidth, float velocity) {
    super(busLength, velocity);
    this.busLength = busLength;
    this.busWidth = busWidth;
  }
  
  Bus(int busLength, int busWidth, float velocity, String name, color c) {
    super(busLength, velocity, name, c);
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
    rotate((-1) * this.currentDir); // positive numbers rotate clockwise ...  need to multiply by -1
    canvas.rect(0, 0, busLength, busWidth);
    popMatrix();
    
    rectMode(CORNER);
    canvas.stroke(strokeColorOriginal);
    canvas.fill(fillColorOriginal);
  }
  
  String toString() { return "Bus: " + this.name; }
}
