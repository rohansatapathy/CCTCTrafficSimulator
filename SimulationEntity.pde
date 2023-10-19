public abstract class SimulationEntity {
  protected String name;
  protected color c;
  
  SimulationEntity(String name, color c) { 
    this.name = name; 
    this.c = c;
  }
  
  // abstract functions 
  abstract boolean clicked(int mouseXPos, int mouseYPos);
  abstract void draw(PApplet canvas);
  abstract String toString();
  
  color getColor() { return this.c; }
  void setColor(color newColor) { this.c = newColor; }
}
