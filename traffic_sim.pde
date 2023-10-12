PImage backgroundImage;
int frameWidth = 1033;
int frameHeight = 720;

int buttonTopLeftX = frameWidth - 110;
int buttonTopLeftY = frameHeight - 60;
int buttonWidth = 100;
int buttonHeight = 50;

ArrayList<Path> paths;

void setup() {
  
  size(1033, 720);
  backgroundImage = loadImage("CCTC.png");
  backgroundImage.resize(frameWidth, frameHeight);
  
  
}

void draw() {
  background(backgroundImage);
  
  
  
  stroke(255, 0, 0);
  //noFill();
  
  
  
  Point myPoint = new Point(500, 500, this);
  Point myPoint1 = new Point(200, 200, this);
  Point myPoint2 = new Point(100, 150, this);
  
  
  //myPoint.draw(color(255, 0, 0));
  
  
  Point[] pointsArray = {myPoint, myPoint1, myPoint2};
  Path myPath = new Path(pointsArray, this);
  
  myPath.draw();
  
  circle(50, 50, 10);
  
  // collision detection in abstract class
  
}
