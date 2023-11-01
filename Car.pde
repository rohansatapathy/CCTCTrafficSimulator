public class Car extends Commuter {
  private int carLength;
  private int carWidth;
  
  Car(int carLength, int carWidth, float velocity) {
    super(carLength / 2, velocity, new SeekConfig(10, carLength, 10, carLength, 10, carLength));
    this.carLength = carLength;
    this.carWidth = carWidth;
  }
  
  Car(int carLength, int carWidth, float velocity, String name, color c) {
    super(carLength / 2, velocity, new SeekConfig(10, carLength, 9, carWidth, 10, carLength), name, c);
    this.carLength = carLength;
    this.carWidth = carWidth;
  }
  
  void draw(PApplet canvas) {
    color strokeColorOriginal = g.strokeColor;
    color fillColorOriginal = g.fillColor;
    //canvas.fill(color(0, 0, 255));
    //canvas.circle(this.currentPoint.getX(), this.currentPoint.getY(), this.getRadius() * 2);
    
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
