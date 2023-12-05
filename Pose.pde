class Pose {
  private float heading;
  private Point position;
  
  Pose(float xPos, float yPos, float heading) {
    this.position = new Point(xPos, yPos);
    this.heading = heading;
  }
  
  Point getPosition() { return this.position; }
  float getHeading() { return this.heading; }
  
  void setPosition(float xPos, float yPos) {
    this.position.setX(xPos);
    this.position.setY(yPos);
  }
  
  void setHeading(float newHeading) {
    this.heading = newHeading;
  }
}
