public class Point {
  private int x;
  private int y;
  private PApplet canvas;
  
  // constructor
  Point(int x, int y, PApplet canvas) {
    this.x = x;
    this.y = y;
    this.canvas = canvas;
  }
  
  // default draw function with color BLACK
  void draw() {
    this.draw(color(0, 0, 0));
  }
  
  // draw function with parameter options for color
  void draw(color c) {
    // replace original stroke color and fill color --> currently NOT working when original fill color is noFill() (noFill() value and WHITE value are the same)
    color strokeColorOriginal = g.strokeColor;
    color fillColorOriginal = g.fillColor;
    
    canvas.stroke(c);
    canvas.fill(c);
    canvas.circle(this.x, this.y, 10);
    
    canvas.stroke(strokeColorOriginal);
    canvas.fill(fillColorOriginal);
  }
  
  
  // setter and getters for private member variables
  void setX(int newX) { this.x = newX; }
  
  void setY(int newY) { this.y = newY; }
  
  int getX() { return this.x; }
  
  int getY() { return this.y; }
}
