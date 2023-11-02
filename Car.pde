public class Car extends Commuter {
  private int carLength;
  private int carWidth;
  
  Car(int carLength, int carWidth, float velocity) {
    super(carLength / 2, velocity, new SeekConfig(10, carLength, 10, carLength, 10, carLength));
    this.carLength = carLength;
    this.carWidth = carWidth;
  }
  
  Car(int carLength, int carWidth, float velocity, String name, color c) {
    super(carLength / 2, velocity, new SeekConfig(10, carLength, 9, carWidth, 15, 20), name, c);
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
    //canvas.fill(color(255, 0, 0));
    //canvas.circle(this.seekForwardPoint.getX(), this.seekForwardPoint.getY(), 15);
    canvas.stroke(strokeColorOriginal);
    canvas.fill(fillColorOriginal);
  }
  
  String toString() { return "Car: " + this.name; }
}
