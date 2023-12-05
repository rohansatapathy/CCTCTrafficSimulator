class Car extends Commuter {
  private float carLength;
  private float carWidth;
  
  Car(float carLength, float carWidth, float velocity) {
    super(carLength / 2, velocity, new SeekConfig(carLength, carLength, carLength, carLength / 2, carLength * 2, carLength, carLength / 4));
    this.carLength = carLength;
    this.carWidth = carWidth;
  }
  
  Car(float carLength, float carWidth, float velocity, String name, color c) {
    super(carLength / 2, velocity, new SeekConfig(carLength, carLength, carLength, carLength / 2, carLength * 2, carLength, carLength / 4), name, c);
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
    rotate((-1) * this.currentDir);
    canvas.rect(0, 0, carLength, carWidth);
    popMatrix();
    
    rectMode(CORNER);
    canvas.stroke(strokeColorOriginal);
    canvas.fill(fillColorOriginal);
  }
  
  String toString() { return "Car: " + this.name; }
  
  float getTotalDelay() { return super.getTotalDelay() * 2; }
}
