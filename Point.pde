public class Point extends SimulationEntity {
  //private float x;
  //private float y;
  
  private PVector coord;
  
  // constructor
  Point(float x, float y) {
    super("Unnamed", color(0, 0, 0));
    this.coord = new PVector(x, y);
    //this.x = x;
    //this.y = y;
  }
  
  Point(float x, float y, String name, color c) {
    super(name, c);
    this.coord = new PVector(x, y);
    //this.x = x;
    //this.y = y;
  }
  
  
  // draw function w defined color
  void draw(PApplet canvas) {
    this.draw(canvas, this.c);
  }
  
  // overridden draw function w new color
  void draw(PApplet canvas, color newColor) {
    // replace original stroke color and fill color --> currently NOT working when original fill color is noFill() (noFill() value and WHITE value are the same)
    color strokeColorOriginal = g.strokeColor;
    color fillColorOriginal = g.fillColor;
    
    canvas.stroke(newColor);
    canvas.fill(newColor);
    canvas.circle(this.getX(), this.getY(), 10);
    
    canvas.stroke(strokeColorOriginal);
    canvas.fill(fillColorOriginal);
  }
  
  boolean onPoint(float xPos, float yPos, float threshold) {
    assert(threshold >= 0);
    return PVector.sub(new PVector(xPos, yPos), this.coord).mag() <= threshold;
    //return sqrt(pow(xPos - this.x, 2) + pow(yPos - this.y, 2)) <= threshold;
  }
  
  boolean clicked(int mouseXPos, int mouseYPos) {
    return onPoint(mouseXPos, mouseYPos, 10);
  }
  
  // setter and getters for private member variables
  void setX(float newX) { coord.set(newX, this.getY()); }
  
  void setY(float newY) { coord.set(this.getX(), newY); }
  
  float getX() { return coord.x; }
  
  float getY() { return coord.y; }
  
  String toString() { return "Point " + this.name + ": " + this.getX() + ", " + this.getY(); }
  
}
