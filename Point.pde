public class Point extends SimEntity {
  private float x;
  private float y;
  
  Point(float x, float y) {
    super("Unnamed", color(0, 0, 0));
    this.x = x;
    this.y = y;
  }
  
  Point(float x, float y, String name, color c) {
    super(name, c);
    this.x = x;
    this.y = y;
  }
  
  void draw(PApplet canvas) {
    this.draw(canvas, this.c);
  }
  
  void draw(PApplet canvas, float radius, color newColor) {
    color strokeColorOriginal = g.strokeColor;
    color fillColorOriginal = g.fillColor;
    
    canvas.stroke(newColor);
    canvas.fill(newColor);
    canvas.circle(this.getX(), this.getY(), radius);
    
    canvas.stroke(strokeColorOriginal);
    canvas.fill(fillColorOriginal);
  }
  
  void draw(PApplet canvas, color newColor) {
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
    float distance = sqrt(pow(xPos - this.x, 2) + pow(yPos - this.y, 2));
    return distance < threshold;
  }
  
  boolean onPoint(Point other, float threshold) {
    assert(threshold >= 0);
    float distance = sqrt(pow(other.x - this.x, 2) + pow(other.y - this.y, 2));
    return distance < threshold;
  }
  
  boolean clicked(int mouseXPos, int mouseYPos) {
    return onPoint(mouseXPos, mouseYPos, 10);
  }
  
  void setX(float newX) { this.x = newX; }
  
  void setY(float newY) { this.y = newY; }
  
  float getX() { return this.x; }
  
  float getY() { return this.y; }
  
  String toString() { return "Point " + this.name + ": " + this.getX() + ", " + this.getY(); }
  
}
