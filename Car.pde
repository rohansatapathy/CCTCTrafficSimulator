public class Car extends Commuter {
  private int carLength;
  private int carWidth;
  
  Car(int carLength, int carWidth, float velocity) {
    super(carLength, velocity);
    this.carLength = carLength;
    this.carWidth = carWidth;
  }
  
  Car(int carLength, int carWidth, float velocity, String name, color c) {
    super(carLength, velocity, name, c);
    this.carLength = carLength;
    this.carWidth = carWidth;
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
    canvas.rect(0, 0, carLength, carWidth);
    popMatrix();
    
    rectMode(CORNER);
    canvas.stroke(strokeColorOriginal);
    canvas.fill(fillColorOriginal);
  }
  
  String toString() { return "Car: " + this.name; }
}
